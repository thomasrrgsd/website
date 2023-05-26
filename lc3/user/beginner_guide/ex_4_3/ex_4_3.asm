;
; LC-3 program from section 4.3.
;
; William T. Jarratt
;
; Addition and subraction.
; Check R1 for the result of the OR (R3 OR R4).
; Check R2 for the result of the XOR (R3 XOR R4).
; R3 and R4 can be changed by the user.
;

.ORIG x3000 ; Program begins at x3000.

	AND R1, R1, #0	; Clearing registers
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	
			BR SKIP
		; Change R3 and R4 here
		myR3	.FILL	xFB34
		myR4	.FILL	x12C8
			SKIP
	
	LD	R3, myR3	; Puts value from above into
	LD	R4, myR4	; proper registers.
	
	; OR, R1 = R3 OR R4 = (R3' AND R4')'
	NOT R3, R3
	NOT R4, R4
	AND R1, R3, R4
	NOT R1, R1
	
	LD	R3, myR3	; Puts value from above into
	LD	R4, myR4	; proper registers.
	
	; XOR, R2 = R3 XOR R4
	;		  = (R3' AND R4')' AND (R3 AND R4)'
	;		  = R1 AND (R3 AND R4)'
	AND R2, R3, R4
	NOT R2, R2
	AND R2, R1, R2
	
	; After program is done running
	; check registers R1 and R2.
	
	HALT ; The program is done, all objectives met.
	
.END   