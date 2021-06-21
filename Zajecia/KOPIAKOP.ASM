	org 100h

	;ah	 al
	;0000011 00000101

	MOV	AL,5
	MOV	AH,3
	CMP	AL,AH ; CMP - compare, od AL odejmujemy AH, por¢wnanie
	;lewej z prawym
	;ZF=0	zero flag, nie jest r¢wne zero
	;SF=0	sign flag, AL > AH, 5 > 3


	MOV	AH,2
	jg	etyk1 ; jump if greater, true
	;JMP - jump, bez warunku, po prostu skipnij linijk©
	MOV	AH,1 ; skoro true, to przeszkoczy t© linijk©
etyk1:	MOV	DL,66 ;'B'

	;[ety1 : mnemonik	arg,arg2 ; komentarz \n]

	INT 21h

	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h