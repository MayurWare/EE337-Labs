ORG 000H                  ;Start Program
Main:
MOV P1, #0FFH             ;Setting input port P1
SETB P1.4                 ;Setting all LEDs to 1
SETB P1.5
SETB P1.6
SETB P1.7
ACALL DelayFunction       ;5 second delay
ACALL DelayFunction
ACALL DelayFunction
ACALL DelayFunction
ACALL DelayFunction
MOV A, P1                 ;Load P1 into A
ANL A, #00001111B         ;Getting the values of switches 
MOV R1, A                 ;Loading A into R1 

blinkingLEDs:             ;Function for blinking LEDs
MOV P1, #00H               
ACALL DelayFunction
MOV P1, #0F0H
ACALL DelayFunction
DJNZ R1, blinkingLEDs     
LJMP Main
DelayFunction:             ;Delay Function
MOV R0,#41                 ;Load 41 into R0 (For 41 times repeatition)
ReCall:
DJNZ R0,PartDelay        
RET
PartDelay:MOV TMOD,#1      
MOV TH0,#03CH
MOV TL0,#0B0H 
SETB TR0
here: 
JNB TF0,here 
CLR TR0 
CLR TF0
SJMP ReCall 
END                        ;End Program