
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R7
	.DEF _rx_counter=R6

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

__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_st7920_init_4bit_G102:
	.DB  0x30,0x30,0x20,0x0,0x20,0x0
_st7920_base_y_G102:
	.DB  0x80,0x90,0x88,0x98
_tbl10_G104:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G104:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x48,0x49,0x0
_0x2140060:
	.DB  0x1
_0x2140000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _0xD
	.DW  _0x0*2

	.DW  0x01
	.DW  __seed_G10A
	.DW  _0x2140060*2

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
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/29/2021
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
;
;// I2C Bus functions
;#include <i2c.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// 1 Wire Bus interface functions
;#include <1wire.h>
;
;// DS1820 Temperature Sensor functions
;#include <ds1820.h>
;
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
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 24
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0051 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0052 char status,data;
; 0000 0053 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0054 data=UDR;
	IN   R16,12
; 0000 0055 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0056    {
; 0000 0057    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0058 #if RX_BUFFER_SIZE == 256
; 0000 0059    // special case for receiver buffer size=256
; 0000 005A    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 005B #else
; 0000 005C    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(24)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 005D    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R6
	LDI  R30,LOW(24)
	CP   R30,R6
	BRNE _0x5
; 0000 005E       {
; 0000 005F       rx_counter=0;
	CLR  R6
; 0000 0060       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0061       }
; 0000 0062 #endif
; 0000 0063    }
_0x5:
; 0000 0064 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006B {
; 0000 006C char data;
; 0000 006D while (rx_counter==0);
;	data -> R17
; 0000 006E data=rx_buffer[rx_rd_index++];
; 0000 006F #if RX_BUFFER_SIZE != 256
; 0000 0070 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0071 #endif
; 0000 0072 #asm("cli")
; 0000 0073 --rx_counter;
; 0000 0074 #asm("sei")
; 0000 0075 return data;
; 0000 0076 }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;
;void main(void)
; 0000 007F {
_main:
; .FSTART _main
; 0000 0080 // Declare your local variables here
; 0000 0081 // Variable used to store graphic display
; 0000 0082 // controller initialization data
; 0000 0083 GLCDINIT_t glcd_init_data;
; 0000 0084 
; 0000 0085 // Input/Output Ports initialization
; 0000 0086 // Port A initialization
; 0000 0087 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0088 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0089 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 008A PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008B 
; 0000 008C // Port B initialization
; 0000 008D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008E DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 008F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0090 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0091 
; 0000 0092 // Port C initialization
; 0000 0093 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0094 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0095 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0096 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0097 
; 0000 0098 // Port D initialization
; 0000 0099 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 009A DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 009B // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 009C PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 009D 
; 0000 009E // Timer/Counter 0 initialization
; 0000 009F // Clock source: System Clock
; 0000 00A0 // Clock value: Timer 0 Stopped
; 0000 00A1 // Mode: Normal top=0xFF
; 0000 00A2 // OC0 output: Disconnected
; 0000 00A3 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00A4 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A5 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00A6 
; 0000 00A7 // Timer/Counter 1 initialization
; 0000 00A8 // Clock source: System Clock
; 0000 00A9 // Clock value: Timer1 Stopped
; 0000 00AA // Mode: Normal top=0xFFFF
; 0000 00AB // OC1A output: Disconnected
; 0000 00AC // OC1B output: Disconnected
; 0000 00AD // Noise Canceler: Off
; 0000 00AE // Input Capture on Falling Edge
; 0000 00AF // Timer1 Overflow Interrupt: Off
; 0000 00B0 // Input Capture Interrupt: Off
; 0000 00B1 // Compare A Match Interrupt: Off
; 0000 00B2 // Compare B Match Interrupt: Off
; 0000 00B3 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00B4 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00B5 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B6 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B7 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00B8 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00B9 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00BA OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00BB OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00BC OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 2 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: Timer2 Stopped
; 0000 00C1 // Mode: Normal top=0xFF
; 0000 00C2 // OC2 output: Disconnected
; 0000 00C3 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00C4 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00C5 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00C6 OCR2=0x00;
	OUT  0x23,R30
; 0000 00C7 
; 0000 00C8 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C9 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00CA 
; 0000 00CB // External Interrupt(s) initialization
; 0000 00CC // INT0: Off
; 0000 00CD // INT1: Off
; 0000 00CE // INT2: Off
; 0000 00CF MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00D0 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00D1 
; 0000 00D2 // USART initialization
; 0000 00D3 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00D4 // USART Receiver: On
; 0000 00D5 // USART Transmitter: On
; 0000 00D6 // USART Mode: Asynchronous
; 0000 00D7 // USART Baud Rate: 9600
; 0000 00D8 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00D9 UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00DA UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00DB UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00DC UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 00DD 
; 0000 00DE // Analog Comparator initialization
; 0000 00DF // Analog Comparator: Off
; 0000 00E0 // The Analog Comparator's positive input is
; 0000 00E1 // connected to the AIN0 pin
; 0000 00E2 // The Analog Comparator's negative input is
; 0000 00E3 // connected to the AIN1 pin
; 0000 00E4 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E5 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E6 
; 0000 00E7 // ADC initialization
; 0000 00E8 // ADC disabled
; 0000 00E9 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00EA 
; 0000 00EB // SPI initialization
; 0000 00EC // SPI disabled
; 0000 00ED SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00EE 
; 0000 00EF // TWI initialization
; 0000 00F0 // TWI disabled
; 0000 00F1 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00F2 
; 0000 00F3 // Bit-Banged I2C Bus initialization
; 0000 00F4 // I2C Port: PORTC
; 0000 00F5 // I2C SDA bit: 1
; 0000 00F6 // I2C SCL bit: 0
; 0000 00F7 // Bit Rate: 100 kHz
; 0000 00F8 // Note: I2C settings are specified in the
; 0000 00F9 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00FA i2c_init();
	CALL _i2c_init
; 0000 00FB 
; 0000 00FC // DS1307 Real Time Clock initialization
; 0000 00FD // Square wave output on pin SQW/OUT: Off
; 0000 00FE // SQW/OUT pin state: 0
; 0000 00FF rtc_init(0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0100 
; 0000 0101 // 1 Wire Bus initialization
; 0000 0102 // 1 Wire Data port: PORTB
; 0000 0103 // 1 Wire Data bit: 0
; 0000 0104 // Note: 1 Wire port settings are specified in the
; 0000 0105 // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0000 0106 w1_init();
	CALL _w1_init
; 0000 0107 
; 0000 0108 // Determine the number of DS1820 devices
; 0000 0109 // connected to the 1 Wire bus
; 0000 010A ds1820_devices=w1_search(0xf0,ds1820_rom_codes);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_ds1820_rom_codes)
	LDI  R27,HIGH(_ds1820_rom_codes)
	CALL _w1_search
	MOV  R5,R30
; 0000 010B 
; 0000 010C // Graphic Display Controller initialization
; 0000 010D // The ST7920 connections are specified in the
; 0000 010E // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 010F // E - PORTA Bit 0
; 0000 0110 // R /W - PORTA Bit 1
; 0000 0111 // RS - PORTA Bit 2
; 0000 0112 // /RST - PORTA Bit 3
; 0000 0113 // DB4 - PORTA Bit 4
; 0000 0114 // DB5 - PORTA Bit 5
; 0000 0115 // DB6 - PORTA Bit 6
; 0000 0116 // DB7 - PORTA Bit 7
; 0000 0117 
; 0000 0118 // Use the internal character generator
; 0000 0119 // for displaying text
; 0000 011A glcd_init_data.font=NULL;
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
; 0000 011B // No function is used for reading
; 0000 011C // image data from external memory
; 0000 011D glcd_init_data.readxmem=NULL;
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 011E // No function is used for writing
; 0000 011F // image data to external memory
; 0000 0120 glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0121 
; 0000 0122 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0123 
; 0000 0124 // Global enable interrupts
; 0000 0125 #asm("sei")
	sei
; 0000 0126 
; 0000 0127 while (1)
_0xA:
; 0000 0128       {
; 0000 0129       // Place your code here
; 0000 012A         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 012B         lcd_clear();
	RCALL _glcd_cleartext
; 0000 012C          delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 012D         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 012E         lcd_puts("HI");
	__POINTW2MN _0xD,0
	CALL _lcd_puts
; 0000 012F         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0130         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0131       }
	RJMP _0xA
; 0000 0132 }
_0xE:
	RJMP _0xE
; .FEND

	.DSEG
_0xD:
	.BYTE 0x3

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2000003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2000004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2000004:
	CALL _i2c_start
	LDI  R26,LOW(208)
	CALL _i2c_write
	LDI  R26,LOW(7)
	CALL _i2c_write
	LDD  R26,Y+2
	CALL _i2c_write
	CALL _i2c_stop
	JMP  _0x2160004
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
_st7920_delay_G102:
; .FSTART _st7920_delay_G102
    nop
    nop
    nop
	RET
; .FEND
_st7920_wrbus_G102:
; .FSTART _st7920_wrbus_G102
	ST   -Y,R26
	CBI  0x1B,1
	SBI  0x1B,0
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	RCALL _st7920_delay_G102
	CBI  0x1B,0
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x1B,R30
	CALL SUBOPT_0x0
	CBI  0x1B,0
	RJMP _0x2160005
; .FEND
_st7920_rdbus_G102:
; .FSTART _st7920_rdbus_G102
	ST   -Y,R17
	SBI  0x1B,1
	IN   R30,0x1A
	ANDI R30,LOW(0xF)
	OUT  0x1A,R30
	SBI  0x1B,0
	RCALL _st7920_delay_G102
	IN   R30,0x19
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	CBI  0x1B,0
	CALL SUBOPT_0x0
	IN   R30,0x19
	SWAP R30
	ANDI R30,0xF
	OR   R17,R30
	CBI  0x1B,0
	MOV  R30,R17
	RJMP _0x2160006
; .FEND
_st7920_busy_G102:
; .FSTART _st7920_busy_G102
	ST   -Y,R17
	CBI  0x1B,2
	SBI  0x1B,1
	IN   R30,0x1A
	ANDI R30,LOW(0xF)
	OUT  0x1A,R30
_0x2040004:
	SBI  0x1B,0
	RCALL _st7920_delay_G102
	IN   R30,0x19
	ANDI R30,LOW(0x80)
	LDI  R26,LOW(0)
	CALL __NEB12
	MOV  R17,R30
	CBI  0x1B,0
	CALL SUBOPT_0x0
	CBI  0x1B,0
	RCALL _st7920_delay_G102
	CPI  R17,0
	BRNE _0x2040004
	__DELAY_USB 4
_0x2160006:
	LD   R17,Y+
	RET
; .FEND
_st7920_wrdata:
; .FSTART _st7920_wrdata
	ST   -Y,R26
	RCALL _st7920_busy_G102
	SBI  0x1B,2
	LD   R26,Y
	RCALL _st7920_wrbus_G102
	RJMP _0x2160005
; .FEND
_st7920_rddata:
; .FSTART _st7920_rddata
	RCALL _st7920_busy_G102
	SBI  0x1B,2
	RCALL _st7920_rdbus_G102
	RET
; .FEND
_st7920_wrcmd:
; .FSTART _st7920_wrcmd
	ST   -Y,R26
	RCALL _st7920_busy_G102
	LD   R26,Y
	RCALL _st7920_wrbus_G102
	RJMP _0x2160005
; .FEND
_st7920_setxy_G102:
; .FSTART _st7920_setxy_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x1F)
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRLO _0x2040006
	LDD  R30,Y+1
	ORI  R30,0x80
	STD  Y+1,R30
_0x2040006:
	LDD  R30,Y+1
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _st7920_wrcmd
	RJMP _0x2160002
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	CALL SUBOPT_0x1
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2040007
	LDI  R30,LOW(12)
	RJMP _0x2040008
_0x2040007:
	LDI  R30,LOW(8)
_0x2040008:
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LD   R30,Y
	CPI  R30,0
	BREQ _0x204000A
	LDI  R30,LOW(2)
	RJMP _0x204000B
_0x204000A:
	LDI  R30,LOW(0)
_0x204000B:
	STS  _st7920_graphics_on_G102,R30
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	RJMP _0x2160005
; .FEND
_glcd_cleartext:
; .FSTART _glcd_cleartext
	CALL SUBOPT_0x1
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _yt_G102,R30
	STS  _xt_G102,R30
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
	BREQ _0x204000D
	LDI  R19,LOW(255)
_0x204000D:
	CALL SUBOPT_0x2
	LDI  R16,LOW(0)
_0x204000E:
	CPI  R16,64
	BRSH _0x2040010
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R16
	SUBI R16,-1
	RCALL _st7920_setxy_G102
	LDI  R17,LOW(16)
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	MOV  R26,R19
	RCALL _st7920_wrdata
	__DELAY_USB 4
	RJMP _0x2040011
_0x2040013:
	RJMP _0x204000E
_0x2040010:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	SBI  0x1A,0
	CBI  0x1B,0
	SBI  0x1A,1
	SBI  0x1B,1
	SBI  0x1A,2
	CBI  0x1B,2
	SBI  0x1A,3
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,3
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x1B,3
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,1
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	LDI  R17,LOW(0)
_0x2040015:
	CPI  R17,6
	BRSH _0x2040016
	SBI  0x1B,0
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_st7920_init_4bit_G102*2)
	SBCI R31,HIGH(-_st7920_init_4bit_G102*2)
	LPM  R30,Z
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 18
	CBI  0x1B,0
	__DELAY_USW 553
	SUBI R17,-1
	RJMP _0x2040015
_0x2040016:
	LDI  R26,LOW(8)
	RCALL _st7920_wrbus_G102
	__DELAY_USW 553
	LDI  R26,LOW(1)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	STS  _yt_G102,R30
	STS  _xt_G102,R30
	LDI  R26,LOW(6)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(36)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(64)
	RCALL _st7920_wrcmd
	LDI  R26,LOW(2)
	RCALL _st7920_wrcmd
	LDI  R30,LOW(0)
	STS  _st7920_graphics_on_G102,R30
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
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x2040017
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	__PUTW1MN _glcd_state,4
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20400A6
_0x2040017:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,4
	__PUTW1MN _glcd_state,25
_0x20400A6:
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
	RJMP _0x2160003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LDD  R26,Y+1
	CPI  R26,LOW(0x10)
	BRLO _0x204008E
	LDI  R30,LOW(15)
	STD  Y+1,R30
_0x204008E:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRLO _0x204008F
	LDI  R30,LOW(3)
	ST   Y,R30
_0x204008F:
	CALL SUBOPT_0x1
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G102*2)
	SBCI R31,HIGH(-_st7920_base_y_G102*2)
	LPM  R26,Z
	LDD  R30,Y+1
	LSR  R30
	OR   R30,R26
	MOV  R26,R30
	RCALL _st7920_wrcmd
	LDD  R30,Y+1
	STS  _xt_G102,R30
	LD   R30,Y
	STS  _yt_G102,R30
	RJMP _0x2160002
; .FEND
_glcd_putcharcg:
; .FSTART _glcd_putcharcg
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x10)
	BRLO _0x2040090
	LDI  R30,LOW(15)
	STD  Y+4,R30
_0x2040090:
	LDD  R26,Y+3
	CPI  R26,LOW(0x4)
	BRLO _0x2040091
	LDI  R30,LOW(3)
	STD  Y+3,R30
_0x2040091:
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_st7920_base_y_G102*2)
	SBCI R31,HIGH(-_st7920_base_y_G102*2)
	LPM  R26,Z
	LDD  R30,Y+4
	LSR  R30
	OR   R30,R26
	MOV  R17,R30
	CALL SUBOPT_0x1
	MOV  R26,R17
	RCALL _st7920_wrcmd
	RCALL _st7920_rddata
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2040092
	RCALL _st7920_rddata
	MOV  R16,R30
_0x2040092:
	MOV  R26,R17
	RCALL _st7920_wrcmd
	LDD  R30,Y+4
	ANDI R30,LOW(0x1)
	BREQ _0x2040093
	MOV  R26,R16
	RCALL _st7920_wrdata
_0x2040093:
	LDD  R26,Y+2
	RCALL _st7920_wrdata
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2160001
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040098
	LDS  R26,_xt_G102
	CPI  R26,LOW(0x10)
	BRLO _0x2040097
_0x2040098:
	LDI  R30,LOW(0)
	STS  _xt_G102,R30
	LDS  R26,_yt_G102
	SUBI R26,-LOW(1)
	STS  _yt_G102,R26
	CPI  R26,LOW(0x4)
	BRLO _0x204009A
	STS  _yt_G102,R30
_0x204009A:
_0x2040097:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x204009B
	LDS  R30,_xt_G102
	ST   -Y,R30
	LDS  R26,_yt_G102
	RCALL _lcd_gotoxy
	RJMP _0x204009C
_0x204009B:
	LDS  R30,_xt_G102
	SUBI R30,-LOW(1)
	STS  _xt_G102,R30
	SUBI R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_yt_G102
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_putcharcg
_0x204009C:
_0x2160005:
	ADIW R28,1
	RET
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x204009D:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204009F
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x204009D
_0x204009F:
_0x2160003:
	LDD  R17,Y+0
_0x2160004:
	ADIW R28,3
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x3
	BRLT _0x2060003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160002
_0x2060003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2160002
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2160002
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x3
	BRLT _0x2060005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2160002
_0x2060005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2060006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2160002
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2160002
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
_0x2160002:
	ADIW R28,2
	RET
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

	.CSEG

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
_0x2160001:
	ADIW R28,5
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
___ds1820_scratch_pad:
	.BYTE 0x9
_ds1820_rom_codes:
	.BYTE 0x48
_glcd_state:
	.BYTE 0x1D
_rx_buffer:
	.BYTE 0x18
_st7920_graphics_on_G102:
	.BYTE 0x1
_st7920_bits8_15_G102:
	.BYTE 0x1
_xt_G102:
	.BYTE 0x1
_yt_G102:
	.BYTE 0x1
__seed_G10A:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CALL _st7920_delay_G102
	SBI  0x1B,0
	JMP  _st7920_delay_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDS  R30,_st7920_graphics_on_G102
	ORI  R30,0x20
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R30,_st7920_graphics_on_G102
	ORI  R30,LOW(0x24)
	MOV  R26,R30
	JMP  _st7920_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
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

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
