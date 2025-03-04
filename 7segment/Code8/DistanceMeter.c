/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DistanceMeter
Version : 1.0
Date    : 3/9/2012
Author  : Fardin Abdali Mohammadi
Company : Isfahan University
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega8.h>
#include <stdlib.h> 
#include <delay.h>  
#include <GP2Y0A21.h>
// Alphanumeric LCD Module functions
#include <alcd.h>
#define ADC_VREF_TYPE 0x00
char a,b,c,d,i;
flash char sev[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here

void main(void)
{

       const ir_distance_sensor GP2Y0A21YK = { 5461, -17, 2 };
unsigned int SensorVoltage;
unsigned char sensordata[7];
signed short distance;
signed short prevDistance;
//float distance;
//float prevDistance;

// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 


// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xff;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x3E;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFF;

// ADC initialization
// ADC Clock frequency: 750.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 4
// RD - PORTB Bit 5
// EN - PORTB Bit 6
// D4 - PORTB Bit 0
// D5 - PORTB Bit 1
// D6 - PORTB Bit 2
// D7 - PORTB Bit 3
// Characters/line: 16
lcd_init(16);
// go on the second LCD line
lcd_gotoxy(0,1);

// display the message
lcd_putsf("Calcluating");
 prevDistance = 0; 

while (1)
      { 
               
      SensorVoltage =  read_adc(0);
       if (SensorVoltage<18) {
         SensorVoltage=18;};  
      distance = ir_distance_calculate_cm(GP2Y0A21YK, SensorVoltage);   
      // Place your code here
       if (prevDistance!= distance) {
           prevDistance = distance;
           lcd_clear();
           itoa(distance, sensordata);
           lcd_puts(sensordata);
           
      a=distance/1000;
      b=(distance%1000)/100;
      c=(distance%100)/10;
      d=distance%10;            
           }
     

    
      while (i<=25)
      {
      PORTC=0X02;
      PORTB=sev[d];
      delay_ms(2);
      
      PORTC=0X04;
      PORTB=sev[c];
      
      delay_ms(2);
      
      
      PORTC=0X16;
      PORTB=sev[b];
      
      delay_ms(2);
      
      PORTC=0X32;
      PORTB=sev[a];
      delay_ms(2);
      PORTC=0X00; 
      i++;
      }; 
     i=0;
 
    };     
}

