//by Sh. Nourbakhsh Rad			Ver: 1.5.0
#ifndef PEMAP_H
	#define PEMAP_H

			//PEmap[x][0] = standalone 	character
			//PEmap[x][1] = first 			character
			//PEmap[x][2] = last 				character
			//PEmap[x][3] = middle 			character
			
			//PEmap[x][4] = 1: current char. attach to previous char.
			//PEmap[x][5] = 1: current char. attach to next char.

	PROGMEM unsigned char PEmap[63][6] = {
		{0xC1,0xC1,0xC1,0xC1,0,0},	//0 	-	193
		{0xC2,0xC2,0x02,0x02,1,0},	//1  	-	194
		{0xC3,0xC3,0x01,0x01,1,0},	//2  	-	195
		{0xC4,0xC4,0xC4,0xC4,0,0},	//3  	-	196
		{0xC5,0xC5,0x03,0x03,1,0},	//4  	-	197
		{0xC6,0xC6,0xC6,0xC6,0,0},	//5  	-	198
		{0xC7,0xC7,0x00,0x00,1,0},	//6  	-	199
		{0xC8,0x04,0xC8,0x04,1,1},	//7  	-	200
		{0xC9,0xFE,0xE9,0x95,1,1},	//8  	-	201
		{0xCA,0x05,0xCA,0x05,1,1},	//9   -	202
		{0xCB,0x06,0xCB,0x06,1,1},	//10 	-	203
		{0xCC,0x07,0x08,0x07,1,1},	//11 	-	204
		{0xCD,0x09,0x9A,0x09,1,1},	//12 	-	205
		{0xCE,0x0B,0x0C,0x0B,1,1},	//13 	-	206
		{0xCF,0xCF,0xCF,0xCF,1,0},	//14 	-	207
		{0xD0,0xD0,0xD0,0xD0,1,0},	//15 	-	208
		{0xD1,0xD1,0xD1,0xD1,1,0},	//16 	-	209
		{0xD2,0xD2,0xD2,0xD2,1,0},	//17 	-	210
		{0xD3,0x8A,0xD3,0x8A,1,1},	//18 	-	211
		{0xD4,0x0E,0xD4,0x0E,1,1},	//19 	-	212
		{0xD5,0x0F,0xD5,0x0F,1,1},	//20 	-	213
		{0xD6,0x1A,0xD6,0x1A,1,1},	//21 	-	214
		{0xD7,0xD7,0xD7,0xD7,0,0},	//22 	-	215
		{0xD8,0xD8,0xD8,0xD8,1,1},	//23 	-	216
		{0xD9,0xD9,0xD9,0xD9,1,1},	//24 	-	217
		{0xDA,0x1B,0xF1,0xF0,1,1},	//25 	-	218
		{0xDB,0xF5,0x7F,0xF6,1,1},	//26 	-	219
		{0xDC,0xDC,0xDC,0xDC,1,1},	//27 	-	220
		{0xDD,0x80,0xDD,0x80,1,1},	//28 	-	221
		{0xDE,0x83,0xDE,0x83,1,1},	//29 	-	222
		{0xDF,0x8C,0xDF,0x8C,1,1},	//30 	-	223
		{0xE0,0xE0,0xE0,0xE0,0,0},	//31 	-	224
		{0xE1,0xF3,0xE1,0xF3,1,1},	//32 	-	225
		{0xE2,0xE2,0xE2,0xE2,0,0},	//33 	-	226
		{0xE3,0xF8,0xE3,0xF8,1,1},	//34 	-	227
		{0xE4,0xF2,0xE4,0xF2,1,1},	//35 	-	228
		{0xE5,0xFE,0xE7,0x95,1,1},	//36 	-	229
		{0xE6,0xE6,0xE6,0xE6,1,0},	//37 	-	230
		{0xE7,0xE7,0xE7,0xE7,0,0},	//38 	-	231
		{0xE8,0xE8,0xE8,0xE8,0,0},	//39 	-	232
		{0xE9,0xE9,0xE9,0xE9,0,0},	//40 	-	233
		{0x81,0xFD,0x81,0xFD,1,1},	//41 	-	234
		{0x8D,0x9D,0x9E,0x9D,1,1},	//42 	-	235
		{0xEC,0xC0,0xA0,0xC0,1,1},	//43 	-	236
		{0xED,0xC0,0x9C,0xC0,1,1},	//44 	-	237
		{0x8E,0x8E,0x8E,0x8E,1,0},	//45 	-	238
		{0x90,0xFA,0x90,0xFA,1,1},	//46 	-	239
		{0xF0,0xF0,0xF0,0xF0,0,0},	//47 	-	240
		{0xF1,0xF1,0xF1,0xF1,0,0},	//48 	-	241
		{0xF2,0xF2,0xF2,0xF2,0,0},	//49 	-	242
		{0xF3,0xF3,0xF3,0xF3,0,0},	//50 	-	243
		{0xF4,0xF4,0xF4,0xF4,0,0},	//51 	-	244
		{0xF5,0xF5,0xF5,0xF5,0,0},	//52 	-	245
		{0xF6,0xF6,0xF6,0xF6,0,0},	//53 	-	246
		{0xF7,0xF7,0xF7,0xF7,0,0},	//54 	-	247
		{0xF8,0xF8,0xF8,0xF8,0,0},	//55 	-	248
		{0xF9,0xF9,0xF9,0xF9,0,0}, 	//56 	-	249
		{0xFA,0xFA,0xFA,0xFA,0,0}, 	//57 	-	250
		{0xA5,0xA5,0x9F,0x9F,1,0}, 	//58 	-	251
		{0xFC,0xFC,0xFC,0xFC,0,0}, 	//59 	-	252
		{0xFD,0xFD,0xFD,0xFD,0,0}, 	//60 	-	253
		{0xFE,0xFE,0xFE,0xFE,0,0}, 	//61 	-	254
		{0xFF,0xFF,0xFF,0xFF,0,0} 	//62 	-	255
		};

#endif	//PEMAP_H
