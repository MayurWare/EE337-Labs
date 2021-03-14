ORG 000H
MOV P1, #0FFH             ;Setting input port P1
;SETB P1.2                ;Set initial values
;SETB P1.1
;SETB P1.0
;This subroutine writes characters on the LCD
LCD_data equ P2           ;LCD Data port
LCD_rs   equ P0.0         ;LCD Register Select
LCD_rw   equ P0.1         ;LCD Read/Write
LCD_en   equ P0.2         ;LCD Enable
ACALL lcd_init            ;initialise LCD
ACALL delay
ACALL delay
MOV A, #80H		  ;Put cursor on first row,0 column
ACALL lcd_command	  ;send command to LCD
ACALL delay
MOV DPTR, #my_string1     ;Load DPTR with sring1 Addr
ACALL lcd_sendstring	  ;call text strings sending routine
ACALL delay
MOV A,#0C0H		  ;Put cursor on second row,0 column
ACALL lcd_command
ACALL delay
MOV DPTR, #my_string2
ACALL lcd_sendstring

Main:                      
MOV B, P1                 ;Load P1 into B
ANL B, #00000111B         ;Getting the values of switches 
;(10-P1+1)*8*25m sec = Duty Cycle  => 25 m sec because DelayFunction gives 25 m sec delay in one cycle
MOV R7, B
INC B
MOV A, #10
SUBB A, B 
MOV B, #8
MUL AB
INC A
SETB P1.4                 ;Setting all LEDs to 1
SETB P1.5
SETB P1.6
SETB P1.7           
ACALL DelayFunction
CLR P1.4                  ;Clearing all LEDs
CLR P1.5
CLR P1.6
CLR P1.7
MOV B, A
DEC B
DEC B
MOV A, #80
SUBB A, B
ACALL DelayFunction

MOV A, #8CH		 ;Put cursor on first row,12 column
ACALL lcd_command	 ;send command to LCD
MOV A, #39H
SUBB A, R7               ;9-P1+30H is ASCII value of duty cycle/10
SUBB A, #30H
MOV R6, A                ;load duty cycle/10 into R6
ADD A, #30H
acall lcd_senddata 
;Duty Cylce*20 = Pulse Width ( As T = 2000 m sec)
MOV B, #2         
MOV A, R6
MUL AB
MOV R6, A

MOV A, #8DH		 ;Put cursor on first row,14 column
ACALL lcd_command	 ;send command to LCD
MOV R7, #30H
MOV A, R7            
ACALL lcd_senddata       ;Send '0'

MOV A, #0CCH		 ;Put cursor on first row,14 column
ACALL lcd_command	 ;send command to LCD
MOV A, R6
MOV B, #10
DIV AB
ADD A, #30H
ACALL lcd_senddata

MOV A, #0CDH		 ;Put cursor on first row,14 column
ACALL lcd_command	 ;send command to LCD
MOV A, B
ADD A, #30H
ACALL lcd_senddata

MOV A, #0CEH		 ;Put cursor on first row,14 column
ACALL lcd_command	 ;send command to LCD
MOV R7, #30H
MOV A, R7
ACALL lcd_senddata       ;Send '0'

MOV A, #0CFH		 ;Put cursor on first row,14 column
ACALL lcd_command	 ;send command to LCD
MOV R7, #30H
MOV A, R7
ACALL lcd_senddata       ;Send '0'
LJMP Main                ;Jumo to Main for infinite loop


DelayFunction:             ;Delay Function
MOV R0, A                  ;Load A into R0 (For A times repeatition)
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
DB   " Duty Cycle: ", 00H
my_string2:
DB   "Pulse Width: ", 00H

END                        ;End Program