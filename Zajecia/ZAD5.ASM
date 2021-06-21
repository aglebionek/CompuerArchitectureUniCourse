org 100h

	CALL	enter
czyt:
	MOV	AH,1
	INT	21h ; wczytuje liczbe n

	SUB	AL,48 ; odejmuje 48 zeby miec liczbe, nie znak ASCII
	MOV	AH,0 ; liczba jest w AL, w AH sa smieci, trzeba wyzerowac zeby uzyc AX
	XOR	CX,CX
	MOV	CX,AX ; n w CX, w AX bedzie wynik mnozenia

	CALL	enter

	XOR	AX,AX
	MOV	AX,1
	XOR	DX,DX
silnia:
	MUL	CX ; dla n<=8 wynik bedzie w AX
LOOP silnia
	
	XOR	BX,BX
	MOV	BX,10
	XOR	CX,CX ; bede liczyl ile jest bitow
reszty:
	XOR	DX,DX
	DIV	BX ; 
	PUSH	DX ; reszta na stos, czyli najmniej znaczaca cyfra w dziesietnym
	INC	CX
	CMP	AX,0 ; dziele dopoki AX nie jest 0
	JG	reszty

	MOV	AH,2
wysw:
	POP	DX ; zdejmuje reszty od najbardziej do najmniej znaczacej
	ADD	DX,48 ; by miec znak ASCII reszty (reszta z dzielenia przez 10 jest w przedziale <0,9>)
	INT	21h
LOOP wysw

koniec:
	MOV	AX,4C00h
	INT	21h

enter:
	POP	BX ; adres powrotu
	PUSH	AX ; zgodnie ze sztuk¥
	PUSH	DX

	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h

	POP	DX
	POP	AX
	PUSH	BX
ret