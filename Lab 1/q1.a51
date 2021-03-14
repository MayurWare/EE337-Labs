ORG 00H                       ;Start
MOV 70H, #0AAH                ;Load AAH into 70H
MOV A, 70H		              ;Load 70H i.e. AAH into A
MOV R0, #8H                   ;Load 8H into R0
MOV R1, #0                    ;Load 0 into R1

ShiftRight: RRC A	          ;Right Shift A by 1
JNC LOOP		              ;Reshift if last bit is 0
INC R1			              ;Increase R1 by 1 if bit is nonzero
LOOP: DJNZ R0, ShiftRight	  ;Loop through the accumulator 8 times
MOV 71H, R1		              ;Load the final count into 71H
END                           ;END Program