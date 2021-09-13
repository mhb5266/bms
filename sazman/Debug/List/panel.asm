
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	.DEF _ds1820_devices=R5
	.DEF _c=R4
	.DEF __hour=R7
	.DEF __min=R6
	.DEF __sec=R9
	.DEF __wday=R8
	.DEF __year=R11
	.DEF __month=R10
	.DEF __day=R13
	.DEF _lastsec=R12

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
	JMP  _timer1_ovf_isr
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

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x4,0x4,0x4,0x4,0x4
	.DB  0x0,0x4,0xA,0xA,0xA,0x0,0x0,0x0
	.DB  0x0,0xA,0xA,0x1F,0xA,0x1F,0xA,0xA
	.DB  0x4,0x1E,0x5,0xE,0x14,0xF,0x4,0x3
	.DB  0x13,0x8,0x4,0x2,0x19,0x18,0x6,0x9
	.DB  0x5,0x2,0x15,0x9,0x16,0x6,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x8,0x4,0x2,0x2
	.DB  0x2,0x4,0x8,0x2,0x4,0x8,0x8,0x8
	.DB  0x4,0x2,0x0,0xA,0x4,0x1F,0x4,0xA
	.DB  0x0,0x0,0x4,0x4,0x1F,0x4,0x4,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x4,0x2,0x0
	.DB  0x0,0x0,0x1F,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x6,0x6,0x0,0x0,0x10,0x8
	.DB  0x4,0x2,0x1,0x0,0xE,0x11,0x19,0x15
	.DB  0x13,0x11,0xE,0x4,0x6,0x4,0x4,0x4
	.DB  0x4,0xE,0xE,0x11,0x10,0x8,0x4,0x2
	.DB  0x1F,0x1F,0x8,0x4,0x8,0x10,0x11,0xE
	.DB  0x8,0xC,0xA,0x9,0x1F,0x8,0x8,0x1F
	.DB  0x1,0xF,0x10,0x10,0x11,0xE,0xC,0x2
	.DB  0x1,0xF,0x11,0x11,0xE,0x1F,0x10,0x8
	.DB  0x4,0x2,0x2,0x2,0xE,0x11,0x11,0xE
	.DB  0x11,0x11,0xE,0xE,0x11,0x11,0x1E,0x10
	.DB  0x8,0x6,0x0,0x6,0x6,0x0,0x6,0x6
	.DB  0x0,0x0,0x6,0x6,0x0,0x6,0x4,0x2
	.DB  0x10,0x8,0x4,0x2,0x4,0x8,0x10,0x0
	.DB  0x0,0x1F,0x0,0x1F,0x0,0x0,0x1,0x2
	.DB  0x4,0x8,0x4,0x2,0x1,0xE,0x11,0x10
	.DB  0x8,0x4,0x0,0x4,0xE,0x11,0x10,0x16
	.DB  0x15,0x15,0xE,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0xF,0x11,0x11,0xF,0x11,0x11
	.DB  0xF,0xE,0x11,0x1,0x1,0x1,0x11,0xE
	.DB  0x7,0x9,0x11,0x11,0x11,0x9,0x7,0x1F
	.DB  0x1,0x1,0xF,0x1,0x1,0x1F,0x1F,0x1
	.DB  0x1,0x7,0x1,0x1,0x1,0xE,0x11,0x1
	.DB  0x1,0x19,0x11,0xE,0x11,0x11,0x11,0x1F
	.DB  0x11,0x11,0x11,0xE,0x4,0x4,0x4,0x4
	.DB  0x4,0xE,0x1C,0x8,0x8,0x8,0x8,0x9
	.DB  0x6,0x11,0x9,0x5,0x3,0x5,0x9,0x11
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1F,0x11
	.DB  0x1B,0x15,0x11,0x11,0x11,0x11,0x11,0x11
	.DB  0x13,0x15,0x19,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xE,0xF,0x11,0x11,0xF
	.DB  0x1,0x1,0x1,0xE,0x11,0x11,0x11,0x15
	.DB  0x9,0x16,0xF,0x11,0x11,0xF,0x5,0x9
	.DB  0x11,0x1E,0x1,0x1,0xE,0x10,0x10,0xF
	.DB  0x1F,0x4,0x4,0x4,0x4,0x4,0x4,0x11
	.DB  0x11,0x11,0x11,0x11,0x11,0xE,0x11,0x11
	.DB  0x11,0x11,0x11,0xA,0x4,0x11,0x11,0x11
	.DB  0x15,0x15,0x1B,0x11,0x11,0x11,0xA,0x4
	.DB  0xA,0x11,0x11,0x11,0x11,0xA,0x4,0x4
	.DB  0x4,0x4,0x1F,0x10,0x8,0x4,0x2,0x1
	.DB  0x1F,0x1C,0x4,0x4,0x4,0x4,0x4,0x1C
	.DB  0x0,0x1,0x2,0x4,0x8,0x10,0x0,0x7
	.DB  0x4,0x4,0x4,0x4,0x4,0x7,0x4,0xA
	.DB  0x11,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1F,0x2,0x4,0x8,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xE,0x10,0x1E
	.DB  0x11,0x1E,0x1,0x1,0xD,0x13,0x11,0x11
	.DB  0xF,0x0,0x0,0xE,0x1,0x1,0x11,0xE
	.DB  0x10,0x10,0x16,0x19,0x11,0x11,0x1E,0x0
	.DB  0x0,0xE,0x11,0x1F,0x1,0xE,0xC,0x12
	.DB  0x2,0x7,0x2,0x2,0x2,0x0,0x0,0x1E
	.DB  0x11,0x1E,0x10,0xC,0x1,0x1,0xD,0x13
	.DB  0x11,0x11,0x11,0x4,0x0,0x6,0x4,0x4
	.DB  0x4,0xE,0x8,0x0,0xC,0x8,0x8,0x9
	.DB  0x6,0x2,0x2,0x12,0xA,0x6,0xA,0x12
	.DB  0x6,0x4,0x4,0x4,0x4,0x4,0xE,0x0
	.DB  0x0,0xB,0x15,0x15,0x11,0x11,0x0,0x0
	.DB  0xD,0x13,0x11,0x11,0x11,0x0,0x0,0xE
	.DB  0x11,0x11,0x11,0xE,0x0,0x0,0xF,0x11
	.DB  0xF,0x1,0x1,0x0,0x0,0x16,0x19,0x1E
	.DB  0x10,0x10,0x0,0x0,0xD,0x13,0x1,0x1
	.DB  0x1,0x0,0x0,0xE,0x1,0xE,0x10,0xF
	.DB  0x2,0x2,0x7,0x2,0x2,0x12,0xC,0x0
	.DB  0x0,0x11,0x11,0x11,0x19,0x16,0x0,0x0
	.DB  0x11,0x11,0x11,0xA,0x4,0x0,0x0,0x11
	.DB  0x11,0x15,0x15,0xA,0x0,0x0,0x11,0xA
	.DB  0x4,0xA,0x11,0x0,0x0,0x11,0x11,0x1E
	.DB  0x10,0xE,0x0,0x0,0x1F,0x8,0x4,0x2
	.DB  0x1F,0x8,0x4,0x4,0x2,0x4,0x4,0x8
	.DB  0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x2
	.DB  0x4,0x4,0x8,0x4,0x4,0x2,0x2,0x15
	.DB  0x8,0x0,0x0,0x0,0x0,0x1F,0x11,0x11
	.DB  0x11,0x11,0x11,0x1F
_conv_delay_G103:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G103:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G104:
	.DB  0x30,0x30,0x20,0x0,0x20,0x0
_st7920_base_y_G104:
	.DB  0x80,0x90,0x88,0x98

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0001

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0

_0x3:
	.DB  0x53,0x61,0x74,0x0,0x53,0x75,0x6E,0x0
	.DB  0x4D,0x6F,0x6E,0x0,0x54,0x75,0x65,0x0
	.DB  0x57,0x65,0x64,0x0,0x54,0x68,0x75,0x0
	.DB  0x46,0x72,0x69
_0x0:
	.DB  0x25,0x30,0x32,0x64,0x3A,0x25,0x30,0x32
	.DB  0x64,0x3A,0x25,0x30,0x32,0x64,0x0,0x25
	.DB  0x34,0x64,0x2F,0x25,0x30,0x32,0x64,0x2F
	.DB  0x25,0x30,0x32,0x64,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x25,0x30,0x34,0x64,0x2F,0x0,0x25,0x30
	.DB  0x32,0x64,0x2F,0x0,0x25,0x30,0x32,0x64
	.DB  0x3A,0x0,0x61,0x6C,0x6C,0x20,0x73,0x61
	.DB  0x76,0x65,0x64,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2120060:
	.DB  0x1
_0x2120000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x09
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x1B
	.DW  __weekday
	.DW  _0x3*2

	.DW  0x0A
	.DW  _0x57
	.DW  _0x0*2+58

	.DW  0x01
	.DW  __seed_G109
	.DW  _0x2120060*2

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
	OUT  MCUCR,R31
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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/30/2021
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
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
;#define xtal 11059200
;
;// 1 Wire Bus interface functions
;#include <1wire.h>
;#include <stdio.h>
;#include <ds1307.h>
;#include <testfont.c>
;/****************************************************************************
;Font created by the LCD Vision V1.05 font & image editor/converter
;(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Font name: New font
;Fixed font width: 8 pixels
;Font height: 8 pixels
;First character: 0x20
;Last character: 0x7F
;
;Exported font data size:
;772 bytes for displays organized as horizontal rows of bytes
;772 bytes for displays organized as rows of vertical bytes.
;****************************************************************************/
;
;flash unsigned char she[]=
;{
;0x08, /* Fixed font width */
;0x08, /* Font height */
;0x20, /* First character */
;0x60, /* Number of characters in font */
;
;#ifndef _GLCD_DATA_BYTEY_
;/* Font data for displays organized as
;   horizontal rows of bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0x10, 0x28, 0x00, 0x54, 0x7D, 0x05, 0x05, 0x07,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;#else
;/* Font data for displays organized as
;   rows of vertical bytes */
;
;/* Code: 0x20, ASCII Character: ' ' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x21, ASCII Character: '!' */
;0xF0, 0x80, 0xF8, 0x12, 0x19, 0x12, 0x18, 0x00,
;
;/* Code: 0x22, ASCII Character: '"' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x23, ASCII Character: '#' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x24, ASCII Character: '$' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x25, ASCII Character: '%' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x26, ASCII Character: '&' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x27, ASCII Character: ''' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x28, ASCII Character: '(' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x29, ASCII Character: ')' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2A, ASCII Character: '*' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2B, ASCII Character: '+' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2C, ASCII Character: ',' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2D, ASCII Character: '-' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2E, ASCII Character: '.' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x2F, ASCII Character: '/' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x30, ASCII Character: '0' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x31, ASCII Character: '1' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x32, ASCII Character: '2' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x33, ASCII Character: '3' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x34, ASCII Character: '4' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x35, ASCII Character: '5' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x36, ASCII Character: '6' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x37, ASCII Character: '7' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x38, ASCII Character: '8' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x39, ASCII Character: '9' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3A, ASCII Character: ':' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3B, ASCII Character: ';' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3C, ASCII Character: '<' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3D, ASCII Character: '=' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3E, ASCII Character: '>' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x3F, ASCII Character: '?' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x40, ASCII Character: '@' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x41, ASCII Character: 'A' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x42, ASCII Character: 'B' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x43, ASCII Character: 'C' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x44, ASCII Character: 'D' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x45, ASCII Character: 'E' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x46, ASCII Character: 'F' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x47, ASCII Character: 'G' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x48, ASCII Character: 'H' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x49, ASCII Character: 'I' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4A, ASCII Character: 'J' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4B, ASCII Character: 'K' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4C, ASCII Character: 'L' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4D, ASCII Character: 'M' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4E, ASCII Character: 'N' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x4F, ASCII Character: 'O' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x50, ASCII Character: 'P' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x51, ASCII Character: 'Q' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x52, ASCII Character: 'R' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x53, ASCII Character: 'S' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x54, ASCII Character: 'T' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x55, ASCII Character: 'U' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x56, ASCII Character: 'V' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x57, ASCII Character: 'W' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x58, ASCII Character: 'X' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x59, ASCII Character: 'Y' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5A, ASCII Character: 'Z' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5B, ASCII Character: '[' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5C, ASCII Character: '\' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5D, ASCII Character: ']' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5E, ASCII Character: '^' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x5F, ASCII Character: '_' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x60, ASCII Character: '`' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x61, ASCII Character: 'a' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x62, ASCII Character: 'b' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x63, ASCII Character: 'c' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x64, ASCII Character: 'd' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x65, ASCII Character: 'e' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x66, ASCII Character: 'f' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x67, ASCII Character: 'g' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x68, ASCII Character: 'h' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x69, ASCII Character: 'i' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6A, ASCII Character: 'j' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6B, ASCII Character: 'k' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6C, ASCII Character: 'l' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6D, ASCII Character: 'm' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6E, ASCII Character: 'n' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x6F, ASCII Character: 'o' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x70, ASCII Character: 'p' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x71, ASCII Character: 'q' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x72, ASCII Character: 'r' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x73, ASCII Character: 's' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x74, ASCII Character: 't' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x75, ASCII Character: 'u' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x76, ASCII Character: 'v' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x77, ASCII Character: 'w' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x78, ASCII Character: 'x' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x79, ASCII Character: 'y' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7A, ASCII Character: 'z' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7B, ASCII Character: '{' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7C, ASCII Character: '|' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7D, ASCII Character: '}' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7E, ASCII Character: '~' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;/* Code: 0x7F, ASCII Character: '' */
;0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;
;#endif
;};
;
;#include <string.h>
;// DS1820 Temperature Sensor functions
;#include <ds18b20.h>
;//#include <bfreeze.c>
;// maximum number of DS1820 devices
;// connected to the 1 Wire bus
;#define MAX_DS1820 8
;// number of DS1820 devices
;// connected to the 1 Wire bus
;unsigned char ds1820_devices;
;// DS1820 devices ROM code storage area,
;// 9 bytes are used for each device
;// (see the w1_search function description in the help)
;unsigned char ds1820_rom_codes[MAX_DS1820][9];
;
;// Graphic Display functions
;#include <glcd.h>
;#include <delay.h>
;// Font used for displaying text
;// on the graphic display
;#include <font5x7.h>
;
;// Declare your global variables here
;#include <defines.c>
;//float temp=0;
;//char i=0;
;//char a=0;
;//char buffer[16];
;
;char c=1;
;//char j=250;
;char _hour=0;
;char _min=0;
;char _sec=0;
;char _wday,_year,_month,_day;
;int sh_year;
;char _weekday[7][4]={{"Sat"},{"Sun"},{"Mon"},{"Tue"},{"Wed"},{"Thu"},{"Fri"}};

	.DSEG
;char lastsec=0;
;char strsec[12];
;bit a=1;
;
;//#define led1 PORTD.6;
;
;#define led PORTD.6
;#define up PIND.5
;#define down PIND.4
;#define menu PIND.3
;
;typedef unsigned char byte;
;typedef unsigned int  word;
;
;
;
;         bit blank=false;
;         byte selection,j;
;         char str[10];
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 003A {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
; 0000 003B // Reinitialize Timer1 value
; 0000 003C TCNT1H=0x5740 >> 8;
	LDI  R30,LOW(87)
	OUT  0x2D,R30
; 0000 003D TCNT1L=0x5740 & 0xff;
	LDI  R30,LOW(64)
	OUT  0x2C,R30
; 0000 003E // Place your code here
; 0000 003F 
; 0000 0040 }
	LD   R30,Y+
	RETI
; .FEND
;
;
;
;void main(void)
; 0000 0045 {
_main:
; .FSTART _main
; 0000 0046 
; 0000 0047 
; 0000 0048 // Declare your local variables here
; 0000 0049 // Variable used to store graphic display
; 0000 004A // controller initialization data
; 0000 004B GLCDINIT_t glcd_init_data;
; 0000 004C 
; 0000 004D // Input/Output Ports initialization
; 0000 004E // Port A initialization
; 0000 004F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0050 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0051 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0052 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0053 
; 0000 0054 // Port B initialization
; 0000 0055 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0056 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0057 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0058 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0059 
; 0000 005A // Port C initialization
; 0000 005B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 005D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 005E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 005F 
; 0000 0060 // Port D initialization
; 0000 0061 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0062 DDRD=(0<<DDD7) | (1<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(64)
	OUT  0x11,R30
; 0000 0063 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0064 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0065 
; 0000 0066 // Timer/Counter 0 initialization
; 0000 0067 // Clock source: System Clock
; 0000 0068 // Clock value: Timer 0 Stopped
; 0000 0069 // Mode: Normal top=0xFF
; 0000 006A // OC0 output: Disconnected
; 0000 006B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 006C TCNT0=0x00;
	OUT  0x32,R30
; 0000 006D OCR0=0x00;
	OUT  0x3C,R30
; 0000 006E 
; 0000 006F // Timer/Counter 1 initialization
; 0000 0070 // Clock source: System Clock
; 0000 0071 // Clock value: 43.200 kHz
; 0000 0072 // Mode: Normal top=0xFFFF
; 0000 0073 // OC1A output: Disconnected
; 0000 0074 // OC1B output: Disconnected
; 0000 0075 // Noise Canceler: Off
; 0000 0076 // Input Capture on Falling Edge
; 0000 0077 // Timer Period: 1 s
; 0000 0078 // Timer1 Overflow Interrupt: On
; 0000 0079 // Input Capture Interrupt: Off
; 0000 007A // Compare A Match Interrupt: Off
; 0000 007B // Compare B Match Interrupt: Off
; 0000 007C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 007D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 007E TCNT1H=0x57;
	LDI  R30,LOW(87)
	OUT  0x2D,R30
; 0000 007F TCNT1L=0x40;
	LDI  R30,LOW(64)
	OUT  0x2C,R30
; 0000 0080 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0081 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0082 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0083 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0084 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0085 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0086 
; 0000 0087 // Timer/Counter 2 initialization
; 0000 0088 // Clock source: System Clock
; 0000 0089 // Clock value: Timer2 Stopped
; 0000 008A // Mode: Normal top=0xFF
; 0000 008B // OC2 output: Disconnected
; 0000 008C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 008D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 008E TCNT2=0x00;
	OUT  0x24,R30
; 0000 008F OCR2=0x00;
	OUT  0x23,R30
; 0000 0090 
; 0000 0091 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0092 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0093 
; 0000 0094 // External Interrupt(s) initialization
; 0000 0095 // INT0: Off
; 0000 0096 // INT1: Off
; 0000 0097 // INT2: Off
; 0000 0098 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0099 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 009A 
; 0000 009B // USART initialization
; 0000 009C // USART disabled
; 0000 009D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 009E 
; 0000 009F // Analog Comparator initialization
; 0000 00A0 // Analog Comparator: Off
; 0000 00A1 // The Analog Comparator's positive input is
; 0000 00A2 // connected to the AIN0 pin
; 0000 00A3 // The Analog Comparator's negative input is
; 0000 00A4 // connected to the AIN1 pin
; 0000 00A5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A7 
; 0000 00A8 // ADC initialization
; 0000 00A9 // ADC disabled
; 0000 00AA ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00AB 
; 0000 00AC // SPI initialization
; 0000 00AD // SPI disabled
; 0000 00AE SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00AF 
; 0000 00B0 // TWI initialization
; 0000 00B1 // TWI disabled
; 0000 00B2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00B3 
; 0000 00B4 // 1 Wire Bus initialization
; 0000 00B5 // 1 Wire Data port: PORTB
; 0000 00B6 // 1 Wire Data bit: 0
; 0000 00B7 // Note: 1 Wire port settings are specified in the
; 0000 00B8 // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 00B9 w1_init();
	CALL _w1_init
; 0000 00BA 
; 0000 00BB // Determine the number of DS1820 devices
; 0000 00BC // connected to the 1 Wire bus
; 0000 00BD ds1820_devices=w1_search(0xf0,ds1820_rom_codes);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_ds1820_rom_codes)
	LDI  R27,HIGH(_ds1820_rom_codes)
	CALL _w1_search
	MOV  R5,R30
; 0000 00BE 
; 0000 00BF // Graphic Display Controller initialization
; 0000 00C0 // The ST7920 connections are specified in the
; 0000 00C1 // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 00C2 // E - PORTA Bit 0
; 0000 00C3 // R /W - PORTA Bit 1
; 0000 00C4 // RS - PORTA Bit 2
; 0000 00C5 // /RST - PORTA Bit 3
; 0000 00C6 // DB4 - PORTA Bit 4
; 0000 00C7 // DB5 - PORTA Bit 5
; 0000 00C8 // DB6 - PORTA Bit 6
; 0000 00C9 // DB7 - PORTA Bit 7
; 0000 00CA 
; 0000 00CB // Specify the current font for displaying text
; 0000 00CC glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00CD // No function is used for reading
; 0000 00CE // image data from external memory
; 0000 00CF glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 00D0 // No function is used for writing
; 0000 00D1 // image data to external memory
; 0000 00D2 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 00D3 
; 0000 00D4 glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 00D5 
; 0000 00D6 // Global enable interrupts
; 0000 00D7 #asm("sei")
	sei
; 0000 00D8 glcd_cleargraphics();
	CALL _glcd_cleargraphics
; 0000 00D9 rtc_init(0,0,0);
	CALL SUBOPT_0x0
; 0000 00DA //rtc_set_time(13,43,0);
; 0000 00DB //rtc_set_date(2,21,06,00);
; 0000 00DC while (1)
_0x4:
; 0000 00DD {
; 0000 00DE       //glcd_clear();
; 0000 00DF       //delay_ms(1000);
; 0000 00E0       rtc_init(0,0,0);
	CALL SUBOPT_0x0
; 0000 00E1       rtc_get_time(&_hour,&_min,&_sec);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	CALL _rtc_get_time
; 0000 00E2       sprintf(strsec,"%02d:%02d:%02d",_hour,_min,_sec);
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 00E3       //if(PIND.5==0){
; 0000 00E4       lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
; 0000 00E5       lcd_puts(strsec);
; 0000 00E6       rtc_get_date(&_wday,&_day,&_month,&_year);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	CALL _rtc_get_date
; 0000 00E7       _wday--;
	DEC  R8
; 0000 00E8       sh_year=_year+1400;
	CALL SUBOPT_0x7
; 0000 00E9       sprintf(strsec,"%4d/%02d/%02d",sh_year,_month,_day);
	CALL SUBOPT_0x1
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	CALL SUBOPT_0x5
; 0000 00EA       lcd_gotoxy(0,0);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6
; 0000 00EB       lcd_puts(strsec);
; 0000 00EC       //_weekday[]="s";
; 0000 00ED       //if (_sec==2) a^;
; 0000 00EE       //glcd_display(a);
; 0000 00EF       if (_wday>6)_wday=0;
	LDI  R30,LOW(6)
	CP   R30,R8
	BRSH _0x7
	CLR  R8
; 0000 00F0       strcpy(strsec,_weekday[_wday]);
_0x7:
	CALL SUBOPT_0x1
	CALL SUBOPT_0xB
; 0000 00F1       lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6
; 0000 00F2       lcd_puts(strsec);
; 0000 00F3 
; 0000 00F4       if(menu==0){
	SBIC 0x10,3
	RJMP _0x8
; 0000 00F5         selection=0;
	LDI  R30,LOW(0)
	STS  _selection,R30
; 0000 00F6         delay_ms(50);
	CALL SUBOPT_0xC
; 0000 00F7         if(menu==0){
	SBIC 0x10,3
	RJMP _0x9
; 0000 00F8             while(menu==0){
_0xA:
	SBIS 0x10,3
; 0000 00F9             }
	RJMP _0xA
; 0000 00FA 
; 0000 00FB             while(1){
_0xD:
; 0000 00FC                 delay_ms(50);
	CALL SUBOPT_0xC
; 0000 00FD                 j++;
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
; 0000 00FE                 if (j==10){
	LDS  R26,_j
	CPI  R26,LOW(0xA)
	BRNE _0x10
; 0000 00FF                     blank=!blank;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 0100                     j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 0101                 }
; 0000 0102                 strcpyf(str,"          ");
_0x10:
	CALL SUBOPT_0xD
	__POINTW2FN _0x0,29
	CALL _strcpyf
; 0000 0103                 sh_year=1400+_year;
	CALL SUBOPT_0x7
; 0000 0104                 if (selection==1 & blank==0)sprintf(str,"%04d/",sh_year);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	BRNE _0x59
; 0000 0105                 else if(selection==1 & blank==1) strcpyf(str,"    ");
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	BREQ _0x13
	CALL SUBOPT_0xD
	__POINTW2FN _0x0,35
	CALL _strcpyf
; 0000 0106                 else if(selection!=1) sprintf(str,"%04d/",sh_year);
	RJMP _0x14
_0x13:
	LDS  R26,_selection
	CPI  R26,LOW(0x1)
	BREQ _0x15
_0x59:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,40
	CALL SUBOPT_0x8
	CALL SUBOPT_0x11
; 0000 0107                 lcd_gotoxy(0,0);
_0x15:
_0x14:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x12
; 0000 0108                 lcd_puts(str);
; 0000 0109 
; 0000 010A                 if (selection==2 & blank==0)sprintf(str,"%02d/",_month);
	CALL SUBOPT_0x13
	CALL SUBOPT_0xF
	BREQ _0x16
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,46
	RJMP _0x5A
; 0000 010B                 else if(selection==2 & blank==1) strcpyf(str,"  ");
_0x16:
	LDS  R26,_selection
	CALL SUBOPT_0x13
	CALL SUBOPT_0x10
	BREQ _0x18
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
; 0000 010C                 else if(selection!=2) sprintf(str,"%02d",_month);
	RJMP _0x19
_0x18:
	LDS  R26,_selection
	CPI  R26,LOW(0x2)
	BREQ _0x1A
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,10
_0x5A:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
	CALL SUBOPT_0x11
; 0000 010D                 lcd_gotoxy(5,0);
_0x1A:
_0x19:
	LDI  R30,LOW(5)
	CALL SUBOPT_0x12
; 0000 010E                 lcd_puts(str);
; 0000 010F 
; 0000 0110                 if (selection==3 & blank==0)sprintf(str,"%02d",_day);
	CALL SUBOPT_0x15
	CALL SUBOPT_0xF
	BRNE _0x5B
; 0000 0111                 else if(selection==3 & blank==1) strcpyf(str,"  ");
	LDS  R26,_selection
	CALL SUBOPT_0x15
	CALL SUBOPT_0x10
	BREQ _0x1D
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
; 0000 0112                 else if(selection!=3) sprintf(str,"%02d",_day);
	RJMP _0x1E
_0x1D:
	LDS  R26,_selection
	CPI  R26,LOW(0x3)
	BREQ _0x1F
_0x5B:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	CALL SUBOPT_0x16
	CALL SUBOPT_0xA
	CALL SUBOPT_0x11
; 0000 0113                 lcd_gotoxy(8,0);
_0x1F:
_0x1E:
	LDI  R30,LOW(8)
	CALL SUBOPT_0x12
; 0000 0114                 lcd_puts(str);
; 0000 0115 
; 0000 0116                 if (selection==4 & blank==0) strcpy(str,_weekday[_wday]);
	CALL SUBOPT_0x17
	CALL SUBOPT_0xF
	BRNE _0x5C
; 0000 0117                 else if(selection==4 & blank==1) strcpyf(str,"   ");
	LDS  R26,_selection
	CALL SUBOPT_0x17
	CALL SUBOPT_0x10
	BREQ _0x22
	CALL SUBOPT_0xD
	__POINTW2FN _0x0,36
	CALL _strcpyf
; 0000 0118                 else if(selection!=4)strcpy(str,_weekday[_wday]);
	RJMP _0x23
_0x22:
	LDS  R26,_selection
	CPI  R26,LOW(0x4)
	BREQ _0x24
_0x5C:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
; 0000 0119                 lcd_gotoxy(11,0);
_0x24:
_0x23:
	LDI  R30,LOW(11)
	CALL SUBOPT_0x12
; 0000 011A                 lcd_puts(str);
; 0000 011B                 //sprintf(str,"%02d",_wday);
; 0000 011C                 //lcd_gotoxy(11,1);
; 0000 011D                 //lcd_puts(str);
; 0000 011E 
; 0000 011F                 if (selection==5 & blank==0)sprintf(str,"%02d:",_hour);
	CALL SUBOPT_0x18
	CALL SUBOPT_0xF
	BREQ _0x25
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,52
	RJMP _0x5D
; 0000 0120                 else if(selection==5 & blank==1) strcpyf(str,"  ");
_0x25:
	LDS  R26,_selection
	CALL SUBOPT_0x18
	CALL SUBOPT_0x10
	BREQ _0x27
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
; 0000 0121                 else if(selection!=5) sprintf(str,"%02d",_hour);
	RJMP _0x28
_0x27:
	LDS  R26,_selection
	CPI  R26,LOW(0x5)
	BREQ _0x29
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,10
_0x5D:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2
	CALL SUBOPT_0x11
; 0000 0122                 lcd_gotoxy(0,1);
_0x29:
_0x28:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x19
; 0000 0123                 lcd_puts(str);
; 0000 0124 
; 0000 0125                 if (selection==6 & blank==0)sprintf(str,"%02d:",_min);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xF
	BRNE _0x5E
; 0000 0126                 else if(selection==6 & blank==1) strcpyf(str,"  ");
	LDS  R26,_selection
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x10
	BREQ _0x2C
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
; 0000 0127                 else if(selection!=6) sprintf(str,"%02d:",_min);
	RJMP _0x2D
_0x2C:
	LDS  R26,_selection
	CPI  R26,LOW(0x6)
	BREQ _0x2E
_0x5E:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	CALL SUBOPT_0x11
; 0000 0128                 lcd_gotoxy(3,1);
_0x2E:
_0x2D:
	LDI  R30,LOW(3)
	CALL SUBOPT_0x19
; 0000 0129                 lcd_puts(str);
; 0000 012A 
; 0000 012B                 if (selection==7 & blank==0)sprintf(str,"%02d",_sec);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0xF
	BRNE _0x5F
; 0000 012C                 else if(selection==7 & blank==1) strcpyf(str,"  ");
	LDS  R26,_selection
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x10
	BREQ _0x31
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
; 0000 012D                 else if(selection!=7) sprintf(str,"%02d",_sec);
	RJMP _0x32
_0x31:
	LDS  R26,_selection
	CPI  R26,LOW(0x7)
	BREQ _0x33
_0x5F:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	CALL SUBOPT_0x16
	CALL SUBOPT_0x4
	CALL SUBOPT_0x11
; 0000 012E                 lcd_gotoxy(6,1);
_0x33:
_0x32:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 012F                 lcd_puts(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _lcd_puts
; 0000 0130 
; 0000 0131                 if(up==0) {
	SBIC 0x10,5
	RJMP _0x34
; 0000 0132                     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0133                     if(up==0) {
	SBIC 0x10,5
	RJMP _0x35
; 0000 0134                         blank=0;
	CALL SUBOPT_0x1C
; 0000 0135                         j=0;
; 0000 0136                         if(selection==1)_year++;
	BRNE _0x36
	INC  R11
; 0000 0137                         if(selection==2)_month++;
_0x36:
	LDS  R26,_selection
	CPI  R26,LOW(0x2)
	BRNE _0x37
	INC  R10
; 0000 0138                         if(selection==3)_day++;
_0x37:
	LDS  R26,_selection
	CPI  R26,LOW(0x3)
	BRNE _0x38
	INC  R13
; 0000 0139                         if(selection==4)_wday++;
_0x38:
	LDS  R26,_selection
	CPI  R26,LOW(0x4)
	BRNE _0x39
	INC  R8
; 0000 013A                         if(selection==5)_hour++;
_0x39:
	LDS  R26,_selection
	CPI  R26,LOW(0x5)
	BRNE _0x3A
	INC  R7
; 0000 013B                         if(selection==6)_min++;
_0x3A:
	LDS  R26,_selection
	CPI  R26,LOW(0x6)
	BRNE _0x3B
	INC  R6
; 0000 013C                         if(selection==7)_sec++;
_0x3B:
	LDS  R26,_selection
	CPI  R26,LOW(0x7)
	BRNE _0x3C
	INC  R9
; 0000 013D                     }
_0x3C:
; 0000 013E                 }
_0x35:
; 0000 013F 
; 0000 0140                 if(down==0) {
_0x34:
	SBIC 0x10,4
	RJMP _0x3D
; 0000 0141                     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0142                     if(down==0) {
	SBIC 0x10,4
	RJMP _0x3E
; 0000 0143                         blank=0;
	CALL SUBOPT_0x1C
; 0000 0144                         j=0;
; 0000 0145                         if(selection==1) _year--;
	BRNE _0x3F
	DEC  R11
; 0000 0146                         if(selection==2)_month--;
_0x3F:
	LDS  R26,_selection
	CPI  R26,LOW(0x2)
	BRNE _0x40
	DEC  R10
; 0000 0147                         if(selection==3)_day--;
_0x40:
	LDS  R26,_selection
	CPI  R26,LOW(0x3)
	BRNE _0x41
	DEC  R13
; 0000 0148                         if(selection==4)_wday--;
_0x41:
	LDS  R26,_selection
	CPI  R26,LOW(0x4)
	BRNE _0x42
	DEC  R8
; 0000 0149                         if(selection==5)_hour--;
_0x42:
	LDS  R26,_selection
	CPI  R26,LOW(0x5)
	BRNE _0x43
	DEC  R7
; 0000 014A                         if(selection==6)_min--;
_0x43:
	LDS  R26,_selection
	CPI  R26,LOW(0x6)
	BRNE _0x44
	DEC  R6
; 0000 014B                         if(selection==7)_sec--;
_0x44:
	LDS  R26,_selection
	CPI  R26,LOW(0x7)
	BRNE _0x45
	DEC  R9
; 0000 014C                     }
_0x45:
; 0000 014D                 }
_0x3E:
; 0000 014E 
; 0000 014F                 if (_year>99 & _year<101)_year=0;
_0x3D:
	MOV  R26,R11
	LDI  R30,LOW(99)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(101)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x46
	CLR  R11
; 0000 0150                 if (_year>101)_year=99;
_0x46:
	LDI  R30,LOW(101)
	CP   R30,R11
	BRSH _0x47
	LDI  R30,LOW(99)
	MOV  R11,R30
; 0000 0151 
; 0000 0152                 if (_month>12 & _month<14)_month=1;
_0x47:
	MOV  R26,R10
	LDI  R30,LOW(12)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(14)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x48
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0153                 if (_month>14 )_month=12;
_0x48:
	LDI  R30,LOW(14)
	CP   R30,R10
	BRSH _0x49
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 0154 
; 0000 0155                 if (_day>30 & _day<32)_day=0;
_0x49:
	MOV  R26,R13
	LDI  R30,LOW(30)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(32)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x4A
	CLR  R13
; 0000 0156                 if (_day>32)_day=31;
_0x4A:
	LDI  R30,LOW(32)
	CP   R30,R13
	BRSH _0x4B
	LDI  R30,LOW(31)
	MOV  R13,R30
; 0000 0157 
; 0000 0158                 if (_wday>6 & _wday<8) _wday=0;
_0x4B:
	MOV  R26,R8
	LDI  R30,LOW(6)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(8)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x4C
	CLR  R8
; 0000 0159                 if (_wday>8)_wday=6;
_0x4C:
	LDI  R30,LOW(8)
	CP   R30,R8
	BRSH _0x4D
	LDI  R30,LOW(6)
	MOV  R8,R30
; 0000 015A 
; 0000 015B                 if (_hour>23 & _hour<25)_hour=0;
_0x4D:
	MOV  R26,R7
	LDI  R30,LOW(23)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(25)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x4E
	CLR  R7
; 0000 015C                 if (_hour>25)_hour=23;
_0x4E:
	LDI  R30,LOW(25)
	CP   R30,R7
	BRSH _0x4F
	LDI  R30,LOW(23)
	MOV  R7,R30
; 0000 015D 
; 0000 015E                 if (_min>59 & _min<61)_min=0;
_0x4F:
	MOV  R26,R6
	LDI  R30,LOW(59)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(61)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x50
	CLR  R6
; 0000 015F                 if (_min>61)_min=59;
_0x50:
	LDI  R30,LOW(61)
	CP   R30,R6
	BRSH _0x51
	LDI  R30,LOW(59)
	MOV  R6,R30
; 0000 0160 
; 0000 0161                 if (_sec>59 & _sec<61)_sec=0;
_0x51:
	MOV  R26,R9
	LDI  R30,LOW(59)
	CALL __GTB12U
	MOV  R0,R30
	LDI  R30,LOW(61)
	CALL __LTB12U
	AND  R30,R0
	BREQ _0x52
	CLR  R9
; 0000 0162                 if (_sec>61)_sec=59;
_0x52:
	LDI  R30,LOW(61)
	CP   R30,R9
	BRSH _0x53
	LDI  R30,LOW(59)
	MOV  R9,R30
; 0000 0163 
; 0000 0164 
; 0000 0165 
; 0000 0166                 if(menu==0) {
_0x53:
	SBIC 0x10,3
	RJMP _0x54
; 0000 0167                     delay_ms(100);
	CALL SUBOPT_0x1D
; 0000 0168                     if(menu==1) {
	SBIS 0x10,3
	RJMP _0x55
; 0000 0169                         selection++;
	LDS  R30,_selection
	SUBI R30,-LOW(1)
	STS  _selection,R30
; 0000 016A                         if(selection==8){
	LDS  R26,_selection
	CPI  R26,LOW(0x8)
	BRNE _0x56
; 0000 016B                            //rtc_init(0,0,0);
; 0000 016C                            delay_ms(100);
	CALL SUBOPT_0x1D
; 0000 016D                            rtc_set_time(_hour,_min,_sec);
	ST   -Y,R7
	ST   -Y,R6
	MOV  R26,R9
	CALL _rtc_set_time
; 0000 016E                            delay_ms(100);
	CALL SUBOPT_0x1D
; 0000 016F                            rtc_set_date(_wday,_day,_month,_year);
	ST   -Y,R8
	ST   -Y,R13
	ST   -Y,R10
	MOV  R26,R11
	CALL _rtc_set_date
; 0000 0170                            glcd_clear();
	CALL _glcd_clear
; 0000 0171                            lcd_puts("all saved");
	__POINTW2MN _0x57,0
	CALL _lcd_puts
; 0000 0172                            delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0173                            glcd_clear();
	CALL _glcd_clear
; 0000 0174 
; 0000 0175                            break;
	RJMP _0xF
; 0000 0176                         }
; 0000 0177                     }
_0x56:
; 0000 0178                 }
_0x55:
; 0000 0179 
; 0000 017A             }
_0x54:
	RJMP _0xD
_0xF:
; 0000 017B         }
; 0000 017C       }
_0x9:
; 0000 017D 
; 0000 017E 
; 0000 017F   // Place your code here
; 0000 0180       //lcd_clear();
; 0000 0181       //delay_ms(500);
; 0000 0182 
; 0000 0183       /*
; 0000 0184       a=w1_init();
; 0000 0185       if (a>0) {
; 0000 0186       lcd_gotoxy(0,0);
; 0000 0187       lcd_puts("HI Ehsan");
; 0000 0188       lcd_gotoxy(0,1);
; 0000 0189         temp=ds18b20_temperature(0);
; 0000 018A         sprintf(buffer,"Temp=%2.1f%`C",temp,223);
; 0000 018B         lcd_puts(buffer);
; 0000 018C       }
; 0000 018D       delay_ms(500);
; 0000 018E       lcd_clear();
; 0000 018F       lcd_gotoxy(0,0);
; 0000 0190       glcd_putimagef(0,0,bfreeze,0);
; 0000 0191       delay_ms(2000);
; 0000 0192       glcd_putimagef(0,0,bfreeze,3);
; 0000 0193       delay_ms(2000);
; 0000 0194       lcd_clear();*/
; 0000 0195 
; 0000 0196       }
_0x8:
	RJMP _0x4
; 0000 0197 }
_0x58:
	RJMP _0x58
; .FEND

	.DSEG
_0x57:
	.BYTE 0xA
;
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
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x1E
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x1E
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x1F
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x218000A
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x218000A
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001E
	CALL SUBOPT_0x20
	RJMP _0x200001C
_0x200001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x20
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x21
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	CALL SUBOPT_0x20
_0x2000022:
	CALL SUBOPT_0x21
	BRLO _0x2000024
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	CALL SUBOPT_0x21
	BRSH _0x2000028
	CALL SUBOPT_0x22
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	CALL SUBOPT_0x20
_0x2000025:
	__GETD1S 12
	CALL SUBOPT_0x26
	CALL SUBOPT_0x25
	CALL SUBOPT_0x21
	BRLO _0x2000029
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	__GETD2S 4
	CALL SUBOPT_0x27
	CALL SUBOPT_0x26
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	__PUTD1S 4
	CALL SUBOPT_0x22
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x22
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x25
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	CALL SUBOPT_0x28
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	CALL SUBOPT_0x2B
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x2B
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x218000A:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x1E
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	CALL SUBOPT_0x2C
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	CALL SUBOPT_0x2C
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2D
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2F
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x200005A
_0x2000059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x30
	CALL __GETD1P
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	CALL SUBOPT_0x33
	CALL __ANEGF1
	CALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x2F
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	CALL SUBOPT_0x33
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2000065
_0x2000064:
	CALL SUBOPT_0x33
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x34
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x36
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	CALL SUBOPT_0x36
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	CALL SUBOPT_0x36
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	CALL SUBOPT_0x36
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	CALL SUBOPT_0x32
	CALL SUBOPT_0x30
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	CALL __CWD1
	RJMP _0x2000115
_0x2000081:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	CALL SUBOPT_0x33
	CALL __ANEGD1
	CALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	CALL SUBOPT_0x2C
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	CALL SUBOPT_0x37
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x2F
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	CALL SUBOPT_0x38
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	CALL SUBOPT_0x37
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x38
	CALL __MODD21U
	CALL SUBOPT_0x31
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x36
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2F
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x39
	SBIW R30,0
	BRNE _0x20000B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2180009
_0x20000B9:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x39
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2180009:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	CALL SUBOPT_0x3A
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL SUBOPT_0x3B
	JMP  _0x2180005
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x3A
	LDI  R26,LOW(0)
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3F
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
	ADIW R28,6
	RET
; .FEND
_rtc_set_time:
; .FSTART _rtc_set_time
	ST   -Y,R26
	CALL SUBOPT_0x3A
	LDI  R26,LOW(0)
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	CALL SUBOPT_0x3B
	JMP  _0x2180005
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x3A
	LDI  R26,LOW(3)
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x3E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3D
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND
_rtc_set_date:
; .FSTART _rtc_set_date
	ST   -Y,R26
	CALL SUBOPT_0x3A
	LDI  R26,LOW(3)
	CALL _i2c_write
	LDD  R26,Y+3
	CALL SUBOPT_0x42
	CALL SUBOPT_0x41
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3B
	JMP  _0x2180003
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	JMP  _0x2180007
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND
_strlenf:
; .FSTART _strlenf
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
; .FEND

	.CSEG
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
_st7920_delay_G104:
; .FSTART _st7920_delay_G104
    nop
    nop
    nop
	RET
; .FEND
_st7920_wrbus_G104:
; .FSTART _st7920_wrbus_G104
	ST   -Y,R26
	CBI  0x1B,6
	SBI  0x1B,5
	SBI  0x1A,4
	SBI  0x1A,3
	SBI  0x1A,2
	SBI  0x1A,1
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2080003
	SBI  0x1B,4
	RJMP _0x2080004
_0x2080003:
	CBI  0x1B,4
_0x2080004:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2080005
	SBI  0x1B,3
	RJMP _0x2080006
_0x2080005:
	CBI  0x1B,3
_0x2080006:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2080007
	SBI  0x1B,2
	RJMP _0x2080008
_0x2080007:
	CBI  0x1B,2
_0x2080008:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x2080009
	SBI  0x1B,1
	RJMP _0x208000A
_0x2080009:
	CBI  0x1B,1
_0x208000A:
	RCALL _st7920_delay_G104
	CBI  0x1B,5
    nop
    nop
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ _0x208000B
	SBI  0x1B,4
	RJMP _0x208000C
_0x208000B:
	CBI  0x1B,4
_0x208000C:
	LD   R30,Y
	ANDI R30,LOW(0x2)
	BREQ _0x208000D
	SBI  0x1B,3
	RJMP _0x208000E
_0x208000D:
	CBI  0x1B,3
_0x208000E:
	LD   R30,Y
	ANDI R30,LOW(0x4)
	BREQ _0x208000F
	SBI  0x1B,2
	RJMP _0x2080010
_0x208000F:
	CBI  0x1B,2
_0x2080010:
	LD   R30,Y
	ANDI R30,LOW(0x8)
	BREQ _0x2080011
	SBI  0x1B,1
	RJMP _0x2080012
_0x2080011:
	CBI  0x1B,1
_0x2080012:
	CALL SUBOPT_0x43
	CBI  0x1B,5
	RJMP _0x2180006
; .FEND
_st7920_rdbus_G104:
; .FSTART _st7920_rdbus_G104
	ST   -Y,R17
	SBI  0x1B,6
	CBI  0x1A,4
	CBI  0x1A,3
	CBI  0x1A,2
	CBI  0x1A,1
	SBI  0x1B,5
	RCALL _st7920_delay_G104
	LDI  R17,LOW(0)
	SBIC 0x19,4
	LDI  R17,LOW(16)
	SBIC 0x19,3
	ORI  R17,LOW(32)
	SBIC 0x19,2
	ORI  R17,LOW(64)
	SBIC 0x19,1
	ORI  R17,LOW(128)
	CBI  0x1B,5
	CALL SUBOPT_0x43
	SBIC 0x19,4
	ORI  R17,LOW(1)
	SBIC 0x19,3
	ORI  R17,LOW(2)
	SBIC 0x19,2
	ORI  R17,LOW(4)
	SBIC 0x19,1
	ORI  R17,LOW(8)
	CBI  0x1B,5
	MOV  R30,R17
	RJMP _0x2180008
; .FEND
_st7920_busy_G104:
; .FSTART _st7920_busy_G104
	ST   -Y,R17
	CBI  0x1B,7
	SBI  0x1B,6
	CBI  0x1A,4
	CBI  0x1A,3
	CBI  0x1A,2
	CBI  0x1A,1
_0x208001C:
	SBI  0x1B,5
	RCALL _st7920_delay_G104
	IN   R30,0x19
	ANDI R30,LOW(0x2)
	LDI  R26,LOW(0)
	CALL __NEB12
	MOV  R17,R30
	CBI  0x1B,5
	CALL SUBOPT_0x43
	CBI  0x1B,5
	RCALL _st7920_delay_G104
	CPI  R17,0
	BRNE _0x208001C
	__DELAY_USB 4
_0x2180008:
	LD   R17,Y+
	RET
; .FEND
_st7920_wrdata:
; .FSTART _st7920_wrdata
	ST   -Y,R26
	RCALL _st7920_busy_G104
	SBI  0x1B,7
	LD   R26,Y
	RCALL _st7920_wrbus_G104
	RJMP _0x2180006
; .FEND
_st7920_rddata:
; .FSTART _st7920_rddata
	RCALL _st7920_busy_G104
	SBI  0x1B,7
	RCALL _st7920_rdbus_G104
	RET
; .FEND
_st7920_wrcmd:
; .FSTART _st7920_wrcmd
	ST   -Y,R26
	RCALL _st7920_busy_G104
	LD   R26,Y
	RCALL _st7920_wrbus_G104
	RJMP _0x2180006
; .FEND
_st7920_setxy_G104:
; .FSTART _st7920_setxy_G104
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x208001E
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
_0x208001E:
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	RJMP _0x2180004
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	CALL SUBOPT_0x44
	LD   R30,Y
	CPI  R30,0
	BREQ _0x208001F
	LDI  R30,LOW(12)
	RJMP _0x2080020
_0x208001F:
	LDI  R30,LOW(8)
_0x2080020:
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2080022
	LDI  R30,LOW(2)
	RJMP _0x2080023
_0x2080022:
	LDI  R30,LOW(0)
_0x2080023:
	STS  _st7920_graphics_on_G104,R30
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
	RJMP _0x2180006
; .FEND
_glcd_cleartext:
; .FSTART _glcd_cleartext
	CALL SUBOPT_0x44
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _yt_G104,R30
	STS  _xt_G104,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RET
; .FEND
_glcd_cleargraphics:
; .FSTART _glcd_cleargraphics
	CALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2080025
	LDI  R19,LOW(255)
_0x2080025:
	CALL SUBOPT_0x45
	LDI  R16,LOW(0)
_0x2080026:
	CPI  R16,64
	BRSH _0x2080028
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R16
	SUBI R16,-1
	RCALL _st7920_setxy_G104
	LDI  R17,LOW(16)
_0x2080029:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208002B
	MOV  R26,R19
	RCALL _st7920_wrdata
	__DELAY_USB 4
	RJMP _0x2080029
_0x208002B:
	RJMP _0x2080026
_0x2080028:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	JMP  _0x2180003
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL _glcd_cleartext
	RCALL _glcd_cleargraphics
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	SBI  0x1A,5
	CBI  0x1B,5
	SBI  0x1A,6
	SBI  0x1B,6
	SBI  0x1A,7
	CBI  0x1B,7
	SBI  0x1A,0
	CALL SUBOPT_0xC
	CBI  0x1B,0
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x1B,0
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,6
	SBI  0x1A,4
	SBI  0x1A,3
	SBI  0x1A,2
	SBI  0x1A,1
	LDI  R17,LOW(0)
_0x208002D:
	CPI  R17,6
	BRSH _0x208002E
	SBI  0x1B,5
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_st7920_init_4bit_G104*2)
	SBCI R31,HIGH(-_st7920_init_4bit_G104*2)
	LPM  R16,Z
	SBRS R16,4
	RJMP _0x208002F
	SBI  0x1B,4
	RJMP _0x2080030
_0x208002F:
	CBI  0x1B,4
_0x2080030:
	SBRS R16,5
	RJMP _0x2080031
	SBI  0x1B,3
	RJMP _0x2080032
_0x2080031:
	CBI  0x1B,3
_0x2080032:
	SBRS R16,6
	RJMP _0x2080033
	SBI  0x1B,2
	RJMP _0x2080034
_0x2080033:
	CBI  0x1B,2
_0x2080034:
	SBRS R16,7
	RJMP _0x2080035
	SBI  0x1B,1
	RJMP _0x2080036
_0x2080035:
	CBI  0x1B,1
_0x2080036:
	__DELAY_USB 18
	CBI  0x1B,5
	__DELAY_USW 553
	SUBI R17,-1
	RJMP _0x208002D
_0x208002E:
	LDI  R26,LOW(8)
	RCALL _st7920_wrbus_G104
	__DELAY_USW 553
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _yt_G104,R30
	STS  _xt_G104,R30
	LDI  R26,LOW(6)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(36)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(64)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(2)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _st7920_graphics_on_G104,R30
	RCALL _glcd_cleargraphics
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x2080037
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20800C6
_0x2080037:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20800C6:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	LDI  R30,LOW(1)
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2180003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x10)
	BRLO _0x20800AE
	LDI  R30,LOW(15)
	STD  Y+1,R30
_0x20800AE:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRLO _0x20800AF
	LDI  R30,LOW(3)
	ST   Y,R30
_0x20800AF:
	CALL SUBOPT_0x44
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G104*2)
	SBCI R31,HIGH(-_st7920_base_y_G104*2)
	LPM  R26,Z
	LDD  R30,Y+1
	LSR  R30
	OR   R30,R26
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LDD  R30,Y+1
	STS  _xt_G104,R30
	LD   R30,Y
	STS  _yt_G104,R30
	RJMP _0x2180004
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRLO _0x20800B0
	LDI  R30,LOW(15)
	STD  Y+4,R30
_0x20800B0:
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRLO _0x20800B1
	LDI  R30,LOW(3)
	STD  Y+3,R30
_0x20800B1:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G104*2)
	SBCI R31,HIGH(-_st7920_base_y_G104*2)
	LPM  R26,Z
	LDD  R30,Y+4
	LSR  R30
	OR   R30,R26
	MOV  R17,R30
	CALL SUBOPT_0x44
	MOV  R26,R17
	RCALL _st7920_wrcmd
	RCALL _st7920_rddata
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x20800B2
	RCALL _st7920_rddata
	MOV  R16,R30
_0x20800B2:
	MOV  R26,R17
	RCALL _st7920_wrcmd
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x20800B3
	MOV  R26,R16
	RCALL _st7920_wrdata
_0x20800B3:
	LDD  R26,Y+2
	RCALL _st7920_wrdata
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2180007:
	ADIW R28,5
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x20800B8
	LDS  R26,_xt_G104
	CPI  R26,LOW(0x10)
	BRLO _0x20800B7
_0x20800B8:
	LDI  R30,LOW(0)
	STS  _xt_G104,R30
	LDS  R26,_yt_G104
	SUBI R26,-LOW(1)
	STS  _yt_G104,R26
	CPI  R26,LOW(0x4)
	BRLO _0x20800BA
	STS  _yt_G104,R30
_0x20800BA:
_0x20800B7:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x20800BB
	LDS  R30,_xt_G104
	ST   -Y,R30
	LDS  R26,_yt_G104
	RCALL _lcd_gotoxy
	RJMP _0x20800BC
_0x20800BB:
	LDS  R30,_xt_G104
	SUBI R30,-LOW(1)
	STS  _xt_G104,R30
	SUBI R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_yt_G104
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_putcharcg
_0x20800BC:
_0x2180006:
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x20800BD:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x20800BF
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x20800BD
_0x20800BF:
	LDD  R17,Y+0
_0x2180005:
	ADIW R28,3
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x46
	BRLT _0x20A0003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2180004
_0x20A0003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x20A0004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2180004
_0x20A0004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180004
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x46
	BRLT _0x20A0005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2180004
_0x20A0005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x20A0006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2180004
_0x20A0006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180004
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
_0x2180004:
	ADIW R28,2
	RET
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
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
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x2180003
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x2180003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	CALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x212000D
	CALL SUBOPT_0x47
	__POINTW2FN _0x2120000,0
	CALL _strcpyf
	RJMP _0x2180002
_0x212000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x212000C
	CALL SUBOPT_0x47
	__POINTW2FN _0x2120000,1
	CALL _strcpyf
	RJMP _0x2180002
_0x212000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x212000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x48
	CALL SUBOPT_0x49
	LDI  R30,LOW(45)
	ST   X,R30
_0x212000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2120010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2120010:
	LDD  R17,Y+8
_0x2120011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2120013
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4B
	RJMP _0x2120011
_0x2120013:
	CALL SUBOPT_0x4C
	CALL __ADDF12
	CALL SUBOPT_0x48
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x4B
_0x2120014:
	CALL SUBOPT_0x4C
	CALL __CMPF12
	BRLO _0x2120016
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x24
	CALL SUBOPT_0x4B
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2120017
	CALL SUBOPT_0x47
	__POINTW2FN _0x2120000,5
	CALL _strcpyf
	RJMP _0x2180002
_0x2120017:
	RJMP _0x2120014
_0x2120016:
	CPI  R17,0
	BRNE _0x2120018
	CALL SUBOPT_0x49
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2120019
_0x2120018:
_0x212001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x212001C
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x27
	CALL SUBOPT_0x26
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x29
	LDI  R31,0
	CALL SUBOPT_0x4A
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x48
	RJMP _0x212001A
_0x212001C:
_0x2120019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x2180001
	CALL SUBOPT_0x49
	LDI  R30,LOW(46)
	ST   X,R30
_0x212001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2120020
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x24
	CALL SUBOPT_0x48
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x29
	LDI  R31,0
	CALL SUBOPT_0x4D
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x48
	RJMP _0x212001E
_0x2120020:
_0x2180001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2180002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND
_bin2bcd:
; .FSTART _bin2bcd
	ST   -Y,R26
    ld   r26,y+
    clr  r30
bin2bcd0:
    subi r26,10
    brmi bin2bcd1
    subi r30,-16
    rjmp bin2bcd0
bin2bcd1:
    subi r26,-10
    add  r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_ds1820_rom_codes:
	.BYTE 0x48
_glcd_state:
	.BYTE 0x1D
_sh_year:
	.BYTE 0x2
__weekday:
	.BYTE 0x1C
_strsec:
	.BYTE 0xC
_selection:
	.BYTE 0x1
_j:
	.BYTE 0x1
_str:
	.BYTE 0xA
_st7920_graphics_on_G104:
	.BYTE 0x1
_st7920_bits8_15_G104:
	.BYTE 0x1
_xt_G104:
	.BYTE 0x1
_yt_G104:
	.BYTE 0x1
__seed_G109:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _rtc_init

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_strsec)
	LDI  R31,HIGH(_strsec)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R30,R6
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	CALL _lcd_gotoxy
	LDI  R26,LOW(_strsec)
	LDI  R27,HIGH(_strsec)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-1400)
	SBCI R31,HIGH(-1400)
	STS  _sh_year,R30
	STS  _sh_year+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_sh_year
	LDS  R31,_sh_year+1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	MOV  R30,R8
	LDI  R26,LOW(__weekday)
	LDI  R27,HIGH(__weekday)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	JMP  _strcpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDS  R26,_selection
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _lcd_puts
	LDS  R26,_selection
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(2)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	__POINTW2FN _0x0,37
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(3)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,10
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(4)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(5)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _lcd_puts
	LDS  R26,_selection
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(6)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(7)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
	STS  _j,R30
	LDS  R26,_selection
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x20:
	__GETD2S 4
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x21:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2C:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2D:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x30:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x2D
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x30
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	CALL _i2c_write
	LD   R26,Y
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _bin2bcd
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	CALL _st7920_delay_G104
	SBI  0x1B,5
	JMP  _st7920_delay_G104

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	LDS  R30,_st7920_graphics_on_G104
	ORI  R30,0x20
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDS  R30,_st7920_graphics_on_G104
	ORI  R30,LOW(0x24)
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x49:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	__GETD2S 9
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x15 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

	.equ __w1_port=0x18
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x52F
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x34
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USW 0xD2
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x436
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x7
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x29
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USW 0xDD
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x7
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x30
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USW 0xCF
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x12
	set
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
