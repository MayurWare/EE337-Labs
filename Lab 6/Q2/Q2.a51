ORG 000H                   ;Start Program
LJMP Main                  ;Jump to Main Program

;Timer 0 Interrupt
ORG 000BH           
CPL P0.0                   ;Complement the value of P0.0
MOV TH0, R0                ;Load TH0
MOV TL0, R1                ;Load TH0
SETB TR0                   ;Rum Timer 0
RETI 

;Timer 1 Interrupt
ORG 001BH
;Load Timer 1 with #3CB0H for 25 m sec time
MOV TH1, #03CH            ;Load TH1        
MOV TL1, #0B0H            ;Load TL1
SETB TR1                  ;Run Timer 1
INC R5                    ;Increase R5 by 1
RETI


Main:
MOV R5, #0                ;Clear R5
SETB EA                   ;Set Global Interrupt
SETB ET0                  ;Set Timer 0 interrupt
SETB ET1                  ;Set Timer 1 interrupt
MOV TMOD, #00010001B      ;Setting both timers in Mode 1

;Load Timer 1 with #3CB0H for 25 m sec time
MOV TH1,#03CH             ;Loading TH0
MOV TL1,#0B0H             ;Loading TL0

;Load Timer 0 with #0F189H for 540Hz freqency i.e 1/540 sec time
MOV R0, #0F1H             ;Load R0   
MOV R1, #89H              ;Load R1
MOV TH0, R0
MOV TL0, R1
SETB TR0                  ;Run Timer 0
SETB TR1                  ;Run Timer 1

here:
CJNE R5, #50H, here       ;Wait for 80 cycles [80*25=2000m sec = 2sec)

CLR TR0                   ;Stop Timer 0
CLR TR1                   ;Stop Timer 1

MOV R5, #0                ;Clear R5
;Load Timer 1 with #3CB0H for 25 m sec time
MOV TH1,#03CH             ;Loading TH0
MOV TL1,#0B0H             ;Loading TL0

;Load Timer 0 with #0F2FBH for 600Hz freqency i.e 1/600 sec time
MOV R0, #0F2H             ;Load R0   
MOV R1, #0FBH             ;Load R1
MOV TH0, R0
MOV TL0, R1
SETB TR0                  ;Run Timer 0
SETB TR1                  ;Run Timer 1

here2:
CJNE R5, #50H, here2      ;Wait for 80 cycles [80*25=2000m sec = 2sec)
LJMP Main                 ;Jump to Main

END