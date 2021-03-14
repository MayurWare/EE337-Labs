ORG 00H         ;Start
MOV 50H, #0FEH  ;Loading Number into 50H
MOV 40H, #03H
MOV A, 50H
MOV R0, #60H
divby10:       ;divby10 Function
MOV B, #0AH
DIV AB         ;Divide A by B
MOV @R0, B
INC R0
DJNZ 40H, divby10   ;Repeat 3 times for 3 digits
MOV A, 61H
SWAP A              ;Swap nibbles
ADD A, 60H
MOV 53H, A          ;tens place, units place
MOV 52H, 62H        ;hundreds place
HERE: SJMP HERE	
END                 ;End