
#ifndef F_CPU
#define F_CPU 11059200UL // 16 MHz clock speed
#endif


#define D4 eS_PORTC2
#define D5 eS_PORTC3
#define D6 eS_PORTC4
#define D7 eS_PORTC5
#define RS eS_PORTC1
#define EN eS_PORTC0

#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"


#include <avr/io.h>

int main(void)
{
   DDRD = 0xFF;
   DDRC = 0xFF;
   //DDRB=  0xFF;
   int i;
   Lcd4_Init();
   while(1)
   {
	   Lcd4_Clear();
	   Lcd4_Set_Cursor(1,1);
	   Lcd4_Write_String("Hi Mohammad");
	   for(i=0;i<15;i++)
	   {
		   _delay_ms(500);
		   Lcd4_Shift_Left();
	   }
	   for(i=0;i<15;i++)
	   {
		   _delay_ms(500);
		   Lcd4_Shift_Right();
	   }
	   Lcd4_Clear();
	   Lcd4_Set_Cursor(2,1);
	   Lcd4_Write_Char('H');
	   Lcd4_Write_Char('i');
	   _delay_ms(2000);
	   
   }
}