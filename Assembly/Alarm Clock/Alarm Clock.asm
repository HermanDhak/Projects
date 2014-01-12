;EECE 281 LAB 1
;Herman Dhak   14368138

$MODDE2

org 0000H
	ljmp myprogram
	
org 000BH
	ljmp ISR_timer0
	
org 001BH
	ljmp ISR_timer1

org 002BH
	ljmp ISR_timer2 ;for buzzer
	
DSEG at 30H
count10ms: ds 1
seconds:   ds 1
minutes:   ds 1
hours:     ds 1
temphours: ds 1
alarmseconds:  ds 1
alarmminutes:  ds 1
alarmhours:    ds 1

BSEG
meridian:   dbit 1
alarmmeridian: dbit 1

CSEG
; Look-up table for 7-segment displays
myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H
    DB 092H, 082H, 0F8H, 080H, 090H
    DB 0FFH ; All segments off

XTAL           EQU 33333333
FREQ           EQU 100
FREQ_2		   EQU 2000
TIMER0_RELOAD  EQU 65538-(XTAL/(12*FREQ))
TIMER1_RELOAD  EQU 65538-(XTAL/(12*FREQ))
TIMER2_RELOAD EQU 65536-(XTAL/(12*2*FREQ_2))

ISR_Timer0:
	; Reload the timer
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
    
    ; Save used register into the stack
    push psw
    push acc
    push dph
    push dpl
    
    jb SWA.0, ISR_Timer0_L0 ; Setting up time.  Do not increment anything

    ; Increment the counter and check if a second has passed
    inc count10ms
    mov a, count10ms
    cjne A, #100, ISR_Timer0_L0
    mov count10ms, #0
    
    mov a, seconds
    add a, #1
    da a
    mov seconds, a
    cjne A, #60H, ISR_Timer0_L0
    mov seconds, #0

    mov a, minutes
    add a, #1
    da a
    mov minutes, a
    cjne A, #60H, ISR_Timer0_L0
    mov minutes, #0

    mov a, hours
    add a, #1
    da a
    mov hours, a
    cjne A, #12H, setmeridianinterrupt
    cpl meridian
setmeridianinterrupt:
    cjne A, #13H, ISR_Timer0_L0
    mov hours, #1

ISR_Timer0_L0:
	lcall setAMPM
	
	; Update the display.  This happens every 10 ms
	mov dptr, #myLUT
	
	mov a, seconds
	anl a, #0fH
	movc a, @a+dptr
	mov HEX2, a
	mov a, seconds
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX3, a

	mov a, minutes
	anl a, #0fH
	movc a, @a+dptr
	mov HEX4, a
	mov a, minutes
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX5, a

	mov a, hours
	anl a, #0fH
	movc a, @a+dptr
	mov HEX6, a
	mov a, hours
	jb acc.4, ISR_Timer0_L1
	mov a, #0A0H
ISR_Timer0_L1:
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX7, a

	; Restore used registers
	pop dpl
	pop dph
	pop acc
	pop psw    
	reti

;=======================================================
;=========== ALARM INTERRUPT ===========================
;======================================================
ISR_Timer1:
	; Reload the timer
    mov TH1, #high(TIMER1_RELOAD)
    mov TL1, #low(TIMER1_RELOAD)
    ; Save used register into the stack
    push psw
    push acc
    push dph
    push dpl
    
    inc count10ms
    mov a, count10ms
    cjne A, #100, ISR_Timer1_L0
    mov count10ms, #0
    
    mov a, seconds
    add a, #1
    da a
    mov seconds, a
    cjne A, #60H, ISR_Timer1_L0
    mov seconds, #0

    mov a, minutes
    add a, #1
    da a
    mov minutes, a
    cjne A, #60H, ISR_Timer1_L0
    mov minutes, #0

    mov a, hours
    add a, #1
    da a
    mov hours, a
    cjne A, #12H, setmeridianinterrupt2
    cpl meridian
setmeridianinterrupt2:
    cjne A, #13H, ISR_Timer1_L0
    mov hours, #1
 	jb SWA.1, ISR_Timer1_L0 ;Setting alarm

ISR_Timer1_L0:
	; Update the display.  This happens every 10 ms
	mov dptr, #myLUT
    lcall setAMPMalarm
	mov a, alarmseconds
	anl a, #0fH
	movc a, @a+dptr
	mov HEX2, a
	mov a, alarmseconds
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX3, a

	mov a, alarmminutes
	anl a, #0fH
	movc a, @a+dptr
	mov HEX4, a
	mov a, alarmminutes
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX5, a

	mov a, alarmhours
	anl a, #0fH
	movc a, @a+dptr
	mov HEX6, a
	mov a, alarmhours
	jb acc.4, ISR_Timer1_L1
	mov a, #0A0H
ISR_Timer1_L1:
	swap a
	anl a, #0fH
	movc a, @a+dptr
	mov HEX7, a
	; Restore used registers
	pop dpl
	pop dph
	pop acc
	pop psw    
	reti
	
;==================== END TIMER 1 INTERRUPT =====================

ISR_Timer2:
clr TF2
	cpl P0.0
    mov TH2, #high(TIMER2_RELOAD)
    mov TL2, #low(TIMER2_RELOAD)
    reti

;================ ALARM MODE ==============================
A0: 
	jnb SWA.1, alarm2clock
	jnb SWA.1, A0

	jb KEY.3, A1
    jnb KEY.3, $
    mov a, alarmhours
	add a, #1
	da a
	mov alarmhours, a
    
    cjne A, #12H, setalarmmeridian
    cpl alarmmeridian
setalarmmeridian:
    cjne A, #13H, A1
    mov alarmhours, #1
   	
A1:	
	jb KEY.2, A2
    jnb KEY.2, $
    mov a, alarmminutes
	add a, #1
	da a
	mov alarmminutes, a
    cjne A, #60H, A2
    mov alarmminutes, #0
    
A2:	
	jb KEY.1, A3
	jnb KEY.1, $
	mov a, alarmseconds
	add a, #1
	da a
	mov alarmseconds, a
    cjne A, #60H, A3
    mov alarmseconds, #0

A3:	
	ljmp A0

clock2alarm:
	clr TR0 ;stop timer 0
	setb LEDG.0 ; ALARM IS ON
	setb TR1 ;start timer 1
	ljmp A0

alarm2clock:
	clr TR1 ;stop timer 1
	setb TR0 ;start timer 0
	ljmp M0
	
;================= SETUP ========================================
Init_Timers:	
	mov TMOD,  #00010001B ; GATE=0, C/T*=0, M1=1, M0=1: 16-bit timers
	clr TR0 ; Disable timer 0
	clr TR1 ; Disable timer 1
	clr TF0
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
    mov TH1, #high(TIMER1_RELOAD)
    mov TL1, #low(TIMER1_RELOAD)
    setb TR0 ; Enable timer 0
    setb ET0 ; Enable timer 0 interrupt
    setb ET1 ; Enable timer 1 interrupt
    
    ;timer 2 code
    mov T2CON, #00H ; Autoreload is enabled, work as a timer
    clr TR2
    clr TF2
    ; Set up timer 2 to interrupt every 10ms
    mov RCAP2H,#high(TIMER2_RELOAD)
    mov RCAP2L,#low(TIMER2_RELOAD)
    ret

myprogram:
	mov SP, #7FH
	mov P0MOD, #00000011B ; P0.0, P0.1 are outputs.  P0.1 is used for testing Timer 2!
	setb P0.0
	clr meridian
	clr alarmmeridian
	mov LEDRA,#0
	mov LEDRB,#0
	mov LEDRC,#0
	mov LEDG,#0
	
	mov seconds, #02H
	mov minutes, #00H
	mov hours, #12H
	mov alarmseconds, #00H
	mov alarmminutes, #00H
	mov alarmhours, #12H
	mov HEX0, #8CH
	
	lcall Init_Timers
    setb EA  ; Enable all interrupts

M0: 
	jb SWA.1, clock2alarm
	;mov LEDG, seconds
	;mov LEDRA, minutes
	;mov LEDRB, hours
	; check for alarm
	jnb SWA.2, increment_L0 ;only check for the alarm if enabled, disable LED if off
	setb LEDRA.1
 	mov A, hours
 	cjne A, alarmhours, increment
 	mov A, minutes
 	cjne A, alarmminutes, increment
 	mov A, seconds
 	cjne A, alarmseconds, increment
 	mov A, meridian
 	cjne A, alarmmeridian, increment
 	lcall beep
  increment_L0:
  	clr LEDRA.1
  increment:
	jnb SWA.0, M0

	jb KEY.3, M1
    jnb KEY.3, $
    mov a, hours
	add a, #1
	da a
	mov hours, a
    
    cjne A, #12H, setmeridian
    cpl meridian
setmeridian:
    cjne A, #13H, M1
    mov hours, #1
	
M1:	
	jb KEY.2, M2
    jnb KEY.2, $
    mov a, minutes
	add a, #1
	da a
	mov minutes, a
    cjne A, #60H, M2
    mov minutes, #0

M2:	
	jb KEY.1, M3
	jnb KEY.1, $
	mov a, seconds
	add a, #1
	da a
	mov seconds, a
    cjne A, #60H, M3
    mov seconds, #0

M3:	
	ljmp M0
;============ BEEP CODE ===================================	
beep:
	setb TR2
    setb ET2
    beeper:
	cpl LEDRA.0
	cpl TR2
	lcall WaitHalfSec
	jb SWA.3, stopbeep
	sjmp beeper

stopbeep:
	clr TR2
	ljmp M0
	
WaitHalfSec:
	mov R2, #90
L3: mov R1, #250
L2: mov R0, #250
L1: djnz R0, L1
	djnz R1, L2
	djnz R2, L3
	ret

setAMPM:
   jb meridian, setPM
   mov HEX0, #08H ;A
   ret
setPM:
   mov HEX0, #8CH ;P
   ret
  
setAMPMalarm:
   jb alarmmeridian, setPMalarm
   mov HEX0, #08H ;A
   ret
setPMalarm:
   mov HEX0, #8CH ;P
   ret
END
