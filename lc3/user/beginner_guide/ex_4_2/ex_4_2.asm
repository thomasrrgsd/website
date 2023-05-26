;
; LC-3 program from section 4.2.
;
; William T. Jarratt
;
; Addition and subraction.
; Check R1 for the result of the addition (R3+R4).
; Check R2 for the result of the subtraction (R3-R4).
; R3 and R4 can be changed by the user.
;

.ORIG x3000 ; Program begins at x3000.

	AND R1, R1, #0	; Clearing registers
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	
		; Change R3 here
		ADD R3, R3, #12
	
		; Change R4 here
		ADD R4, R4, #7
	
	; Addition, R1 = R3+R4
	ADD R1, R3, R4
	
	; Subtraction, R2 = R3-R4
	NOT R4, R4
	ADD R4, R4, #1
	ADD R2, R3, R4
	
	; After program is done running
	; check registers R1 and R2.
	
	HALT ; The program is done, all objectives met.
	
.END   