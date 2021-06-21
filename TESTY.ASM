	org 100h

	MOV	BL,134
	CMP	BL,122

	JG	etyk1
	JA	etyk2

koniec:	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h

etyk1:
	MOV	AH,2
	MOV	DL,65
	INT	21h
	JMP	koniec

etyk2:
	MOV	AH,2
	MOV	DL,66
	INT	21h
	JMP	koniec
	