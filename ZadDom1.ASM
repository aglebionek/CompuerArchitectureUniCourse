	ORG	100h	;Przesuni�cie

	;Przej�cie do nowej lini
	MOV	AH,2	
	MOV	DL,10
	INT	21h

	;Przej�cie do pocz�ku lini
	MOV	AH,2
	MOV	DL,13
	INT	21h

	;Imi�
	MOV	AH,2
	MOV	DL,65	;'A'
	INT	21h

	MOV	AH,2
	MOV	DL,108	;'l'
	INT	21h

	MOV	AH,2
	MOV	DL,101	;'e'
	INT	21h

	MOV	AH,2
	MOV	DL,107	;'k'
	INT	21h

	MOV	AH,2
	MOV	DL,115	;'s'
	INT	21h

	MOV	AH,2
	MOV	DL,97	;'a'
	INT	21h

	MOV	AH,2
	MOV	DL,110	;'n'
	INT	21h

	MOV	AH,2
	MOV	DL,100	;'d'
	INT	21h

	MOV	AH,2
	MOV	DL,101	;'e'
	INT	21h

	MOV	AH,2
	MOV	DL,114	;'r'
	INT	21h	

	;Spacja
	MOV	AH,2
	MOV	DL,32
	INT	21h

	;Nazwisko
	MOV	AH,2
	MOV	DL,71	;'G'
	INT	21h

	MOV	AH,2
	MOV	DL,108	;'l'
	INT	21h

	MOV	AH,2
	MOV	DL,101	;'e'
	INT	21h

	MOV	AH,2
	MOV	DL,98	;'b'
	INT	21h

	MOV	AH,2
	MOV	DL,105	;'i'
	INT	21h

	MOV	AH,2
	MOV	DL,111	;'o'
	INT	21h

	MOV	AH,2
	MOV	DL,110	;'n'
	INT	21h

	MOV	AH,2
	MOV	DL,101	;'e'
	INT	21h

	MOV	AH,2
	MOV	DL,107	;'k'
	INT	21h

	;Zawieszenie programu oczekiwaniem na input (C# - Console.ReadKey())
	MOV	AH,1
	INT	21h

	;Prawid�owe zako�czenie programu
	MOV	AX,4C00h
	INT	21h