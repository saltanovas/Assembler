.model small

.stack 100h

.data 

	ivesk	   db "Iveskite eilute: $"  
	rezult	   db "Tarpu yra: $"
	niekas     db "Nebuvo niekas ivesta $"
	enteris    db 10, 13, "$"
	dydis      db 255
	nusk       db ?
	buferis    db 255 dup (0)
	
.code 

pradzia:
	MOV	ax, @data
	MOV	ds, ax 
	
	MOV ah, 9			    
	MOV dx, offset ivesk    
	INT	21h			        
	                   
	MOV ah, 0Ah			    
	MOV	dx, offset dydis
	INT	21h
    
    XOR cx, cx     
    MOV cl, nusk            
	MOV bx, offset buferis  
				               
	MOV ah, 9			    
	MOV dx, offset enteris  
	INT	21h			        
	
	CMP cx, 0
	JE  neivesta
	
	xor dx, dx			         
	
	;MOV dl, 20h
	;MOV dh, '9'  
	
	xor ax, ax
	
ciklas:
	;CMP ds:bx, dl 
	;MOV dl, [bx]
	cmp [bx], 32  
	JNE  neprideti
	;CMP ds:bx, dh
	;JA  neprideti    
	INC al

neprideti: 
    INC bx             
    DEC cl
    CMP cl, 0
    JNE ciklas 
    ;LOOP ciklas         
     
    PUSH ax
                                                         
	MOV ah, 9           
	MOV dx, offset rezult
	INT	21h 
	                    
    XOR ax, ax
    XOR bx, bx 
    xor cx, cx
    
    POP ax
    MOV bl, 10
     
dalyba:     
    DIV bl
    PUSH ax
    inc cl
    xor ah, ah
    cmp al, 0
    JNE dalyba
        
isvedimas:
    pop ax
    MOV dl, ah
    ADD dl, 48
    MOV ah, 2
    INT 21h
    LOOP isvedimas
    JMP pabaiga  

neivesta:
    MOV ah, 9			    
	MOV dx, offset niekas  
	INT	21h			     

pabaiga:
	MOV	ah, 4Ch			
	MOV	al, 0			
	INT	21h			    
END pradzia