/*****************************************************
Chip type               : ATmega32A
AVR Core Clock frequency: 7.372800 MHz
Data Stack size         : 512

converted from lpc 8bit 8952 micro (nxp example) to avr 8bit codevision by:
Ehsan Safamanesh.
email:  ehsan_safa66@yahoo.com
*****************************************************/

////////////   PORTB.3 is ss (sda) pin

#include <mega32a.h>
#include <delay.h>
#include "MFRC522.h"

#define LED_GREEN  PORTA.0

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 250
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// SPI functions
#include <spi.h>

// Declare your global variables here
//flash
unsigned char data1[16] = {0x12,0x34,0x56,0x78,0xED,0xCB,0xA9,0x87,0x12,0x34,0x56,0x78,0x01,0xFE,0x01,0xFE};
unsigned char data2[4]  = {0,0,0,0x01};
unsigned char DefaultKey[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 
unsigned char g_ucTempbuf[20];                        
void delay1(unsigned int z)
{
	unsigned int x;
    //unsigned int y;
	for(x=z;x>0;x--) delay_ms(1);
	//for(y=110;y>0;y--);	
}


void main(void)
{
// Declare your local variables here
    unsigned char status,i;
    unsigned int temp;

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0xFF;

// Port B initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=0 State4=0 State3=1 State2=T State1=T State0=T 
PORTB=0x08;
DDRB=0xB8;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x03;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 460.800 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x51;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")

printf("hello\r");

PcdReset();
delay_ms(1);
PcdAntennaOff(); 
delay_ms(1);
PcdAntennaOn();
delay_ms(1);

while (1)
    {
        status = PcdRequest(PICC_REQALL, g_ucTempbuf);
        if (status != MI_OK)
        {    
            PcdReset();
            delay_ms(1);
            PcdAntennaOff(); 
            delay_ms(1);
            PcdAntennaOn();
            delay_ms(1); 
			continue;
        }
			     
		printf("print1");
        
        for(i=0;i<2;i++)
		{
		    temp=g_ucTempbuf[i];
			printf("%X",temp);			
		}
			
        status = PcdAnticoll(g_ucTempbuf);
        if (status != MI_OK) continue;
		
		printf("print2:");
		
        for(i=0;i<4;i++)
		{
		    temp=g_ucTempbuf[i];
			printf("%X",temp);			
		}

		///////////////////////////////////////////////////////////

         status = PcdSelect(g_ucTempbuf);
         if (status != MI_OK) continue;
         
         status = PcdAuthState(PICC_AUTHENT1A, 1, DefaultKey, g_ucTempbuf);
         if (status != MI_OK) continue;
         
         status = PcdWrite(1, data1);
         if (status != MI_OK) continue;
         
        while(1)
		{
            status = PcdRequest(PICC_REQALL, g_ucTempbuf);
            if (status != MI_OK)
            {   
                PcdReset();
                delay_ms(1);
                PcdAntennaOff(); 
                delay_ms(1);
                PcdAntennaOn();
                delay_ms(1);; 
			    continue;
            }
            
		    status = PcdAnticoll(g_ucTempbuf);
            if (status != MI_OK)continue;

		    status = PcdSelect(g_ucTempbuf);
            if (status != MI_OK)continue;
         
            status = PcdAuthState(PICC_AUTHENT1A, 1, DefaultKey, g_ucTempbuf);
            if (status != MI_OK) continue;

            status = PcdValue(PICC_DECREMENT,1,data2);
            if (status != MI_OK) continue;
		 
            status = PcdBakValue(1, 2);
            if (status != MI_OK)continue;
         
            status = PcdRead(2, g_ucTempbuf);
            if (status != MI_OK)continue; 

        	printf("print3");
            for(i=0;i<16;i++)
			{
			    temp=g_ucTempbuf[i];
				printf("%X",temp);		
			}

		    printf("\n");
		    LED_GREEN = 0;
		    delay1(100);
		    LED_GREEN = 1;
		    delay1(100);
		    LED_GREEN = 0;
		    delay1(200);
		    LED_GREEN = 1;				 		         
		    PcdHalt();
		}
    }
}
