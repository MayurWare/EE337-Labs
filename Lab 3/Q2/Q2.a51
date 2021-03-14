ORG 000H                  ;Start Program
MOV P1, #0FFH              ;Loading Port 1
;Setting Initial Conditions of P1.0 and P1.1
CLR P1.0    
SETB P1.1
;Clearing P1.4 and P1.6
CLR P1.4 
CLR P1.6

MainProgram:              ;Main Program
JB P1.0, Check1           ;Send to Check for P1.0=1
JNB P1.0, Check2          ;Send to Check2 for P1.0=0
 
Check1:
JB P1.1, Condition4       ;Send to Condition4
JNB P1.1, Condition1      ;Send to Condition1

Check2:
JNB P1.1, Condition3      ;Send to Condition3
JB P1.1, Condition2       ;Send to Condition2


Condition1:               ;First Condition : P1.0=1 and P1.1=0
SETB P1.4              
ACALL DelayFunction
CLR P1.4
ACALL DelayFunction
ACALL DelayFunction
ACALL DelayFunction
LJMP MainProgram


Condition2:                ;Second Condition : P1.0=0 and P1.1=1
SETB P1.6
ACALL DelayFunction
ACALL DelayFunction
CLR P1.6
ACALL DelayFunction
ACALL DelayFunction
LJMP MainProgram

Condition3:                ;Third Condition : P1.0=0 and P1.1=0
CLR P1.4
CLR P1.6
LJMP MainProgram

Condition4:                ;Fourth Condition : P1.0=1 and P1.1=1
SETB P1.6
SETB P1.4
ACALL DelayFunction
CLR P1.4
ACALL DelayFunction
CLR P1.6
ACALL DelayFunction
ACALL DelayFunction
LJMP MainProgram

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

END                       ;End Program