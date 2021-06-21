	org 100h

	MOV	AH,10
	MOV	DX,zmien
	INT	21h

	XOR	DX,DX

	MOV	AH,2
	MOV	SI,3
	MOV	DL,[zmien+SI]
	INT	21h

	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h

zmien DB 4,0,36,36,36,36