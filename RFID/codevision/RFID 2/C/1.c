#include <mega8.h>
#include <stdio.h>
#include <delay.h>
#include <lcd.h>
#asm
   .equ __lcd_port=0x1B  //PORTc
#endasm


char str[]={'0','0','0','0','0','0','0','0','0','0'};

char card1[]={'0','0','0','1','3','5','4','5','9','8'};
char card2[]={'0','0','0','1','1','5','7','1','8','6'};


void main(void)
{
    UCSRA=0x00;
    UCSRB=0x10;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=51;

    lcd_init(20);

    
    while (1)
    {
        UCSRB=0x90; 
        gets(str,10);        
        UCSRB=0x00;   
                
        
        lcd_clear();
        lcd_puts(str);   
           
        if      (str[9]==card1[9] && str[8]==card1[8] && str[7]==card1[7] && str[6]==card1[6] && str[5]==card1[5] && str[4]==card1[4] && str[3]==card1[3]){lcd_gotoxy(5,1);lcd_puts("CART 1");delay_ms(1000);} 
        else if (str[9]==card2[9] && str[8]==card2[8] && str[7]==card2[7] && str[6]==card2[6] && str[5]==card2[5] && str[4]==card2[4] && str[3]==card2[3]){lcd_gotoxy(5,1);lcd_puts("CART 2");delay_ms(1000);} 
        else {lcd_gotoxy(0,1);lcd_puts(" Not Card Defined!");}  
    }   
}