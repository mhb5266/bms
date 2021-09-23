#include <mega16.h>
#include <stdio.h>
#include <math.h>
#include <tm1637.h>
#include "DHT22.h"

//PORTD=0x12;
//PORTC=0x15;
//PORTB=0x18;
//PORTA=0x1b;

#asm
 .equ __tm1637_port=0X1b;
 .equ __clk_bit=0;
 .equ __dio_bit=1;
#endasm

unsigned char str[]={"    ----HELLO-----    "};

void main(void)
{
float temperature,humidity;
char t,h;
char dig1T,dig2T,dig1H,dig2H;
tm1637_init();
tm1637_scroll(str);
while (1)
      {
      if(dht22_read(&temperature,&humidity) == 0)
        {
           tm1637_scroll("    Error  dht22    ");
        }
      else
        { 
        t=ceil(temperature);  
        h=ceil(humidity);                                                
        dig1T = t / 10;
        dig2T = t % 10; 
        dig1H = h / 10;
        dig2H = h % 10;
        tm1637_display_all(dig1T,dig2T,38,36); // (degree = 38)  -  ("c" = 36) 
        delay_ms(2500);
        tm1637_display_all(dig1H,dig2H,24,40); // ("r" = 24)  -  ("h" = 40)
        delay_ms(2500);     
        }
      }
}