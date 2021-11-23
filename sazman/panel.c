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
#include "settingmenu.h"
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
    /*  
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
      */   
      
      /* 
        while (1){
        lcd_clear();
              sprintf(str,"send=%d",j);
              //sprintf(buffer,"Temp=%2.1f%`C",temp);
              lcd_puts(str); 
         printf("*ID= %2d #",j);
         //printf("%d",j);
         delay_ms(3000);
         j++;
         if (j>=10) j=0;
        }  
        */
        /*
        while (1){
         if (up==0){
            j=1;
            printf("*ID= %2d #",j);
         } 
         if (down==0){
            j=2;
            printf("*ID= %2d #",j);
         }
         if (menu==0){
            j=4;
            printf("*ID= %2d #",j);
         }   

         while (menu==0|up==0|down==0){
         }           
         //printf("%d",j);
         lcd_clear();
              sprintf(str,"send=%d",j);
              //sprintf(buffer,"Temp=%2.1f%`C",temp);
              lcd_puts(str); 
         delay_ms(200);
         j=0;
        }          
        */
      
         while (1){     

              readclock();
              if (lsec!=_sec){
                led=~led;
                lsec=_sec;

                if (_sec==1){                      
                     
                    if (state==1){
                        lcd_gotoxy(9,2);
                        lcd_puts("Heater");              
                        glcd_putimagef(0,32,sheater,0);
                        if(_hour==onhour & _min==onmin){
                            motor=1;                            
                            heateng=1;
                            chiller=0;
                        } 
                        if(_hour==offhour & _min==offmin){
                            motor=0;                            
                            heateng=0;
                            chiller=0;
                        }                        
                    }
                    
                    if(state==2){
                        lcd_gotoxy(9,2);
                        lcd_puts("Cooler");         
                        glcd_putimagef(0,32,scooler,0); 
                        if(_hour==onhour & _min==onmin){
                            motor=1;                            
                            heateng=0;
                            chiller=1;
                        } 
                        if(_hour==offhour & _min==offmin){
                            motor=0;                            
                            heateng=0;
                            chiller=0;
                        }                                                                    
                    }      
                    
                    if (onhour==_hour & onmin==_min){
                                            
                            printf("*Motor >> ON #");
                            delay_ms(3000);
                            
                            printf("*Chiller >> ON #");
                            delay_ms(3000);
                            
                            printf("*Heater >> ON #");
                            delay_ms(3000);                                                        
                      
                    }
                    
                    if (offhour==_hour & offmin==_min){
                            printf("*Motor >> OFF #");
                            delay_ms(3000);
                            
                            printf("*Chiller >> OFF #");
                            delay_ms(3000);
                            
                            printf("*Heater >> OFF #");
                            delay_ms(3000);  
                    }                        
                    /*
                    if (onhour==_hour & onmin==_min){
                        for (j=1;j<9;j++){
                            printf("*ID= %02d #",j);
                            delay_ms(1000);
                        }
                    }
                    
                    if (offhour==_hour & offmin==_min){
                        for (j=10;j<19;j++){
                            printf("*ID= %02d #",j);
                            delay_ms(1000);
                        }
                    } 
                    */  
                    
                                  
                   
                /*      
                   outs[1]=motor;
                   outs[2]=heateng;
                   outs[3]=chiller;
                   outs[4]=non3;
                   outs[5]=non4;
                   outs[6]=non5;
                   outs[7]=non6;
                   outs[8]=non7;
                   
                   for (j=1;j<9;j++){
                     printf("*ID= %2d #",outs[j]);
                     sprintf(str,"id=%2d  %2d",outs[j],j);
                     lcd_clear();
                     lcd_puts(str);
                     delay_ms(3000);
                   }
                   */                                                                                                                                         
                }
                
                /*
                issame=0;
                issame=strcmpf(state,"cooler");
                if (issame==1)glcd_putimagef(0,32,sheater,1);
                //sprintf(str,"%02d",issame);
                //lcd_puts(str);
                //lcd_puts(state);
                //delay_ms(1000);
                //glcd_clear();
                issame=0;
                issame=strcmpf(state,"heater");
                if(issame==1)glcd_putimagef(0,32,scooler,1);  
                */              
              }          
              
              readtemp();
              sprintf(str,"%2.1f%`C",temp);
              //sprintf(buffer,"Temp=%2.1f%`C",temp);
              lcd_gotoxy(10,1);
              lcd_puts(str);
              
              //_wday=readcalender(_year);
              
              //glcd_display(1);
              //lcd_putsf("hi")
              

              

              if(up==0){
                j=0;
                
                do{
                  delay_ms(25);
                  j++;
                   if (j==80) {
                        glcd_clear();
                        state=1;
                        glcd_putimagef(0,0,heater,0);
                        heaters=!heaters;
                        coolers=0; 
                    }
                }
                while(up==0);
                glcd_clear();
                if (heaters==1){     
                    
                    glcd_putimagef(0,32,sheater,0);
                    printf("*Motor >> OFF #");
                    delay_ms(100);
                                
                    printf("*Chiller >> OFF #");
                    delay_ms(100);
                                
                    printf("*Heater >> OFF #");
                    delay_ms(100);
                                        
                    printf("*Motor >> ON #");
                    delay_ms(3000);
                                
                    printf("*Chiller >> OFF #");
                    delay_ms(3000);
                                
                    printf("*Heater >> ON #");
                    delay_ms(3000);
                    }
                else {
                    printf("*Motor >> OFF #");
                    delay_ms(3000);
                                
                    printf("*Chiller >> OFF #");
                    delay_ms(3000);
                                
                    printf("*Heater >> OFF #");
                    delay_ms(3000);                
                }            
              } 
              
              if(down==0){
                j=0;
                do{
                  delay_ms(25);
                  j++;
                   if (j==80) {
                        glcd_clear();                
                        state=2;
                        glcd_putimagef(0,0,cooler,0);
                        coolers=!coolers;
                        heaters=0; 
                    }
                }
                while(down==0);
                glcd_clear();
                if (coolers==1){  
                    
                    glcd_putimagef(0,32,scooler,0);
                    printf("*Motor >> OFF #");
                    delay_ms(100);
                                
                    printf("*Chiller >> OFF #");
                    delay_ms(100);
                                
                    printf("*Heater >> OFF #");
                    delay_ms(100);
                                                         
                    printf("*Motor >> ON #");
                    delay_ms(3000);
                                
                    printf("*Chiller >> ON #");
                    delay_ms(3000);
                                
                    printf("*Heater >> OFF #");
                    delay_ms(3000);
                    }
                else {
                    printf("*Motor >> OFF #");
                    delay_ms(3000);
                                
                    printf("*Chiller >> OFF #");
                    delay_ms(3000);
                                
                    printf("*Heater >> OFF #");
                    delay_ms(3000);                
                }                          
              }               
              
              if(menu==0){
                j=0;
                do{
                  delay_ms(25);
                  j++;  
                               
                    if (j==80) {
                        glcd_clear();
                        glcd_putimagef(0,0,settingicon2,1);
                    }
                                    
                    if(j==140){
                        glcd_clear();
                        glcd_putimagef(0,0,clock,1);
                    }
                  
                                  
                    if (menu==1) break;
                }      
                while(menu==0);

                if (j>=80 & j<=140) { 
                        glcd_clear();
                        lcd_gotoxy(0,0);
                        lcd_puts("settign menu");
                        delay_ms(2000);                
                        menusetting();          
                        glcd_clear();
                }
                
                if(j>=140 & j<=180){ 
                        glcd_clear();
                        lcd_gotoxy(0,0);
                        lcd_puts("Clock menu");
                        delay_ms(2000);                                
                        changeclock();
                        glcd_clear();
                }  
                glcd_clear();          
              }    


                  
        }
    }      

