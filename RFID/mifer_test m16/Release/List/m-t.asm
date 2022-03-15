
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x41,0x3A,0x25,0x33,0x64,0x20,0x25,0x33
	.DB  0x64,0x0,0x42,0x3A,0x25,0x33,0x64,0x20
	.DB  0x25,0x33,0x64,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x20C0060:
	.DB  0x1
_0x20C0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G106
	.DW  _0x20C0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;Chip type               : ATmega16A
;AVR Core Clock frequency: 8/000000 MHz
;*******************************************************/
;#include <mega8.h>
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
;#include <alcd.h>
;#include <spi.h>
;#include <stdio.h>
;#include <delay.h>
;#include "MFRC522.h"

	.CSEG
_PcdReset:
; .FSTART _PcdReset
	RCALL SUBOPT_0x0
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
	ST   -Y,R30
	RCALL SUBOPT_0x1
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
; .FEND
_PcdAntennaOn:
; .FSTART _PcdAntennaOn
	ST   -Y,R17
;	i -> R17
	LDI  R26,LOW(20)
	RCALL _ReadRawRC
	MOV  R17,R30
	ANDI R30,LOW(0x3)
	BRNE _0x3
	RCALL SUBOPT_0x2
	RCALL _SetBitMask
_0x3:
	LD   R17,Y+
	RET
; .FEND
_PcdAntennaOff:
; .FSTART _PcdAntennaOff
	RCALL SUBOPT_0x2
	RCALL _ClearBitMask
	RET
; .FEND
_PcdRequest:
; .FSTART _PcdRequest
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,18
	RCALL __SAVELOCR4
;	req_code -> Y+24
;	*pTagType -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
	RCALL SUBOPT_0x3
	LDI  R26,LOW(7)
	RCALL _WriteRawRC
	RCALL SUBOPT_0x2
	RCALL _SetBitMask
	LDD  R30,Y+24
	STD  Y+4,R30
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x0
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x5
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
	MOV  R30,R17
	RCALL __LOADLOCR4
	ADIW R28,25
	RET
; .FEND
_PcdAnticoll:
; .FSTART _PcdAnticoll
	RCALL SUBOPT_0x6
	SBIW R28,18
	RCALL __SAVELOCR6
;	*pSnr -> Y+24
;	status -> R17
;	i -> R16
;	snr_check -> R19
;	unLen -> R20,R21
;	ucComMF522Buf -> Y+6
	LDI  R19,0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x7
	RCALL _ClearBitMask
	LDI  R30,LOW(147)
	STD  Y+6,R30
	LDI  R30,LOW(32)
	STD  Y+7,R30
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,7
	RCALL SUBOPT_0x5
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0x5
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
	RCALL SUBOPT_0x8
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	MOVW R26,R0
	ST   X,R30
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	EOR  R19,R30
	SUBI R16,-1
	RJMP _0xA
_0xB:
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	CP   R30,R19
	BREQ _0xC
	LDI  R17,LOW(254)
_0xC:
_0x8:
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x7
	RCALL _SetBitMask
	MOV  R30,R17
	RCALL __LOADLOCR6
	ADIW R28,26
	RET
; .FEND
;	*pSnr -> Y+22
;	status -> R17
;	i -> R16
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
;	auth_mode -> Y+27
;	addr -> Y+26
;	*pKey -> Y+24
;	*pSnr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	addr -> Y+24
;	*pData -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	dd_mode -> Y+25
;	addr -> Y+24
;	*pValue -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	i -> R16
;	ucComMF522Buf -> Y+4
;	sourceaddr -> Y+23
;	goaladdr -> Y+22
;	status -> R17
;	unLen -> R18,R19
;	ucComMF522Buf -> Y+4
_PcdHalt:
; .FSTART _PcdHalt
	SBIW R28,18
	RCALL __SAVELOCR2
;	unLen -> R16,R17
;	ucComMF522Buf -> Y+2
	LDI  R30,LOW(80)
	STD  Y+2,R30
	LDI  R30,LOW(0)
	STD  Y+3,R30
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0x5
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _CalulateCRC
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,3
	RCALL SUBOPT_0x5
	LDI  R30,LOW(4)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x5
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	RCALL _PcdComMF522
	POP  R16
	POP  R17
	LDI  R30,LOW(0)
	RCALL __LOADLOCR2
	ADIW R28,20
	RET
; .FEND
_PcdComMF522:
; .FSTART _PcdComMF522
	RCALL SUBOPT_0x6
	SBIW R28,2
	RCALL __SAVELOCR6
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
	RCALL SUBOPT_0x7
	RCALL _ClearBitMask
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x7
	RCALL _SetBitMask
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x4A:
	LDD  R30,Y+12
	RCALL SUBOPT_0xA
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x4B
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	ADIW R30,1
	RCALL SUBOPT_0xE
	RJMP _0x4A
_0x4B:
	RCALL SUBOPT_0x0
	LDD  R26,Y+16
	RCALL _WriteRawRC
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BRNE _0x4C
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x7
	RCALL _SetBitMask
_0x4C:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0xE
_0x4E:
	LDI  R26,LOW(4)
	RCALL _ReadRawRC
	MOV  R21,R30
	RCALL SUBOPT_0xD
	SBIW R30,1
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xA
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
	RCALL SUBOPT_0x7
	RCALL _ClearBitMask
	RCALL SUBOPT_0xD
	SBIW R30,0
	BRNE PC+2
	RJMP _0x52
	LDI  R26,LOW(6)
	RCALL _ReadRawRC
	ANDI R30,LOW(0x1B)
	BREQ PC+2
	RJMP _0x53
	LDI  R17,LOW(0)
	MOV  R30,R16
	AND  R30,R21
	ANDI R30,LOW(0x1)
	BREQ _0x54
	LDI  R17,LOW(255)
_0x54:
	LDD  R26,Y+15
	CPI  R26,LOW(0xC)
	BRNE _0x55
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
	RCALL __LSLW3
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x9C
_0x56:
	LDI  R30,LOW(8)
	MUL  R30,R21
	MOVW R30,R0
_0x9C:
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
	RCALL SUBOPT_0xA
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x5C
	RCALL SUBOPT_0xD
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
	RCALL SUBOPT_0xD
	ADIW R30,1
	RCALL SUBOPT_0xE
	RJMP _0x5B
_0x5C:
_0x55:
	RJMP _0x5D
_0x53:
	LDI  R17,LOW(254)
_0x5D:
_0x52:
	RCALL SUBOPT_0x4
	LDI  R26,LOW(128)
	RCALL _SetBitMask
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	MOV  R30,R17
	RCALL __LOADLOCR6
	RJMP _0x20E0006
; .FEND
_CalulateCRC:
; .FSTART _CalulateCRC
	RCALL SUBOPT_0x6
	RCALL __SAVELOCR2
;	*pIndata -> Y+5
;	len -> Y+4
;	*pOutData -> Y+2
;	i -> R17
;	n -> R16
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _ClearBitMask
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x7
	RCALL _SetBitMask
	LDI  R17,LOW(0)
_0x5F:
	LDD  R30,Y+4
	CP   R17,R30
	BRSH _0x60
	LDI  R30,LOW(9)
	ST   -Y,R30
	MOV  R30,R17
	LDI  R31,0
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
	SUBI R17,-1
	RJMP _0x5F
_0x60:
	RCALL SUBOPT_0x0
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
	RCALL SUBOPT_0xF
	ST   X,R30
	LDI  R26,LOW(33)
	RCALL _ReadRawRC
	__PUTB1SNS 2,1
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
; .FEND
_WriteRawRC:
; .FSTART _WriteRawRC
	ST   -Y,R26
;	reg -> Y+1
;	value -> Y+0
	CBI  0x18,2
	LDD  R30,Y+1
	LSL  R30
	MOV  R26,R30
	RCALL _spi
	LD   R26,Y
	RCALL _spi
	SBI  0x18,2
	ADIW R28,2
	RET
; .FEND
_ReadRawRC:
; .FSTART _ReadRawRC
	ST   -Y,R26
;	reg -> Y+0
	CBI  0x18,2
	LD   R30,Y
	LSL  R30
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _spi
	LDI  R26,LOW(0)
	RCALL _spi
	ST   Y,R30
	SBI  0x18,2
	RJMP _0x20E0008
; .FEND
_SetBitMask:
; .FSTART _SetBitMask
	RCALL SUBOPT_0x10
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	OR   R17,R30
	RCALL SUBOPT_0x11
	RJMP _0x20E0007
; .FEND
_ClearBitMask:
; .FSTART _ClearBitMask
	RCALL SUBOPT_0x10
;	reg -> Y+2
;	mask -> Y+1
;	tmp -> R17
	COM  R30
	AND  R17,R30
	RCALL SUBOPT_0x11
	RJMP _0x20E0007
; .FEND
;	keyA -> Y+27
;	keyB -> Y+25
;	sector_num -> Y+24
;	key -> Y+22
;	dd -> Y+2
;	stat -> R17
;	k -> R16
;	keyA -> Y+27
;	keyB -> Y+25
;	sector_num -> Y+24
;	key -> Y+22
;	dd -> Y+2
;	stat -> R17
;	k -> R16
;	wrdata -> Y+28
;	sector_num -> Y+27
;	block_num -> Y+26
;	key -> Y+24
;	dd -> Y+4
;	stat -> R17
;	address -> R16
;	k -> R19
;	rddata -> Y+28
;	sector_num -> Y+27
;	block_num -> Y+26
;	key -> Y+24
;	dd -> Y+4
;	flag_err -> R17
;	stat -> R16
;	k -> R19
;	address -> R18
_rd_serial:
; .FSTART _rd_serial
	RCALL SUBOPT_0x6
	SBIW R28,20
	ST   -Y,R17
;	serial -> Y+21
;	dd -> Y+1
;	stat -> R17
	LDI  R30,LOW(82)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _PcdRequest
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x94
	MOVW R26,R28
	ADIW R26,1
	RCALL _PcdAnticoll
	MOV  R17,R30
	RCALL _PcdHalt
	LDD  R30,Y+1
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ST   X,R30
	LDD  R30,Y+2
	__PUTB1SNS 21,1
	LDD  R30,Y+3
	__PUTB1SNS 21,2
	LDD  R30,Y+4
	__PUTB1SNS 21,3
	CPI  R17,0
	BRNE _0x95
	LDI  R30,LOW(1)
	RJMP _0x20E0009
_0x95:
	LDI  R30,LOW(0)
	RJMP _0x20E0009
_0x94:
	LDI  R30,LOW(0)
_0x20E0009:
	LDD  R17,Y+0
	ADIW R28,23
	RET
; .FEND
_reset_mfrc:
; .FSTART _reset_mfrc
	RCALL _PcdReset
	RCALL SUBOPT_0x12
	RCALL _PcdAntennaOff
	RCALL SUBOPT_0x12
	RCALL _PcdAntennaOn
	RCALL SUBOPT_0x12
	RCALL _PcdHalt
	RET
; .FEND
;
;unsigned char serial[4],d[16];
;bit a;
;
;void main(void){
; 0000 000F void main(void){
_main:
; .FSTART _main
; 0000 0010 {
; 0000 0011 // Declare your local variables here
; 0000 0012 
; 0000 0013 // Input/Output Ports initialization
; 0000 0014 // Port A initialization
; 0000 0015 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0016 //DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
; 0000 0017 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0018 //PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
; 0000 0019 
; 0000 001A // Port B initialization
; 0000 001B // Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 001C DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (1<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(180)
	OUT  0x17,R30
; 0000 001D // State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 001E PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 001F 
; 0000 0020 // Port C initialization
; 0000 0021 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0022 DDRC= (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0023 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0024 PORTC= (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0025 
; 0000 0026 // Port D initialization
; 0000 0027 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0028 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0029 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002A PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 002B 
; 0000 002C // Timer/Counter 0 initialization
; 0000 002D // Clock source: System Clock
; 0000 002E // Clock value: Timer 0 Stopped
; 0000 002F // Mode: Normal top=0xFF
; 0000 0030 // OC0 output: Disconnected
; 0000 0031 TCCR0= (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0032 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0033 
; 0000 0034 
; 0000 0035 // Timer/Counter 1 initialization
; 0000 0036 // Clock source: System Clock
; 0000 0037 // Clock value: Timer1 Stopped
; 0000 0038 // Mode: Normal top=0xFFFF
; 0000 0039 // OC1A output: Disconnected
; 0000 003A // OC1B output: Disconnected
; 0000 003B // Noise Canceler: Off
; 0000 003C // Input Capture on Falling Edge
; 0000 003D // Timer1 Overflow Interrupt: Off
; 0000 003E // Input Capture Interrupt: Off
; 0000 003F // Compare A Match Interrupt: Off
; 0000 0040 // Compare B Match Interrupt: Off
; 0000 0041 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0042 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0043 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0044 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0045 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0046 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0047 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0048 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0049 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 004A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 004B 
; 0000 004C // Timer/Counter 2 initialization
; 0000 004D // Clock source: System Clock
; 0000 004E // Clock value: Timer2 Stopped
; 0000 004F // Mode: Normal top=0xFF
; 0000 0050 // OC2 output: Disconnected
; 0000 0051 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0052 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0053 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0054 OCR2=0x00;
	OUT  0x23,R30
; 0000 0055 
; 0000 0056 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0057 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1)  | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0058 
; 0000 0059 // External Interrupt(s) initialization
; 0000 005A // INT0: Off
; 0000 005B // INT1: Off
; 0000 005C // INT2: Off
; 0000 005D MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 005E //MCUCSR=(0<<ISC2);
; 0000 005F 
; 0000 0060 // USART initialization
; 0000 0061 // USART disabled
; 0000 0062 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0063 
; 0000 0064 // Analog Comparator initialization
; 0000 0065 // Analog Comparator: Off
; 0000 0066 // The Analog Comparator's positive input is
; 0000 0067 // connected to the AIN0 pin
; 0000 0068 // The Analog Comparator's negative input is
; 0000 0069 // connected to the AIN1 pin
; 0000 006A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 006B SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 006C 
; 0000 006D // ADC initialization
; 0000 006E // ADC disabled
; 0000 006F ADCSRA=(0<<ADEN) | (0<<ADSC)  | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0070 
; 0000 0071 // SPI initialization
; 0000 0072 // SPI Type: Master
; 0000 0073 // SPI Clock Rate: 500/000 kHz
; 0000 0074 // SPI Clock Phase: Cycle Start
; 0000 0075 // SPI Clock Polarity: Low
; 0000 0076 // SPI Data Order: MSB First
; 0000 0077 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 0078 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0079 
; 0000 007A // TWI initialization
; 0000 007B // TWI disabled
; 0000 007C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 007D 
; 0000 007E // Alphanumeric LCD initialization
; 0000 007F // Connections are specified in the
; 0000 0080 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0081 // RS - PORTC Bit 0
; 0000 0082 // RD - PORTC Bit 1
; 0000 0083 // EN - PORTC Bit 2
; 0000 0084 // D4 - PORTC Bit 3
; 0000 0085 // D5 - PORTC Bit 4
; 0000 0086 // D6 - PORTC Bit 5
; 0000 0087 // D7 - PORTC Bit 6
; 0000 0088 // Characters/line: 16
; 0000 0089 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 008A }
; 0000 008B 
; 0000 008C delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 008D //PORTB.2 is sda pin
; 0000 008E     reset_mfrc();
	RCALL _reset_mfrc
; 0000 008F 
; 0000 0090 while (1)
_0x98:
; 0000 0091       {
; 0000 0092           a=rd_serial(serial);
	LDI  R26,LOW(_serial)
	LDI  R27,HIGH(_serial)
	RCALL _rd_serial
	RCALL __BSTB1
	BLD  R2,0
; 0000 0093           //lcd_gotoxy(0,0);
; 0000 0094           sprintf(d,"A:%3d %3d",serial[0],serial[1]);
	LDI  R30,LOW(_d)
	LDI  R31,HIGH(_d)
	RCALL SUBOPT_0x5
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x5
	LDS  R30,_serial
	RCALL SUBOPT_0x13
	__GETB1MN _serial,1
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 0095           puts(d);
; 0000 0096           //lcd_gotoxy(0,1);
; 0000 0097           sprintf(d,"B:%3d %3d",serial[2],serial[3]);
	LDI  R30,LOW(_d)
	LDI  R31,HIGH(_d)
	RCALL SUBOPT_0x5
	__POINTW1FN _0x0,10
	RCALL SUBOPT_0x5
	__GETB1MN _serial,2
	RCALL SUBOPT_0x13
	__GETB1MN _serial,3
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 0098           puts(d);
; 0000 0099           delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 009A 
; 0000 009B       }
	RJMP _0x98
; 0000 009C }
_0x9B:
	RJMP _0x9B
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,6
_0x200000B:
	RCALL SUBOPT_0x15
	SBI  0x15,2
	RCALL SUBOPT_0x15
	CBI  0x15,2
	RCALL SUBOPT_0x15
	RJMP _0x20E0008
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 184
	RJMP _0x20E0008
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x16
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x17
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
	RJMP _0x20E0008
; .FEND
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
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0xF,R30
_0x2020003:
	SBIS 0xE,7
	RJMP _0x2020003
	IN   R30,0xF
	RJMP _0x20E0008
; .FEND
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
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20E0008:
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	RCALL SUBOPT_0x6
	ST   -Y,R17
_0x2040003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2040003
_0x2040005:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x20E0007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_put_buff_G102:
; .FSTART _put_buff_G102
	RCALL SUBOPT_0x6
	RCALL __SAVELOCR2
	RCALL SUBOPT_0xF
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	RCALL SUBOPT_0xF
	ADIW R26,2
	RCALL SUBOPT_0x19
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	RCALL SUBOPT_0xF
	RCALL __GETW1P
	TST  R31
	BRMI _0x2040014
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x19
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	RCALL SUBOPT_0xF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__ftoe_G102:
; .FSTART __ftoe_G102
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2040019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0x5
	__POINTW2FN _0x2040000,0
	RCALL _strcpyf
	RJMP _0x20E0005
_0x2040019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2040018
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x5
	__POINTW2FN _0x2040000,1
	RCALL _strcpyf
	RJMP _0x20E0005
_0x2040018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x204001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x204001B:
	LDD  R17,Y+11
_0x204001C:
	RCALL SUBOPT_0x1C
	BREQ _0x204001E
	RCALL SUBOPT_0x1D
	RJMP _0x204001C
_0x204001E:
	RCALL SUBOPT_0x1E
	RCALL __CPD10
	BRNE _0x204001F
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x1D
	RJMP _0x2040020
_0x204001F:
	LDD  R19,Y+11
	RCALL SUBOPT_0x1F
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2040021
	RCALL SUBOPT_0x1D
_0x2040022:
	RCALL SUBOPT_0x1F
	BRLO _0x2040024
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x2040022
_0x2040024:
	RJMP _0x2040025
_0x2040021:
_0x2040026:
	RCALL SUBOPT_0x1F
	BRSH _0x2040028
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	SUBI R19,LOW(1)
	RJMP _0x2040026
_0x2040028:
	RCALL SUBOPT_0x1D
_0x2040025:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x1F
	BRLO _0x2040029
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
_0x2040029:
_0x2040020:
	LDI  R17,LOW(0)
_0x204002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x204002C
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x20
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x25
	RCALL __MULF12
	RCALL SUBOPT_0x20
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x23
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x204002A
	RCALL SUBOPT_0x27
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x204002A
_0x204002C:
	RCALL SUBOPT_0x29
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x204002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2040113
_0x204002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2040113:
	ST   X,R30
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	RCALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0005:
	RCALL __LOADLOCR4
_0x20E0006:
	ADIW R28,16
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	RCALL SUBOPT_0x6
	SBIW R28,63
	SBIW R28,17
	RCALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	RCALL SUBOPT_0x19
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2040036
	CPI  R18,37
	BRNE _0x2040037
	LDI  R17,LOW(1)
	RJMP _0x2040038
_0x2040037:
	RCALL SUBOPT_0x2B
_0x2040038:
	RJMP _0x2040035
_0x2040036:
	CPI  R30,LOW(0x1)
	BRNE _0x2040039
	CPI  R18,37
	BRNE _0x204003A
	RCALL SUBOPT_0x2B
	RJMP _0x2040114
_0x204003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x204003B
	LDI  R16,LOW(1)
	RJMP _0x2040035
_0x204003B:
	CPI  R18,43
	BRNE _0x204003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003C:
	CPI  R18,32
	BRNE _0x204003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2040035
_0x204003D:
	RJMP _0x204003E
_0x2040039:
	CPI  R30,LOW(0x2)
	BRNE _0x204003F
_0x204003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040040
	ORI  R16,LOW(128)
	RJMP _0x2040035
_0x2040040:
	RJMP _0x2040041
_0x204003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2040042
_0x2040041:
	CPI  R18,48
	BRLO _0x2040044
	CPI  R18,58
	BRLO _0x2040045
_0x2040044:
	RJMP _0x2040043
_0x2040045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2040035
_0x2040043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2040046
	LDI  R17,LOW(4)
	RJMP _0x2040035
_0x2040046:
	RJMP _0x2040047
_0x2040042:
	CPI  R30,LOW(0x4)
	BRNE _0x2040049
	CPI  R18,48
	BRLO _0x204004B
	CPI  R18,58
	BRLO _0x204004C
_0x204004B:
	RJMP _0x204004A
_0x204004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2040035
_0x204004A:
_0x2040047:
	CPI  R18,108
	BRNE _0x204004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2040035
_0x204004D:
	RJMP _0x204004E
_0x2040049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2040035
_0x204004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040053
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2C
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x2E
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x45)
	BREQ _0x2040057
	CPI  R30,LOW(0x65)
	BRNE _0x2040058
_0x2040057:
	RJMP _0x2040059
_0x2040058:
	CPI  R30,LOW(0x66)
	BRNE _0x204005A
_0x2040059:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL __GETD1P
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	LDD  R26,Y+13
	TST  R26
	BRMI _0x204005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x204005D
	CPI  R26,LOW(0x20)
	BREQ _0x204005F
	RJMP _0x2040060
_0x204005B:
	RCALL SUBOPT_0x33
	RCALL __ANEGF1
	RCALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x204005D:
	SBRS R16,7
	RJMP _0x2040061
	LDD  R30,Y+21
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	RJMP _0x2040062
_0x2040061:
_0x204005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	RCALL SUBOPT_0x34
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2040062:
_0x2040060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2040064
	RCALL SUBOPT_0x33
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _ftoa
	RJMP _0x2040065
_0x2040064:
	RCALL SUBOPT_0x33
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G102
_0x2040065:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0xB
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040066
_0x204005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2040068
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0xB
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040069
_0x2040068:
	CPI  R30,LOW(0x70)
	BRNE _0x204006B
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0xB
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x204006D
	CP   R20,R17
	BRLO _0x204006E
_0x204006D:
	RJMP _0x204006C
_0x204006E:
	MOV  R17,R20
_0x204006C:
_0x2040066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x204006F
_0x204006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2040072
	CPI  R30,LOW(0x69)
	BRNE _0x2040073
_0x2040072:
	ORI  R16,LOW(4)
	RJMP _0x2040074
_0x2040073:
	CPI  R30,LOW(0x75)
	BRNE _0x2040075
_0x2040074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2040076
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x36
	LDI  R17,LOW(10)
	RJMP _0x2040077
_0x2040076:
	__GETD1N 0x2710
	RCALL SUBOPT_0x36
	LDI  R17,LOW(5)
	RJMP _0x2040077
_0x2040075:
	CPI  R30,LOW(0x58)
	BRNE _0x2040079
	ORI  R16,LOW(8)
	RJMP _0x204007A
_0x2040079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20400B8
_0x204007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x204007C
	__GETD1N 0x10000000
	RCALL SUBOPT_0x36
	LDI  R17,LOW(8)
	RJMP _0x2040077
_0x204007C:
	__GETD1N 0x1000
	RCALL SUBOPT_0x36
	LDI  R17,LOW(4)
_0x2040077:
	CPI  R20,0
	BREQ _0x204007D
	ANDI R16,LOW(127)
	RJMP _0x204007E
_0x204007D:
	LDI  R20,LOW(1)
_0x204007E:
	SBRS R16,1
	RJMP _0x204007F
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x30
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2040115
_0x204007F:
	SBRS R16,2
	RJMP _0x2040081
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x35
	RCALL __CWD1
	RJMP _0x2040115
_0x2040081:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x35
	CLR  R22
	CLR  R23
_0x2040115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2040083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2040084
	RCALL SUBOPT_0x33
	RCALL __ANEGD1
	RCALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2040084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2040085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2040086
_0x2040085:
	ANDI R16,LOW(251)
_0x2040086:
_0x2040083:
	MOV  R19,R20
_0x204006F:
	SBRC R16,0
	RJMP _0x2040087
_0x2040088:
	CP   R17,R21
	BRSH _0x204008B
	CP   R19,R21
	BRLO _0x204008C
_0x204008B:
	RJMP _0x204008A
_0x204008C:
	SBRS R16,7
	RJMP _0x204008D
	SBRS R16,2
	RJMP _0x204008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x204008F
_0x204008E:
	LDI  R18,LOW(48)
_0x204008F:
	RJMP _0x2040090
_0x204008D:
	LDI  R18,LOW(32)
_0x2040090:
	RCALL SUBOPT_0x2B
	SUBI R21,LOW(1)
	RJMP _0x2040088
_0x204008A:
_0x2040087:
_0x2040091:
	CP   R17,R20
	BRSH _0x2040093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040094
	RCALL SUBOPT_0x37
	BREQ _0x2040095
	SUBI R21,LOW(1)
_0x2040095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x2040096
	SUBI R21,LOW(1)
_0x2040096:
	SUBI R20,LOW(1)
	RJMP _0x2040091
_0x2040093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2040097
_0x2040098:
	CPI  R19,0
	BREQ _0x204009A
	SBRS R16,3
	RJMP _0x204009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	RCALL SUBOPT_0x34
	RJMP _0x204009C
_0x204009B:
	RCALL SUBOPT_0xB
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x204009C:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x204009D
	SUBI R21,LOW(1)
_0x204009D:
	SUBI R19,LOW(1)
	RJMP _0x2040098
_0x204009A:
	RJMP _0x204009E
_0x2040097:
_0x20400A0:
	RCALL SUBOPT_0x38
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20400A2
	SBRS R16,3
	RJMP _0x20400A3
	SUBI R18,-LOW(55)
	RJMP _0x20400A4
_0x20400A3:
	SUBI R18,-LOW(87)
_0x20400A4:
	RJMP _0x20400A5
_0x20400A2:
	SUBI R18,-LOW(48)
_0x20400A5:
	SBRC R16,4
	RJMP _0x20400A7
	CPI  R18,49
	BRSH _0x20400A9
	RCALL SUBOPT_0x39
	__CPD2N 0x1
	BRNE _0x20400A8
_0x20400A9:
	RJMP _0x20400AB
_0x20400A8:
	CP   R20,R19
	BRSH _0x2040116
	CP   R21,R19
	BRLO _0x20400AE
	SBRS R16,0
	RJMP _0x20400AF
_0x20400AE:
	RJMP _0x20400AD
_0x20400AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20400B0
_0x2040116:
	LDI  R18,LOW(48)
_0x20400AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20400B1
	RCALL SUBOPT_0x37
	BREQ _0x20400B2
	SUBI R21,LOW(1)
_0x20400B2:
_0x20400B1:
_0x20400B0:
_0x20400A7:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x20400B3
	SUBI R21,LOW(1)
_0x20400B3:
_0x20400AD:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x38
	RCALL __MODD21U
	RCALL SUBOPT_0x31
	LDD  R30,Y+20
	RCALL SUBOPT_0x39
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x36
	__GETD1S 16
	RCALL __CPD10
	BREQ _0x20400A1
	RJMP _0x20400A0
_0x20400A1:
_0x204009E:
	SBRS R16,0
	RJMP _0x20400B4
_0x20400B5:
	CPI  R21,0
	BREQ _0x20400B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	RJMP _0x20400B5
_0x20400B7:
_0x20400B4:
_0x20400B8:
_0x2040054:
_0x2040114:
	LDI  R17,LOW(0)
_0x2040035:
	RJMP _0x2040030
_0x2040032:
	RCALL SUBOPT_0xA
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x3A
	SBIW R30,0
	BRNE _0x20400B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20E0004
_0x20400B9:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x5
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	RCALL SUBOPT_0x5
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20E0004:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x6
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x6
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
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x6
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
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x3B
	RJMP _0x20E0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x3B
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20E0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20C000D
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x5
	__POINTW2FN _0x20C0000,0
	RCALL _strcpyf
	RJMP _0x20E0002
_0x20C000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20C000C
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x5
	__POINTW2FN _0x20C0000,1
	RCALL _strcpyf
	RJMP _0x20E0002
_0x20C000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20C000F
	RCALL SUBOPT_0x3C
	RCALL __ANEGF1
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
	LDI  R30,LOW(45)
	ST   X,R30
_0x20C000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20C0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20C0010:
	LDD  R17,Y+8
_0x20C0011:
	RCALL SUBOPT_0x1C
	BREQ _0x20C0013
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x40
	RJMP _0x20C0011
_0x20C0013:
	RCALL SUBOPT_0x41
	RCALL __ADDF12
	RCALL SUBOPT_0x3D
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x40
_0x20C0014:
	RCALL SUBOPT_0x41
	RCALL __CMPF12
	BRLO _0x20C0016
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x40
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x20C0017
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x5
	__POINTW2FN _0x20C0000,5
	RCALL _strcpyf
	RJMP _0x20E0002
_0x20C0017:
	RJMP _0x20C0014
_0x20C0016:
	CPI  R17,0
	BRNE _0x20C0018
	RCALL SUBOPT_0x3E
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20C0019
_0x20C0018:
_0x20C001A:
	RCALL SUBOPT_0x1C
	BREQ _0x20C001C
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x41
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x3F
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x42
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x3D
	RJMP _0x20C001A
_0x20C001C:
_0x20C0019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20E0001
	RCALL SUBOPT_0x3E
	LDI  R30,LOW(46)
	ST   X,R30
_0x20C001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20C0020
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3C
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x42
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x3D
	RJMP _0x20C001E
_0x20C0020:
_0x20E0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20E0002:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_serial:
	.BYTE 0x4
_d:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4
__seed_G106:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(0)
	RJMP _WriteRawRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(20)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _ClearBitMask
	LDI  R30,LOW(13)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(12)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R26,LOW(128)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RJMP _WriteRawRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+2
	RCALL _ReadRawRC
	MOV  R17,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDD  R30,Y+2
	ST   -Y,R30
	MOV  R26,R17
	RJMP _WriteRawRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(1)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(_d)
	LDI  R27,HIGH(_d)
	RJMP _puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__DELAY_USB 18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x6
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1D:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1F:
	__GETD1S 4
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x20:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x23:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0x1B
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2B:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2C:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x2D:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x30:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x2C
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x36:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x37:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3D:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0xA
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3F:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x41:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
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
