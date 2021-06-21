org 100h        ; to będzie program typu .com

main:           ; etykieta dowolna, nawet niepotrzebna        
    pushf          ; 32 bity flag idą na stos        
    mov ah,0eh    ; AH = 0eh, czyli funkcja wyświetlania, AL = 30h = kod ASCII cyfry zero        
    mov	al,30h
    pop si         ; flagi ze stosu do ESI
    mov cx,16       ; tyle bitów i tyle razy trzeba przejść przez pętlę

petla:                  ; etykieta oznaczająca początek pętli.        
    and al,30h
    shl si,1
    adc al,0
    int 10h
loop petla

    mov ax,4c00h
    int 21h
