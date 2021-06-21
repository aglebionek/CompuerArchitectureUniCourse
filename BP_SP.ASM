org 100h


	PUSH	BP

	MOV	BP,SP ; do BP wrzucam adres wierzchu stosu Stack Pointer

	SUB	SP,2 ; przesuwam Stack Pointer w dol, robiac miejsce na dwa adresy
	


	mov	ax, 4C00h; KONIEC PROGRAMU
	int	21h

a:
	PUSH	BP
	MOV	BP,SP
	SUB	SP,2
	
	POP	BP
ret