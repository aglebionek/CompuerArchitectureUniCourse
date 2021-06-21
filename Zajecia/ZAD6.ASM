org 100h
	CALL enter

	;;POBIERZ TEKST
	MOV	AH,10
	MOV	DX,tekst2
	INT	21h
	;;

	CALL enter
	XOR	DX,DX

	;;POBIERZ PRZESUNIECIE
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

	;WYSW DLUGOSC TEKSTU
	MOV	DL,[tekst2+1]
	INT	21h
	;;

	MOV	CL,DL ; dlugosc tekstu do petli
	
	CALL enter
	
	;;PRZESUN WSZYSTKIE WPISANE ZNAKI O PODANA WARTOSC
	XOR	SI,SI
	XOR	AX,AX
	XOR	BX,BX
	XOR 	DX,DX
	
	MOV	AX,[przes]
	MOV	BX,26	; 26 liter alfabetu
	DIV	BX	; przesuniece to przes%26, znajduje sie w DX

	MOV	AH,2 ;DEBUG
	INT	21h ;DEBUG
	CALL enter
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

	XOR	AX,AX
	XOR	DX,DX
	;;WYSWIETL TEKST
	MOV	AH,9
	MOV	DX,tekst2+2
	INT	21h
	;;

	;;ZAKONCZ PROGRAM
	mov	ax, 4C00h
	int	21h
	;;

tekst2	DB	25
	DB	0
	TIMES	26	DB	36

przes DW 0

enter:
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
ret