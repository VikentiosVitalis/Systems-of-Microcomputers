; Microcomputer Systems - Roh Y [6th Semester]  
; 5th Series of Exercises
; Kazdagli Ariadni - 03118838 
; Vitalis Vikentios - 03118803 



INCLUDE macros.asm

DATA SEGMENT
    MSGZ DB "Z=$"
    MSGW DB "W=$"
    MSGSUM DB "Z+W=$"
    MSGSUB DB "Z-W=$"
    MSGMINUS DB "Z-W=-$"
    Z DB 0
    W DB 0
	TEN DB DUP(10)		;Gia tis dekades
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
		START:			;Construction, display and storage of Z
			PRINTSTR MSGZ
			CALL READ_DEC_DIGIT	;1st decimal digit
			MUL TEN				
			LEA DI,Z			;Storage of first digit
			MOV [DI],AL			
			CALL READ_DEC_DIGIT	;2nd unit digit
			ADD [DI],AL			;Storage of second digit
			
			PRINTCH ' '
						;Construction, display and storage of W
			PRINTSTR MSGW
			CALL READ_DEC_DIGIT	;1st decimal digit
			MUL TEN
			LEA DI,W			;Storage of first digit
			MOV [DI],AL
			CALL READ_DEC_DIGIT	;2nd unit digit
			ADD [DI],AL			;Storage of second digit
			
			PRINTLN
						;Summary
			MOV AL,[DI]			;W
			LEA DI,Z			;Z
			ADD AL,[DI]			;Sum
			PRINTSTR MSGSUM
			CALL PRINT_NUM8_HEX	;Summary display 
			
			PRINTCH ' '
						;Subtraction
			MOV AL,[DI]			;Z
			LEA DI,W			;W
			MOV BL,[DI]
			
			CMP AL,BL			;Z>W or W>Z ?
			JB MINUS
			SUB AL,BL			;if Z>W
			PRINTSTR MSGSUB
			JMP SHOWSUB
		MINUS:
			SUB BL,AL			;if Z<W
			MOV AL,BL
			PRINTSTR MSGMINUS
		SHOWSUB:
			CALL PRINT_NUM8_HEX	;Subtraction result display
			PRINTLN
			PRINTLN
			JMP START
	MAIN ENDP
						;Instertion and display of decimal digit in AL register
	READ_DEC_DIGIT PROC NEAR
		READ:
			READCH
			CMP AL,48			;<0 ?
			JB READ
			CMP AL,57			;>9 ?
			JA READ
			PRINTCH AL
			SUB AL,48			;Code ASCII
			RET
	READ_DEC_DIGIT ENDP
						;ÎPrin the 8-bit number in hex form in AL register
	PRINT_NUM8_HEX PROC NEAR
			MOV DL,AL
			AND DL,0F0H			;1st decimal digit
			MOV CL,4
			ROR DL,CL
			CMP DL,0			;Ignore the first 0
			JE SKIPZERO
			CALL PRINT_HEX
		SKIPZERO:
			MOV DL,AL
			AND DL,0FH			;2nd hex digit
			CALL PRINT_HEX
			RET
	PRINT_NUM8_HEX ENDP
						;Print hex digit from DL register
	PRINT_HEX PROC NEAR
			CMP DL,9			;0...9
			JG LETTER
			ADD DL,48
			JMP SHOW
		LETTER:
			ADD DL,55			;A...F
		SHOW:
			PRINTCH DL
			RET
	PRINT_HEX ENDP
CODE ENDS
END MAIN
