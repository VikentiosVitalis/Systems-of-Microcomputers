; Microcomputer Systems - Roh Y [6th Semester]  
; 5th Series of Exercises
; Kazdagli Ariadni - 03118838 
; Vitalis Vikentios - 03118803 


INCLUDE macros.asm

DATA SEGMENT
	STARTPROMPT DB "START(Y,N):$";Starting message
	ERRORMSG DB "ERROR$"		 ;Error message
ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
			PRINTSTR STARTPROMPT
		START:			;Instertion of starting character
			READCH
			CMP AL,'N'			;= N ?
			JE FINISH			;End‚
			CMP AL,'Y'			;= Y ?
			JE CONT				;Function
			JMP START
		CONT:
			PRINTCH AL			;Display of starting character
			PRINTLN
			PRINTLN
		NEWTEMP:
			MOV DX,0
			MOV CX,3			;3 Hex digits
		READTEMP:		;Input
			CALL HEX_KEYB		;Insertion of digit
			CMP AL,'N'			;Check for ending
			JE FINISH
						;Union of digits in DX register
			PUSH CX
			DEC CL				;Shifting
			ROL CL,2		
			MOV AH,0
			ROL AX,CL			;Left shift 8, 4, 0 digits
			OR DX,AX			;Addition of digit in the number
			POP CX
			LOOP READTEMP
			
			PRINTTAB
			MOV AX,DX
			CMP AX,2047			;V<=2 ?
			JBE BRANCH1
			CMP AX,3071			;V<=3 ?
			JBE BRANCH2
			PRINTSTR ERRORMSG	;V>3
			PRINTLN
			JMP NEWTEMP
			
		BRANCH1:		;1st branch: V<=2, T=(800*V) div 4095
			MOV BX,800
			MUL BX
			MOV BX,4095
			DIV BX
			JMP SHOWTEMP
		BRANCH2:		;2nd branch: 2<V<=3, T=((3200*V) div 4095)-1200
			MOV BX,3200
			MUL BX
			MOV BX,4095
			DIV BX
			SUB AX,1200
		SHOWTEMP:
			CALL PRINT_DEC16	;Display of whole part in (AX) register
						;Fraction part = ( remainrder *10 ) div 4095
			MOV AX,DX
			MOV BX,10
			MUL BX
			MOV BX,4095
			DIV BX
			
			PRINTCH ','			;comma 
			ADD AL,48			;Code ASCII
			PRINTCH AL			;Display of fraction part
			PRINTLN
			JMP NEWTEMP
			
		FINISH:
			PRINTCH AL
			EXIT
	MAIN ENDP
						;Instert hex digit in AL register
	HEX_KEYB PROC NEAR	
		READ:
			READCH
			CMP AL,'N'			;=N ?
			JE RETURN
			CMP AL,48			;<0 ?
			JL READ
			CMP AL,57			;>9 ?
			JG LETTER
			PRINTCH AL
			SUB AL,48			;Code ASCII
			JMP RETURN
		LETTER:					;A...F
			CMP AL,'A'			;<A ?
			JL READ
			CMP AL,'F'			;>F ?
			JG READ
			PRINTCH AL
			SUB AL,55			;Code ASCII
		RETURN:
			
			RET
	HEX_KEYB ENDP
							;Display of 16-bit hex numver from AX register
	PRINT_DEC16 PROC NEAR
			PUSH DX
			
			MOV BX,10			;Decimal => divisions with 10
			MOV CX,0			;Digit counter
		GETDEC:			;Digit export
			MOV DX,0			;Number mod 10 (remainder)
			DIV BX				;Division with 10
			PUSH DX				;Temporary storage
			INC CL
			CMP AX,0			;Number div 10 = 0 ? ( quotient ) 
			JNE GETDEC
		PRINTDEC:		;Digit display
			POP DX
			ADD DL,48			;Code ASCII
			PRINTCH DL
			LOOP PRINTDEC
			
			POP DX
			RET
	PRINT_DEC16 ENDP
CODE ENDS
END MAIN
