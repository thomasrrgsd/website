
; This program gets two digits (0-3) and prints the
; difference of the two digits.


.ORIG x3000 ; Program begins at x3000.

	LD R2, checkThree	; Used to check <=3
	LD R3, checkZero	; Used to check >=0

tryAgain1
	LEA R0, prompt1		; Ask user for digitOne
	PUTS
	GETC				; Get and echo input
	OUT
	ADD R1, R0, #0		; R1 has digitOne
	
	; Check if digitOne between 0 and 3
	ADD R0, R1, R2		; digitOne - checkThree
	BRp tryAgain1
	ADD R0, R1, R3		; digitOne - checkZero
	BRn tryAgain1
	
	ST R1, temp			; Store digitOne in temp

tryAgain2
	LEA R0, prompt2		; Ask user for digitTwo
	PUTS
	GETC				; Get and echo input
	OUT
	ADD R1, R0, #0		; R1 has digitTwo
						; temp has digitOne
	
	; Check if digitTwo between 0 and 3
	ADD R0, R1, R2		; digitOne - checkThree
	BRp tryAgain2
	ADD R0, R1, R3		; digitOne - checkZero
	BRn tryAgain2

successfulInput
	; Both digits are in the specified range
	; temp has digitOne and R1 has digitTwo
	
	; Begin printing the resulting prompt.
	LD R0, lineFeed		; Print result next line
	OUT
	LD R0, temp			; R0 has digitOne
	OUT					; Print digitOne
	LEA R0, result1		; " + "
	PUTS		
	ADD R0, R1, #0
	OUT					; Print digitTwo
	LEA R0, result2		; " = "
	PUTS
	
	; Check if result is negative
	LD R0, temp			; R0 has digitOne
	NOT R1, R1
	ADD R1, R1, #1		; Negative digitTwo
	ADD R1, R0, R1		; digitOne - digitTwo
	BRzp outputResult	; Skip negative code
	
	; Negative, need to print dash and 2sC
	LD R0, dash			; Print dash for negative
	OUT
	NOT R1, R1
	ADD R1, R1, #1		; Convert back to positive

outputResult
	LD R0, asciiOn		; Convert binary difference,
	ADD R0, R0, R1		; to ascii to print to output
	
	OUT
	
	HALT ; The program is done, all objectives met.

temp		.FILL		x0000	; Holds temporary values
	
asciiOn		.FILL		#48		; Binary -> ascii
checkZero	.FILL		#-48	; Check input to '0'
checkThree	.FILL		#-51	; Check input to '3'
lineFeed	.FILL		#10		; Line feed, '\n'
dash		.FILL		#45		; Dash '-'

prompt1		.STRINGZ	"\nEnter first digit: "		; Prompt user for first digit
prompt2		.STRINGZ	"\nEnter second digit: " 	; Prompt user for second digit
result1		.STRINGZ	" - "						; Part of printing result
result2		.STRINGZ	" = "						; Part of printing result


.END