
; Basic lc3 program.

; Semi-colons are used to create comments.

.ORIG x3000 ; Program begins at x3000.

	
	LD R0, picLoc
	LD R1, picAddr
	LD R4, height

Loop1
	LD R2, wid
	Loop2
		LDR R3, R1, #0
		STR R3, R0, #0
		ADD R1, R1, #1
		ADD R0, R0, #1
		ADD R2, R2, #-1
		BRp Loop2
	LD R2, nxtLine
	ADD R0, R0, R2
	ADD R4, R4, #-1
	BRp Loop1
		
	
	HALT ; The program is done, all objectives met.
	
prompt1	.STRINGZ "Hello World!"	; String variable.
picLoc	.FILL	xC555
picAddr	.FILL	x5000
wid		.FILL	#14
height	.FILL	#14
nxtLine	.FILL	#114
	
.END   