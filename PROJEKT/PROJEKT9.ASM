;Aleksander Glebionek, projekt nr 9, 2021
;Projekt wykorzystuje wyˆacznie stos do realizacji zadania.
;
;Na poczatek ustawiam wartosc BP i BX na SP.
;
;Stos przechowuje 16 bitow, wiec w lewych osmiu bitach 
;przechowuje znaki z pierwszego lancucha, a w prawych
;osmiu bitach przechowuje znaki z drugiego lancucha.
;
;Znaki wczytuje za pomoca AH,1
;
;Po wczytaniu znaku z pierwszego lancucha do AL przenosze go do DH
;a do DL wpisuje wartosc 32 (spacje), w razie gdyby pierwszy lancuch
;byl dluzszy od drugiego. Nastepnie DX wrzucam na stos. Operacje 
;powtarzam az do wpisania przez uzytkownika entera. W tym momencie
;SP wskazuje adres stosu na ktorym konczy sie pierwszy lancuch.
;
;Drugi lancuch rowniez wczytuje za pomoca AH 1, tak dlugo, az uzytkownik
;nie poda entera. BX wskazuje na dol stosu. Wykorzystuje adresowanie
;rejestrowe posrednie (w BX znajduje sie adres dolu stosu).
;Po podaniu znaku, od BX odejmowane jest 2 (poruszam sie w strone SP)
;po czym do DX wstawiam zawartosc stosu pod adresem w BX (MOV DX,[BX]).
;DH zawiera znak z pierwszego lancucha, a DL spacje. Do DL wstawiam znak
;pobrany z klawiatury (MOV DL,AL).
;Nastepnie, sprawdzam, czy BX jest mniejszy od SP (SP to koniec
;pierwszego lanucha; czy mniejszy, poniewaz adresy stosu maleja).
;Jezeli jest mniejszy, to znaczy, ze drugi lancuch jest dluzszy niz
;pierwszy. Analogicznie zatem do pierwszego lancucha, do DH
;wpisuje spacje i ustawiam SP rowne BX (chce, zeby SP wskazywal
;miejsce, gdzie konczy sie nasz lancuch). Finalnie, umiesczam
;zawarosc DX w stosie, pod adresem w BX (MOV [BX],DX)
;
;SP wskazuje gdzie konczy sie nasz lancuch znakowy, BP wskazuje jego
;poczatek. W lewych osmiu bitach stosu znajduja sie znaki z pierwszego
;lancucha, w prawych z drugiego. Dzieki temu, moge ustawic AH na 2 i
;w petli uzywac POP DX, do momentu az SP nie zrowna sie z BP.
;Wyswietlam to co jest w DL, nastepnie do DL wrzucam zawartosc DH
;i wyswietlam ponownie zawartosc DL. W ten sposob otrzymuje ciag
;znakow zgodny z poleceniem zadania, posiadajacym spacje na odpowiednich
;miejscach, w zaleznosci od tego, ktory z lancuchow jest dluzszy, 
;oraz wykorzystujacy jak najefektywniej pamiec stosu.

org 100h

start:
	CALL	enter

	MOV	BP,SP ; poczatek stosu do BP
	MOV	BX,BP ; poczatek stosu do BX
		      ; do adresowania stosu posredniego rejestrowego
	;wyswietl polecenie dla uzytkownika
	MOV	AH,9
	MOV	DX,polec1
	INT	21h

	;wczytaj pierwszy lancuch
	MOV	AH,1 
wczytaj1:
	INT	21h ; wczytuje znak ASCII z klawiatury za pomoca AH 1
	CMP	AL,13 ; jezeli jest enterem to koncze wczytywanie
	JE	wyjdz1 
	MOV	DH,AL ; wczytany znak do DH
	MOV	DL,32 ; do DL spacja, 
	PUSH	DX ; DX na stos, SP wskazuje koniec pierwszego lancucha
JMP wczytaj1
wyjdz1:
	;wyswietl drugie polecenie
	MOV	AH,9
	MOV	DX,polec2
	INT	21h

	;wczytaj drugie polecenie
	MOV	AH,1	
wczytaj2:
	INT	21h ; wczutyjemy drugi lancuch
	CMP	AL,13 ; az nie otrzymamy entera
	JE	wyjdz2
	SUB	BX,2 ; nastepnie podruzujemy od dolu do gory stosu
	MOV	DX,[BX] ; zawartosc stosu z dolu do DX
	MOV	DL,AL ; do DL znak drugiego lancucha
	CMP	BX,SP ; porownuje, czy BX jest mniejsze od SP
	JL	spacja ; jezeli jest, to znaczy, ze drugi lancuch jest 
		       ; dluzszy od pierwszego
back:	MOV	[BX],DX ; aktualnione DX o drugi lancuch wraca na swoje miejsce
			; na stosie
JMP wczytaj2

wyjdz2:
	;wyswietl wynik
	MOV	AH,9
	MOV	DX,wynik
	INT	21h

	MOV	AH,2 ; odczytujemy znaki ze stosu 
wypisz:
	CMP	BP,SP ; do momentu az SP nie zrowna sie z BP
	JE	wyjdz3
	POP	DX ; wierzcholek stosu do DX
	INT	21h ; w DL mamy znaki drugiego lancucha
	MOV	DL,DH ; w DH pierwszego lancucha, ktory idzie do DL 
	INT	21h ; aby go wyswietlic
JMP wypisz
wyjdz3:
	CALL	enter
	;spytaj uzytkownika, czy chce uruchomic program jeszcze raz
	MOV	AH,9
	MOV	DX,znowu
	INT	21h
	MOV	AH,8 ; czyta znak z klawiatury, bez wyswietlania go
	INT	21h ; dla int 21h (odczytano z tablicy przerwan Browna)
	CMP	AL,13
	JE	start

;koniec programu
MOV	AX, 4C00h
INT	21h

polec1	DB	"Podaj pierwszy lancuch i wcisnij enter:",10,13,36
polec2	DB	"Podaj drugi lancuch i wcisnij enter:",10,13,36
wynik	DB	"Wynik:",10,13,36
znowu	DB	"Aby powtorzyc dzialanie programu, wcisnij enter. Aby je zakonczyc, wcisnij dowolny inny znak.",10,13,36

enter:
	PUSH	AX
	PUSH	DX
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
	POP	DX
	POP	AX
ret

spacja:
	MOV	DH,32 ; umieszczamy spacje gdzie bylyby znaki pierwszego lancucha
	MOV	SP,BX ; SP ma wskazywac koniec lanucha (najdluzszego)
JMP back