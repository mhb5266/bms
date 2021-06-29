//-----------------------------------------------------------------------------
// Copyright:      RAD Electronic Co. LTD,
// Author:         jaruwit supa, Base on FontEditor written by H. Reddmann
//								 Modified by Sh. Nourbakhsh Rad for Persian and Arabic font
//								 and fixed some errors
// Remarks:        
// known Problems: none
// Version:        3.0.0
// Description:    Font Library
//-----------------------------------------------------------------------------

#ifndef _FONT_H_
#define _FONT_H_

	#include <glcd.h>
    #include <stddef.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include <math.h>
    #include <delay.h>    
    
    	// Letter type (English - Persian)
	typedef enum {
	  E_LETTER,
	  P_LETTER
	} Lt_Mode;

        
  	typedef enum {
		BLACK		= 1,
		WHITE		= 0
	} GLCD_Color;
	////////////////////////////////////////////////////////////////////////////////
	#define GetMaxX()		glcd_getmaxx()
	#define GetMaxY()		glcd_getmaxy()

	////////////////////////////////////////////////////////////////////////////////
	#define PutPixel(x, y, clr)  	glcd_putpixel(x, y, clr)
    #define pefLightMode  						0	 					// 0: Disable light mode
 																								// 1: Enable  light mode1
 																								// 2: Enable  light mode2

 	#define PersianSupport  					1 					// 0: Disable Persian-Arabic functions
 																								// 1: Enable  Persian-Arabic functions

 	#define FONT_HEADER_SIZE  				7 					// header size of fonts


        //-----------------------     
        #ifndef F_CPU
            #define F_CPU                                                                    _MCU_CLOCK_FREQUENCY_
        #endif
        
        //-----------------------     
        typedef signed char                                             int8;
        typedef unsigned char                                           uint8;
        typedef signed int                                              int16;
        typedef unsigned int                                            uint16;
        typedef signed long int                                         int32;
        typedef unsigned long int                                       uint32;    
        
        //-----------------------     
        #define M_PI                                                                        PI
        
    //#define inline
    //#define __inline__
        
        #define PGM_P                                      char flash *
        #define PROGMEM                                    flash
        #define const                                      flash
        #define PSTR(x)                                    x

        #define EEMEM                                     eeprom
        
        #define pgm_read_byte(x)                             (*((uint8  flash *)(x)))
        #define pgm_read_word(x)                           (*((uint16 flash *)(x)))
        #define pgm_read_float(x)                                                (*((uint32 flash *)(x)))
        #define pgm_read_byte_near(x)                                        (*((uint8  flash *)(x)))

        #define eeprom_read_byte(ads)                     (*((uint8  eeprom *)(ads)))
        #define eeprom_read_word(ads)                     (*((uint16 eeprom *)(ads)))
        #define eeprom_read_float(ads)                       (*((uint32 eeprom *)(ads)))
        
        #define eeprom_write_byte(ads, x)                  (*((uint8  eeprom *)(ads))) = x
        #define eeprom_write_word(ads, x)                  (*((uint16 eeprom *)(ads))) = x
        #define eeprom_write_float(ads, x)                 (*((uint32 eeprom *)(ads))) = x

        #define _NOP()                                     #asm("nop")
        #define sei()                                     #asm("sei")
        #define cli()                                     #asm("cli")

        #define _delay_ms                                 delay_ms
		#define _delay_us               	              delay_us

		#ifndef ISR(vec)
			#define ISR(vec)            	                interrupt [vec] void isr##vec(void)
		#endif

		#define _BV(pin)            	                  (1<< pin)
		#define sbi(port, pin)      	                  (port |=  _BV(pin))
		#define cbi(port, pin)  		                    (port &= ~_BV(pin))
		#define outb(port, data)												(port = data)
		#define inb(port)																(port)
		
		#define bit_is_set(port, pin)		        				(port &   _BV(pin))
		#define bit_is_clear(port, pin)	        				(!(port &   _BV(pin)))
		#define loop_until_bit_is_set(port, pin)      	while(bit_is_clear(port, pin));
		#define loop_until_bit_is_clear(port, pin)     	while(bit_is_set(port, pin));

		//-----------------------	 
  	#define strncpy(a, b, c)												strncpy(a, b, c)
		#define strnlen(a, b)														strlen(a)

  	#define strncpy_P(a, b, c)											strcpyf(a, b)
		#define strnlen_P(a, b)													strlenf(a)
		
  	#define strcpy_P(a, b)													strcpyf(a, b)
		#define strlen_P(a)															strlenf(a)

		#define prog_char																flash char
		
		//-----------------------	 
		#define wdt_reset()															#asm("wdr")
		#define wdt_enable(t)														
		#define wdt_disable()														
		
		#define WDTO_15MS   														0
		#define WDTO_30MS   														1
		#define WDTO_60MS   														2
		#define WDTO_120MS  														3
		#define WDTO_250MS  														4
		#define WDTO_500MS  														5
		#define WDTO_1S     														6
		#define WDTO_2S     														7
		#define WDTO_4S     														8
		#define WDTO_8S     														9

		//----------------------------------------------------------------
		#if	defined(_CHIP_AT90S4414_) || defined(_CHIP_AT90S8515_) || defined(_CHIP_ATMEGA64_)  || \
  	   	defined(_CHIP_ATMEGA8515_)|| defined(_CHIP_ATMEGA103_) || defined(_CHIP_ATMEGA128_) || \
    	 	defined(_CHIP_ATMEGA161_) || defined(_CHIP_ATMEGA162_)

    	#define XMemory_OK
    #endif

	/////////////////////////////////////////////////////////
#if(pefLightMode <2)			//----	light mode0, 1
	#define STYLE_NONE								0
	#define STYLE_NO_ZERO   					1
	#define STYLE_NO_SPACE  					2
#endif
	
#if(pefLightMode ==0)			//----	light mode0
	#define ALINE_LEFT								0
	#define ALINE_CENTER							1
	#define ALINE_RIGHT								2
	#define ALINE_MARK								(ALINE_LEFT | ALINE_CENTER | ALINE_RIGHT)
	
	#define BORDER_NONE								0x00
	#define BORDER_RECT								0x04
	#define BORDER_FILL								0x08
	#define BORDER_BEVEL							0xF0	// bevel radius 0x00(rectangle), 0x10-0xF0(radius size)
	#define BORDER_MASK								(BORDER_FILL | BORDER_RECT)
	#define bvl(x)										(x<<4)
#endif

	/////////////////////////////////////////////////////////	
	extern unsigned char 							rot;
	extern unsigned char 							Reverse;
	extern unsigned char							Horizontal;

	extern unsigned short							FgColor;
	extern unsigned short							BkColor;
	extern unsigned char							FontFixed;
	extern unsigned char							NonTransparence;
	
	extern unsigned char 							FontWidth;
	extern unsigned char 							FontHeight;
	extern unsigned char 							FontXScale;
	extern unsigned char 							FontYScale;

	extern unsigned char 							FontSpaceX;
	extern unsigned char 							FontSpaceY;
	
	extern unsigned int 							cursorX;
	extern unsigned int 							cursorY;

#if (PersianSupport ==1)
	extern Lt_Mode										peLETTER;

	/////////////////////////////////////////////////////////	
	#define GetLetter() 							peLETTER
#endif

	#define GetCursorX() 							cursorX
	#define GetCursorY() 							cursorY
	#define SetCursorX(x) 						cursorX = x
	#define SetCursorY(y) 						cursorY = y
	#define SetCursor(x, y) 					{cursorX = x; cursorY = y;}
	
	#define LcdRot(n)									rot = n
	#define LcdReverse(n)							Reverse = n
	#define LcdHorizontal(n)					Horizontal = n
	
	#define LcdFontFixed(n)						FontFixed = n
	#define LcdNonTransparence(n)			NonTransparence = n
	
	#define SetFgColor(c)							FgColor = c
	#define SetBkColor(c)							BkColor = c
	#define GetFgColor()							FgColor
	#define GetBkColor()							BkColor
	
	#define LcdFontXScale(n)					FontXScale = n
	#define LcdFontYScale(n)					FontYScale = n

	#define LcdFontSpaceX(n)					FontSpaceX  = n
	#define LcdFontSpaceY(n)					FontSpaceY  = n
	
	#define LcdFontWidth() 	 					FontWidth
	#define LcdFontHeight()						FontHeight
	
	// complex function
	#define DrawStringAt(l, c, s, fk, bk)					{SetLine(l, c); SetFgColor(fk); SetBkColor(bk); Puts(s);}
	
	//******************* Function Prototypes
	void LcdFont(const unsigned char *pointer);

	void SetLetter(Lt_Mode L);
	void SetLine(unsigned char line,unsigned char column);

	void PutChar(unsigned char c);
	void Puts(char *Text);
#endif	//_FONT_H_
