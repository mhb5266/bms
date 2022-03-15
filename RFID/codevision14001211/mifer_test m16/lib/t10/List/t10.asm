
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32A
;Program type             : Application
;Clock frequency          : 7.372800 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x75:
	.DB  0x12,0x34,0x56,0x78,0xED,0xCB,0xA9,0x87
	.DB  0x12,0x34,0x56,0x78,0x1,0xFE,0x1,0xFE
_0x76:
	.DB  0x0,0x0,0x0,0x1
_0x77:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
_0x0:
	.DB  0x68,0x65,0x6C,0x6C,0x6F,0xD,0x0,0x70
	.DB  0x72,0x69,0x6E,0x74,0x31,0x0,0x25,0x58
	.DB  0x0,0x70,0x72,0x69,0x6E,0x74,0x32,0x3A
	.DB  0x0,0x70,0x72,0x69,0x6E,0x74,0x33,0x0
	.DB  0xA,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x10
	.DW  _data1
	.DW  _0x75*2

	.DW  0x04
	.DW  _data2
	.DW  _0x76*2

	.DW  0x06
	.DW  _DefaultKey
	.DW  _0x77*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;Chip type               : ATmega32A
;AVR Core Clock frequency: 7.372800 MHz
;Data Stack size         : 512
;
;converted from lpc 8bit 8952 micro (nxp example) to avr 8bit codevision by:
;Ehsan Safamanesh.
;email:  ehsan_safa66@yahoo.com
;*****************************************************/
;
;////////////   PORTB.3 is ss (sda) pin
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "MFRC522.h"

	.CSEG
_PcdReset:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _WriteRawRC
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(61)
	RCALL _WriteRawRC
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(30)
	RCALL _WriteRawRC
	LDI  R30,LOW(44)
	CALL SUBOPT_0x0
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(141)
	RCALL _WriteRawRC
	LDI  R30,LOW(43)
	ST   -Y,R30
	LDI  R26,LOW(62)
	RCALL _WriteRawRC
	LDI  R30,LOW(21)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _WriteRawRC
	LDI  R30,LOW(0)
	RET
_PcdAntennaOn:
	ST   -Y,R17
;	i -> R17
	LDI  R26,LOW(20)
	RCALL _ReadRawRC
	MOV  R17,R30
	MOV  R30,R17
	ANDI R30,LOW(0x3)
	BRNE _0x3
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _SetBitMask
_0x3:
	LD   R17,Y+
	RET
_PcdAntennaOff:
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ClearBitMask
	RET
_PcdRequest:
	CALL SUBOPT_0x1
;	req_code -> Y+24
;	*pTagType -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	CALL SUBOPT_0x2
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _WriteRawRC
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _SetBitMask
	LDD  R30,Y+24
	STD  Y+4,R30
	CALL SUBOPT_0x3
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x5
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
	LDD  R30,Y+4
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ST   X,R30
	LDD  R30,Y+5
	__PUTB1SNS 22,1
	RJMP _0x7
_0x4:
	LDI  R17,LOW(254)
_0x7:
	RJMP _0x2080006
_PcdAnticoll:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,18
	CALL __SAVELOCR6
;	*pSnr -> Y+24
;	status -> R17
;	i -> R16
;	snr_check -> R19
;	unLen -> R20,R21
;	ucComMF522Buf -> Y+6
	LDI  R19,0
	CALL SUBOPT_0x2
	CALL SUBOPT_0x0
	LDI  R30,LOW(14)
	CALL SUBOPT_0x5
	LDI  R30,LOW(147)
	STD  Y+6,R30
	LDI  R30,LOW(32)
	STD  Y+7,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	CALL SUBOPT_0x6
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R21
	PUSH R20
	RCALL _PcdComMF522
	POP  R20
	POP  R21
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x8
	LDI  R16,LOW(0)
_0xA:
	CPI  R16,4
	BRSH _0xB
	CALL SUBOPT_0x7
	MOVW R22,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	MOVW R26,R0
	ST   X,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	EOR  R19,R30
	SUBI R16,-1
	RJMP _0xA
_0xB:
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CP   R30,R19
	BREQ _0xC
	LDI  R17,LOW(254)
_0xC:
_0x8:
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA
	MOV  R30,R17
	CALL __LOADLOCR6
	RJMP _0x2080005
_PcdSelect:
	CALL SUBOPT_0x1
;	*pSnr -> Y+22
;	status -> R17
;	i -> R16
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	LDI  R30,LOW(147)
	STD  Y+4,R30
	LDI  R30,LOW(112)
	STD  Y+5,R30
	LDI  R30,LOW(0)
	STD  Y+10,R30
	LDI  R16,LOW(0)
_0xE:
	CPI  R16,4
	BRSH _0xF
	CALL SUBOPT_0x7
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	MOVW R26,R0
	ST   X,R30
	MOVW R30,R28
	ADIW R30,10
	MOVW R22,R30
	LD   R0,Z
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
	EOR  R30,R0
	MOVW R26,R22
	ST   X,R30
	SUBI R16,-1
	RJMP _0xE
_0xF:
	CALL SUBOPT_0xD
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,14
	RCALL _CalulateCRC
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _ClearBitMask
	CALL SUBOPT_0x3
	LDI  R30,LOW(9)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x11
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
	LDI  R17,LOW(0)
	RJMP _0x13
_0x10:
	LDI  R17,LOW(254)
_0x13:
	RJMP _0x2080004
_PcdAuthState:
	CALL SUBOPT_0x1
;	auth_mode -> Y+27
;	addr -> Y+26
;	*pKey -> Y+24
;	*pSnr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
	LDD  R30,Y+27
	STD  Y+4,R30
	LDD  R30,Y+26
	STD  Y+5,R30
	LDI  R16,LOW(0)
_0x15:
	CPI  R16,6
	BRSH _0x16
	CALL SUBOPT_0x7
	CALL SUBOPT_0xB
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x15
_0x16:
	LDI  R16,LOW(0)
_0x18:
	CPI  R16,6
	BRSH _0x19
	CALL SUBOPT_0x7
	MOVW R22,R30
	ADIW R30,8
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x18
_0x19:
	LDI  R30,LOW(14)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x1B
	LDI  R26,LOW(8)
	RCALL _ReadRawRC
	ANDI R30,LOW(0x8)
	BRNE _0x1A
_0x1B:
	LDI  R17,LOW(254)
_0x1A:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,28
	RET
_PcdRead:
	CALL SUBOPT_0x1
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
	LDI  R30,LOW(48)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x1E
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
	LDI  R16,LOW(0)
_0x21:
	CPI  R16,16
	BRSH _0x22
	CALL SUBOPT_0x7
	MOVW R22,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x8
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x21
_0x22:
	RJMP _0x23
_0x1D:
	LDI  R17,LOW(254)
_0x23:
	RJMP _0x2080006
_PcdWrite:
	CALL SUBOPT_0x1
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
	LDI  R30,LOW(160)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x25
	CALL SUBOPT_0x11
	BRNE _0x25
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x24
_0x25:
	LDI  R17,LOW(254)
_0x24:
	CPI  R17,0
	BRNE _0x27
	LDI  R16,LOW(0)
_0x29:
	CPI  R16,16
	BRSH _0x2A
	CALL SUBOPT_0x7
	MOVW R22,R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x29
_0x2A:
	CALL SUBOPT_0xD
	LDI  R30,LOW(16)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,23
	RCALL _CalulateCRC
	CALL SUBOPT_0x3
	LDI  R30,LOW(18)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2C
	CALL SUBOPT_0x11
	BRNE _0x2C
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x2B
_0x2C:
	LDI  R17,LOW(254)
_0x2B:
_0x27:
_0x2080006:
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,25
	RET
_PcdValue:
	CALL SUBOPT_0x1
;	dd_mode -> Y+25
;	addr -> Y+24
;	*pValue -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
	LDD  R30,Y+25
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2F
	CALL SUBOPT_0x11
	BRNE _0x2F
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x2E
_0x2F:
	LDI  R17,LOW(254)
_0x2E:
	CPI  R17,0
	BRNE _0x31
	LDI  R16,LOW(0)
_0x33:
	CPI  R16,16
	BRSH _0x34
	CALL SUBOPT_0x7
	MOVW R22,R30
	CALL SUBOPT_0xE
	CALL SUBOPT_0xC
	MOVW R26,R0
	ST   X,R30
	SUBI R16,-1
	RJMP _0x33
_0x34:
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	__GETWRN 18,19,0
	CALL SUBOPT_0x3
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	CALL SUBOPT_0x13
	BREQ _0x35
	LDI  R17,LOW(0)
_0x35:
_0x31:
	CPI  R17,0
	BRNE _0x36
	LDI  R30,LOW(176)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x38
	CALL SUBOPT_0x11
	BRNE _0x38
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x37
_0x38:
	LDI  R17,LOW(254)
_0x37:
_0x36:
	MOV  R30,R17
	CALL __LOADLOCR4
_0x2080005:
	ADIW R28,26
	RET
_PcdBakValue:
	ST   -Y,R26
	SBIW R28,18
	CALL __SAVELOCR4
;	sourceaddr -> Y+23
;	goaladdr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	LDI  R30,LOW(194)
	STD  Y+4,R30
	LDD  R30,Y+23
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x3B
	CALL SUBOPT_0x11
	BRNE _0x3B
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x3A
_0x3B:
	LDI  R17,LOW(254)
_0x3A:
	CPI  R17,0
	BRNE _0x3D
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x12
	CALL SUBOPT_0x3
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	CALL SUBOPT_0x13
	BREQ _0x3E
	LDI  R17,LOW(0)
_0x3E:
_0x3D:
	CPI  R17,0
	BREQ _0x3F
	LDI  R30,LOW(254)
	RJMP _0x2080003
_0x3F:
	LDI  R30,LOW(176)
	STD  Y+4,R30
	LDD  R30,Y+22
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x41
	CALL SUBOPT_0x11
	BRNE _0x41
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	CPI  R30,LOW(0xA)
	BREQ _0x40
_0x41:
	LDI  R17,LOW(254)
_0x40:
_0x2080004:
	MOV  R30,R17
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,24
	RET
_PcdHalt:
	SBIW R28,18
	CALL __SAVELOCR4
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	LDI  R30,LOW(80)
	STD  Y+4,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R19
	PUSH R18
	RCALL _PcdComMF522
	POP  R18
	POP  R19
	MOV  R17,R30
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	ADIW R28,22
	RET
_PcdComMF522:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	CALL __SAVELOCR6
;	Command -> Y+15
;	*pInData -> Y+13
;	InLenByte -> Y+12
;	*pOutData -> Y+10
;	*pOutLenBit -> Y+8
;	status -> R17
;	irqEn -> R16
;	waitFor -> R19
;	lastBits -> R18
;	n -> R21
;	i -> Y+6
	LDI  R17,254
	LDI  R16,0
	LDI  R19,0
	LDD  R30,Y+15
	LDI  R31,0
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x46
	LDI  R16,LOW(18)
	LDI  R19,LOW(16)
	RJMP _0x45
_0x46:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x48
	LDI  R16,LOW(119)
	LDI  R19,LOW(48)
_0x48:
_0x45:
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R30,R16
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _WriteRawRC
	LDI  R30,LOW(4)
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
	LDI  R30,LOW(10)
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x4A:
	LDD  R30,Y+12
	CALL SUBOPT_0x15
	BRSH _0x4B
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _WriteRawRC
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x4A
_0x4B:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R26,Y+16
	RCALL _WriteRawRC
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BRNE _0x4C
	LDI  R30,LOW(13)
	CALL SUBOPT_0xA
_0x4C:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x4E:
	LDI  R26,LOW(4)
	RCALL _ReadRawRC
	MOV  R21,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,0
	BREQ _0x50
	SBRC R21,0
	RJMP _0x50
	MOV  R30,R19
	AND  R30,R21
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
	RJMP _0x4E
_0x4F:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x5
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x52
	LDI  R26,LOW(6)
	RCALL _ReadRawRC
	ANDI R30,LOW(0x1B)
	BREQ PC+3
	JMP _0x53
	LDI  R17,LOW(0)
	MOV  R30,R16
	AND  R30,R21
	ANDI R30,LOW(0x1)
	BREQ _0x54
	LDI  R17,LOW(255)
_0x54:
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BREQ PC+3
	JMP _0x55
	LDI  R26,LOW(10)
	RCALL _ReadRawRC
	MOV  R21,R30
	LDI  R26,LOW(12)
	RCALL _ReadRawRC
	ANDI R30,LOW(0x7)
	MOV  R18,R30
	CPI  R18,0
	BREQ _0x56
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,1
	CALL __LSLW3
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x9F
_0x56:
	LDI  R30,LOW(8)
	MUL  R30,R21
	MOVW R30,R0
_0x9F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ST   X+,R30
	ST   X,R31
	CPI  R21,0
	BRNE _0x58
	LDI  R21,LOW(1)
_0x58:
	CPI  R21,19
	BRLO _0x59
	LDI  R21,LOW(18)
_0x59:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x5B:
	MOV  R30,R21
	CALL SUBOPT_0x15
	BRSH _0x5C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(9)
	RCALL _ReadRawRC
	POP  R26
	POP  R27
	ST   X,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x5B
_0x5C:
_0x55:
	RJMP _0x5D
_0x53:
	LDI  R17,LOW(254)
_0x5D:
_0x52:
	LDI  R30,LOW(12)
	CALL SUBOPT_0xA
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
	MOV  R30,R17
	CALL __LOADLOCR6
	ADIW R28,16
	RET
_CalulateCRC:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pIndata -> Y+5
;	len -> Y+4
;	*pOutData -> Y+2
;	i -> R17
;	n -> R16
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _ClearBitMask
	LDI  R30,LOW(1)
	CALL SUBOPT_0x0
	LDI  R30,LOW(10)
	CALL SUBOPT_0xA
	LDI  R17,LOW(0)
_0x5F:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x60
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _WriteRawRC
	SUBI R17,-1
	RJMP _0x5F
_0x60:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _WriteRawRC
	LDI  R17,LOW(255)
_0x62:
	LDI  R26,LOW(5)
	RCALL _ReadRawRC
	MOV  R16,R30
	SUBI R17,1
	CPI  R17,0
	BREQ _0x64
	SBRS R16,2
	RJMP _0x65
_0x64:
	RJMP _0x63
_0x65:
	RJMP _0x62
_0x63:
	LDI  R26,LOW(34)
	RCALL _ReadRawRC
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(33)
	RCALL _ReadRawRC
	__PUTB1SNS 2,1
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
_WriteRawRC:
	ST   -Y,R26
;	reg -> Y+1
;	value -> Y+0
	CBI  0x18,3
	LDD  R30,Y+1
	LSL  R30
	MOV  R26,R30
	RCALL _spi
	LD   R26,Y
	RCALL _spi
	SBI  0x18,3
	ADIW R28,2
	RET
_ReadRawRC:
	ST   -Y,R26
;	reg -> Y+0
	CBI  0x18,3
	LD   R30,Y
	LSL  R30
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _spi
	LDI  R26,LOW(0)
	RCALL _spi
	ST   Y,R30
	SBI  0x18,3
	JMP  _0x2080002
_SetBitMask:
	CALL SUBOPT_0x16
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	OR   R17,R30
	CALL SUBOPT_0x17
	JMP  _0x2080001
_ClearBitMask:
	CALL SUBOPT_0x16
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	COM  R30
	AND  R17,R30
	CALL SUBOPT_0x17
	JMP  _0x2080001
;
;#define LED_GREEN  PORTA.0
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 250
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0044 {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0045 char status,data;
; 0000 0046 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0047 data=UDR;
	IN   R16,12
; 0000 0048 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6E
; 0000 0049    {
; 0000 004A    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 004B #if RX_BUFFER_SIZE == 256
; 0000 004C    // special case for receiver buffer size=256
; 0000 004D    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 004E #else
; 0000 004F    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(250)
	CP   R30,R5
	BRNE _0x6F
	CLR  R5
; 0000 0050    if (++rx_counter == RX_BUFFER_SIZE)
_0x6F:
	INC  R7
	LDI  R30,LOW(250)
	CP   R30,R7
	BRNE _0x70
; 0000 0051       {
; 0000 0052       rx_counter=0;
	CLR  R7
; 0000 0053       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0054       }
; 0000 0055 #endif
; 0000 0056    }
_0x70:
; 0000 0057 }
_0x6E:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 005E {
; 0000 005F char data;
; 0000 0060 while (rx_counter==0);
;	data -> R17
; 0000 0061 data=rx_buffer[rx_rd_index++];
; 0000 0062 #if RX_BUFFER_SIZE != 256
; 0000 0063 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0064 #endif
; 0000 0065 #asm("cli")
; 0000 0066 --rx_counter;
; 0000 0067 #asm("sei")
; 0000 0068 return data;
; 0000 0069 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// SPI functions
;#include <spi.h>
;
;// Declare your global variables here
;//flash
;unsigned char data1[16] = {0x12,0x34,0x56,0x78,0xED,0xCB,0xA9,0x87,0x12,0x34,0x56,0x78,0x01,0xFE,0x01,0xFE};

	.DSEG
;unsigned char data2[4]  = {0,0,0,0x01};
;unsigned char DefaultKey[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
;
;unsigned char g_ucTempbuf[20];
;void delay1(unsigned int z)
; 0000 007B {

	.CSEG
_delay1:
; 0000 007C 	unsigned int x;
; 0000 007D     //unsigned int y;
; 0000 007E 	for(x=z;x>0;x--) delay_ms(1);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	z -> Y+2
;	x -> R16,R17
	__GETWRS 16,17,2
_0x79:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRSH _0x7A
	CALL SUBOPT_0x18
	__SUBWRN 16,17,1
	RJMP _0x79
_0x7A:
; 0000 0080 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;
;
;void main(void)
; 0000 0084 {
_main:
; 0000 0085 // Declare your local variables here
; 0000 0086     unsigned char status,i;
; 0000 0087     unsigned int temp;
; 0000 0088 
; 0000 0089 // Input/Output Ports initialization
; 0000 008A // Port A initialization
; 0000 008B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 008C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 008D PORTA=0x00;
;	status -> R17
;	i -> R16
;	temp -> R18,R19
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008E DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 008F 
; 0000 0090 // Port B initialization
; 0000 0091 // Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 0092 // State7=0 State6=T State5=0 State4=0 State3=1 State2=T State1=T State0=T
; 0000 0093 PORTB=0x08;
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 0094 DDRB=0xB8;
	LDI  R30,LOW(184)
	OUT  0x17,R30
; 0000 0095 
; 0000 0096 // Port C initialization
; 0000 0097 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0098 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0099 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 009A DDRC=0x00;
	OUT  0x14,R30
; 0000 009B 
; 0000 009C // Port D initialization
; 0000 009D // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009E // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009F PORTD=0x00;
	OUT  0x12,R30
; 0000 00A0 DDRD=0x00;
	OUT  0x11,R30
; 0000 00A1 
; 0000 00A2 // Timer/Counter 0 initialization
; 0000 00A3 // Clock source: System Clock
; 0000 00A4 // Clock value: Timer 0 Stopped
; 0000 00A5 // Mode: Normal top=0xFF
; 0000 00A6 // OC0 output: Disconnected
; 0000 00A7 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00A8 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A9 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00AA 
; 0000 00AB // Timer/Counter 1 initialization
; 0000 00AC // Clock source: System Clock
; 0000 00AD // Clock value: Timer1 Stopped
; 0000 00AE // Mode: Normal top=0xFFFF
; 0000 00AF // OC1A output: Discon.
; 0000 00B0 // OC1B output: Discon.
; 0000 00B1 // Noise Canceler: Off
; 0000 00B2 // Input Capture on Falling Edge
; 0000 00B3 // Timer1 Overflow Interrupt: Off
; 0000 00B4 // Input Capture Interrupt: Off
; 0000 00B5 // Compare A Match Interrupt: Off
; 0000 00B6 // Compare B Match Interrupt: Off
; 0000 00B7 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00B8 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00B9 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00BA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00BB ICR1H=0x00;
	OUT  0x27,R30
; 0000 00BC ICR1L=0x00;
	OUT  0x26,R30
; 0000 00BD OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00BE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C1 
; 0000 00C2 // Timer/Counter 2 initialization
; 0000 00C3 // Clock source: System Clock
; 0000 00C4 // Clock value: Timer2 Stopped
; 0000 00C5 // Mode: Normal top=0xFF
; 0000 00C6 // OC2 output: Disconnected
; 0000 00C7 ASSR=0x00;
	OUT  0x22,R30
; 0000 00C8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00C9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00CA OCR2=0x00;
	OUT  0x23,R30
; 0000 00CB 
; 0000 00CC // External Interrupt(s) initialization
; 0000 00CD // INT0: Off
; 0000 00CE // INT1: Off
; 0000 00CF // INT2: Off
; 0000 00D0 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00D1 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00D2 
; 0000 00D3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D4 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00D5 
; 0000 00D6 // USART initialization
; 0000 00D7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00D8 // USART Receiver: On
; 0000 00D9 // USART Transmitter: On
; 0000 00DA // USART Mode: Asynchronous
; 0000 00DB // USART Baud Rate: 115200
; 0000 00DC UCSRA=0x00;
	OUT  0xB,R30
; 0000 00DD UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00DE UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x20,R30
; 0000 00DF UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00E0 UBRRL=0x03;
	LDI  R30,LOW(3)
	OUT  0x9,R30
; 0000 00E1 
; 0000 00E2 // Analog Comparator initialization
; 0000 00E3 // Analog Comparator: Off
; 0000 00E4 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00E5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E6 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E7 
; 0000 00E8 // ADC initialization
; 0000 00E9 // ADC disabled
; 0000 00EA ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00EB 
; 0000 00EC // SPI initialization
; 0000 00ED // SPI Type: Master
; 0000 00EE // SPI Clock Rate: 460.800 kHz
; 0000 00EF // SPI Clock Phase: Cycle Start
; 0000 00F0 // SPI Clock Polarity: Low
; 0000 00F1 // SPI Data Order: MSB First
; 0000 00F2 SPCR=0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 00F3 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 00F4 
; 0000 00F5 // TWI initialization
; 0000 00F6 // TWI disabled
; 0000 00F7 TWCR=0x00;
	OUT  0x36,R30
; 0000 00F8 
; 0000 00F9 // Global enable interrupts
; 0000 00FA #asm("sei")
	sei
; 0000 00FB 
; 0000 00FC printf("hello\r");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x19
; 0000 00FD 
; 0000 00FE PcdReset();
	CALL SUBOPT_0x1A
; 0000 00FF delay_ms(1);
; 0000 0100 PcdAntennaOff();
	CALL SUBOPT_0x1B
; 0000 0101 delay_ms(1);
; 0000 0102 PcdAntennaOn();
	CALL SUBOPT_0x1C
; 0000 0103 delay_ms(1);
; 0000 0104 
; 0000 0105 while (1)
_0x7B:
; 0000 0106     {
; 0000 0107         status = PcdRequest(PICC_REQALL, g_ucTempbuf);
	CALL SUBOPT_0x1D
; 0000 0108         if (status != MI_OK)
	BREQ _0x7E
; 0000 0109         {
; 0000 010A             PcdReset();
	CALL SUBOPT_0x1A
; 0000 010B             delay_ms(1);
; 0000 010C             PcdAntennaOff();
	CALL SUBOPT_0x1B
; 0000 010D             delay_ms(1);
; 0000 010E             PcdAntennaOn();
	CALL SUBOPT_0x1C
; 0000 010F             delay_ms(1);
; 0000 0110 			continue;
	RJMP _0x7B
; 0000 0111         }
; 0000 0112 
; 0000 0113 		printf("print1");
_0x7E:
	__POINTW1FN _0x0,7
	CALL SUBOPT_0x19
; 0000 0114 
; 0000 0115         for(i=0;i<2;i++)
	LDI  R16,LOW(0)
_0x80:
	CPI  R16,2
	BRSH _0x81
; 0000 0116 		{
; 0000 0117 		    temp=g_ucTempbuf[i];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
; 0000 0118 			printf("%X",temp);
; 0000 0119 		}
	SUBI R16,-1
	RJMP _0x80
_0x81:
; 0000 011A 
; 0000 011B         status = PcdAnticoll(g_ucTempbuf);
	CALL SUBOPT_0x1F
; 0000 011C         if (status != MI_OK) continue;
	BRNE _0x7B
; 0000 011D 
; 0000 011E 		printf("print2:");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x19
; 0000 011F 
; 0000 0120         for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0x84:
	CPI  R16,4
	BRSH _0x85
; 0000 0121 		{
; 0000 0122 		    temp=g_ucTempbuf[i];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
; 0000 0123 			printf("%X",temp);
; 0000 0124 		}
	SUBI R16,-1
	RJMP _0x84
_0x85:
; 0000 0125 
; 0000 0126 		///////////////////////////////////////////////////////////
; 0000 0127 
; 0000 0128          status = PcdSelect(g_ucTempbuf);
	CALL SUBOPT_0x20
; 0000 0129          if (status != MI_OK) continue;
	BRNE _0x7B
; 0000 012A 
; 0000 012B          status = PcdAuthState(PICC_AUTHENT1A, 1, DefaultKey, g_ucTempbuf);
	CALL SUBOPT_0x21
; 0000 012C          if (status != MI_OK) continue;
	BRNE _0x7B
; 0000 012D 
; 0000 012E          status = PcdWrite(1, data1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_data1)
	LDI  R27,HIGH(_data1)
	RCALL _PcdWrite
	MOV  R17,R30
; 0000 012F          if (status != MI_OK) continue;
	CPI  R17,0
	BRNE _0x7B
; 0000 0130 
; 0000 0131         while(1)
_0x89:
; 0000 0132 		{
; 0000 0133             status = PcdRequest(PICC_REQALL, g_ucTempbuf);
	CALL SUBOPT_0x1D
; 0000 0134             if (status != MI_OK)
	BREQ _0x8C
; 0000 0135             {
; 0000 0136                 PcdReset();
	CALL SUBOPT_0x1A
; 0000 0137                 delay_ms(1);
; 0000 0138                 PcdAntennaOff();
	CALL SUBOPT_0x1B
; 0000 0139                 delay_ms(1);
; 0000 013A                 PcdAntennaOn();
	CALL SUBOPT_0x1C
; 0000 013B                 delay_ms(1);;
; 0000 013C 			    continue;
	RJMP _0x89
; 0000 013D             }
; 0000 013E 
; 0000 013F 		    status = PcdAnticoll(g_ucTempbuf);
_0x8C:
	CALL SUBOPT_0x1F
; 0000 0140             if (status != MI_OK)continue;
	BRNE _0x89
; 0000 0141 
; 0000 0142 		    status = PcdSelect(g_ucTempbuf);
	CALL SUBOPT_0x20
; 0000 0143             if (status != MI_OK)continue;
	BRNE _0x89
; 0000 0144 
; 0000 0145             status = PcdAuthState(PICC_AUTHENT1A, 1, DefaultKey, g_ucTempbuf);
	CALL SUBOPT_0x21
; 0000 0146             if (status != MI_OK) continue;
	BRNE _0x89
; 0000 0147 
; 0000 0148             status = PcdValue(PICC_DECREMENT,1,data2);
	LDI  R30,LOW(192)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_data2)
	LDI  R27,HIGH(_data2)
	RCALL _PcdValue
	MOV  R17,R30
; 0000 0149             if (status != MI_OK) continue;
	CPI  R17,0
	BRNE _0x89
; 0000 014A 
; 0000 014B             status = PcdBakValue(1, 2);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _PcdBakValue
	MOV  R17,R30
; 0000 014C             if (status != MI_OK)continue;
	CPI  R17,0
	BRNE _0x89
; 0000 014D 
; 0000 014E             status = PcdRead(2, g_ucTempbuf);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(_g_ucTempbuf)
	LDI  R27,HIGH(_g_ucTempbuf)
	RCALL _PcdRead
	MOV  R17,R30
; 0000 014F             if (status != MI_OK)continue;
	CPI  R17,0
	BRNE _0x89
; 0000 0150 
; 0000 0151         	printf("print3");
	__POINTW1FN _0x0,25
	CALL SUBOPT_0x19
; 0000 0152             for(i=0;i<16;i++)
	LDI  R16,LOW(0)
_0x94:
	CPI  R16,16
	BRSH _0x95
; 0000 0153 			{
; 0000 0154 			    temp=g_ucTempbuf[i];
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1E
; 0000 0155 				printf("%X",temp);
; 0000 0156 			}
	SUBI R16,-1
	RJMP _0x94
_0x95:
; 0000 0157 
; 0000 0158 		    printf("\n");
	__POINTW1FN _0x0,32
	CALL SUBOPT_0x19
; 0000 0159 		    LED_GREEN = 0;
	CBI  0x1B,0
; 0000 015A 		    delay1(100);
	CALL SUBOPT_0x22
; 0000 015B 		    LED_GREEN = 1;
	SBI  0x1B,0
; 0000 015C 		    delay1(100);
	CALL SUBOPT_0x22
; 0000 015D 		    LED_GREEN = 0;
	CBI  0x1B,0
; 0000 015E 		    delay1(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay1
; 0000 015F 		    LED_GREEN = 1;
	SBI  0x1B,0
; 0000 0160 		    PcdHalt();
	RCALL _PcdHalt
; 0000 0161 		}
	RJMP _0x89
; 0000 0162     }
; 0000 0163 }
_0x9E:
	RJMP _0x9E
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_spi:
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2000003:
	SBIS 0xE,7
	RJMP _0x2000003
	IN   R30,0xF
	RJMP _0x2080002
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080002:
	ADIW R28,1
	RET
_put_usart_G101:
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2080001:
	ADIW R28,3
	RET
__print_G101:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x23
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x23
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x24
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x25
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x24
	CALL SUBOPT_0x27
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x27
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x23
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x23
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x25
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x23
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x25
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_rx_buffer:
	.BYTE 0xFA
_data1:
	.BYTE 0x10
_data2:
	.BYTE 0x4
_DefaultKey:
	.BYTE 0x6
_g_ucTempbuf:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _WriteRawRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,18
	CALL __SAVELOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _ClearBitMask
	LDI  R30,LOW(13)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(12)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R26,LOW(128)
	JMP  _ClearBitMask

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,LOW(128)
	JMP  _SetBitMask

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOVW R22,R30
	ADIW R30,2
	MOVW R26,R28
	ADIW R26,4
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R26,R28
	ADIW R26,4
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	STD  Y+4,R30
	LDD  R30,Y+24
	STD  Y+5,R30
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	ADIW R26,9
	CALL _CalulateCRC
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,11
	JMP  _CalulateCRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	MOV  R17,R30
	MOV  R26,R17
	LDI  R30,LOW(254)
	LDI  R27,0
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	STD  Y+5,R30
	MOVW R30,R28
	ADIW R30,4
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	CALL _ReadRawRC
	MOV  R17,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDD  R30,Y+2
	ST   -Y,R30
	MOV  R26,R17
	CALL _WriteRawRC
	LDD  R17,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL _PcdReset
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _PcdAntennaOff
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL _PcdAntennaOn
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(82)
	ST   -Y,R30
	LDI  R26,LOW(_g_ucTempbuf)
	LDI  R27,HIGH(_g_ucTempbuf)
	CALL _PcdRequest
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1E:
	SUBI R30,LOW(-_g_ucTempbuf)
	SBCI R31,HIGH(-_g_ucTempbuf)
	LD   R18,Z
	CLR  R19
	__POINTW1FN _0x0,14
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_g_ucTempbuf)
	LDI  R27,HIGH(_g_ucTempbuf)
	CALL _PcdAnticoll
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_g_ucTempbuf)
	LDI  R27,HIGH(_g_ucTempbuf)
	CALL _PcdSelect
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(96)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(_DefaultKey)
	LDI  R31,HIGH(_DefaultKey)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_g_ucTempbuf)
	LDI  R27,HIGH(_g_ucTempbuf)
	CALL _PcdAuthState
	MOV  R17,R30
	CPI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay1

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x23:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x733
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
