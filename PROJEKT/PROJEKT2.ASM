org 100h

	CALL	enter

	MOV	BP,SP
	MOV	BX,BP
	
	MOV	AH,1
wczytaj1:
	INT	21h
	CMP	AL,13
	JE	wyjdz1
	PUSH	AX
JMP wczytaj1
wyjdz1:	
;	SUB	BP,2
wczytaj2:
	SUB	BX,2
	INT	21h
	CMP	AL,13
	JE	wyjdz2
	MOV	DX,[BX]
	MOV	DH,AL
	MOV	[BX],DX
JMP wczytaj2
wyjdz2:
	MOV	AH,2

wypisz2:
	CMP	BP,SP
	JE	wyjdz3
	POP	DX
	INT	21h
	MOV	DL,DH
	INT	21h
	;ADD	SP,2
JMP wypisz2
wyjdz3:

MOV	AX, 4C00h; KONIEC PROGRAMU
INT	21h

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