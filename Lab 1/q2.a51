Org 00H                  ;Start
MOV 40H, #7FH
MOV 41H, #7EH
MOV 42H, #7DH
MOV 43H, #7CH
MOV 44H, #7BH
MOV 45H, #7AH
MOV 46H, #79H
MOV 47H, #78H
MOV 48H, #77H
MOV 49H, #76H
MOV 4AH, #75H
MOV 4BH, #74H
MOV 4CH, #73H
MOV 4DH, #72H
MOV 4EH, #71H
MOV 4FH, #70H
MOV 50H, #6FH
MOV 51H, #6EH
MOV 52H, #6DH
MOV 53H, #6CH
MOV R1, #40H	         ;Load 40H into R1 (Starting from 40H)
MOV R2, #14H	         ;Load 14H into R1 (for 20 loops)

MOV 70H, 40H	         ;Load 40H into 70H
MOV 71H, 41H	         ;Load 41H into 71H

INCR: INC R1             ;Increase R1 (40H, 41H,....)
MOV A, 70H               ;Load 70H into A (i.e. 40H)         
CLR C
SUBB A, @R1              ; A - R1
JNC SecondL              ;Jump to SecondL function
MOV 71H, 70H     
MOV 70H, @R1
LJMP NONE	     

SecondL:
	MOV A, 71H
	CLR C
	SUBB A, @R1
	JNC NONE
	MOV 71H, @R1
	
NONE: DJNZ R2, INCR	     ;Looping from 40H to 53H
HERE: SJMP HERE	
END