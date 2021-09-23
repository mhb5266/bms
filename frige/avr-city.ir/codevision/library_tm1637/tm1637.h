#ifndef _TM1637_INCLUDED_
#define _TM1637_INCLUDED_

 
////////////////////////////////////////////////////////////////////

#define ADDR_AUTO  0x40   //40H address is automatically incremented
#define ADDR_FIXED 0x44   // 44H fixed address mode
    
#define STARTADDR  0xc0 
	/**** definitions for the clock point of the 4-Digit Display *******/
#define POINT_ON   1   // COLON = (:)
#define POINT_OFF  0
#define OFF  28        //digit off

#pragma used+

extern unsigned char _point; 
extern unsigned int _scrolldelay; //ms 
extern unsigned char _brightness; //0 ~ 7 >>>  0=off  >>  7=max light
     
extern flash char Table_7s[42];

void tm1637_init(void);
void tm1637_display_all(char d1,char d2,char d3,char d4);
void tm1637_display(char addr,char data);
void tm1637_point(unsigned char point);
void tm1637_brightness(unsigned char brightness);
void tm1637_num(unsigned int num);
void tm1637_puts(char *str);
void tm1637_putsf(char flash *str);
void tm1637_scroll(char *str);
void tm1637_scrolldelay(unsigned int scrolldelay);
//unsigned char ScanKey (void);

unsigned char Tm1637_table_str(unsigned char ch);
void I2CStart(void);
void I2CStop(void);
void I2Cack(void);  
void I2CWrByte(unsigned char oneByte);

#pragma used-

#pragma library tm1637.lib

#endif