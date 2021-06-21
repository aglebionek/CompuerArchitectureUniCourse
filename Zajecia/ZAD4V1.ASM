org 100h
;;procedury nie nadpisuj¥ warto˜ci rejestr¢w,
;; warto˜ci a i b s¥ w procedurach czytane ze zmiennych
	PUSHA
	PUSHF
	
	CALL	enter

	;wczytanie a z klawiatury
	MOV	AH,1
	INT	21h

	;0 = 48, trzeba odjac 48 od wczytanej liczby, zeby miec te liczby
	SUB	AL,48
	MOV	[a],AL ; zapisuje podana liczbe w zmiennej a

	CALL	enter

	;wczytuje b z klawiatury
	MOV	AH,1
	INT	21h

	;odejmuje 48 jak wyzej
	SUB	AL,48
	MOV	[b],AL

	CALL	enter

	CALL	add

	CALL	spacja

	CALL 	sub

	CALL	spacja

	CALL	mul
	
	CALL	spacja

	CALL	div


	;KONIEC PROGRAMU
koniec:
	POPF
	POPA

	MOV	AX,4C00h
	INT	21h

wyk:
	MOV	AH,2
	MOV	DL,33
	INT	21h
	JMP	koniec

a dw 0
b dw 0
CXkopia dw 0

enter:
	PUSH	AX
	PUSH	DX

	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h

	POP DX
	POP AX
ret

spacja:
	PUSH	AX
	PUSH	DX

	MOV	AH,2
	MOV	DL,32
	INT	21h

	POP	DX
	POP	AX
ret

add:
	MOV	[CXkopia],CX
	POP	CX ; adres powrotu do CALL
	PUSH	DX
	PUSH	AX
	MOV	AX,[b] ; [b]
	MOV 	DX,[a] ; [a]
	
	ADD	DX,AX ; dodaje do a b

	;wyswietl wynik
	MOV	AH,2
	INT	21h

	POP	AX
	POP	DX
	PUSH	CX ; klade adres powrotu na stos
	MOV	CX,[CXkopia]
ret

sub:
	MOV	[CXkopia],CX
	POP	CX
	PUSH	DX
	PUSH	AX
	MOV	AX,[b]
	MOV	DX,[a]
	
	SUB	DX,AX

	MOV	AH,2
	INT	21h

	POP	AX
	POP	DX
	PUSH	CX
	MOV	CX,[CXkopia]
ret

mul:
	MOV	[CXkopia],CX
	POP	CX
	PUSH	AX
	MOV	AL,[a]
	MOV	AH,[b]

	MUL	AH

	MOV	DX,AX
	MOV	AH,2
	INT	21h

	POP	AX
	PUSH	CX
	MOV	CX,[CXkopia]
ret

div:
	MOV	[CXkopia],CX
	POP	CX
	PUSH	DX
	PUSH	AX
	
	MOV	AX,[b]
	CMP	AX,0
	JE	wyk

	XOR	AX,AX
	XOR	DX,DX

	MOV	DH,[b]
	MOV	AL,[a]

	DIV	DH
	
	MOV	AH,2
	MOV	DL,AL
	INT	21h

	POP	AX
	POP	DX
	PUSH	CX
	MOV	CX,[CXkopia]
ret