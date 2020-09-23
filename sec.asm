;Programa viename faile iesko nurodyto fragmento ir i kita isveda eiluciu,
;kuriose rastas sis fragmentas, numerius ir pacias eilutes     

.model small                                     

BufDydis EQU 255                          

.stack 100h                         

.data  
    klaida1                 db "neteisingai ivesti duomenys", 10, 13, '$'
    klaida2                 db "nepilnai isvesti duomenys", 10, 13,'$'
    klaida3                 db "ivyko klaida rasant duomenis", 10, 13,'$'
    klaida4                 db "ivyko klaida skaitant duomenis", 10, 13,'$'
    help                    db "Programa viename faile iesko nurodyto fragmento ir i kita isveda eiluciu, kuriose rastas sis fragmentas, numerius ir pacias eilutes", 10, 13, "$"
    buferis1                db BufDydis dup (0)
    dHandle                 dw ?
    rHandle                 dw ?
    duomf                   db 20 dup (0)
    fragmentas              db 20 dup (0)
    rezf                    db 20 dup (0)
    duomenusk               dw 0 
    eilutes_numeris         dw 0      
    fragmento_ilgis         dw 0 
    ar_buvo_fragmentas      db 0    
    eilutes_ilgis           dw 0 
    eilutes_pradzia         dw 0 
    isvesti_eilutes_numeris db 0, 32, 58 
    naujas db ?
    adresas dw 100h
    
.code    
pradzia:
    mov ax, @data
    mov ds, ax   
        
    mov si, 81h
    mov di, offset duomf
    call parametruSkaitymas             
    mov di, offset rezf
    call parametruSkaitymas  
     
failo_atidarymas:
    mov dx, offset duomf                           
    mov ah, 3dh
    mov al, 00
    int 21h
    jc klaida                 
    mov dHandle, ax
                                    
kuriamFaila:
    mov ah, 3ch
    mov cx, 0
    mov dx, offset rezf
    int 21h
    jnc neklaida
    jmp klaida
    neklaida:
    mov rHandle, ax
    
atidarom_rezfaila:
    mov ah, 3dh
    mov al, 1
    mov dx, offset rezf
    int 21h            
    mov rhandle, ax 
  
skaitomDuom:    
    mov bx, dHandle
    call SkaitomBuf 

    mov cx, duomenusk
    mov di, offset buferis1  
    jmp l1
;----------------------------- 
isnaujo:
    add di, 2     
  
l7:
    add eilutes_ilgis, 2
    cmp ar_buvo_fragmentas, 0
    jg isvedimas
    
l6:       
    cmp cx, 0  
    je uzdaromDuom
    
l1:                                                           
    mov si, offset fragmentas   
    mov ar_buvo_fragmentas, 0
    mov eilutes_ilgis, 0
    inc eilutes_numeris
    mov eilutes_pradzia, di
   
algoritmas: 
    mov dl, byte ptr[si]      
    mov dh, byte ptr[di]     
    cmp dl, dh
    je tinka 
l2:
    cmp dh, 13
    je isnaujo               
    mov si, offset fragmentas 
    mov dl, byte ptr[si]       
    mov dh, byte ptr[di]     
    cmp dl, dh
    je tinka 
l5:
    dec cx  
    inc eilutes_ilgis
    inc di
    cmp cx, 0  
    jne algoritmas
    cmp ar_buvo_fragmentas, 0
    jg isvedimas 
    jmp uzdaromDuom

tinka: 
    xor bx, bx
    mov bx, si
    sub bx, offset fragmentas
    add bx, 1  
    cmp bx, fragmento_ilgis 
    jne l4
    mov si, offset fragmentas 
    mov ar_buvo_fragmentas, 1 
    jmp algoritmas
l4:
    inc si
    jmp l5      
       
isvedimas:
    push cx 
    push si
    mov si, offset isvesti_eilutes_numeris
    mov bx, eilutes_numeris
    mov [si], bx
    add word ptr[si], 48
    
    mov ah, 40h
    mov cx, 3
    mov bx, rHandle
    mov dx, offset isvesti_eilutes_numeris
    int 21h
    pop si
    
    mov ar_buvo_fragmentas, 0
      
    mov ah, 40h
    mov cx, eilutes_ilgis 
    mov eilutes_ilgis, 0
    mov dx, eilutes_pradzia  
    int 21h
    pop cx
    jmp l6
    
;-----------------------------                    
uzdaromDuom:
    mov ah, 3eh
    mov bx, dHandle
    int 21h
    jc klaida
        
uzdaromRez:
    mov ah, 3eh
    mov bx, rHandle
    int 21h
    jc klaida
        
pabaiga:
    mov ah, 4ch
    int 21h
                               
klaida:
    mov dx, offset klaida1
    mov ah, 09h
    int 21h
    jmp pabaiga
    
pagalba:
    mov dx, offset help
    mov ah, 09h
    int 21h
    jmp pabaiga
       
proc parametruSkaitymas   
kelione:      
    mov ax, es:[si] 
    inc si      
    cmp al, 0dh     
    je klaida
    cmp al, 20h
    je kelione     
    cmp ax, "?/"
    jne skaitom
    mov ax, es:[si]
    cmp ah, 0dh
    je pagalba
        
skaitom:  
    mov byte ptr[di], al 
    inc di
    mov ax, es:[si]
    inc si
    cmp al, 0
    je uzteks
    cmp al, 0dh
    je uzteks
    cmp al, 20h  
    jne skaitom
          
uzteks:
    ret
        
parametruSkaitymas endp

proc SkaitomBuf 
    mov ah, 3fh  
    mov dx, offset buferis1
    mov cx, BufDydis
    int 21h 
    mov duomenusk, ax      
    jc klaida 
    ret
    
SkaitomBuf endp 
end pradzia