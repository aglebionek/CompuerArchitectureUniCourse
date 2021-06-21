	org 100h
	
	;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	AH,2
	MOV	DL,13
	INT	21h

	;wczytanie a z klawiatury
	MOV	AH,1
	INT	21h

	;0 = 48, trzeba odjac 48 od wczytanej liczby, zeby miec te liczby
	SUB	AL,48
	MOV	[a],AL ; zapisuje podana liczbe w zmiennej a
	
	;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	AH,2
	MOV	DL,13
	INT	21h

	;wczytuje liczbe
	MOV	AH,1
	INT	21h

	;odejmuje 48 jak wyzej
	SUB	AL,48
	MOV	[b],AL

	;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	AH,2
	MOV	DL,13
	INT	21h

	;wsadzam a do DL i dodaje do tego b (a+b)
	MOV	DL,[a]
	ADD	DL,[b]

	;wyswietlam DL, w ktorym jest (a+b)
	MOV	AH,2
	INT	21h

	;spacja
	MOV	AH,2
	MOV	DL,32
	INT	21h
	
	;przenosze a do DL i odejmuje od tego b (a-b)
	MOV	DL,[a]
	SUB	DL,[b]

	;wyswietlam DL (a-b)
	MOV	AH,2
	INT	21h

	;spacja
	MOV	AH,2
	MOV	DL,32
	INT	21h

	;a do AL, b do AH i mno¾© AH domy˜lnie z AL
	MOV	AL,[a]
	MOV	AH,[b]
	MUL	AH ; AX = AH * AL

	;wyswietlam DL wynik mno¾enia (a*b)
	MOV	AH,2
	MOV	DL,AL
	INT	21h
	
	;spacja
	MOV	AH,2
	MOV	DL,32
	INT	21h

	MOV	AL,[b]
	CMP	AL,0
	JZ	wyk

	;Wsadzam a do AX, b do BH i dziel© AX/BH
	XOR	AX,AX ; wyzerowuje AX ¾eby go u¾y† do dzielenia, bez tego program si© wiesza
	MOV	AL,[a] ; a wsadzam do AL a nie do AX, bo a ma 8 bit¢w i si© program zawiesza po uruchomieniu
	MOV	BH,[b] 
	DIV	BH ; wynik w AL, reszta w AH
	
	MOV	AH,2 ; nadpisuj© reszt©, nie jest potrzebna w zadaniu
	MOV	DL,AL ; wynik dzielenia (caˆkowity) do DL
	INT	21h

	;KONIEC PROGRAMU
koniec:	MOV	AX,4C00h
	INT	21h

wyk:	MOV	AH,2
	MOV	DL,33
	INT	21h
	JMP	koniec

a db 0
b db 0