//-----------------------------------------------------------------------------
// Copyright:      RAD Electronic Co. LTD,
// Author:         jaruwit supa, Base on FontEditor written by H. Reddmann
//								 Modified by Sh. Nourbakhsh Rad for Persian and Arabic font
//								 and fixed some errors
// Remarks:        
// known Problems: none
// Version:        3.3.0
// Description:    Font Library
//-----------------------------------------------------------------------------

#include "Font.h"
#if (PersianSupport ==1)
	#include "PE_Map.h"
#endif


const unsigned char 	   *FontPointer; 									// Font	Pointer


unsigned char 						rot 						= 0;					// Rot 0=0°, 1=90°
unsigned char 						Reverse					= 0;					// Reverse text direction on the display
unsigned char							Horizontal			=	1;					// 1: Portrait - 240x320 ,   2: Landscape - 320x240

unsigned short 						FgColor 				= BLACK;			// Text fg color, 5-6-5 RGB
unsigned short 						BkColor 				= WHITE;			// Text bk color, 5-6-5 RGB
unsigned char 						FontFixed				= 0;					// Text type 0=Proportional , 1=Fixed
unsigned char							NonTransparence = 0;					// Transparent 0=No, 1=Yes

unsigned short 						fontSize;											// size of current font
unsigned char 						firstchar;										// first character noumber of current font
unsigned char 						lastchar;											// last character noumber of current font
unsigned char 						charwidth;										// current character width register

unsigned char							FontWidth;										// max width of font
unsigned char							FontHeight;										// max height of font
unsigned char 						FontXScale 			= 1;					// X size of font
unsigned char 						FontYScale 			= 1;					// Y size of font

unsigned char 						FontSpaceX 			= 1;					// space between char
unsigned char 						FontSpaceY			= 0;					// space between lines

unsigned int 							cursorX 				= 0;					// x position
unsigned int 							cursorY 				= 0;					// y position

#if (PersianSupport ==1)
	Lt_Mode									peLETTER				= E_LETTER;		// English or Persian letter
#endif

unsigned char 						prevLet 				= 0xFF;				// previous persian character register
unsigned char	 						nextLet 				= 0xFF; 			// next persian character register


//*************************************************
//******************* Functions *******************
//*************************************************


void PutCharEN(unsigned char c)
{
	unsigned char 			byte 					= 0;
	unsigned char 			bitoffset 		= 0;
	unsigned char 			maske 				= 0;
	unsigned short 			bcounter 			= 0;
	unsigned short 			bitsbischar 	= 0;
	unsigned short 			bytesbischar	= 0;
	unsigned short 			xPos, yPos;
	
	unsigned char 			Ccounter 			= 0;
	unsigned char 			xc						= 0;
	unsigned char 			yc						= 0;
	unsigned char 			sx 						= 0;
	unsigned char 			sy 						= 0;

   // get current character width
	charwidth	= pgm_read_byte(&FontPointer[(unsigned int)(c)+FONT_HEADER_SIZE-firstchar]);
	
	// line feed, goto next line
	if(c == '\n')
	{
		cursorX = 0;
		cursorY += (unsigned int)(FontHeight +FontSpaceY)*FontYScale;
		
		return;
	}

	// character out of range.
  if( (c < firstchar) || (c > lastchar) || (fontSize == 0)) 
  	return;

	// character is not in list.
	if (charwidth == 0)
		return;

	// sara thai font. line remain at last position
	if(FontFixed)
		charwidth = FontWidth;
	else
	{
		//english special fonts!
		if (((c >= 0xd4) && (c <= 0xda)) || 
	  	  ((c >= 0xe7) && (c <= 0xec)) ||
				 (c == 0xd1))
		{
			cursorX = cursorX - (unsigned int)charwidth * FontXScale;
		}
	}

	// fixed width for digit
 	if((c >= '0') && (c <= '9'))		// english : 0 to 9
		charwidth = pgm_read_byte(&FontPointer[(unsigned int)(FONT_HEADER_SIZE)+'0'-firstchar]);		//width reference = ZERO
	
	// line adjust
	if(((int)cursorX + charwidth * FontXScale) > GetMaxX())
	{
		cursorY = cursorY + (unsigned int)FontHeight * FontYScale; 
		cursorX = 0;
	}

	// calculate current character position on the table
	for(Ccounter = 0; Ccounter < c-firstchar; Ccounter++)
		bitsbischar += (pgm_read_byte(&FontPointer[(unsigned int)(Ccounter)+FONT_HEADER_SIZE]));	//c0_width +...+ cn_width
    
    
	bitsbischar 		*= FontHeight;																										//c_widths * FH
	bitsbischar 		+= (((unsigned short)(lastchar)-firstchar)+FONT_HEADER_SIZE)*8;		//plus font headers
	bytesbischar 		 = bitsbischar/8;																//
	bitoffset 			 = bitsbischar % 8;															//
	maske						 = bitoffset % 8;																//

	// draw character
	for(xc = 0; xc < charwidth; xc++)
	{
		for(yc = 0; yc < FontHeight; yc++)
		{
			if(maske > 7)
			{
				maske = 0;
				bcounter += 1;
			}
			byte = pgm_read_byte(&FontPointer[bytesbischar + bcounter + 1]);

			xPos = (unsigned short)xc*FontXScale + cursorX;
			
			if(Horizontal)	//128x64
			{
				if(Reverse)
					yPos = (((unsigned short)FontHeight-yc)*FontYScale + cursorY);
				else
					yPos = (((unsigned short)yc)*FontYScale + cursorY);     
			}
			else						//64x128
			{
				if(Reverse)
					yPos = (((unsigned short)FontHeight-yc)*FontYScale + cursorY);
				else
					yPos = (((unsigned short)yc)*FontYScale + cursorY);
				
			}	//Horizontal

			for(sx = 0; sx < FontXScale; sx++)
			{
				for(sy = 0; sy < FontYScale; sy++)
				{
					if(bit_is_set(byte, maske))
					{
						if(rot)		PutPixel(yPos+sy, xPos+sx, FgColor);
						else			PutPixel(xPos+sx, yPos+sy, FgColor);
					}
					else
					{
						if(NonTransparence)
						{
							if(rot)		PutPixel(yPos+sy, xPos+sx, BkColor);
							else			PutPixel(xPos+sx, yPos+sy, BkColor);
						}
					}
				};//for sy
			};//for sx
			
			maske++;
		};//for yc
	};//for xc
	
	// adjust cursor to next position - english
	cursorX	+= (unsigned int)charwidth * FontXScale + FontSpaceX;
}	//*PutCharEN

void PutCharPE(unsigned char c)
{
	#if (PersianSupport ==1)
		unsigned char 			byte 					= 0;
		unsigned char 			bitoffset 		= 0;
		unsigned char 			maske 				= 0;
		unsigned short 			bcounter 			= 0;
		unsigned short 			bitsbischar 	= 0;
		unsigned short 			bytesbischar	= 0;
		unsigned short 			xPos, yPos;
	
		unsigned char 			Ccounter 			= 0;
		unsigned char 			xc 						= 0;
		unsigned char 			yc 						= 0;
		unsigned char 			sx 						= 0;
		unsigned char 			sy 						= 0;
		
		// get current character width
		charwidth	= pgm_read_byte(&FontPointer[(unsigned int)(c)+FONT_HEADER_SIZE-firstchar]);
		
		// line feed, goto next line
		if(c == '\n')
		{
			cursorX = GetMaxX();
			cursorY += (unsigned int)(FontHeight +FontSpaceY)* FontYScale;
			
			return;
		}
	
		// character out of range.
	  if( (c < firstchar) || (c > lastchar) || (fontSize == 0)) 
	  	return;
	
		// character is not in list.
		if (charwidth == 0)
			return;
	
		// sara thai font. line remain at last position
		if(FontFixed)
			charwidth = FontWidth;
		
		// line adjust
		if(((int)cursorX - charwidth * FontXScale) < 0)
	  {
			cursorY = cursorY   + (unsigned int)FontHeight * FontYScale; 
			cursorX = GetMaxX() - (unsigned int)charwidth * FontXScale;
		}
	
		// adjust cursor to current position - persian
		cursorX	-= (unsigned int)charwidth * FontXScale + FontSpaceX;
	
		// calculate current character position on the table
		for(Ccounter = 0; Ccounter < c-firstchar; Ccounter++)
			bitsbischar += (pgm_read_byte(&FontPointer[(unsigned int)(Ccounter)+FONT_HEADER_SIZE]));	//c0_width +...+ cn_width
	
	
		bitsbischar 		*= FontHeight;																										//c_widths * FH
		bitsbischar 		+= (((unsigned short)(lastchar)-firstchar)+FONT_HEADER_SIZE)*8;		//plus font headers
		bytesbischar 		 = bitsbischar/8;									//
		bitoffset 			 = bitsbischar % 8;								//
		maske						 = bitoffset % 8;									//
	
		// draw character
		for(xc = 0; xc < charwidth; xc++)
		{
			for(yc = 0; yc < FontHeight; yc++)
			{
				if(maske > 7)
				{
					maske = 0;
					bcounter+=1;
				}
				byte = pgm_read_byte(&FontPointer[bytesbischar + bcounter + 1]);
	
				xPos = (unsigned short)xc*FontXScale + cursorX;
				
				if(Horizontal)	//128x64
				{
					if(Reverse)
						yPos = (((unsigned short)FontHeight-yc)*FontYScale + cursorY);
					else
						yPos = (((unsigned short)yc)*FontYScale + cursorY);     
				}
				else						//64x128
				{
					if(Reverse)
						yPos = (((unsigned short)FontHeight-yc)*FontYScale + cursorY);
					else
						yPos = (((unsigned short)yc)*FontYScale + cursorY);
					
				}	//Horizontal
	
				for(sx = 0; sx < FontXScale; sx++)
				{
					for(sy = 0; sy < FontYScale; sy++)
					{
						if(bit_is_set(byte,maske))
						{
							if(rot)		PutPixel(yPos+sy, xPos+sx, FgColor);
							else			PutPixel(xPos+sx, yPos+sy, FgColor);
						}
						else
						{
							if(NonTransparence)
							{
								if(rot)		PutPixel(yPos+sy, xPos+sx, BkColor);
								else			PutPixel(xPos+sx, yPos+sy, BkColor);
							}
						}
					}//for sy
				}//for sx
				
				maske++;
			}//for yc
		}//for xc	
	#endif
}	//*PutCharPE

unsigned int CalcTextWidthEN(char *str)
{
	unsigned int 		strSize = 0;
	unsigned char 	c;
	unsigned int 		i = 0;	

	while(str[i])
	{
		c = str[i++];
		
		if(c == '\n')			continue;
		
		if(FontFixed)
			strSize += (unsigned int)(FontWidth) * FontXScale;
		else
		{
		  if((c < firstchar) || (c > lastchar)) 
				charwidth = FontWidth;
			else
			{
				charwidth = pgm_read_byte(&FontPointer[(unsigned int)(c)+FONT_HEADER_SIZE-firstchar]);

				//english spesial fonts!
				if (((c >= 0xd4) && (c <= 0xda)) || 
		    		((c >= 0xe7) && (c <= 0xec)) ||
				  	 (c == 0xd1))

					charwidth = 0;
			}
			
			strSize += (unsigned int)(charwidth) * FontXScale;
		}
		
		strSize += FontSpaceX;
	}//while
	
	return(strSize);
}	//*CalcTextWidthEN

unsigned int CalcTextWidthPE(char *str)
{
	#if (PersianSupport ==1)
		unsigned char 	curnLet, dumyLet;
		unsigned char 	Pstat, stat, Nstat;
		
		unsigned char		backFontSpace = FontSpaceX;
		unsigned int 		strSize = 0;
		unsigned int		i = 0;
		
	 	while(str[i])
		{ 		
			curnLet = str[i++];
			if(curnLet == '\n')			continue;
		
			if(FontFixed)
				strSize += (unsigned int)(FontWidth) * FontXScale;
			else
			{
			 	if((curnLet < firstchar) || (curnLet > lastchar)) 
					charwidth = FontWidth;
				else
				{
			 		switch(curnLet)
			 		{	
			 			case 0x81:				//peh
			    		curnLet = 0xEA;
			 				break;
			 			case 0x8D:				//cheh
			    		curnLet = 0xEB;
			 				break;
			 			case 0x8E:				//zheh
			    		curnLet = 0xEE;
			 				break;
			 			case 0x90:				//geh
			    		curnLet = 0xEF;
			 				break;  
                        case 0x98:				//Ke
		    		    curnLet = 0xDF;
		 				break;
			 			case 0xE1:				//laa
			    		nextLet = str[i++];
			    		
			    		if(nextLet == 0xC7)
			    			curnLet = 0xFB;
			    		else
			    		{
			    			i--;
			    			curnLet = 0xE1;
			    		}
			 				break;
			 			case 0x30:				//persian digits 0...9
						case 0x31:
						case 0x32:
						case 0x33:
						case 0x34:
						case 0x35:
						case 0x36:
						case 0x37:
						case 0x38:
						case 0x39:
							curnLet -= 0x20;
			 				break;
			 			case 0x3F:				//persian question mark
			    		curnLet = 0xBF;
			 				break;
			 			case 0x3B:				//persian semicolon
			    		curnLet = 0x1F;
			 				break;
			 			case 0x2C:				//persian comma
			    		curnLet = 0x1D;
			 				break;
			 			case 0x2E:				//persian point
			    		curnLet = 0x1C;
			 				break; 				
					}//switch curnLet
			
					//--------------------------------
			  	nextLet = str[i++];
			  	i--;
			  	
			 		switch(nextLet)
			 		{	
			 			case 0x81:				//peh
			    		nextLet = 0xEA;
			 				break;
			 			case 0x8D:				//cheh
			    		nextLet = 0xEB;
			 				break;
			 			case 0x8E:				//zheh
			    		nextLet = 0xEE;
			 				break;
			 			case 0x90:				//geh
			    		nextLet = 0xEF;
			 				break; 
                         case 0x98:				//Ke
		    		    nextLet = 0xDF;
		 				break;
			 			case 0x30:				//0...9
						case 0x31:
						case 0x32:
						case 0x33:
						case 0x34:
						case 0x35:
						case 0x36:
						case 0x37:
						case 0x38:
						case 0x39:
							nextLet -= 0x20;
			 				break; 			
			 			case 0x3F:				//persian question mark
			    		nextLet = 0xBF;
			 				break;
			 			case 0x3B:				//persian semicolon
			    		nextLet = 0x1F;
			 				break;
			 			case 0x2C:				//persian comma
			    		nextLet = 0x1D;
			 				break;
			 			case 0x2E:				//persian point
			    		nextLet = 0x1C;
			 				break; 				
					}//switch nextLet
	
					if(curnLet > 0xC0)
					{		
						if(prevLet > 0xC0)
							Pstat = (pgm_read_byte(&PEmap[prevLet-0xC1][5]));
						else
							Pstat = 0;
							
						if(nextLet > 0xC0)
							Nstat = (pgm_read_byte(&PEmap[nextLet-0xC1][4]));
						else
							Nstat = 0;
						
						stat = (Pstat<<1) | Nstat;		
						
						if(stat>1)	FontSpaceX = 0;
						else 				FontSpaceX = backFontSpace;
						////////////////
						dumyLet = pgm_read_byte(&PEmap[curnLet-0xC1][stat]);
						
						charwidth = pgm_read_byte(&FontPointer[(unsigned int)(dumyLet)+FONT_HEADER_SIZE-firstchar]);
						strSize += (unsigned int)(charwidth) * FontXScale;
						strSize += FontSpaceX;
						////////////////
						FontSpaceX = backFontSpace;
					}
					else
					{
						charwidth = pgm_read_byte(&FontPointer[(unsigned int)(curnLet)+FONT_HEADER_SIZE-firstchar]);
						strSize += (unsigned int)(charwidth) * FontXScale;
						strSize += FontSpaceX;
					}
					
					prevLet = curnLet;
				}
			}
		}//while
	
	 	prevLet = 0xFF;
	 	
		return(strSize);
	#endif
}	//*CalcTextWidthPE

unsigned int CalcTextWidth(char *Text)
{
	#if (PersianSupport ==1)
		if(peLETTER == E_LETTER)
			return(CalcTextWidthEN(Text));
		else
	#endif
			return(CalcTextWidthPE(Text));
}	//*CalcTextWidth

unsigned int CalcTextHeight(void)
{
	return((unsigned int)(FontHeight) * FontYScale);
}	//*CalcTextHeight

void PutsPE(char *str)
{	
	#if (PersianSupport ==1)
		unsigned char 	curnLet;
		unsigned char 	Pstat, stat, Nstat;
		
		unsigned char		backFontSpace = FontSpaceX;
		char 						strTemp[50];
		unsigned char 	i = 0, j = 0;
		unsigned int		k = 0;
	
	 	while(str[k])
		{ 		
	 		curnLet = str[k++];
	 		
	 		switch(curnLet)
	 		{	
	 			case 0x81:				//peh
	    		curnLet = 0xEA;
	 				break;
	 			case 0x8D:				//cheh
	    		curnLet = 0xEB;
	 				break;
	 			case 0x8E:				//zheh
	    		curnLet = 0xEE;
	 				break;
	 			case 0x90:				//geh
	    		curnLet = 0xEF;
	 				break; 
                 case 0x98:				//Ke
		    		    curnLet = 0xDF;
		 				break;
	 			case 0xE1:				//laa
	    		nextLet = str[k++];
	    		
	    		if(nextLet == 0xC7)
	    			curnLet = 0xFB;
	    		else
	    		{
	    			k--;
	    			curnLet = 0xE1;
	    		}
	 				break;
	 			case 0x3F:				//persian question mark
	    		curnLet = 0xBF;
	 				break;
	 			case 0x3B:				//persian semicolon
	    		curnLet = 0x1F;
	 				break;
	 			case 0x2C:				//persian comma
	    		curnLet = 0x1D;
	 				break;
	 			case 0x2E:				//persian point
	    		curnLet = 0x1C;
	 				break; 				
			}//switch curnLet
			
			//--------------------------------
	  	nextLet = str[k++];
	  	k--;
	 	
	 		switch(nextLet)
	 		{	
	 			case 0x81:				//peh
	    		nextLet = 0xEA;
	 				break;
	 			case 0x8D:				//cheh
	    		nextLet = 0xEB;
	 				break;
	 			case 0x8E:				//zheh
	    		nextLet = 0xEE;
	 				break;
	 			case 0x90:				//geh
	    		nextLet = 0xEF;
	 				break;
                 case 0x98:				//Ke
		    		    nextLet = 0xDF;
		 				break;
	 			case 0x3F:				//persian question mark
	    		nextLet = 0xBF;
	 				break;
	 			case 0x3B:				//persian semicolon
	    		nextLet = 0x1F;
	 				break;
	 			case 0x2C:				//persian comma
	    		nextLet = 0x1D;
	 				break;
	 			case 0x2E:				//persian point
	    		nextLet = 0x1C;
	 				break; 			
			}//switch nextLet
	
			if(curnLet > 0xC0)
			{		
				if(prevLet > 0xC0)
					Pstat = (pgm_read_byte(&PEmap[prevLet-0xC1][5]));		// 1: prevLet attach to curnLet -- 0: prevLet don't attach to curnLet
				else
					Pstat = 0;
					
				if(nextLet > 0xC0)
					Nstat = (pgm_read_byte(&PEmap[nextLet-0xC1][4]));		// 1: nextLet attach to curnLet -- 0: nextLet don't attach to curnLet
				else
					Nstat = 0;
				
				//			Pstat	|	Nstat	|	stat
				//		 -------+-------+------
				//				0		|		0		|		0				curnLet, don't attach to prevLet and nextLet
				//				0		|		1		|		1				curnLet, don't attach to prevLet and attach to nextLet
				//				1		|		0		|		2				curnLet, attach to prevLet and don't attach to nextLet
				//				1		|		1		|		3				curnLet, attach to prevLet and nextLet
				
				stat = (Pstat<<1) | Nstat;		
				
				if(stat>1)	FontSpaceX = 0;
				else 				FontSpaceX = backFontSpace;
				
				PutCharPE(pgm_read_byte(&PEmap[curnLet-0xC1][stat]));
				FontSpaceX = backFontSpace;
			}
			else	//Original 'curnLet' below 193 without (    Ž )  -- for digits and symbols!
			{
	  		if((curnLet >= '0') && (curnLet <= '9'))		// 0 to 9
	  		{
	  			i++;
	  			strTemp[i] 	 = curnLet;
	
	  			if(!((nextLet >= '0') && (nextLet <= '9')))
					{
						for(j=i; j>0; j--)
							PutCharPE(strTemp[j]-0x20);
	
						i = 0;
					}
				}		
				else
					PutCharPE(curnLet);
			}
			
			prevLet = curnLet;
		}//while
	
	 	prevLet = 0xFF;
	#endif
}	//*PutsPE

//-------------------------------------------------
//**** select font
void LcdFont(const unsigned char *pointer)
{
	FontPointer 			= pointer;

	FontWidth 				= pgm_read_byte(&FontPointer[2]);
	FontHeight				= pgm_read_byte(&FontPointer[3]);

	fontSize					=	pgm_read_word(&FontPointer[0]);
	firstchar 				=	pgm_read_byte(&FontPointer[5]);
	lastchar 					=	pgm_read_byte(&FontPointer[6]);
}	//*LcdFont

void SetLetter(Lt_Mode L)
{
	#if (PersianSupport ==1)
		peLETTER = L;
		
		if(L == P_LETTER)
			cursorX = GetMaxX();
		else
			cursorX = 0;
	#endif
}	//*SetLetter

void SetLine(unsigned char line,unsigned char column)
{
	#if (PersianSupport ==1)
		if(peLETTER == P_LETTER)
			cursorX =GetMaxX() - (unsigned int)FontWidth  * FontXScale * column;
		else
	#endif
			cursorX =(unsigned int)FontWidth  * FontXScale * column;

	cursorY =(unsigned int)(FontHeight +FontSpaceY)* FontYScale * line;
}	//*SetLine


//-------------------------------------------------
//**** draw char
void PutChar(unsigned char c)
{
	#if (PersianSupport ==1)
	  if(peLETTER == P_LETTER)
			PutCharPE(c);
		else
	#endif
			PutCharEN(c);
}	//*PutChar

//**** draw string
void Puts(char *Text)
{	
	unsigned int		i = 0;
	
	#if (PersianSupport ==1)
	  if(peLETTER == P_LETTER)
	  {
			PutsPE(Text);
		}
		else
	#endif
		{
			while(Text[i])
				PutCharEN(Text[i++]);
		}
}	//*Puts


