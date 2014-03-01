;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1034 (Dec 12 2012) (MSVC)
; This file was generated Sat Mar 01 13:03:24 2014
;--------------------------------------------------------
$name Heart_Rate_Monitor
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _main
	public _OverflowIrqHandler
	public _wait1s
	public __c51_external_startup
	public _ofcnt
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
_ACC            DATA 0xe0
_B              DATA 0xf0
_PSW            DATA 0xd0
_SP             DATA 0x81
_SPX            DATA 0xef
_DPL            DATA 0x82
_DPH            DATA 0x83
_DPLB           DATA 0xd4
_DPHB           DATA 0xd5
_PAGE           DATA 0xf6
_AX             DATA 0xe1
_BX             DATA 0xf7
_DSPR           DATA 0xe2
_FIRD           DATA 0xe3
_MACL           DATA 0xe4
_MACH           DATA 0xe5
_PCON           DATA 0x87
_AUXR           DATA 0x8e
_AUXR1          DATA 0xa2
_DPCF           DATA 0xa1
_CKRL           DATA 0x97
_CKCKON0        DATA 0x8f
_CKCKON1        DATA 0xaf
_CKSEL          DATA 0x85
_CLKREG         DATA 0xae
_OSCCON         DATA 0x85
_IE             DATA 0xa8
_IEN0           DATA 0xa8
_IEN1           DATA 0xb1
_IPH0           DATA 0xb7
_IP             DATA 0xb8
_IPL0           DATA 0xb8
_IPH1           DATA 0xb3
_IPL1           DATA 0xb2
_P0             DATA 0x80
_P1             DATA 0x90
_P2             DATA 0xa0
_P3             DATA 0xb0
_P4             DATA 0xc0
_P0M0           DATA 0xe6
_P0M1           DATA 0xe7
_P1M0           DATA 0xd6
_P1M1           DATA 0xd7
_P2M0           DATA 0xce
_P2M1           DATA 0xcf
_P3M0           DATA 0xc6
_P3M1           DATA 0xc7
_P4M0           DATA 0xbe
_P4M1           DATA 0xbf
_SCON           DATA 0x98
_SBUF           DATA 0x99
_SADEN          DATA 0xb9
_SADDR          DATA 0xa9
_BDRCON         DATA 0x9b
_BRL            DATA 0x9a
_TCON           DATA 0x88
_TMOD           DATA 0x89
_TCONB          DATA 0x91
_TL0            DATA 0x8a
_TH0            DATA 0x8c
_TL1            DATA 0x8b
_TH1            DATA 0x8d
_RL0            DATA 0xf2
_RH0            DATA 0xf3
_RTL1           DATA 0xf4
_RH1            DATA 0xf5
_WDTRST         DATA 0xa6
_WDTPRG         DATA 0xa7
_T2CON          DATA 0xc8
_T2MOD          DATA 0xc9
_RCAP2H         DATA 0xcb
_RCAP2L         DATA 0xca
_TH2            DATA 0xcd
_TL2            DATA 0xcc
_SPCON          DATA 0xc3
_SPSTA          DATA 0xc4
_SPDAT          DATA 0xc5
_SSCON          DATA 0x93
_SSCS           DATA 0x94
_SSDAT          DATA 0x95
_SSADR          DATA 0x96
_KBLS           DATA 0x9c
_KBE            DATA 0x9d
_KBF            DATA 0x9e
_KBMOD          DATA 0x9f
_BMSEL          DATA 0x92
_FCON           DATA 0xd2
_EECON          DATA 0xd2
_ACSRA          DATA 0xa3
_ACSRB          DATA 0xab
_AREF           DATA 0xbd
_DADC           DATA 0xa4
_DADI           DATA 0xa5
_DADL           DATA 0xac
_DADH           DATA 0xad
_CCON           DATA 0xd8
_CMOD           DATA 0xd9
_CL             DATA 0xe9
_CH             DATA 0xf9
_CCAPM0         DATA 0xda
_CCAPM1         DATA 0xdb
_CCAPM2         DATA 0xdc
_CCAPM3         DATA 0xdd
_CCAPM4         DATA 0xde
_CCAP0H         DATA 0xfa
_CCAP1H         DATA 0xfb
_CCAP2H         DATA 0xfc
_CCAP3H         DATA 0xfd
_CCAP4H         DATA 0xfe
_CCAP0L         DATA 0xea
_CCAP1L         DATA 0xeb
_CCAP2L         DATA 0xec
_CCAP3L         DATA 0xed
_CCAP4L         DATA 0xee
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
_ACC_0          BIT 0xe0
_ACC_1          BIT 0xe1
_ACC_2          BIT 0xe2
_ACC_3          BIT 0xe3
_ACC_4          BIT 0xe4
_ACC_5          BIT 0xe5
_ACC_6          BIT 0xe6
_ACC_7          BIT 0xe7
_B_0            BIT 0xf0
_B_1            BIT 0xf1
_B_2            BIT 0xf2
_B_3            BIT 0xf3
_B_4            BIT 0xf4
_B_5            BIT 0xf5
_B_6            BIT 0xf6
_B_7            BIT 0xf7
_P              BIT 0xd0
_F1             BIT 0xd1
_OV             BIT 0xd2
_RS0            BIT 0xd3
_RS1            BIT 0xd4
_F0             BIT 0xd5
_AC             BIT 0xd6
_CY             BIT 0xd7
_EX0            BIT 0xa8
_ET0            BIT 0xa9
_EX1            BIT 0xaa
_ET1            BIT 0xab
_ES             BIT 0xac
_ET2            BIT 0xad
_EC             BIT 0xae
_EA             BIT 0xaf
_PX0            BIT 0xb8
_PT0            BIT 0xb9
_PX1            BIT 0xba
_PT1            BIT 0xbb
_PS             BIT 0xbc
_PT2            BIT 0xbd
_IP0D           BIT 0xbf
_PPCL           BIT 0xbe
_PT2L           BIT 0xbd
_PLS            BIT 0xbc
_PT1L           BIT 0xbb
_PX1L           BIT 0xba
_PT0L           BIT 0xb9
_PX0L           BIT 0xb8
_P0_0           BIT 0x80
_P0_1           BIT 0x81
_P0_2           BIT 0x82
_P0_3           BIT 0x83
_P0_4           BIT 0x84
_P0_5           BIT 0x85
_P0_6           BIT 0x86
_P0_7           BIT 0x87
_P1_0           BIT 0x90
_P1_1           BIT 0x91
_P1_2           BIT 0x92
_P1_3           BIT 0x93
_P1_4           BIT 0x94
_P1_5           BIT 0x95
_P1_6           BIT 0x96
_P1_7           BIT 0x97
_P2_0           BIT 0xa0
_P2_1           BIT 0xa1
_P2_2           BIT 0xa2
_P2_3           BIT 0xa3
_P2_4           BIT 0xa4
_P2_5           BIT 0xa5
_P2_6           BIT 0xa6
_P2_7           BIT 0xa7
_P3_0           BIT 0xb0
_P3_1           BIT 0xb1
_P3_2           BIT 0xb2
_P3_3           BIT 0xb3
_P3_4           BIT 0xb4
_P3_5           BIT 0xb5
_P3_6           BIT 0xb6
_P3_7           BIT 0xb7
_RXD            BIT 0xb0
_TXD            BIT 0xb1
_INT0           BIT 0xb2
_INT1           BIT 0xb3
_T0             BIT 0xb4
_T1             BIT 0xb5
_WR             BIT 0xb6
_RD             BIT 0xb7
_P4_0           BIT 0xc0
_P4_1           BIT 0xc1
_P4_2           BIT 0xc2
_P4_3           BIT 0xc3
_P4_4           BIT 0xc4
_P4_5           BIT 0xc5
_P4_6           BIT 0xc6
_P4_7           BIT 0xc7
_RI             BIT 0x98
_TI             BIT 0x99
_RB8            BIT 0x9a
_TB8            BIT 0x9b
_REN            BIT 0x9c
_SM2            BIT 0x9d
_SM1            BIT 0x9e
_SM0            BIT 0x9f
_IT0            BIT 0x88
_IE0            BIT 0x89
_IT1            BIT 0x8a
_IE1            BIT 0x8b
_TR0            BIT 0x8c
_TF0            BIT 0x8d
_TR1            BIT 0x8e
_TF1            BIT 0x8f
_CP_RL2         BIT 0xc8
_C_T2           BIT 0xc9
_TR2            BIT 0xca
_EXEN2          BIT 0xcb
_TCLK           BIT 0xcc
_RCLK           BIT 0xcd
_EXF2           BIT 0xce
_TF2            BIT 0xcf
_CF             BIT 0xdf
_CR             BIT 0xde
_CCF4           BIT 0xdc
_CCF3           BIT 0xdb
_CCF2           BIT 0xda
_CCF1           BIT 0xd9
_CCF0           BIT 0xd8
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_ofcnt:
	ds 1
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
	CSEG at 0x000b
	ljmp	_OverflowIrqHandler
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:9: unsigned char _c51_external_startup(void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:12: P0M0=0;	P0M1=0;
	mov	_P0M0,#0x00
	mov	_P0M1,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:13: P1M0=0;	P1M1=0;
	mov	_P1M0,#0x00
	mov	_P1M1,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:14: P2M0=0;	P2M1=0;
	mov	_P2M0,#0x00
	mov	_P2M1,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:15: P3M0=0;	P3M1=0;
	mov	_P3M0,#0x00
	mov	_P3M1,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:16: AUXR=0B_0001_0001; // 1152 bytes of internal XDATA, P4.4 is a general purpose I/O
	mov	_AUXR,#0x11
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:17: P4M0=0;	P4M1=0;
	mov	_P4M0,#0x00
	mov	_P4M1,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:18: setbaud_timer2(TIMER_2_RELOAD); // Initialize serial port using timer 2
	mov	dptr,#0xFFFA
	lcall	_setbaud_timer2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:20: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'wait1s'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:23: void wait1s (void)
;	-----------------------------------------
;	 function wait1s
;	-----------------------------------------
_wait1s:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:35: _endasm;
	
  ;For a 22.1184MHz crystal one machine cycle
  ;takes 12/22.1184MHz=0.5425347us
	     mov R2, #20
	 L3:
	mov R1, #200
	 L2:
	mov R0, #100
	 L1:
	djnz R0, L1 ; 2 machine cycles-> 2*0.5425347us*184=200us
	     djnz R1, L2 ; 200us*250=0.05s
	     djnz R2, L3 ; 0.05s*20=1s
	     ret
	    
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'OverflowIrqHandler'
;------------------------------------------------------------
;------------------------------------------------------------
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:39: void OverflowIrqHandler (void) interrupt 1 { ofcnt++; }
;	-----------------------------------------
;	 function OverflowIrqHandler
;	-----------------------------------------
_OverflowIrqHandler:
	inc	_ofcnt
	reti
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;period                    Allocated to registers r2 r3 r4 r5 
;frequency                 Allocated to registers r2 r3 r4 r5 
;bpm                       Allocated to registers r2 r3 
;num1                      Allocated to registers r4 r5 
;num2                      Allocated to registers r6 r7 
;num3                      Allocated to registers r0 r1 
;------------------------------------------------------------
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:42: void main (void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:51: printf( "\r\nLP51B Period meter example\r\n" );
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:52: TR0=0; // Disable timer/counter 0
	clr	_TR0
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:53: TMOD=0B_00000001; // Set timer/counter 0 as 16-bit timer
	mov	_TMOD,#0x01
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:54: P3_4=1; // Pin used as input
	setb	_P3_4
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:55: ET0=1; // enable timer 0 interrupt
	setb	_ET0
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:56: EA=1;	
	setb	_EA
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:57: while (1)
L005118?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:59: TL0=0; TH0=0; ofcnt=0; // Reset the timer and overflow
	mov	_TL0,#0x00
	mov	_TH0,#0x00
	mov	_ofcnt,#0x00
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:60: while(P3_4!=0); // Wait for the signal to be zero
L005001?:
	jb	_P3_4,L005001?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:61: while(P3_4!=1); // Wait for the signal to be one
L005004?:
	jnb	_P3_4,L005004?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:62: TR0=1; // Start the timer
	setb	_TR0
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:63: while(P3_4!=0); // Wait for the signal to be zero
L005007?:
	jb	_P3_4,L005007?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:64: while(P3_4!=1); // Wait for the signal to be one
L005010?:
	jnb	_P3_4,L005010?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:65: TR0=0; // Stop timer 0, ofcnt-TH0-TL0 has the period!
	clr	_TR0
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:66: period=(ofcnt*65536.0+TH0*256.0+TL0)*(12.0/22.1184e6);
	mov	dpl,_ofcnt
	lcall	___uchar2fs
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0x0000
	mov	b,#0x80
	mov	a,#0x47
	lcall	___fsmul
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,_TH0
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	lcall	___uchar2fs
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	dptr,#0x0000
	mov	b,#0x80
	mov	a,#0x43
	lcall	___fsmul
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fsadd
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	r6,_TL0
	mov	r7,#0x00
	mov	dpl,r6
	mov	dph,r7
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	lcall	___sint2fs
	mov	r6,dpl
	mov	r7,dph
	mov	r0,b
	mov	r1,a
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	push	ar6
	push	ar7
	push	ar0
	push	ar1
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fsadd
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0xA2B4
	mov	b,#0x11
	mov	a,#0x35
	lcall	___fsmul
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:69: frequency = 1/period;
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0x0000
	mov	b,#0x80
	mov	a,#0x3F
	lcall	___fsdiv
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:70: bpm = 60 * frequency;
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0x0000
	mov	b,#0x70
	mov	a,#0x42
	lcall	___fsmul
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fs2sint
	mov	r2,dpl
	mov	r3,dph
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:71: num1 = bpm % 10;
	mov	__modsint_PARM_2,#0x0A
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r2
	mov	dph,r3
	push	ar2
	push	ar3
	lcall	__modsint
	mov	r4,dpl
	mov	r5,dph
	pop	ar3
	pop	ar2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:72: num2 = bpm / 10 % 10;
	mov	__divsint_PARM_2,#0x0A
	clr	a
	mov	(__divsint_PARM_2 + 1),a
	mov	dpl,r2
	mov	dph,r3
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	lcall	__divsint
	mov	r6,dpl
	mov	r7,dph
	mov	__modsint_PARM_2,#0x0A
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r6
	mov	dph,r7
	lcall	__modsint
	mov	r6,dpl
	mov	r7,dph
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:73: num3 = bpm / 100 % 10;
	mov	__divsint_PARM_2,#0x64
	clr	a
	mov	(__divsint_PARM_2 + 1),a
	mov	dpl,r2
	mov	dph,r3
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	lcall	__divsint
	mov	r0,dpl
	mov	r1,dph
	mov	__modsint_PARM_2,#0x0A
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r0
	mov	dph,r1
	lcall	__modsint
	mov	r0,dpl
	mov	r1,dph
	pop	ar7
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:75: if (num1 == 0) 
	mov	a,r4
	orl	a,r5
	jnz	L005040?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:76: P0 = 0B_01000000;
	mov	_P0,#0x40
	sjmp	L005041?
L005040?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:77: else if (num1 == 1)
	cjne	r4,#0x01,L005037?
	cjne	r5,#0x00,L005037?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:78: P0 = 0B_11111001;
	mov	_P0,#0xF9
	sjmp	L005041?
L005037?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:79: else if (num1 == 2)
	cjne	r4,#0x02,L005034?
	cjne	r5,#0x00,L005034?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:80: P0 = 0B_10001100;
	mov	_P0,#0x8C
	sjmp	L005041?
L005034?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:81: else if (num1 == 3)
	cjne	r4,#0x03,L005031?
	cjne	r5,#0x00,L005031?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:82: P0 = 0B_10101000;
	mov	_P0,#0xA8
	sjmp	L005041?
L005031?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:83: else if (num1 == 4)
	cjne	r4,#0x04,L005028?
	cjne	r5,#0x00,L005028?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:84: P0 = 0B_00111001;
	mov	_P0,#0x39
	sjmp	L005041?
L005028?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:85: else if (num1 == 5)
	cjne	r4,#0x05,L005025?
	cjne	r5,#0x00,L005025?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:86: P0 = 0B_00101010;
	mov	_P0,#0x2A
	sjmp	L005041?
L005025?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:87: else if (num1 == 6)
	cjne	r4,#0x06,L005022?
	cjne	r5,#0x00,L005022?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:88: P0 = 0B_00000010;
	mov	_P0,#0x02
	sjmp	L005041?
L005022?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:89: else if (num1 == 7)
	cjne	r4,#0x07,L005019?
	cjne	r5,#0x00,L005019?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:90: P0 = 0B_11111000;
	mov	_P0,#0xF8
	sjmp	L005041?
L005019?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:91: else if (num1 == 8)
	cjne	r4,#0x08,L005016?
	cjne	r5,#0x00,L005016?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:92: P0 = 0B_00000000;
	mov	_P0,#0x00
	sjmp	L005041?
L005016?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:93: else if(num1 == 9)
	cjne	r4,#0x09,L005041?
	cjne	r5,#0x00,L005041?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:94: P0 = 0B_00110000;
	mov	_P0,#0x30
L005041?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:96: if (num2 == 0) 
	mov	a,r6
	orl	a,r7
	jnz	L005069?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:97: P1 = 0B_01000000;
	mov	_P1,#0x40
	sjmp	L005070?
L005069?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:98: else if (num2 == 1)
	cjne	r6,#0x01,L005066?
	cjne	r7,#0x00,L005066?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:99: P1 = 0B_11111001;
	mov	_P1,#0xF9
	sjmp	L005070?
L005066?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:100: else if (num2 == 2)
	cjne	r6,#0x02,L005063?
	cjne	r7,#0x00,L005063?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:101: P1 = 0B_10001100;
	mov	_P1,#0x8C
	sjmp	L005070?
L005063?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:102: else if (num2 == 3)
	cjne	r6,#0x03,L005060?
	cjne	r7,#0x00,L005060?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:103: P1 = 0B_10101000;
	mov	_P1,#0xA8
	sjmp	L005070?
L005060?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:104: else if (num2 == 4)
	cjne	r6,#0x04,L005057?
	cjne	r7,#0x00,L005057?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:105: P1 = 0B_00111001;
	mov	_P1,#0x39
	sjmp	L005070?
L005057?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:106: else if (num2 == 5)
	cjne	r6,#0x05,L005054?
	cjne	r7,#0x00,L005054?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:107: P1 = 0B_00101010;
	mov	_P1,#0x2A
	sjmp	L005070?
L005054?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:108: else if (num2 == 6)
	cjne	r6,#0x06,L005051?
	cjne	r7,#0x00,L005051?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:109: P1 = 0B_00000010;
	mov	_P1,#0x02
	sjmp	L005070?
L005051?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:110: else if (num2 == 7)
	cjne	r6,#0x07,L005048?
	cjne	r7,#0x00,L005048?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:111: P1 = 0B_11111000;
	mov	_P1,#0xF8
	sjmp	L005070?
L005048?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:112: else if (num2 == 8)
	cjne	r6,#0x08,L005045?
	cjne	r7,#0x00,L005045?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:113: P1 = 0B_00000000;
	mov	_P1,#0x00
	sjmp	L005070?
L005045?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:114: else if(num2 == 9)
	cjne	r6,#0x09,L005070?
	cjne	r7,#0x00,L005070?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:115: P1 = 0B_00110000;
	mov	_P1,#0x30
L005070?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:117: if (num3 == 0) 
	mov	a,r0
	orl	a,r1
	jnz	L005098?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:118: P2 = 0B_11111111;
	mov	_P2,#0xFF
	sjmp	L005099?
L005098?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:119: else if (num3 == 1)
	cjne	r0,#0x01,L005095?
	cjne	r1,#0x00,L005095?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:120: P2 = 0B_11111001;
	mov	_P2,#0xF9
	sjmp	L005099?
L005095?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:121: else if (num3 == 2)
	cjne	r0,#0x02,L005092?
	cjne	r1,#0x00,L005092?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:122: P2 = 0B_10001100;
	mov	_P2,#0x8C
	sjmp	L005099?
L005092?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:123: else if (num3 == 3)
	cjne	r0,#0x03,L005089?
	cjne	r1,#0x00,L005089?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:124: P2 = 0B_10101000;
	mov	_P2,#0xA8
	sjmp	L005099?
L005089?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:125: else if (num3 == 4)
	cjne	r0,#0x04,L005086?
	cjne	r1,#0x00,L005086?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:126: P2 = 0B_00111001;
	mov	_P2,#0x39
	sjmp	L005099?
L005086?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:127: else if (num3 == 5)
	cjne	r0,#0x05,L005083?
	cjne	r1,#0x00,L005083?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:128: P2 = 0B_00101010;
	mov	_P2,#0x2A
	sjmp	L005099?
L005083?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:129: else if (num3 == 6)
	cjne	r0,#0x06,L005080?
	cjne	r1,#0x00,L005080?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:130: P2 = 0B_00000010;
	mov	_P2,#0x02
	sjmp	L005099?
L005080?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:131: else if (num3 == 7)
	cjne	r0,#0x07,L005077?
	cjne	r1,#0x00,L005077?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:132: P2 = 0B_11111000;
	mov	_P2,#0xF8
	sjmp	L005099?
L005077?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:133: else if (num3 == 8)
	cjne	r0,#0x08,L005074?
	cjne	r1,#0x00,L005074?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:134: P2 = 0B_00000000;
	mov	_P2,#0x00
	sjmp	L005099?
L005074?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:135: else if(num3 == 9)
	cjne	r0,#0x09,L005099?
	cjne	r1,#0x00,L005099?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:136: P2 = 0B_00110000;
	mov	_P2,#0x30
L005099?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:141: if (bpm >= 50 && bpm <= 90) {
	clr	c
	mov	a,r2
	subb	a,#0x32
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	clr	a
	rlc	a
	mov	r4,a
	jnz	L005114?
	clr	c
	mov	a,#0x5A
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L005114?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:142: P4_1 = 0;
	clr	_P4_1
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:143: P3_2 = 1; //YELLOW
	setb	_P3_2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:144: P3_3 = 1; } //RED 
	setb	_P3_3
	sjmp	L005115?
L005114?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:146: else if (bpm >= 30 && bpm < 50) {
	clr	c
	mov	a,r2
	subb	a,#0x1E
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	clr	a
	rlc	a
	mov	r5,a
	jnz	L005110?
	mov	a,r4
	jz	L005110?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:147: P4_1 = 1;// GREEN
	setb	_P4_1
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:148: P3_2 = 0; //YELLOW
	clr	_P3_2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:149: P3_3 = 1; } //RED 
	setb	_P3_3
	sjmp	L005115?
L005110?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:151: else if (bpm < 30) {
	mov	a,r5
	jz	L005107?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:152: P4_1 = 1;// GREEN
	setb	_P4_1
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:153: P3_2 = 1; //YELLOW
	setb	_P3_2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:154: P3_3 = 0; } //RED 
	clr	_P3_3
	sjmp	L005115?
L005107?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:156: else if (bpm > 90 && bpm <= 170) {
	clr	c
	mov	a,#0x5A
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L005103?
	clr	c
	mov	a,#0xAA
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jc	L005103?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:157: P4_1 = 1;// GREEN
	setb	_P4_1
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:158: P3_2 = 0; //YELLOW
	clr	_P3_2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:159: P3_3 = 1; } //RED 
	setb	_P3_3
	sjmp	L005115?
L005103?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:161: else if (bpm > 170) {
	clr	c
	mov	a,#0xAA
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L005115?
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:162: P4_1 = 1;// GREEN
	setb	_P4_1
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:163: P3_2 = 1; //YELLOW
	setb	_P3_2
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:164: P3_3 = 0; } //RED 
	clr	_P3_3
L005115?:
;	C:\Users\Herman\Downloads\Documents\EECE 281\Lab 4\Heart Rate Monitor.c:166: printf( "%d\n",bpm);
	push	ar2
	push	ar3
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	mov	a,sp
	add	a,#0xfb
	mov	sp,a
	ljmp	L005118?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 0x0D
	db 0x0A
	db 'LP51B Period meter example'
	db 0x0D
	db 0x0A
	db 0x00
__str_1:
	db '%d'
	db 0x0A
	db 0x00

	CSEG

end
