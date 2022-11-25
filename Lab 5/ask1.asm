; Microcomputer Systems - Roh Y [6th Semester]  
; 5th Series of Exercises
; Kazdagli Ariadni - 03118838 
; Vitalis Vikentios - 03118803 
   

INCLUDE macros.asm
    
    

DATA_SEG    SEGMENT
    TABLE   DB 128 DUP(?)
    AVERAGE DB ?
    MIN     DB ?
    MAX     DB ?
    NEWLINE DB 0AH,0DH,'$' 
DATA_SEG    ENDS



CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
   
    
    
MAIN PROC FAR
    
    MOV AX,DATA_SEG  ; important initialization
    MOV DS,AX
    
        
    ; in this part data is stored    
    MOV AL,128   ; initialize counter
    MOV DI,0     ; initialize index
STORE:
    MOV [TABLE+DI],AL  
    DEC AL
    INC DI
    CMP DI,128
    JNE STORE   

     
    ; in this part average is calculated 
    MOV DX,0    ; initialize counter to store the sum       
    MOV DI,0    ; initialize index to 0
    MOV AX,1    ; temporary register
SUM:
    MOV AL,[TABLE+DI]
    ADD DX,AX
CONT:
    ADD DI,2
    CMP DI,128
    JNE SUM    
END_COUNT:      ; sum of all peritton in DX
    MOV AX,DX
    MOV DX,1
    MOV CX,64
    DIV CX      ; divide the sum by 64
    MOV DX,AX   
    MOV AVERAGE,DL  ; average is now calculated and stored
      
      
    ; in this part min and max are calculated  
    MOV MAX,1   ; initializations
    MOV MIN,128
    MOV DI,0
    
MIN_MAX:
    MOV AL,[TABLE+DI]
    CMP MIN,AL          ; MIN =< AL ?
    JNA GO_MAX          ; if yes, then go see for max
    MOV MIN,AL          ; else update minimum data
GO_MAX:
    CMP MAX,AL          ; MAX >= AL ?
    JAE ITS_MAX         ; if yes, then continue
    MOV MAX,AL          ; else update maximum data
ITS_MAX:
    INC DI
    CMP DI,128
    JNE MIN_MAX    
    
    
    
    ; in this part, demanded data is printed
	MOV CX,1
	MOV AL,AVERAGE
	MOV DL,10

LD:
	MOV AH,0
	DIV DL
	PUSH AX
	CMP AL,0
	JE PRINT_AVERAGE
	INC CX
	JMP LD

PRINT_AVERAGE:
	POP AX
	MOV AL,AH
	MOV AH,0
	ADD AX,'0'
	PRINT AL
	LOOP PRINT_AVERAGE 
	
	PRINTLN NEWLINE
        
        
        
    MOV AL,MIN          ; PRINT MINIMUM DATA
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB
    CMP AL,0
    JE NEXT_DIGIT 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK2
    ADD AL,07H   ; if it's a letter, fix ASCII
OK2: 
    PRINT AL     ; print the first hex digit
NEXT_DIGIT:    
    MOV AL,MIN
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK3
    ADD AL,07H   ; if it's a letter, fix ASCII
OK3: 
    PRINT AL     ; print the second hex digit
    PRINT 'h'
    
    PRINT ' '
    
    MOV AL,MAX           ; PRINT MAXIMUM DATA
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK4
    ADD AL,07H   ; if it's a letter, fix ASCII
OK4: 
    PRINT AL     ; print the first hex digit
    
    MOV AL,MAX
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK5
    ADD AL,07H   ; if it's a letter, fix ASCII
OK5: 
    PRINT AL     ; print the second hex digit
    PRINT 'h'
      
              
                 
    EXIT   
        
MAIN    ENDP
   
CODE_SEG    ENDS
    END MAIN