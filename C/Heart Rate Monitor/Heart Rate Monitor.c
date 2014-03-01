#include <stdio.h>
#include <at89lp51rd2.h>


#define CLK 22118400L
#define BAUD 115200L
#define TIMER_2_RELOAD (0x10000L-(CLK/(32L*BAUD)))

unsigned char _c51_external_startup(void)
{
	// Configure ports as a bidirectional with internal pull-ups.
	P0M0=0;	P0M1=0;
	P1M0=0;	P1M1=0;
	P2M0=0;	P2M1=0;
	P3M0=0;	P3M1=0;
	AUXR=0B_0001_0001; // 1152 bytes of internal XDATA, P4.4 is a general purpose I/O
	P4M0=0;	P4M1=0;
    setbaud_timer2(TIMER_2_RELOAD); // Initialize serial port using timer 2
    
    return 0;
}

void wait1s (void)
{
	_asm	
		;For a 22.1184MHz crystal one machine cycle 
		;takes 12/22.1184MHz=0.5425347us
	    mov R2, #20
	L3:	mov R1, #200
	L2:	mov R0, #100
	L1:	djnz R0, L1 ; 2 machine cycles-> 2*0.5425347us*184=200us
	    djnz R1, L2 ; 200us*250=0.05s
	    djnz R2, L3 ; 0.05s*20=1s
	    ret
    _endasm;
}

volatile unsigned char ofcnt;
void OverflowIrqHandler (void) interrupt 1 { ofcnt++; }


void main (void)
{
	float period;
	float frequency;
	int bpm;
	int num1;
	int num2;
	int num3;
	
	printf( "\r\nLP51B Period meter example\r\n" );
	TR0=0; // Disable timer/counter 0
	TMOD=0B_00000001; // Set timer/counter 0 as 16-bit timer
	P3_4=1; // Pin used as input
	ET0=1; // enable timer 0 interrupt
	EA=1;	
	while (1)
	{
		TL0=0; TH0=0; ofcnt=0; // Reset the timer and overflow
		while(P3_4!=0); // Wait for the signal to be zero
		while(P3_4!=1); // Wait for the signal to be one
		TR0=1; // Start the timer
		while(P3_4!=0); // Wait for the signal to be zero
		while(P3_4!=1); // Wait for the signal to be one
		TR0=0; // Stop timer 0, ofcnt-TH0-TL0 has the period!
		period=(ofcnt*65536.0+TH0*256.0+TL0)*(12.0/22.1184e6);
		
		// Send the period to the serial port
		frequency = 1/period;
		bpm = 60 * frequency;
		num1 = bpm % 10;
		num2 = bpm / 10 % 10;
		num3 = bpm / 100 % 10;
	
		if (num1 == 0) 
			P0 = 0B_01000000;
		else if (num1 == 1)
			P0 = 0B_11111001;
		else if (num1 == 2)
			P0 = 0B_10001100;
		else if (num1 == 3)
			P0 = 0B_10101000;
		else if (num1 == 4)
			P0 = 0B_00111001;
		else if (num1 == 5)
			P0 = 0B_00101010;
		else if (num1 == 6)
			P0 = 0B_00000010;
		else if (num1 == 7)
			P0 = 0B_11111000;
		else if (num1 == 8)
			P0 = 0B_00000000;
		else if(num1 == 9)
			P0 = 0B_00110000;
			
		if (num2 == 0) 
			P1 = 0B_01000000;
		else if (num2 == 1)
			P1 = 0B_11111001;
		else if (num2 == 2)
			P1 = 0B_10001100;
		else if (num2 == 3)
			P1 = 0B_10101000;
		else if (num2 == 4)
			P1 = 0B_00111001;
		else if (num2 == 5)
			P1 = 0B_00101010;
		else if (num2 == 6)
			P1 = 0B_00000010;
		else if (num2 == 7)
			P1 = 0B_11111000;
		else if (num2 == 8)
			P1 = 0B_00000000;
		else if(num2 == 9)
			P1 = 0B_00110000;
			
		if (num3 == 0) 
			P2 = 0B_11111111;
		else if (num3 == 1)
			P2 = 0B_11111001;
		else if (num3 == 2)
			P2 = 0B_10001100;
		else if (num3 == 3)
			P2 = 0B_10101000;
		else if (num3 == 4)
			P2 = 0B_00111001;
		else if (num3 == 5)
			P2 = 0B_00101010;
		else if (num3 == 6)
			P2 = 0B_00000010;
		else if (num3 == 7)
			P2 = 0B_11111000;
		else if (num3 == 8)
			P2 = 0B_00000000;
		else if(num3 == 9)
			P2 = 0B_00110000;
		
		
		// LED AND BUZZER CODE HERE
		
		if (bpm >= 50 && bpm <= 90) {
			P4_1 = 0;
			P3_2 = 1; //YELLOW
			P3_3 = 1; } //RED 
		
		else if (bpm >= 30 && bpm < 50) {
			P4_1 = 1;// GREEN
			P3_2 = 0; //YELLOW
			P3_3 = 1; } //RED 
		
		else if (bpm < 30) {
			P4_1 = 1;// GREEN
			P3_2 = 1; //YELLOW
			P3_3 = 0; } //RED 
		
		else if (bpm > 90 && bpm <= 170) {
			P4_1 = 1;// GREEN
			P3_2 = 0; //YELLOW
			P3_3 = 1; } //RED 
		
		else if (bpm > 170) {
			P4_1 = 1;// GREEN
			P3_2 = 1; //YELLOW
			P3_3 = 0; } //RED 
		
		printf( "%d\n",bpm);
	}
	
}

