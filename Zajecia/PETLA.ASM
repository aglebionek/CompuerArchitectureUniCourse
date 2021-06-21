	org 100h

start:
	MOV	CX,5 ; rejestr CX sˆu¾y jako iterator do p©tli
	MOV	DL,66
	MOV	AH,2

petla:
	INT	21h

	LOOP petla ; loop etykieta, dec cx, cmp cx,0,
	;jg petla - je˜li cx > 0 to skacze do petla
	;petla leci od 5 do 0

	MOV	CX,0
	MOV	DL,67
	MOV	AH,2
petla2:
	INT	21h

	INC CX ; increment cx
	CMP CX,5
	JNZ petla2 ; jump if not zero - koäczy gdy dojdziemy do 0???

	;ZNAK ASCII ZAPISUJE SI¨ W AL

	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h