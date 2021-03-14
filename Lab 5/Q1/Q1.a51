ORG 000H                  ;Start Program
LED_Blink:
MOV P1, #0FFH             ;Setting input port P1
SETB P1.4                 ;Setting all LEDs to 1
SETB P1.5
SETB P1.6
SETB P1.7
ACALL DelayFunction       ;1 second delay
CLR P1.4                  ;Clearing all LEDs
CLR P1.5
CLR P1.6
CLR P1.7   
ACALL DelayFunction       ;1 second delay
LJMP LED_Blink

DelayFunction:             ;Delay Function
MOV R0,#41                 ;Load 41 into R0 (For 41 times repeatition)
ReCall:
DJNZ R0,PartDelay        
RET
PartDelay:
MOV TMOD,#1                ;Setting Mode-1 for T0      
MOV TH0,#03CH              ;Loading TH0
MOV TL0,#0B0H              ;Loading TL0
SETB TR0                   ;Starting Timer T0
here: 
JNB TF0,here 
CLR TR0                    ;Stopping Timer T0
CLR TF0                    ;Clearing Overflow bit
SJMP ReCall 
END                        ;End Program