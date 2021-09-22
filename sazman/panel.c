#include <mega32a.h>
#define xtal 11059200

// 1 Wire Bus interface functions
#include <1wire.h>
#include <stdio.h>
#include <ds1307.h>
#include <testfont.c>
#include <string.h>
// DS1820 Temperature Sensor functions
#include <ds18b20.h>
//#include <bfreeze.c>
// maximum number of DS1820 devices
// connected to the 1 Wire bus
#define MAX_DS1820 8
// number of DS1820 devices
// connected to the 1 Wire bus
unsigned char ds1820_devices;
// DS1820 devices ROM code storage area,
// 9 bytes are used for each device
// (see the w1_search function description in the help)
unsigned char ds1820_rom_codes[MAX_DS1820][9];

// Graphic Display functions
#include <glcd.h>
#include <delay.h>
// Font used for displaying text
// on the graphic display
#include <font5x7.h>
#include <defines.c>
#include "tempread.h"
#include "clockchange.h"
#include "clockread.h"
#include "calender.h"
// Declare your global variables here

// Timer1 overflow interrupt service routine                                                                
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0x5740 >> 8;
TCNT1L=0x5740 & 0xff;
// Place your code here
    //if (led==1) led=0;
    //else led=1;
    //led^=1;
  
}



void main(void)
    {          

        
        #include "configall.h"
        #asm("sei")
        glcd_cleargraphics();
        glcd_clear();
        glcd_putimagef(0,0,logo,1);
        delay_ms(1000); 
        glcd_clear();
        //rtc_init(0,0,0);
        //rtc_set_time(13,43,0);
        //rtc_set_date(2,21,06,00);
        /*
        while(1){
            glcd_clear();
            glcd_putimagef(0,0,cooler,1);
            delay_ms(5000);
            glcd_putimagef(0,0,cooler,3);
            delay_ms(5000);
        }        
         */  
         
         while (1){
            for (i=0;i<=11;i++){
                delay_ms(1000);
                sprintf(str,"%01d%",i);
                lcd_gotoxy(0,0);
                lcd_puts(str);
            }                  
            glcd_clear();
            delay_ms(2000);
         }
         while (1){     

              readclock();
              readtemp();
              sprintf(str,"%2.1f%`C",temp);
              //sprintf(buffer,"Temp=%2.1f%`C",temp);
              lcd_gotoxy(10,1);
              lcd_puts(str);
              
              _wday=readcalender(_year);
              
              //glcd_display(1);
              //lcd_putsf("hi")
              
              if (lsec!=_sec){
                led=~led;
                lsec=_sec;
                
              }          
              
              

              if(up==0){
                j=0;
                do{
                  delay_ms(25);
                  j++;
                   if (j==80) {
                        glcd_clear();
                        strcpyf(state,"heatre");
                        glcd_putimagef(0,0,heater,1); 
                    }
                }
                while(up==0);
                glcd_clear();          
              } 
              
              if(down==0){
                j=0;
                do{
                  delay_ms(25);
                  j++;
                   if (j==80) {
                        glcd_clear();                
                        strcpyf(state,"cooler");
                        glcd_putimagef(0,0,cooler,1); 
                    }
                }
                while(down==0);
                glcd_clear();          
              }               
              
              if(menu==0){
                j=0;
                do{
                  delay_ms(25);
                  j++;
                   if (j==80) {
                        glcd_clear();
                        glcd_putimagef(0,0,snow,1); 
                    }
                    if(j==100){
                        glcd_clear();
                        changeclock();
                    }  
                }
                while(menu==0);
                glcd_clear();          
              } 
              
              if (_sec==00||_sec==15||_sec==30||_sec==45){
                glcd_clear();
                if (state=="cooler")glcd_putimagef(0,0,snow,1);
                else if(state=="heater")glcd_putimagef(0,0,snow,1);
                issame=strcmpf(state,"cooler");
                sprintf(str,"%02d",issame);
                lcd_puts(str);
                lcd_puts(state);
                delay_ms(1000);
                glcd_clear();
                if (issame==1)glcd_putimagef(0,0,heater,1);
                else if(issame==0)glcd_putimagef(0,0,cooler,1);
                delay_ms(3000);                                
                glcd_clear();
                /*
                //glcd_clear();
                //if (state=="cooler")glcd_putimagef(0,0,snow,1);
                //else if(state=="heater")glcd_putimagef(0,0,snow,1);
                issame=strcmpf(state,"cooler");
                sprintf(str,"%01d",issame);
                //lcd_puts(str);
                //lcd_puts(state);
                //delay_ms(1000);
                //glcd_clear();
                if (issame==1)glcd_putimagef(65,32,sheater,1);
                else if(issame==0)glcd_putimagef(65,32,scooler,1);
                delay_ms(3000);                                
                //glcd_clear(); 
                */               
              }
                
                
                     

                  
        }
    }      

