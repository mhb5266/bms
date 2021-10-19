/*
 * GccApplication1.c
 *
 * Created: 10/18/2021 4:19:14 PM
 * Author : Barouei
 */ 
#define F_CPU 11059200U
#include <avr/io.h>
#include <avr/delay.h>



//
//#define led PORTD.6
//DDRD=(0<<DDD7) | (1<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
int main(void)
{
    /* Replace with your application code */
    while (1) 
    {
		
		//led=~led;
		//1<<PORTD.6;
		_delay_ms(1000);	
    }
}

