	org 100h

	;;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
	;;enter


;;IMIE
	MOV	AH,2 ; Do wyswietlania liter
	XOR	DI,DI ; Zeruj© rejestr pomocniczy
komun:
	MOV	DL,[kom1+DI]
	INT	21h
	INC	DI
	CMP	DI,10
	JNE	komun


	;;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
	;;enter


	MOV	AH,1 ; Do wczytywania z klawiatury
	XOR	DI,DI ; Zeruje rejestr pomocniczy
czytaj:	
	INT 	21h
	CMP	AL,13
	JE	wyjdz
	MOV	[imie+DI],AL
	INC	DI
	JNE	czytaj


wyjdz:
	MOV	[dlug1],DI ; zapisuje dlugosc imienia do zmiennej dlug1
;;IMIE


;;NAZWISKO
	MOV	AH,2 ; do wyswietlania liter
	XOR	DI,DI ; zeruje rejestr pomocniczy
komun2:
	MOV	DL,[kom2+DI]
	INT	21h
	INC	DI
	CMP	DI,14
	JNE	komun2


	;;enter
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
	;;enter


	MOV	AH,1 ; do wczytwywania z klawiatury
	XOR	DI,DI ; zeruje rejestr pomocniczy
czytaj2:
	INT	21h
	CMP	AL,13
	JE	wyjdz2
	MOV	[nazwisko+DI],AL
	INC	DI
	JNE	czytaj2


wyjdz2:
	MOV	[dlug2],DI ; zapisuje dlugosc nazwiska do zmiennej dlug2
;;NAZWISKO


;;Sprawdzanie czy litery (nie biore pod uwage liter innych niz lacinskie)
;;imie
check1:
	MOV	AH,2
	XOR	DI,DI
petla:
	CMP	DI,[dlug1]
	JE	check2
	MOV	DL,122
	CMP	[imie+DI],DL
	JG	nieLit
	MOV	DL,65
	CMP	[imie+DI],DL
	JL	nieLit
	MOV	DL,90
	CMP	[imie+DI],DL
	JG	czyLit
	INC	DI
	JMP	petla

czyLit:
	MOV	DL,97
	CMP	[imie+DI],DL
	JL	nieLit
	INC	DI
	JMP	petla
;;imie
;;nazwisko
check2:
	MOV	AH,2
	XOR	DI,DI
petla2:
	CMP	DI,[dlug2]
	JE	wysw0
	MOV	DL,122
	CMP	[nazwisko+DI],DL
	JG	nieLit
	MOV	DL,65
	CMP	[nazwisko+DI],DL
	JL	nieLit
	MOV	DL,90
	CMP	[nazwisko+DI],DL
	JG	czyLit2
	INC	DI
	JMP	petla2

czyLit2:
	MOV	DL,97
	CMP	[nazwisko+DI],DL
	JL	nieLit
	INC	DI
	JMP	petla2
;;nazwisko	
nieLit:		
	MOV	AH,2
	XOR	DI,DI
komun3:
	MOV	DL,[kom3+DI]
	INT	21h
	INC	DI
	CMP	DI,21
	JNE	komun3


	;;ENTER
	MOV	AH,2
	MOV	DL,10
	INT	21h
	MOV	DL,13
	INT	21h
	;;ENTER
	

;;Sprawdzanie czy litery (nie biore pod uwage liter innych niz lacinskie)


wysw0:
;;Wyswietl imie i nazwisko
	MOV	AH,2
	XOR	DI,DI
wysw1:
	MOV	DL,[imie+DI]
	INT	21h
	INC	DI
	CMP	DI,[dlug1]
	JNE	wysw1


	;;spacja
	MOV	DL,32
	INT	21h
	;;spacja


	XOR	DI,DI
wysw2:
	MOV	DL,[nazwisko+DI]
	INT	21h
	INC	DI
	CMP	DI,[dlug2]
	JNE	wysw2
;;Wyswietl imie i nazwisko


koniec:
	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h

kom1 DB 'P','o','d','a','j',32,'i','m','i','e'
kom2 DB 'P','o','d','a','j',32,'n','a','z','w','i','s','k','o'
kom3 DB 'I','n','n','e',32,'z','n','a','k','i',32,'n','i','z',32,'l','i','t','e','r','y'
dlug1 DW 36
dlug2 DW 36
imie TIMES 50 DB 36
nazwisko TIMES 50 DB 36