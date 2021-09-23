#include <mega16.h>
#include <tm1637.h>

#asm
 .equ __tm1637_port=0X1b; //PORTA
 .equ __clk_bit=0;
 .equ __dio_bit=1;
#endasm
//PORTD=0x12;
//PORTC=0x15;
//PORTB=0x18;
//PORTA=0x1b;
_Bool Update_Time=0;
_Bool ClockPoint=0;
signed char second=0,minute=0,hour=0;

void main(void)
{
ASSR=0x08;
TCCR2=0x05;
TCNT2=0x00;
OCR2=0x00;
TIMSK=0x40;
#asm("sei")

tm1637_init();
tm1637_scroll("   ----HELLO----    ");
while (1)
      {
        if(Update_Time)
        {  
        Update_Time =0;
            if(ClockPoint)
            {
            tm1637_point(POINT_ON);
            }else
            { 
            tm1637_point(POINT_OFF);
            }; 
        tm1637_display_all(hour/10,hour%10,minute/10,minute%10);
        }
      }
}
//*************************************************************************
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
Update_Time =1;
ClockPoint =~ClockPoint;
second++;
    if (second > 59) 
    {
    second=0;
    minute++;
            if (minute>59)
            {
            minute=0;
            hour++;
                    if(hour>23)
                    {
                    hour=0;
                    }
            }
    } 
}
