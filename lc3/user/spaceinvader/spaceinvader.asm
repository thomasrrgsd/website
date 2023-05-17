
; Spaceinvaders.asm

.ORIG x3000 ; Program begins at x3000.

	AND R0, R0, #0
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	AND R7, R7, #0
	
	LD	R0, SEC
	STI R0, TMI
	
timeLoop
	; Check for user input.
	LDI R0, KBSR
	BRzp skipHandleInput
	LDI R0, KBDR
	JSR gameInput
	skipHandleInput

	LDI R0, TMR			; Load timer register to see if ready.
	BRzp timeLoop		; If negative, TMR[15] = 1, it's ready.	

	JSR alienControl

	BR	timeLoop

	HALT ; The program is done, all objectives met.

TMR				.FILL 	xFE08		; Timer register. TMR[15] = 1 if ready.
TMI				.FILL 	xFE0A		; Timer Interval Register.
SEC				.FILL 	#1000		; Timer interval in milliseconds.
KBSR			.FILL	xFE00
KBDR			.FILL	xFE02

;-------------------------------------------------------------------
; alienControl
; 
; Description: 
; 
; Inputs: 
;	- N/A
; 
; Returns: 
;	- N/A
;-------------------------------------------------------------------
alienControl
	ST	R1, alienControlR1
	ST	R2, alienControlR2
	ST	R7, alienControlR7
		
		; Code for Alien collision or explosion.
		LD	R1, debugCounter
		ADD R1, R1, #-1
		BRp skipHALT
		HALT
		skipHALT
		ST	R1, debugCounter
		
		; Code to print Alien.
		LD	R1, picLocPrev
		AND R2, R2, #0
		ADD R2, R2, #3
		JSR printAlien	; Erases old alien image.
		LD	R1, picLoc
		ST	R1, picLocPrev
		LD	R2, alienState
		JSR printAlien
		ADD R2, R2, #1
		ADD R1, R2, #-2
		BRn	skipR2Clear
		AND R2, R2, #0
	skipR2Clear
		LD	R1, picLoc
		ADD R1, R1, #5
		ST	R1, picLoc
		ST	R2, alienState
	
	LD	R7, alienControlR7
	LD	R2, alienControlR2
	LD	R1, alienControlR1
	RET

alienState			.FILL	x0000
picLoc				.FILL	xC204
picLocPrev			.FILL	xC204
alienControlR1		.FILL	x0000
alienControlR2		.FILL	x0000
alienControlR7		.FILL	x0000
debugCounter		.FILL	#24

;-------------------------------------------------------------------
; gameInput
; 
; Description: 
; 
; Inputs: 
;	- R0, ascii input.
; 
; Returns: 
;	- N/A
;-------------------------------------------------------------------
gameInput
	ST	R1, gameInputR1
	ST	R7, gameInputR7
	
	OUT
	LD	R1, ascii_q
	ADD R1, R1, R0
	BRnp skipInputQ
	HALT
	skipInputQ
	
	LD	R7, gameInputR7
	LD	R1, gameInputR1
	RET

ascii_q			.FILL	#-113
gameInputR1		.FILL	x0000
gameInputR7		.FILL	x0000


;-------------------------------------------------------------------
; printAlien
; 
; Description: 
; 
; Inputs: 
;	- R1, where to print alien.
;	- R2, which sprite to print.
; 
; Returns: 
;	- N/A
;-------------------------------------------------------------------
printAlien
	ST R0, printAlienR0	; Temp register
	ST R2, printAlienR2
	ST R3, printAlienR3
	ST R4, printAlienR4
	ST R7, printAlienR7

	; Setup sprite width and row offset.
	LEA R0, widAlien0
	ADD R0, R0, R2
	LDR R3, R0, #0
	
	; Store as current sprite width and calculate row offset.
	; It is okay to throw away R3, as it is setup each loop.
	ST	R3, widAlienCur
	LD	R0, alienRowSize
	NOT R3, R3
	ADD R3, R3, #1
	ADD R3, R3, R0
	ST	R3, nextRowCur
	
	; Setup R4 with sprite height
	LEA R0, heiAlien0
	ADD R0, R0, R2
	LDR R4, R0, #0
	
	; Setup R2 with sprite memory address.
	LEA R0, adrAlien0
	ADD R0, R0, R2
	LDR	R2, R0, #0
	
	printAlienLp1
		LD R3, widAlienCur
		printAlienLp2
			LDR R0, R2, #0
			STR R0, R1, #0
			ADD R1, R1, #1
			ADD R2, R2, #1
			ADD R3, R3, #-1
			BRp printAlienLp2
		LD R3, nextRowCur
		ADD R1, R1, R3
		ADD R4, R4, #-1
		BRp printAlienLp1
	
	LD R7, printAlienR7
	LD R4, printAlienR4
	LD R3, printAlienR3
	LD R2, printAlienR2
	LD R0, printAlienR0
	RET

adrAlien0		.FILL	x5000
adrAlien1 		.FILL	x5080
adrAlien2 		.FILL	x5100
adrAlien3		.FILL	x5180
widAlienCur		.FILL	x0000	; Setup custom width.
widAlien0		.FILL	#11		; Alien with hands down
widAlien1		.FILL	#11		; Alien with hands up
widAlien2		.FILL	#13		; Exploded alien
widAlien3		.FILL	#11		; Blank sprite 8x11
heiAlien0		.FILL	#8
heiAlien1		.FILL	#8
heiAlien2		.FILL	#8
heiAlien3		.FILL	#8
alienRowSize	.FILL	#128
nextRowCur		.FILL	x0000	; Setup current row offset.
printAlienR0	.FILL	x0000
printAlienR2	.FILL	x0000
printAlienR3	.FILL	x0000
printAlienR4	.FILL	x0000
printAlienR7	.FILL	x0000

.END   