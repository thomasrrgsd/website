
; LC-3 Image Generator Test Code

; Semi-colons are used to create comments.

.ORIG x3000 ; Program begins at x3000.

	
	LD R0, picLoc
	LD R1, picAdr1
	LD R4, height

Loop1
	LD R2, wid
	Loop2
		LDR R3, R1, #0
		BRp Skip1
		STR R3, R0, #0
	Skip1
		ADD R1, R1, #1
		ADD R0, R0, #1
		ADD R2, R2, #-1
		BRp Loop2
	LD R2, nxtLine
	ADD R0, R0, R2
	ADD R4, R4, #-1
	BRp Loop1

	LD R0, picLoc
	LD R1, picAdr2
	LD R4, height
	
Loop3
	LD R2, wid
	Loop4
		LDR R3, R1, #0
		BRzp Skip3
		STR R3, R0, #0
	Skip3
		ADD R1, R1, #1
		ADD R0, R0, #1
		ADD R2, R2, #-1
		BRp Loop4
	LD R2, nxtLine
	ADD R0, R0, R2
	ADD R4, R4, #-1
	BRp Loop3

	LD R0, picLoc
	LD R1, picAdr3
	LD R4, height

	HALT
	
Loop5
	LD R2, wid
	Loop6
		LDR R3, R1, #0
		BRzp Skip5
		STR R3, R0, #0
	Skip5
		ADD R1, R1, #1
		ADD R0, R0, #1
		ADD R2, R2, #-1
		BRp Loop6
	LD R2, nxtLine
	ADD R0, R0, R2
	ADD R4, R4, #-1
	BRp Loop5
	
	HALT ; The program is done, all objectives met.
	
picLoc	.FILL	xC555
picAdr1	.FILL	x4000
picAdr2 .FILL	x5000
picAdr3 .FILL	x6000
wid		.FILL	#13
height	.FILL	#10
nxtLine	.FILL	#115
	
.END   