org 100h

	CALL	enter

	MOV	BP,SP
	
	MOV	AH,1
	;MOV	CX,2
	MOV	BX,32
wczytaj1:
	INT	21h
	CMP	AL,13
	JE	wyjdz1
	PUSH	AX
	;PUSH	BX
	SUB	SP,2
JMP wczytaj1
wyjdz1:	;CALL	enter
;	MOV	AH,2
;wypisz1:
;	CMP	BP,SP
;	JE	wyjdz0
;	POP	DX
;	INT	21h
;JMP wypisz1
;wyjdz0:
;	CALL	enter	
;	MOV	AH,1
	MOV	SP,BP
	SUB	SP,2
wczytaj2:
;	SUB	SP,2
	INT	21h
	CMP	AL,13
	JE	wyjdz2
	PUSH	AX
	SUB	SP,2
JMP wczytaj2
wyjdz2:
	MOV	AH,2

wypisz2:
	CMP	BP,SP
	JE	wyjdz3
	POP	DX
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