	;h na ko‰cu liczby - hex
	;org 100h	; Przesuni©cie 
	; AX=5 -przypisanie w normalnym j©zyku
	;MOV	CEL,CO
	;MOV	AX,5
	;MOV	BX,AX
	;INT - Interrupt - przerwij
	;AX=AH+AL
	;16=8+8 bit¢w
	;1111.1111 w bin to 255 w dec
	;dla 4C00 AL = 0000.0000 AL wypeànione r©cznie zerami oznacza
		;prawidàowo zamykany program
	;mov ax, 4C00h jest r¢wnowaæne z MOV AL,0 i MOV AH,76 (MOV AH,4Ch)
	
	;ZNAKI ASCII ΩEBY WYóWIETLIè ENTER
	;mov	AH,2 
	;MOV	DL,10 ;zjechanie w d¢à do nowej lini
	;INT	21H
	
	;MOV	AH,2
	;MOV	DL,13 ;zjechanie na pocz•tek aktualnej lini
	;INT	21H
	;KONIEC ENTERA
	
	;MOV	AH,2 ; instrukcja do wyòwietlenia znaku ascii
	;MOV	DL,66 ; kt¢ry znajduje si© w rejestrze DL i ma wartoòÜ ascii 65
	;INT	21H ; interrupt
	
	;MOV	AH,2 ; - jeæeli dw¢jka jest w tym rejestrze
	;MOV	DL,67 ; - to traktujemy liczb© w rejestrze DL jako znak ascii
	;INT	21H ; - przerwanie dosowe
	;char y = '\n';
	;char x = 65;
	;Console.Write(n, x);
	;'B' - w nowej lini
	
	org 100h

        ;MOV	AH,1
        ;INT	21H		;w AL = znak ascii z klawiatury
	;MOV	CL,AL	;BH BL CH CL DH,AL	

	MOV	AH,2 	;ENTER 1
	MOV	DL,[ZMIENNA]
	MOV	CH,68
	MOV	[ZMIENNA],CH	;int short x = 2;
	INT	21H			;int long y = x;

	MOV	[ZMIENNA],AX
	
	

	;MOV AH,2 	;ENTER 2
	;MOV DL,13
	;INT 21H
	
	;MOV DL,CL 	;DL = AL
	;MOV AH,2
	;INT 21H
	
	;ENTER DWUZNAKOWY
	
	MOV	AH,2
	MOV 	DL,74 ;J - 74
	INT	21H

	;NA KONIEC RK
	
	mov	ax, 4C00h	;KONIEC PROGRAMU
	int	21h;21h - 33 w decimalu
;czy kompilator przy wpisywaniu mniejszej zmiennej do wi©kszej zmiennej
;to czy bardziej znacz•ce bity zostaj• wypeànione zerami
ZMIENNA		DB	66; DB - define byte, DW - define word - 16 bit¢w
ZMIENNA2	DW	67