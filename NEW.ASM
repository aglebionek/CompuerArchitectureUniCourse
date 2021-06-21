org 100h
	CALL enter

;;POBIERZ TEKST
	MOV	AH,10
	MOV	DX,tekst2
	INT	21h
;;

	CALL enter

;;POBIERZ PRZESUNIECIE
	XOR	DX,DX
	MOV	AH,1
	INT	21h
	SUB	AL,48
	MOV	[przes],AL
;;

	CALL enter

;;WYSW PRZESUNIECE
	MOV	AH,2
	MOV	DL,[przes]
	INT	21h
;;	

	CALL enter	

;;WYSW DLUGOSC TEKSTU
	MOV	DL,[tekst2+1]
	INT	21h
;;

	CALL enter

;;ZAPETLAM ALFABET
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

;JMP wysw	
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
;	MOV	AH,2 ;DEBUG
;	INT	21h ;DEBUG
	CALL enter
	CMP	DX,0 ; jezeli przesuniecie to 0 to nie ma co dodawac
	JZ	wysw
	XOR	DX,DX
a:
	;MOV	AL,[tekst2+2+SI] ; sprobowac z AL,DL
	;ADD	
	;MOV	DX,AX	; debug
	;XOR	AX,AX	; debug
	;MOV	AH,2	; debug
	;INT	21h	; debug
	MOV	DL,[tekst2+2+SI]
	ADD	DL,[przes]
	MOV	[tekst2+2+SI],DL
;	MOV	DL,[tekst2+2+SI]
	INC	SI
LOOP a
;;																																																																																																																	

;	XOR	AX,AX
;	XOR	DX,DX
;	XOR	CX,CX
;	MOV	CL,[tekst2+1]
;	MOV	SI,0
;	MOV	AH,2

;b:
;	MOV	DL,[tekst2+2+SI]
;	INT	21h
;	INC	SI
;LOOP b	
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

tekst2	DB	25
	DB	0
	TIMES	26	DB	36 ;; zdanie do zakodowania

przes DW 0

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