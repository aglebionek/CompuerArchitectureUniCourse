org 100h
;; procedury nadpisuj¥ warto˜ci rejestr¢w,
;; warto˜ci a i b s¥ w procedurach czytane ze stosu
	PUSHA
	PUSHF
	
	CALL	enter

	;wczytanie a z klawiatury
	MOV	AH,1
	INT	21h

	;0 = 48, trzeba odjac 48 od wczytanej liczby, zeby miec te liczby
	SUB	AL,48
	MOV	[a],AL ; zapisuje podana liczbe w zmiennej a

	PUSH	AX ; klade AX (a) na stos
	
	CALL	enter

	;wczytuje b z klawiatury
	MOV	AH,1
	INT	21h

	;odejmuje 48 jak wyzej
	SUB	AL,48
	MOV	[b],AL

	PUSH	AX ; klade AX (b) na stos	//stos: b,a

	CALL	enter

	CALL 	add

	CALL spacja

	MOV	BX,[a]
	PUSH	BX
	MOV	BX,[b]
	PUSH	BX

	CALL 	sub

	CALL	spacja

	MOV	BX,[a]
	PUSH	BX
	MOV	BX,[b]
	PUSH	BX

	CALL	mul
	
	CALL	spacja

	MOV	BX,[a]
	PUSH	BX
	MOV	BX,[b]
	PUSH	BX

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
	POP	CX ; adres powrotu do CALL
	POP	AX ; b do AX
	POP	DX ; a do DX
	
	ADD	DX,AX ; dodaje do a b

	;wyswietl wynik
	MOV	AH,2
	INT	21h

	PUSH	CX
ret

sub:
	POP	CX ;; patrz etykiete add
	POP	AX ; b
	POP	DX ; a
	
	SUB	DX,AX

	MOV	AH,2
	INT	21h

	PUSH	CX
ret

mul:
	POP	CX
	POP	AX ; b
	POP	DX ; a	
	
	MOV	AH,DL
	MUL	AH

	MOV	DX,AX
	MOV	AH,2
	INT	21h

	PUSH	CX
ret

div:
	POP	CX

	POP	DX ; b
	CMP	DX,0
	JE	wyk

	POP	AX ; a

	DIV	DL
	
	MOV	AH,2
	MOV	DL,AL
	INT	21h

	PUSH	CX
ret