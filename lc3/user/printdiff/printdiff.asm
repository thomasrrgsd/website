
; This program gets two digits (0-3) and prints the product
; of the two digits.


.ORIG x3000 ; Program begins at x3000.

	LEA R0, prompt1
	PUTS
	GETC
	ADD R1, R0, #0
	LD R2, checkThre
	LD R3, checkZero
	
	
	LEA R0, prompt2
	PUTS
	GETC
	ADD R1, R0, #0
	
	HALT ; The program is done, all objectives met.

digitOne	.FILL		x0000
digitTwo	.FILL		x0000
	
asciiOff	.FILL		#-48
checkZero	.FILL		#-48
checkThre	.FILL		#-51

prompt1		.STRINGZ	"\nEnter first digit: "		; Prompt user for first digit.
prompt2		.STRINGZ	"\nEnter second digit: " 	; Prompt user for second digit.


.END