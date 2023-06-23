
; Basic lc3 program.

; Semi-colons are used to create comments.

.ORIG x3000 ; Program begins at x3000.

	AND R1, R1, #0
	LD	R1, testVal
	JSR rightShift

debug	
	HALT ; The program is done, all objectives met.
	
testVal		.FILL	0x1440


; binStr
;
;
;
binStr

	
	RET
	
;
; rightShift
;
;
; Pass in value to be right shifted in R1.
; This shifted value is returned in R1.
;
rightShift
	ST R7, rightShiftR7
	
	AND R2, R2, #0	; Result
	ADD R3, R2, #1	; Mask1
	ADD R4, R2, #1	; Mask2
	ADD R5, R4, #14	; Load loop count value of #15
	
	rightShiftL1
		ADD R4, R3, R3	; Mask2 = Mask1*2
		
		AND R6, R1, R4
		BRz rightShiftS1
		ADD R2, R2, R3
	rightShiftS1
		ADD R3, R3, R3	; Mask1 = Mask1*2
		ADD R5, R5, #-1
		BRp	rightShiftL1
		
	; Clear the MSb for now (logical shift)
	LD  R5, clearMSb
	AND R1, R2, R5
	
	LD R7, rightShiftR7
	RET
	
rightShiftR7	.FILL	0x0000
clearMSb		.FILL	0x7FFF
	
.END   