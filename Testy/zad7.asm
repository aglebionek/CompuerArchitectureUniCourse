;; Opracowane na podstawie:
;; https://en.wikipedia.org/wiki/Shunting-yard_algorithm
;; https://en.wikipedia.org/wiki/Operator-precedence_parser
;;
;; Aleksander Glebionek, 2020

;; NOTE: Po napisaniu dzialajacej wersji z osobnych elementow widze, ze 
;; ten program w wielu miejscach robi to samo i mozna by go pewnie
;; o polowe skrocic

org 100h
	PUSHA
	PUSHF

	;; wczytaj wyrazenie z klawiatury
czytaj:	MOV	AH,9 ; polecenie dla uzytkownika
	MOV	DX,czyt
	INT	21h

	MOV	AH,10 ; wczytywanie wyrazenia
	MOV	DX,wyrklaw
	INT	21h
	;;

	CALL	popraw ; sprawdz poprawnosc podanego wyrazenia

	CALL	parent ; dodaj nawiasy, zeby uwzglednic kolejnosc dzialan
	CALL	enter

	;; wyswietl wyrazenie z nawiasami (parenthesized)
	;MOV	AH,9
	;MOV	DX,wyrnaw+2
	;INT	21h
	;;

	CALL	dorpn ; przeksztalc wyrazenie z nawiasami do RPN
	CALL	enter
	
	;; wyswietl wyrazenie w rpn
	MOV	AH,9
	MOV	DX,rpn+2
	INT	21h
	;;

	POPF
	POPA

MOV	AX,4C00h
INT	21h

;; ZMIENNE
czyt	DB	10,13,"Podaj wyrazenie do przekonwertowania na RPN",10,13,36 ; informacja dla uzytkownika
warning	DB	10,13,"Warning: Wyrazenie zawiera niedozwolone znaki",36 ; ostrzezenie o niedozwolonych znakach
warnaw	DB	10,13,"Warning: Liczba lewych i prawych nawiasow nie jest rowna",36 ; ostzrezenie o nierownej liczbie nawiasow
temp	DW	0 ; do przetrzymmywania adresu powrotu
wyrklaw	DB	26 ; wyrazenie podane z klawiatury
	DB	0
	TIMES	27	DB	36 ; infix expression, to parenthesized

wyrnaw	DB	100 ; wyrazenie z nawiasami (wskazuje kolejnosc dzialan)
	DB	0
	TIMES	101	DB	36 ; parenthesized expression, to rpn

rpn	DB	60 ; wyrazenie w rpn, bez nawiasow,ze spacjami, max 2 razy dluzsze niz wyrklaw
	DB	0
	TIMES	61	DB	36 ; rpn expression, result
;;

;; PROCEDURY
popraw:
	PUSH	DX
	PUSH	BX
	PUSH	DI
	PUSH	CX
	PUSH	AX
	PUSHF

	XOR	AX,AX
	XOR	CH,CH
	MOV	CL,[wyrklaw+1]
	MOV	DI,2
	XOR	BX,BX ; BH - liczba prawych nawiasow, BL - liczba lewych nawiasow

petla0:
	MOV	DL,[wyrklaw+DI]
	CALL	czydozw ; sprawdzenie, czy dany znak jest dozwolony
	INC	DI
LOOP petla0

	CMP	BH,BL
	JE	skip ; jezeli liczba nawiasow prawych i lewych jest rowna to przejdz dalej
	MOV	AH,9 ; jezeli nie jest to wyswietl ostrzezenie
	MOV	DX,warnaw
	INT	21h
	JMP	czytaj ; i kaz uzytkownikowi podac wyrazenie jeszcze raz

skip:	POPF
	POP	AX
	POP	CX
	POP	DI
	POP	BX
	POP	DX
ret

czydozw:; dozwolone znaki to
	CMP	DL,40 ; '('
	JE	wyjdz0H ; dodaj 1 do liczby lewych nawiasow BH
	CMP	DL,41 ; ')'
	JE	wyjdz0L ; dodaj 1 do liczby prawych nawiasow BL
	CMP	AH,9 ; AH=9 jezeli juz raz wyswietlono ostrzezenie o
	JE	wyjdz0 ; niedozwolonych znakach, nie chce wyswietlac go wielokrotnie
	CMP	DL,42 ; '*'
	JE	wyjdz0
	CMP	DL,43 ; '+'
	JE	wyjdz0
	CMP	DL,45 ; '-'
	JE	wyjdz0
	CMP	DL,47 ; '/'
	JE	wyjdz0
	JG	cyf ; [48, 57] - cyfra

warn:	MOV	AH,9
	MOV	DX,warning
	INT	21h
	JMP	wyjdz0
wyjdz0L:INC	BL
	JMP	wyjdz0
wyjdz0H:INC	BH
wyjdz0: ret

cyf:
	CMP	DL,57
	JLE	wyjdz0 ; [48,57]
	JMP	warn

enter:	; enter
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

parent: ; parenthesize (precedence) - nawiasy (kolejnosc dzialan)
	PUSH	SI
	PUSH	DI
	PUSH	DX
	PUSH	CX
	PUSHF

	;; dwa nawiasy na poczatku
	MOV	DL,40 ; '('
	MOV	[wyrnaw+2],DL
	MOV	[wyrnaw+3],DL
	;;

	MOV	SI,4 ; zmienna do iterowania po wyrnaw
	MOV	DI,2 ; zmienna do iterowania po wyrklaw
	XOR	CH,CH
	MOV	CL,[wyrklaw+1] ; dluosc wyrazenia z klawiatury do LOOP
	XOR	DX,DX
petla: 
	MOV	DL,[wyrklaw+DI]
	
	CALL	czycyf ; czy cyfra
	CALL	plusmin ; czy znak plus/minus
	CALL	mnozdzi ; czy znak mnozenia/dzielenia
	CALL	czynaw ; czy nawias

	INC	DI
LOOP petla
	
	;; dwa zamkniecia nawiasu na koncu
	MOV	DL,41 ; ')', ')'
	MOV	[wyrnaw+SI],DL
	INC	SI
	MOV	[wyrnaw+SI],DL
	;;
	
	SUB	SI,1 ; liczba znakow w wyrnaw, max
	MOV	DX,SI ; 
	MOV	[wyrnaw+1],DL

	POPF
	POP	CX
	POP	DX
	POP	DI
	POP	SI
ret

czycyf: ; sprawdz, czy znak w DL to cyfra lub nawias, jezeli tak
	; to wstaw DL do wyrnaw
	CMP	DL,48 ; cyfry to w ASCII [48,57]
	JL	wyjdz
	CMP	DL,57
	JG	wyjdz
	MOV	[wyrnaw+SI],DL
	INC	SI
wyjdz: ret

plusmin: ; sprawdz, czy znak w DL to plus albo minus
	CMP	DL,43 ; '+'
	JE	wpiszpm ; wpisz operator wraz z nawiasami do wyrnaw (pm - plus/minus)
	CMP	DL,45 ; '-'
	JE	wpiszpm
ret
	
wpiszpm:; teoretycznie powinienem w tych procedurach robic pushf popf
	;; dwa nawiasy zamykajace
	MOV	DH,41 ; ')' ; DH jest nieuzywane
	MOV	[wyrnaw+SI],DH
	INC	SI
	MOV	[wyrnaw+SI],DH
	INC	SI
	;;

	MOV	[wyrnaw+SI],DL ; znak plus/minus
	INC	SI
	
	;; dwa nawiasy zamykajace
	MOV	DH,40 ; '('
	MOV	[wyrnaw+SI],DH
	INC	SI
	MOV	[wyrnaw+SI],DH
	INC	SI

	XOR	DH,DH ; czyszcze DH
ret

mnozdzi:
	CMP	DL,42 ; '*'
	JE	wpiszmd ; wpisz operator wraz z nawiasami do wyrnaw (md - mnoz/dziel)
	CMP	DL,47 ; '/'
	JE	wpiszmd
ret

wpiszmd:
	MOV	DH,41 ; ')'
	MOV	[wyrnaw+SI],DH
	INC	SI

	MOV	[wyrnaw+SI],DL
	INC	SI

	MOV	DH,40 ; '('
	MOV	[wyrnaw+SI],DH
	INC	SI

	XOR	DH,DH
ret

czynaw:
	CMP	DL,40
	JE	wpiszn ; jezeli DL to nawias, wpisz go do wyrnaw (n - nawias)
	CMP	DL,41
	JE	wpiszn
ret

wpiszn:
	MOV	[wyrnaw+SI],DL
	INC	SI
	MOV	[wyrnaw+SI],DL
	INC	SI
	MOV	[wyrnaw+SI],DL
	INC	SI
ret

dorpn:
	PUSH	SI
	PUSH	DI
	PUSH	DX
	PUSH	CX
	PUSH	BX
	PUSH	BP
	PUSH	SP
	PUSHF

	MOV	BP,SP ; zapisuj� pocz�tkowy adres szczytu stosu SP do BP
			; �eby wiedzie�, czy mam jakie� operatory na stosie

			; adresy stosu malej�, czyli je�eli BP-SP>0 to na
			; stosie co� jest

	MOV	DI,2 ; zmienna do iterowania po wyrnaw
	MOV	SI,2 ; zmienna do iterowania po rpn

	XOR	CH,CH ; licznik petli w CL
	MOV	CL,[wyrnaw+1] ; sprawdzam kazdy znak w wyrnaw
	XOR	DX,DX ; rejestr do przetrzymywania znakow z wyrnaw
	XOR	BX,BX ; rejestr do przetrzymywania znak�w ze stosu
		      ; faktycznie to BL, gdyz znaki ascii maja max 8 bitow
		      ; acz adresy maja 16 bitow i musza trafiac do takiej dlugosci rejestru
petla2:
	MOV	DL,[wyrnaw+DI] ; znak z wyrnaw

	CALL	czycyf2 ; czy cyfra
	CALL	czyoper ; czy operator (+, -, *, /)
	CALL	czylewy ; czy lewy nawias
	CALL	czyprawy ; czy prawy nawias

	INC	DI
LOOP petla2

petla3:
	CMP	BP,SP ; wrzuc pozostale operatory ze stosu do wyniku
	JLE	koniec

	POP	BX
	MOV	[rpn+SI],BL
	INC	SI

LOOP petla3

koniec:	
	MOV	SP,BP ; w zasadzie to nie musz� tego robic, mam popy, sp=bp i tak
	SUB	SI,2 ; SI-2 = dlugosc rpn
	MOV	DX,SI
	MOV	[rpn+1],DL ; dlugsc rpn na pozycje rpn+1, w sumie nie wiem po co

	POPF
	POP	SP
	POP	BP
	POP	BX
	POP	CX
	POP	DX
	POP	DI
	POP	SI
ret

czycyf2:
	CMP	DL,48 ; cyfry w ASCII to przedzial [48,57]
	JL	wyjdz2
	CMP	DL,57
	JG	wyjdz2
	MOV	[rpn+SI],DL
	INC	SI
wyjdz2:	ret

czyoper:
	CMP	DL,42 ; '+'
	JE	oper
	CMP	DL,43 ; '*'
	JE	oper
	CMP	DL,45 ; '-'
	JE	oper
	CMP	DL,47 ; '/'
	JE	oper
ret

oper:
	POP	BX ; adres powrotu
	MOV	[temp],BX
petlaop:; petla dla operatora
	CMP	BP,SP ; jezeli na stosie cos lezy
	JLE	wyjdz3
	POP	BX ; to zdejmij to
	CMP	BX,40 ; i jezeli nie jest to lewy nawias
	JE	wyjdz3b
	
	MOV	[rpn+SI],BL ; dodaj operatory o wiekszym precedensie ze stosu do wyniku
	INC	SI

JMP	petlaop
	JMP	wyjdz3
wyjdz3b:PUSH	BX ; lewy nawias z powrotem na stos
wyjdz3:	PUSH	DX ; operator z DL na stos	
	MOV	BX,[temp]
	PUSH	BX ; adres powrotu
ret

czylewy:
	POP	BX ; adres powrotu

	CMP	DL,40 ; jezeli mamy lewy nawias
	JNE	wyjdz5
	PUSH	DX ; to wrzucamy go na stos

wyjdz5:	PUSH	BX ; adres powrotu na stos
ret

czyprawy:
	CMP	DL,41 ; ')'
	JE	prawy
ret

prawy:
	POP	BX ; adres powrotu
	MOV	[temp],BX
petlapr:; petla dla prawego nawiasu (pr - prawy)
	POP	BX ; operator ze stosu, inny niz lewy nawias
	CMP	BX,40 ; jezeli mamy lewy nawias
	JE	wyjdz4 ; to wychodzimy z petli

	MOV	[rpn+SI],BL ; w przeciwnym wypadku dodajemy do wyniku operator ze stosu
	INC	SI

JMP	petlapr

wyjdz4:	MOV	BL,32 ; ' '
	MOV	BH,[rpn+SI-1] ; nie chcemy miec wielu spacji obok siebie
	CMP	BH,BL ; jezeli poprzedni znak to spacja
	JE	wyjdz4b ; to nie chcemy dwoch spacji obok siebie
	MOV	[rpn+SI],BL ; spacje za kazdy prawy nawias
			    ; dla czytelnosci i obslugi liczb wielocyfrowych
	INC	SI
wyjdz4b:MOV	BX,[temp] 
	PUSH	BX ; adres powrotu na stos
	ret
;;