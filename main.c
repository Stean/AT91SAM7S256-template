//  *****************************************************************************
//   						main.c
// 
//     Demonstration program for Atmel AT91SAM7S256-EK Evaluation Board
//
//     blinks LED0 (pin PA0) with an endless loop
//     blinks LED1 (pin PA1) using timer0 interrupt (200 msec rate)
//	   switch SW1 (PA19) triggers FIQ interrupt, turns on LED2 (Pin PA2)
//     plenty of variables for debugger practice
//
//  Author:  James P Lynch  May 12, 2007
//  *****************************************************************************
 
//  *******************************************************
//                Header Files
//  *******************************************************
#include "AT91SAM7S256.h"
#include "board.h"

//  *******************************************************
//                Function Prototypes
//  *******************************************************
void Timer0IrqHandler(void);
void FiqHandler(void);

//  *******************************************************
//                External References
//  *******************************************************
extern	void LowLevelInit(void);
extern	void TimerSetup(void);
extern	unsigned enableIRQ(void);
extern	unsigned enableFIQ(void);

//  *******************************************************
//               Global Variables
//  *******************************************************

// Place here

int main (void) {
	// Initialize the Atmel AT91SAM7S256 (watchdog, PLL clock, default interrupts, etc.)
	LowLevelInit();
	
	// Set up the LEDs (PA0 - PA3)
	volatile AT91PS_PIO	pPIO = AT91C_BASE_PIOA;			// pointer to PIO data structure
	pPIO->PIO_PER = LED_MASK | SW1_MASK;				// PIO Enable Register - allow PIO to control pins P0 - P3 and pin 19
	pPIO->PIO_OER = LED_MASK;			        		// PIO Output Enable Register - sets pins P0 - P3 to outputs
	pPIO->PIO_SODR = LED_MASK;				        	// PIO Set Output Data Register - turns off the four LEDs
	
	// endless blink loop
	while (1) {
		if  ((pPIO->PIO_ODSR & LED1) == LED1)	    	// read previous state of LED1
			pPIO->PIO_CODR = LED1;			        	// turn LED1 (DS1) on	
		else
			pPIO->PIO_SODR = LED1;		        		// turn LED1 (DS1) off
		
		for (int j = 1000000; j != 0; j-- );			// wait 1 second 1000000
	}
}





