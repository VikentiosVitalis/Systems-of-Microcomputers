; Microcomputer Systems - Roh Y [6th Semester]  
; 5th Series of Exercises
; Kazdagli Ariadni - 03118838 
; Vitalis Vikentios - 03118803 


PRINT MACRO CHAR          ;MACRO to print a character
    PUSH AX
    PUSH DX
    MOV DL,CHAR           ;Char must be defined
    MOV AH,2              ;before translation
    INT 21H
    POP DX
    POP AX
ENDM
    
READ MACRO                ;MACRO to read from keyboard
    MOV AH, 8             ;The value of ASCII char is returned
    INT 21H               ;through AL
ENDM
    
NEWLINE MACRO LINEFEED    ;MACRO to print new line
    PUSH AX
    PUSH DX
    MOV AH,09
    MOV DX,OFFSET LINEFEED
    INT 21H
    POP DX
    POP AX
ENDM
 
DATA_SEG SEGMENT
    LINEFEED DB 13, 10, "$" 
DATA_SEG ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX
    
START:
    MOV BX,0
    CALL HEX_KEYB         ;Get first hex digit
    CMP AL, 'T'           ;If it's T then end
    JE QUIT               ;Else store its value to BH
    MOV BH,AL             ;BX will have the 12 bit number
    CALL HEX_KEYB         ;Get second hex digit
    CMP AL, 'T'
    JE QUIT
    MOV BL,AL             ;Store its value to BL
    MOV CL,4              
    ROL BL,CL             ;Rotate the value to 4 MSB
    CALL HEX_KEYB         ;Get third hex digit
    CMP AL, 'T'    
    JE QUIT
    ADD BL,AL             ;BL has the 2nd and 3rd digit
    MOV AX,BX
    MOV CX,0
    CALL PRINT_DEC
    PRINT '='
    CALL PRINT_BIN
    PRINT '='
    CALL PRINT_OCT
    NEWLINE LINEFEED 
    JMP START
QUIT:    
    HLT    
MAIN ENDP


PRINT_OCT PROC NEAR       ;Print 12bit number in octal
    PUSH AX               
    MOV BX,8              ;We have to divide number with 8
    MOV CX,0              ;Initialise counter
GETOCT:
    MOV DX,0              ;DX will have the remainder of the division
    DIV BX                ;Divide number with 8
    PUSH DX               ;Save the remainder to the stack
    INC CL                ;Increase counter
    CMP AX,0              ;If quotient is 0 then there isnt any digit left
    JNE GETOCT
PRINTOCT:
    POP AX                ;Read one digit from the stack
    ADD AL,48             ;Calculate ASCII code and print the
    PRINT AL              ;corresponding character on the screen
    LOOP PRINTOCT
    POP AX
    RET
PRINT_OCT ENDP

PRINT_BIN PROC NEAR       ;Print 12bit number in binary
    PUSH AX
    MOV BX,2              ;We have to divide number with 2
    MOV CX,0              ;We follow the same process as above
GETBIN:                   ;but instead of dividing by 8
    MOV DX,0              ;we divide number with 2
    DIV BX                
    PUSH DX
    INC CL
    CMP AX,0
    JNE GETBIN
PRINTBIN:
    POP AX
    ADD AL,48             ;Calculate ASCII code and print the
    PRINT AL              ;corresponding character on the screen
    LOOP PRINTBIN
    POP AX
    RET
PRINT_BIN ENDP    

PRINT_DEC PROC NEAR       ;Print 12bit number in decimal
    PUSH AX
    MOV BX,10             ;We have to divide number with 10
    MOV CX,0              ;We follow the same process as above
GETDEC:                   ;but instead of dividing by 2
    MOV DX,0              ;we divide number with 10
    DIV BX             
    PUSH DX            
    INC CX             
    CMP AX,0           
    JNE GETDEC
PRINTDEC: 
    POP DX             
    ADD DX,48             ;Calculate ASCII code and print
    PRINT DL              ;the corresponding character on the screen
    LOOP PRINTDEC
    POP AX
    RET    
PRINT_DEC ENDP    
    
    
 
HEX_KEYB PROC NEAR        ;Read a hex digit from the keyboard
                          ;and store it in AL
IGNORE:
    READ                  ;Read from keyboard
    CMP AL, 'T'           ;If char is T then end routine
    JE ADDR2  
    CMP AL, 30H           ;Check if char is a digit
    JL IGNORE             ;If it isn't then wait for a valid input
    CMP AL, 39H           ;Check if char is a digit greater than 9                                          
    JG ADDR1              ;If it is then check if its A,B,C,D,E or F
    SUB AL,30H            ;Export the correct number from its ASCII value
    JMP ADDR2
ADDR1: 
    CMP AL,'A'            ;Check if char is a valid hex digit
    JL IGNORE             ;If it isn't then wait for a valid input
    CMP AL,'F'
    JG IGNORE
    SUB AL,37H            ;Export the correct number from its ASCII value
ADDR2: 
    RET
HEX_KEYB ENDP  
CODE_SEG ENDS
END MAIN
