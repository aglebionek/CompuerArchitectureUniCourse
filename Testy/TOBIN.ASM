org 100h

        XOR	AX,AX
	XOR	BX,BX
	XOR	CX,CX
;	XOR	DX,DX
	MOV	AX,0E30h;AH,2 ; AH = 14 (do przerwania), AL = 48 (0 w ASCII)
	MOV	BX,36 ; liczba do wypisania na BIN (16 bitowa)
	MOV	CX,16 ; 16 bitowa liczba do wypisania
;	MOV	DL,30h

petla:
	AND	AL,30h;DL,30h ; ustawiam pierwszy bit znowu na 0 (AL=48)
	SHL	BX,1 ; przesuwam BX o jeden w lewo, lewy bit wchodzi do flagi CF
	ADC	AL,0;DL,0 ; 0+CF (ADC - add with carry)
	INT	10h;21h ; dla AH = 14 wyswietl AL
loop petla

    mov ax,4c00h
    int 21h
