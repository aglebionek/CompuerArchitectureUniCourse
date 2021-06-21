org 100h
	CALL enter

;;POBIERZ TEKST
	MOV	AH,10
	MOV	DX,tekst2
	INT	21h
;;

	CALL enter

;;POBIERZ PRZESUNIECIE
	MOV	AH,10
	MOV	DX,licz
	INT	21h
;;

	CALL enter

;;ZAMIEN PRZESUNIECIE Z ASCII NA CYFRY
	MOV	CL,[licz+1] ; liczba cyfr w przesunieciu do LOOP
	XOR	DX,DX
	XOR	SI,SI
cyf:
	MOV	DL,[licz+2+SI]
	SUB	DL,48
	MOV	[licz+2+SI],DL
	INC	SI
LOOP cyf
;;

;;POLACZ POSZCZEGOLNE CYFRY PRZESUNIECIA WE WLASCIWA LICZBE
	XOR	AX,AX
	XOR	BX,BX
	XOR	CX,CX
	XOR	DX,DX

	MOV	CL,[licz+1] ; do CL a nie do CX, dla pewnosci, bo [licz+1] to DB
	CBW ; Convert Byte to Word, rozszerza CL do CX
	MOV	SI,CX ; wsadzanie [licz+1] do SI nie dzialalo
	MOV	BX,1 ; 10^pozycja
	MOV	[przes],AX ; upewniam sie, ze w [przes] jest 0

; NOTE ta petla robi rzeczy nawet po obliczeniu koncowego wyniku
; wiec jest nieefektywna, ale wreszcie wszystko dziala wiec nie chce jej dotykac
pol:
	MOV	AL,[licz+1+SI] ; cyfra przesuniecia
	CBW ; rozszerza AL na AX, do 16-bitowego mnozenia	
	MUL	BX ; DX:AX=AX*BX cyfra przesuniecia razy 10^pozycja
	XOR	DX,DX ; teoretycznie moga sie pojawic smieci w DX, ze wzgl na 16bitowe mnozenie
	MOV	DX,[przes] ; obliczone poki co przesuniecia
	ADD	AX,DX ; przesuniecia dodawane do cyfra*10^pozycja z tej petli
	MOV	[przes],AX ; uaktualnianie obliczonych poki co przesuniec
	CALL tys ; uaktualnienie pozycja do nastepnej petli
	DEC	SI
LOOP pol
;;

	CALL enter

;;ZAPETLAM ALFABET
	XOR	AX,AX
	XOR	BX,BX
	XOR	CX,CX
	XOR	SI,SI ; do przesuwania po tablicy tekst2
	XOR	DX,DX ; litery z tekst2 do DL (latwiejszy debug)
	MOV	BL,32 ; spacja
	MOV	CL,[tekst2+1] ; dlugosc tekstu do LOOP

alfab:
	INC	SI 
	MOV	DL,[tekst2+1+SI] ; litera tekstu do DL
	CMP	DL,65
	JL	nielit ; mniejsze jak 65 - nie jest litera
	CMP	DL,122
	JG	nielit ; wieksze jak 122 - nie jest litera
	CMP	DL,97
	JL	nielit2 ; przedzial (90,97) - nie jest litera
else:	CMP	DL,65
	JGE	namala ; przedzial [65,90] - wielka litera, zamieniam na mala
lp:     LOOP	alfab ; dlugosc tablicy jest w CL, uzywam mnemonika LOOP
;;

;;PRZESUN WSZYSTKIE WPISANE ZNAKI O PODANA WARTOSC
	XOR	SI,SI
	XOR	AX,AX
	XOR	BX,BX
	XOR 	DX,DX
	MOV	CL,[tekst2+1] ; dlugosc tekstu do LOOP
	

	MOV	AX,[przes] ; wartosc przesuniecia do AX
	MOV	BX,26	; 26 liter alfabetu
	DIV	BX	; przesuniece to przes%26, znajduje sie w DX
	MOV	[przes],DX ; przes zawsze z przedzialu [0,25]
	CMP	DX,0 ; jezeli przesuniecie to 0 to nie ma co dodawac
	JZ	wysw
	XOR	BX,BX
	XOR	DX,DX	
a:
	MOV	DL,[tekst2+2+SI]
	ADD	DL,[przes]
	MOV	[tekst2+2+SI],DL
	MOV	DL,[tekst2+2+SI]
	INC	SI
LOOP a
;;																																																																																																																	
	
;;WYSWIETL TEKST AH9
wysw:
	XOR	AX,AX
	XOR	DX,DX
	MOV	AH,9
	MOV	DX,tekst2+2
	INT	21h
;;

;;ZAKONCZ PROGRAM
	MOV	AX,4C00h
	INT	21h
;;

;;ZMIENNE
tekst2	DB	25
	DB	0
	TIMES	26	DB	36 ;; zdanie do zakodowania

licz 	DB	5
	DB	0
	TIMES 	6	DB	36 ;; przesuniecie jako cyfry

przes	DW	0
;;

;;FUNKCJE, ETYKIETY
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

nielit:
	MOV	[tekst2+1+SI],BL
	JMP	lp ; lp = LOOP alfab

nielit2:
	CMP	DL,90 
	JG	nielit ; przedzial (90,97)
	JMP	else
	
namala:
	CMP	DL,90
	JLE	namala2 ; przedzial [65,90]
	JMP	lp ; lp = LOOP alfab

namala2:
	ADD	DL,32 ; zamieniam duza na mala
	MOV	[tekst2+1+SI],DL
	JMP	lp

tys:
	PUSH	AX
	PUSH	DX
	MOV	AX,BX ; AX = 10^pozycja
	MOV	DX,10
	MUL	DX ; przesuwam pozcyje o jeden w lewo
	MOV	BX,AX ; umieszczam pozycje w BX
	POP	DX
	POP	AX
ret
;;