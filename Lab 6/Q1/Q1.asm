ORG 000H                   ;Start
LJMP Main                  ;Jump to Main

;Timer 1 Interrupt
ORG 001BH
SETB C                     ;Set Carry Bit
INC R5                     ;Increase
RETI


;This subroutine writes characters on the LCD
LCD_data equ P2            ;LCD Data port
LCD_rs   equ P0.0          ;LCD Register Select
LCD_rw   equ P0.1          ;LCD Read/Write
LCD_en   equ P0.2          ;LCD Enable


ORG 200H
Main: 
SETB EA                    ;Set Global Interrupt
SETB ET1                   ;Set TImer 1 Interrupt
;Clearing all LEDs
CLR P1.4
CLR P1.5 
CLR P1.6
CLR P1.7
JNB P1.0, looop1           ;Go to looop1 if P1.0 is OFF
JB P1.0, Main

looop1:
ACALL delay
ACALL delay
ACALL lcd_init             ;initialise LCD
MOV A, #82H		           ;Put cursor on first row,2 column
ACALL lcd_command	       ;send command to LCD
ACALL delay
MOV DPTR, #my_string1      ;Load DPTR with sring1 Addr
ACALL lcd_sendstring	   ;call text strings sending routine
ACALL delay
MOV A,#0C0H		           ;Put cursor on second row,0 column
ACALL lcd_command          ;send command to LCD
ACALL delay
MOV DPTR, #my_string2      ;Load DPTR with sring2 Addr
ACALL lcd_sendstring       ;call text strings sending routine
ACALL DelayFunction        ;1 second delay
ACALL DelayFunction        ;1 second delay
SETB P1.4                  ;Set LED P1.4

looop2:
MOV TMOD,#00010000B        ;Setting Mode-1 for T1 
SETB TR1                   ;Run Timer 1
JB P1.0, looop3            ;Jump to looop3 if P1.0 is ON
here1: 
JNC here1                  
JB P1.0, looop3            ;Jump to looop3 if P1.0 is ON
SJMP looop2                

DelayFunction:             ;Delay Function
MOV R0, #41                ;Load A into R0 (For A times repeatition)
ReCall:
DJNZ R0,PartDelay        
RET
PartDelay:                 ;25 msec delay
MOV TMOD,#1                ;Setting Mode-1 for T0      
MOV TH0,#03CH              ;Loading TH0
MOV TL0,#0B0H              ;Loading TL0
SETB TR0                   ;Starting Timer T0
here: 
JNB TF0,here 
CLR TR0                    ;Stopping Timer T0
CLR TF0                    ;Clearing Overflow bit
SJMP ReCall 

looop3:
CLR P1.4                   ;Switching OFF LED P1.4
ACALL delay
ACALL delay

MOV A, #80H		           ;Put cursor on first row,0 column
ACALL lcd_command	       ;send command to LCD
ACALL delay
MOV DPTR, #my_string3      ;Load DPTR with sring3 Addr
ACALL lcd_sendstring	   ;call text strings sending routine
ACALL delay

MOV A,#0C0H		           ;Put cursor on second row,0 column
ACALL lcd_command          ;send command to LCD
ACALL delay
MOV DPTR, #my_string4      ;Load DPTR with sring3 Addr
ACALL lcd_sendstring       ;call text strings sending routine

MOV A,#0C9H		           ;Put cursor on second row,9 column
ACALL lcd_command          ;send command to LCD
MOV A, R5
SWAP A
ANL A, #00001111B          ;Getting the value of uppper nibble of R5 
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

MOV A,#0CAH		           ;Put cursor on second row,10 column
ACALL lcd_command          ;send command to LCD
MOV A, R5
ANL A, #00001111B          ;Getting the value of lower nibble of A 
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

MOV A,#0CBH		           ;Put cursor on second row,11 column
ACALL lcd_command          ;send command to LCD
MOV A, TH1
SWAP A
ANL A, #00001111B          ;Getting the value of upper nibble of TH1
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

MOV A,#0CCH		           ;Put cursor on second row,12 column
ACALL lcd_command          ;send command to LCD
MOV A, TH1
ANL A, #00001111B          ;Getting the value of lower nibble of A  
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

MOV A,#0CDH		           ;Put cursor on second row,13 column
ACALL lcd_command          ;send command to LCD
MOV A, TL1
SWAP A
ANL A, #00001111B          ;Getting the value of upper nibble of TL0
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

MOV A,#0CEH		           ;Put cursor on second row,14 column
ACALL lcd_command
MOV A, TL1
ANL A, #00001111B          ;Getting the value of lower nibble of TL0 
ACALL check                ;check if we have to send an alphabet
ADD A, #30H
ACALL lcd_senddata

LJMP Main                  ;Jump to Main for infinite loop

check:
CLR C
SUBB A, #10
JC skip7
ADD A, #7
skip7:
ADD A, #10
RETI

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#155
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
;------------- ROM text strings---------------------------------------------------------------
org 600h
my_string1:
DB   " Toggle SW1", 00H
my_string2:
DB   "if LED glows", 00H
my_string3:
DB   " Reaction Time", 00H
my_string4:
DB   "Count is ", 00H
END                        ;End Program