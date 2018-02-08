
;CodeVisionAVR C Compiler V1.24.8d Professional
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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

	.CSEG
	.ORG 0

	.INCLUDE "distance meter..vec"
	.INCLUDE "distance meter..inc"

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 #include <mega8.h>
;       2 #include <delay.h>
;       3 
;       4 #define add 0x78;
;       5 #define TWINT   7
;       6 
;       7 
;       8 
;       9 void com_write(unsigned int com); //com_write , com_tx
;      10 void data_write(unsigned int data); 
;      11 void bit_draw(flash unsigned char *ch); //bit_draw
;      12 void draw_font_10x16(int x, int y, int ch); //font_10x16
;      13 void draw_font_28x32(int x, int ch); //font_28x32
;      14 void oled_init(void);
;      15 void oled_clear(void); //oled_clear
;      16 void draw_dot(int x); //
;      17 
;      18 unsigned int distance = 0,edge_mode = 0, avg_cnt = 0, sum = 0; //distance, edge_mode, avg_cnt, sum
;      19 unsigned int digit_1, digit_10, digit_100, digit_1000; //digit_1,digit_10,digit_100,digit_1000
_digit_10:
	.BYTE 0x2
_digit_100:
	.BYTE 0x2
_digit_1000:
	.BYTE 0x2
;      20 
;      21 flash unsigned char gretting_screen [] = {        //gretting_screen, init_screen (distance mesurer) 128x32

	.CSEG
;      22     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x04, 0x04, 0xFC, 0xFC, 0x04,
;      23     0x04, 0x04, 0x04, 0x0C, 0x18, 0xF0, 0xF0, 0xC0, 0x00, 0x04, 0x04, 0x04, 0xFC, 0xFC, 0x04, 0x00,
;      24     0x00, 0x20, 0x78, 0xCC, 0x84, 0x84, 0x84, 0x84, 0x0C, 0x1C, 0x1C, 0x20, 0x00, 0x18, 0x0C, 0x0C,
;      25     0x04, 0x04, 0xFC, 0xFC, 0xFC, 0x04, 0x04, 0x04, 0x1C, 0x1C, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00,
;      26     0xE0, 0x3C, 0x3C, 0x3C, 0xF8, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x04, 0xFC, 0x1C, 0x70,
;      27     0xE0, 0xE0, 0x80, 0x00, 0x04, 0xFC, 0xFC, 0xFC, 0x04, 0x00, 0xE0, 0xE0, 0xF8, 0x0C, 0x04, 0x04,
;      28     0x04, 0x04, 0x0C, 0x1C, 0x38, 0x38, 0x00, 0x04, 0x04, 0xFC, 0xFC, 0x84, 0x84, 0x84, 0xE4, 0xE4,
;      29     0x0C, 0x1C, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;      30     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x3F, 0x3F, 0x20,
;      31     0x20, 0x20, 0x20, 0x30, 0x18, 0x0F, 0x0F, 0x03, 0x00, 0x20, 0x20, 0x20, 0x3F, 0x2F, 0x20, 0x00,
;      32     0x00, 0x18, 0x30, 0x20, 0x21, 0x21, 0x61, 0x61, 0x23, 0x3F, 0x3F, 0x0C, 0x00, 0x00, 0x00, 0x00,
;      33     0x00, 0x20, 0x2F, 0x3F, 0x3F, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x38, 0x38, 0x2F,
;      34     0x23, 0x02, 0x02, 0x02, 0x23, 0x2F, 0x3E, 0x3E, 0x30, 0x20, 0x00, 0x20, 0x20, 0x3F, 0x20, 0x20,
;      35     0x00, 0x00, 0x03, 0x07, 0x0C, 0x3F, 0x3F, 0x3F, 0x00, 0x00, 0x0F, 0x0F, 0x1F, 0x38, 0x20, 0x60,
;      36     0x60, 0x60, 0x20, 0x30, 0x1C, 0x1C, 0x04, 0x20, 0x20, 0x3F, 0x3F, 0x21, 0x21, 0x21, 0x27, 0x27,
;      37     0x20, 0x38, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;      38     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x04, 0x04, 0xFC, 0x3C, 0xE0, 0xE0, 0x80, 0x00, 0x00,
;      39     0x00, 0x00, 0xE0, 0x3C, 0xFC, 0xFC, 0xFC, 0x04, 0x00, 0x04, 0xFC, 0xFC, 0xFC, 0x84, 0x84, 0x84,
;      40     0x84, 0xCC, 0x1C, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0xF0, 0x1C, 0x7C, 0xF0, 0xF0,
;      41     0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0xF8, 0xCC, 0xCC, 0x84, 0x84, 0x0C, 0x1C, 0x1C, 0x38,
;      42     0x00, 0x04, 0x04, 0x04, 0xFC, 0xFC, 0x04, 0x04, 0x00, 0x00, 0x04, 0x04, 0x04, 0xFC, 0x04, 0x04,
;      43     0x04, 0x04, 0x04, 0xFC, 0x6C, 0x04, 0x04, 0x04, 0x8C, 0xF8, 0xF8, 0xF8, 0x00, 0x00, 0x04, 0xFC,
;      44     0xFC, 0xFC, 0x84, 0x84, 0x84, 0x84, 0xCC, 0x0C, 0x38, 0x00, 0x00, 0x00, 0x04, 0xFC, 0xFC, 0xFC,
;      45     0x04, 0x04, 0x04, 0x8C, 0x8C, 0xF8, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;      46     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x60, 0x60, 0x3F, 0x60, 0x01, 0x01, 0x0F, 0x7C, 0x3C,
;      47     0x07, 0x07, 0x61, 0x60, 0x3F, 0x3F, 0x3F, 0x60, 0x00, 0x60, 0x3F, 0x3F, 0x3F, 0x61, 0x61, 0x61,
;      48     0x61, 0x27, 0x30, 0x38, 0x08, 0x08, 0x60, 0x60, 0x3C, 0x67, 0x67, 0x22, 0x02, 0x02, 0x63, 0x63,
;      49     0x6F, 0x3C, 0x60, 0x60, 0x60, 0x00, 0x38, 0x30, 0x20, 0x20, 0x61, 0x61, 0x61, 0x37, 0x37, 0x1E,
;      50     0x00, 0x00, 0x00, 0x00, 0x1F, 0x3F, 0x20, 0x20, 0x60, 0x60, 0x60, 0x30, 0x30, 0x1F, 0x00, 0x00,
;      51     0x60, 0x60, 0x60, 0x3F, 0x6D, 0x61, 0x61, 0x03, 0x0F, 0x38, 0x30, 0x30, 0x60, 0x00, 0x60, 0x3F,
;      52     0x3F, 0x3F, 0x61, 0x61, 0x61, 0x61, 0x27, 0x30, 0x38, 0x08, 0x08, 0x00, 0x60, 0x3F, 0x3F, 0x3F,
;      53     0x61, 0x03, 0x0F, 0x1C, 0x1C, 0x30, 0x60, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
;      54 };
;      55 
;      56 
;      57 
;      58 // 10x16 폰트 배열
;      59 flash unsigned char font_10x16 [12][20] = {   //font_10x16
;      60     //0
;      61     {0x00, 0xC0, 0xE0, 0xF0, 0xF0, 0x38, 0x18, 0x88, 0xF8, 0xF0, 0x0F, 0x1F, 0x1F, 0x13, 0x18, 0x0C, 0x06, 0x03, 0x01, 0x00},
;      62     //1
;      63     {0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0XF8, 0X38, 0X18, 0x02, 0x12, 0x1B, 0x1D, 0x1F, 0x0F, 0x03, 0x00, 0x00, 0x00},
;      64     //2
;      65     {0x00, 0x00, 0xE0, 0xF0, 0xF0, 0x38, 0x88, 0xF8, 0xF8, 0x70, 0x10, 0x18, 0x0C, 0x1E, 0x1E, 0x1B, 0x19, 0x18, 0x08, 0x00},
;      66     //3
;      67     {0x00, 0x00, 0x00, 0x70, 0x70, 0xB8, 0x88, 0xC8, 0x78 ,0x78, 0x0E, 0x1E, 0x16, 0x10, 0x18, 0x1C, 0x1F, 0x0F, 0x07, 0x00},
;      68     //4
;      69     {0x00, 0x00, 0x00, 0xC0, 0xE0, 0x78, 0x38, 0x98, 0xC8, 0x40, 0x04, 0x06, 0x13, 0x1F, 0x1C, 0x1E, 0x0F, 0x05, 0x04, 0x00},
;      70     //5
;      71     {0x00, 0x00, 0x00, 0xC0, 0xF0, 0xB8, 0x98, 0x98, 0x18, 0x08, 0x0C, 0x1C, 0x14, 0x10, 0x18, 0x1C, 0x1F, 0x0F, 0x07, 0x00},
;      72     //6
;      73     {0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF0, 0x98, 0x88, 0x38, 0x38, 0x00, 0x0F, 0x1F, 0x1F, 0x13, 0x1D, 0x1F, 0x0F, 0x07, 0x00},
;      74     //7
;      75     {0x00, 0x00, 0x00, 0x20, 0x38, 0x98, 0xD0, 0xF0, 0x30, 0x18, 0x00, 0x00, 0x38, 0x3E, 0x3F, 0x07, 0x01, 0x00, 0x00, 0x00},
;      76     //8
;      77     {0x00, 0x00, 0x00, 0x70, 0xF0, 0xF8, 0xC8, 0xF8, 0x78, 0x30, 0x0E, 0x1F, 0x1F, 0x11, 0x11, 0x11, 0x1F, 0x0F, 0x07, 0x00},
;      78     //9
;      79     {0x00, 0x00, 0xE0, 0xF0, 0xF8, 0x38, 0xC8, 0xF8, 0xF8, 0xF0, 0x0C, 0x1C, 0x1C, 0x11, 0x19, 0x0D, 0x0F, 0x07, 0x03, 0x00},
;      80     //c
;      81     {0x00, 0x00, 0x80, 0xC0, 0x60, 0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x0F, 0x1F, 0x30, 0x20, 0x20, 0x20, 0x20, 0x00},
;      82     //m
;      83     {0xC0, 0xC0, 0x40, 0x40, 0x80, 0x80, 0x40, 0x40, 0xC0, 0x80, 0x3F, 0x3F, 0x00, 0x00, 0x3F, 0x3F, 0x00, 0x00, 0x3F, 0x3F}
;      84 };
;      85 
;      86 
;      87 
;      88 //28x32 폰트 배열
;      89 flash unsigned char font_28x32 [10][112] = {    //font_28x32
;      90     //0
;      91     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0, 0xF0, 0x70, 0x38, 0x18, 0x18, 0x18, 0x18,
;      92     0x38, 0x70, 0xF0, 0xE0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;      93     0x00, 0xF0, 0xFF, 0xFF, 0x0F, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x0F,
;      94     0xFF, 0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1F, 0xFF, 0xFF,
;      95     0xE0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0xFF, 0xFF, 0x1F, 0x00,
;      96     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x0F, 0x1F, 0x1C, 0x38,
;      97     0x20, 0x30, 0x30, 0x20, 0x38, 0x1C, 0x1F, 0x0F, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;      98     //1
;      99     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0xC0, 0xC0, 0xF8, 0xF8,
;     100     0xF8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     101     0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00,
;     102     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     103     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     104     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     105     0x00, 0x00, 0x3F, 0x3F, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     106     //2
;     107     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0x70, 0x38, 0x18, 0x18, 0x18, 0x18,
;     108     0x18, 0x38, 0x70, 0xF0, 0xE0, 0xC0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     109     0x00, 0x00, 0x0F, 0x0F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0,
;     110     0xFF, 0x7F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0,
;     111     0xE0, 0xF0, 0x70, 0x38, 0x1C, 0x0C, 0x06, 0x06, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
;     112     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x3F, 0x3F, 0x23, 0x30, 0x30, 0x30,
;     113     0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00},
;     114     //3
;     115     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0x18, 0x38, 0x08, 0x08, 0x08, 0x08,
;     116     0x38, 0x18, 0xF0, 0xE0, 0xC0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     117     0x00, 0x00, 0x07, 0x07, 0x07, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0x80, 0xC0, 0xC0, 0xF0, 0x7F,
;     118     0x3F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0xE0, 0xE0,
;     119     0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x03, 0x07, 0x0F, 0xFE, 0xFC, 0xF8, 0x00,
;     120     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x1E, 0x1C, 0x30, 0x38,
;     121     0x20, 0x20, 0x20, 0x20, 0x38, 0x30, 0x1C, 0x1E, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00},
;     122     //4
;     123     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0,
;     124     0xF0, 0xF8, 0xF8, 0xF8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     125     0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0, 0xF0, 0x7C, 0x3E, 0x0F, 0x07, 0x03, 0xFF, 0xFF, 0xFF,
;     126     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0xF0, 0xFC,
;     127     0x9F, 0xCF, 0xC3, 0xC1, 0xC0, 0xC0, 0xC0, 0xC0, 0x80, 0xFF, 0xFF, 0xFF, 0x80, 0xC0, 0xC0, 0xC0,
;     128     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     129     0x00, 0x00, 0x00, 0x00, 0x00, 0x3F, 0x3F, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     130     //5
;     131     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xF8, 0xF8, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18,
;     132     0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     133     0x00, 0x00, 0xF0, 0xFF, 0xFF, 0xE7, 0x70, 0x70, 0x30, 0x30, 0x30, 0x30, 0x70, 0x70, 0xE0, 0xC0,
;     134     0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01,
;     135     0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0xFF, 0xFF, 0xFC, 0x00,
;     136     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x0F, 0x1F, 0x1C, 0x30, 0x38, 0x20,
;     137     0x20, 0x20, 0x20, 0x20, 0x38, 0x18, 0x1C, 0x1F, 0x0F, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     138     //6
;     139     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xE0, 0xF0, 0x70, 0x38, 0x38, 0x18, 0x18, 0x18,
;     140     0x38, 0x38, 0xF0, 0xF0, 0xE0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     141     0x00, 0xF0, 0xFE, 0xFF, 0x8F, 0xC1, 0xC0, 0xE0, 0x60, 0x60, 0x60, 0x60, 0x60, 0xE0, 0xC0, 0xC3,
;     142     0x83, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF,
;     143     0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0xFF, 0xFF, 0xFC, 0x00,
;     144     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0F, 0x1F, 0x1C, 0x30, 0x38,
;     145     0x20, 0x20, 0x20, 0x20, 0x30, 0x30, 0x18, 0x1E, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00},
;     146     //7
;     147     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18,
;     148     0x18, 0x98, 0xC8, 0xF8, 0xF8, 0x78, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     149     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xF0, 0xFC, 0x7F, 0x1F, 0x07, 0x01,
;     150     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     151     0x00, 0x00, 0xC0, 0xF8, 0xFF, 0x7F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     152     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x3F, 0x3F,
;     153     0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     154     //8
;     155     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF0, 0x70, 0x38, 0x18, 0x18, 0x18, 0x18,
;     156     0x18, 0x38, 0x70, 0xF0, 0xE0, 0xC0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     157     0x00, 0x00, 0x1F, 0x3F, 0x7F, 0xF0, 0xE0, 0xC0, 0x80, 0x80, 0x80, 0x80, 0x80, 0xC0, 0xE0, 0xF0,
;     158     0x7F, 0x3F, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xFC, 0xFE,
;     159     0x0F, 0x07, 0x03, 0x03, 0x01, 0x01, 0x01, 0x01, 0x03, 0x03, 0x07, 0x0F, 0xFF, 0xFE, 0xFC, 0x00,
;     160     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x07, 0x0F, 0x1E, 0x1C, 0x30, 0x38,
;     161     0x20, 0x20, 0x20, 0x20, 0x38, 0x30, 0x18, 0x1C, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00},
;     162     //9
;     163     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0x70, 0x38, 0x38, 0x18, 0x18, 0x18, 0x18,
;     164     0x38, 0x38, 0x70, 0xF0, 0xE0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
;     165     0x00, 0x7F, 0xFF, 0xFF, 0x81, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC1,
;     166     0xDD, 0xFF, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03,
;     167     0x07, 0x07, 0x0E, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0E, 0x06, 0x07, 0xE3, 0xFB, 0xFF, 0x1F, 0x00,
;     168     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0x0F, 0x1F, 0x1C, 0x38, 0x20,
;     169     0x20, 0x20, 0x20, 0x20, 0x38, 0x1C, 0x1E, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
;     170 };
;     171 
;     172 
;     173 // 16*32 (:)폰트 배열
;     174 flash unsigned char dot_font [4][16] = {     //dot_font
;     175     {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     176     {0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x07, 0x07, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     177     {0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xC0, 0xC0, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
;     178     {0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x03, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00}
;     179 };
;     180 
;     181 
;     182 void com_write(unsigned int com)
;     183 {
_com_write:
;     184     TWCR=0xA4;    //Send START
;	com -> Y+0
	LDI  R30,LOW(164)
	OUT  0x36,R30
;     185     while (!(TWCR & (1<<TWINT)));
_0x3:
	RCALL SUBOPT_0x0
	BREQ _0x3
;     186 
;     187     TWDR=add;    //slave address + R/W
	RCALL SUBOPT_0x1
;     188     TWCR=0x84;
;     189     while (!(TWCR & (1<<TWINT)));
_0x6:
	RCALL SUBOPT_0x0
	BREQ _0x6
;     190     
;     191     TWDR=0x00;    //command 모드
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
;     192     TWCR=0x84;
;     193     while (!(TWCR & (1<<TWINT)));
_0x9:
	RCALL SUBOPT_0x0
	BREQ _0x9
;     194 
;     195     TWDR=com;    //data 출력
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x2
;     196     TWCR=0x84;
;     197     while (!(TWCR & (1<<TWINT)));
_0xC:
	RCALL SUBOPT_0x0
	BREQ _0xC
;     198 
;     199     TWCR=0x94;    //Send STOP
	LDI  R30,LOW(148)
	OUT  0x36,R30
;     200 }
	RJMP _0x41
;     201 
;     202 //SSD1306 데이터 전송 함수
;     203 void data_write(unsigned int data)
;     204 {
_data_write:
;     205     TWCR=0xA4;    //Send START
;	data -> Y+0
	LDI  R30,LOW(164)
	OUT  0x36,R30
;     206     while (!(TWCR & (1<<TWINT)));
_0xF:
	RCALL SUBOPT_0x0
	BREQ _0xF
;     207 
;     208     TWDR=add;    //slave address + R/W
	RCALL SUBOPT_0x1
;     209     TWCR=0x84;
;     210     while (!(TWCR & (1<<TWINT)));
_0x12:
	RCALL SUBOPT_0x0
	BREQ _0x12
;     211     
;     212     TWDR=0x40;    //data 모드
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x2
;     213     TWCR=0x84;
;     214     while (!(TWCR & (1<<TWINT)));
_0x15:
	RCALL SUBOPT_0x0
	BREQ _0x15
;     215 
;     216     TWDR=data;    //data 출력
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x2
;     217     TWCR=0x84;
;     218     while (!(TWCR & (1<<TWINT)));
_0x18:
	RCALL SUBOPT_0x0
	BREQ _0x18
;     219 
;     220     TWCR=0x94;    //Send STOP
	LDI  R30,LOW(148)
	OUT  0x36,R30
;     221 }
	RJMP _0x41
;     222 
;     223 
;     224 //128x32 비트맵 전송 함수
;     225 void bit_draw(flash unsigned char *ch)
;     226 {
_bit_draw:
;     227     unsigned char x,y;
;     228     unsigned int i=0;
;     229 
;     230     for(y=0;y<4;y++)
	RCALL __SAVELOCR4
;	*ch -> Y+4
;	x -> R16
;	y -> R17
;	i -> R18,R19
	LDI  R18,0
	LDI  R19,0
	LDI  R17,LOW(0)
_0x1C:
	CPI  R17,4
	BRSH _0x1D
;     231     {
;     232         com_write(0xb0+y);    //(Y축 주소 지정 커맨드 범위(B0~B3))
	MOV  R30,R17
	SUBI R30,-LOW(176)
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
;     233         com_write(0x00);    // X축 주소
;     234         com_write(0x10);    // X축 주소
;     235 
;     236         for(x=0;x<128;x++)
	LDI  R16,LOW(0)
_0x1F:
	CPI  R16,128
	BRSH _0x20
;     237         {
;     238             data_write(ch[i++]);        //ATMEGA8의 EEPROM이 아닌 플래시 메모리에 배열을 저장했기 때문에 pgm_read_byte로 읽어야한다.
	MOVW R30,R18
	RCALL SUBOPT_0x5
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x6
	LPM  R30,Z
	RCALL SUBOPT_0x3
	RCALL _data_write
;     239         }
	SUBI R16,-1
	RJMP _0x1F
_0x20:
;     240     }
	SUBI R17,-1
	RJMP _0x1C
_0x1D:
;     241 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
;     242 
;     243 
;     244 //10x16 폰트 출력 함수
;     245 void draw_font_10x16(int x, int y, int ch)
;     246 {
_draw_font_10x16:
;     247     unsigned int i, j, k =0;
;     248     unsigned int high, low;
;     249 
;     250     high = x / 16;
	RCALL SUBOPT_0x7
;	x -> Y+14
;	y -> Y+12
;	ch -> Y+10
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	high -> Y+8
;	low -> Y+6
	RCALL SUBOPT_0x8
	RCALL __DIVW21
	STD  Y+8,R30
	STD  Y+8+1,R31
;     251     low = x % 16;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
;     252 
;     253     for(i=0; i<2; i++)
_0x22:
	__CPWRN 16,17,2
	BRSH _0x23
;     254     {
;     255         com_write(0xb0+i+y);
	RCALL SUBOPT_0xA
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
;     256         com_write(0x00+low);
	RCALL SUBOPT_0xC
;     257         com_write(0x10+high);
	RCALL SUBOPT_0xD
;     258         for(j=0; j < 10; j++)
	__GETWRN 18,19,0
_0x25:
	__CPWRN 18,19,10
	BRSH _0x26
;     259         {
;     260             data_write(font_10x16[ch][k++]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	RCALL __MULW12U
	SUBI R30,LOW(-_font_10x16*2)
	SBCI R31,HIGH(-_font_10x16*2)
	RCALL SUBOPT_0xE
	RCALL _data_write
;     261         }
	RCALL SUBOPT_0x5
	RJMP _0x25
_0x26:
;     262     }
	__ADDWRN 16,17,1
	RJMP _0x22
_0x23:
;     263 }
	RCALL __LOADLOCR6
	ADIW R28,16
	RET
;     264 
;     265 
;     266 
;     267 //28x32 폰트 출력 함수
;     268 void draw_font_28x32 (int x, int ch)
;     269 {
_draw_font_28x32:
;     270     unsigned int i, j, k =0;
;     271     unsigned int high, low;
;     272 
;     273     high = x / 16;
	RCALL SUBOPT_0x7
;	x -> Y+12
;	ch -> Y+10
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	high -> Y+8
;	low -> Y+6
	RCALL SUBOPT_0xF
	RCALL __DIVW21
	STD  Y+8,R30
	STD  Y+8+1,R31
;     274     low = x % 16;
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x9
;     275 
;     276     for(i=0; i<4; i++)
_0x28:
	__CPWRN 16,17,4
	BRSH _0x29
;     277     {
;     278         com_write(0xb0+i);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
;     279         com_write(0x00+low);
	RCALL SUBOPT_0xC
;     280         com_write(0x10+high);
	RCALL SUBOPT_0xD
;     281 
;     282         for(j=0; j < 28; j++)
	__GETWRN 18,19,0
_0x2B:
	__CPWRN 18,19,28
	BRSH _0x2C
;     283         {
;     284             data_write(font_28x32[ch][k++]);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDI  R26,LOW(112)
	LDI  R27,HIGH(112)
	RCALL __MULW12U
	SUBI R30,LOW(-_font_28x32*2)
	SBCI R31,HIGH(-_font_28x32*2)
	RCALL SUBOPT_0xE
	RCALL _data_write
;     285         }
	RCALL SUBOPT_0x5
	RJMP _0x2B
_0x2C:
;     286     }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
;     287 }
	RCALL __LOADLOCR6
	ADIW R28,14
	RET
;     288 
;     289 void draw_dot(int x)
;     290 {
;     291     unsigned int i, j, k =0;
;     292     unsigned int high, low;
;     293 
;     294     high = x / 16;
;	x -> Y+10
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	high -> Y+8
;	low -> Y+6
;     295     low = x % 16;
;     296 
;     297     for(i=0; i<4; i++)
;     298     {
;     299         k =0;
;     300         com_write(0xb0+i);
;     301         com_write(0x00+low);
;     302         com_write(0x10+high);
;     303 
;     304         for(j=0; j < 16; j++)
;     305         {
;     306             data_write(dot_font[i][k++]);
;     307         }
;     308     }
;     309 }
;     310 
;     311 //OLED 화면 클리어 함수
;     312 void oled_clear(void)
;     313 {
_oled_clear:
;     314     unsigned int i, j;
;     315 
;     316     for(i=0; i<4; i++)
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x34:
	__CPWRN 16,17,4
	BRSH _0x35
;     317     {
;     318         com_write(0xb0+i);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
;     319         com_write(0x00);
;     320         com_write(0x10);
;     321         for(j=0; j < 128; j++)
	__GETWRN 18,19,0
_0x37:
	__CPWRN 18,19,128
	BRSH _0x38
;     322         {
;     323             data_write(0x00);    //0X00으로 전부 채운다.
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x10
	RCALL _data_write
;     324         }
	RCALL SUBOPT_0x5
	RJMP _0x37
_0x38:
;     325     }
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
;     326 }
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;     327 
;     328 //OLED 화면 초기화 함수
;     329 void oled_init(void)
;     330 {
_oled_init:
;     331     com_write(0xAE); //display off
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	RCALL SUBOPT_0xB
;     332     com_write(0x20); //Set Memory Addressing Mode
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0xB
;     333     com_write(0x10); //00,Horizontal Addressing Mode;01,Vertical Addressing Mode;10,Page Addressing Mode (RESET);11,Invalid
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0xB
;     334     com_write(0xb0); //Set Page Start Address for Page Addressing Mode,0-7
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	RCALL SUBOPT_0xB
;     335     com_write(0xc8); //Set COM Output Scan Direction
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
;     336     com_write(0x00); //---set low column address
;     337     com_write(0x10); //---set high column address
;     338     com_write(0x40); //--set start line address
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RCALL SUBOPT_0xB
;     339 
;     340     com_write(0x81); //--set contrast control register*
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	RCALL SUBOPT_0xB
;     341     com_write(0xFF);
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL SUBOPT_0xB
;     342 
;     343     com_write(0xa1); //--set segment re-map 0 to 127
	LDI  R30,LOW(161)
	LDI  R31,HIGH(161)
	RCALL SUBOPT_0xB
;     344     com_write(0xa6); //--set normal display
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	RCALL SUBOPT_0xB
;     345     com_write(0xa8); //--set multiplex ratio(1 to 64)
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	RCALL SUBOPT_0xB
;     346     com_write(0x1F); //
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	RCALL SUBOPT_0xB
;     347     com_write(0xa4); //0xa4,Output follows RAM content;0xa5,Output ignores RAM content
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	RCALL SUBOPT_0xB
;     348     com_write(0xd3); //-set display offset
	LDI  R30,LOW(211)
	LDI  R31,HIGH(211)
	RCALL SUBOPT_0xB
;     349     com_write(0x00); //-not offset
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xB
;     350     com_write(0xd5); //--set display clock divide ratio/oscillator frequency
	LDI  R30,LOW(213)
	LDI  R31,HIGH(213)
	RCALL SUBOPT_0xB
;     351     com_write(0xf0); //--set divide ratio
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	RCALL SUBOPT_0xB
;     352     com_write(0xd9); //--set pre-charge period
	LDI  R30,LOW(217)
	LDI  R31,HIGH(217)
	RCALL SUBOPT_0xB
;     353 
;     354     com_write(0x22); //
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	RCALL SUBOPT_0xB
;     355     com_write(0xda); //--set com pins hardware configuration
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	RCALL SUBOPT_0xB
;     356     com_write(0x02);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0xB
;     357     com_write(0xdb); //--set vcomh
	LDI  R30,LOW(219)
	LDI  R31,HIGH(219)
	RCALL SUBOPT_0xB
;     358 
;     359     com_write(0x20); //0x20,0.77xVcc
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0xB
;     360     com_write(0x8d); //--set DC-DC enable
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	RCALL SUBOPT_0xB
;     361     com_write(0x14); //
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0xB
;     362     com_write(0xaf); //--turn on oled panel
	LDI  R30,LOW(175)
	LDI  R31,HIGH(175)
	RCALL SUBOPT_0xB
;     363 }
	RET
;     364 
;     365 void digit_num(int k)
;     366 {
_digit_num:
;     367     digit_1 = k % 10;
;	k -> Y+0
	RCALL SUBOPT_0x12
	RCALL __MODW21
	MOVW R12,R30
;     368     digit_10 = (k / 10) % 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	STS  _digit_10,R30
	STS  _digit_10+1,R31
;     369     digit_100 = (k / 100) % 10;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x13
	STS  _digit_100,R30
	STS  _digit_100+1,R31
;     370     digit_1000 = k / 1000;
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21
	STS  _digit_1000,R30
	STS  _digit_1000+1,R31
;     371 }
_0x41:
	ADIW R28,2
	RET
;     372 
;     373 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     374 {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     375     TCNT0=140;
	LDI  R30,LOW(140)
	OUT  0x32,R30
;     376     distance++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
;     377 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     378 
;     379 interrupt [EXT_INT0] void ext_int0_isr(void)
;     380 {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     381      if(edge_mode == 0)
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x39
;     382     {
;     383         distance = 0;
	CLR  R4
	CLR  R5
;     384         TIMSK=0x01; // 오버플로우 인터럽트 설정 0
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     385         TCCR0=0x02;    //프리스케일 설정
	LDI  R30,LOW(2)
	OUT  0x33,R30
;     386         TCNT0=140;    //시작 레지스터 설정
	LDI  R30,LOW(140)
	OUT  0x32,R30
;     387         MCUCR=0x02;    //하강에지로 설정
	LDI  R30,LOW(2)
	OUT  0x35,R30
;     388         edge_mode = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
;     389     }
;     390 
;     391     else
	RJMP _0x3A
_0x39:
;     392     {
;     393         TIMSK=0x00; //오버플로우 인터럽트 설정 x
	LDI  R30,LOW(0)
	OUT  0x39,R30
;     394         edge_mode = 0;
	CLR  R6
	CLR  R7
;     395 
;     396         //450 미만(4.5M 미만)일때의 값은 무시
;     397         if(distance < 450)
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x3B
;     398         {
;     399             sum = sum + distance;
	__ADDWRR 10,11,4,5
;     400             avg_cnt++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
;     401         }
;     402 
;     403         //10번 측정한 값을 평균내서 출력
;     404         if(avg_cnt == 10)
_0x3B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3C
;     405         {
;     406             digit_num(sum/avg_cnt);
	MOVW R30,R8
	MOVW R26,R10
	RCALL __DIVW21U
	RCALL SUBOPT_0x10
	RCALL _digit_num
;     407             avg_cnt=0;
	CLR  R8
	CLR  R9
;     408             sum=0;
	CLR  R10
	CLR  R11
;     409         }
;     410         MCUCR=0x03;    //상승에지로 설정
_0x3C:
	LDI  R30,LOW(3)
	OUT  0x35,R30
;     411     }
_0x3A:
;     412 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     413 
;     414 void main(void)
;     415 {
_main:
;     416     DDRC = 0xFF; //
	LDI  R30,LOW(255)
	OUT  0x14,R30
;     417     DDRD = 0x01; 
	LDI  R30,LOW(1)
	OUT  0x11,R30
;     418 
;     419     TWBR = 12;    //(CPU_Clock/SCL_Clock) - 16)/2 = TWBR*(4^TWPS) -> 통신속도 400kHz설정
	LDI  R30,LOW(12)
	OUT  0x0,R30
;     420     TWSR = 0x00;       
	LDI  R30,LOW(0)
	OUT  0x1,R30
;     421 
;     422     GICR=0x40;    //인터럽트  인에이블
	LDI  R30,LOW(64)
	OUT  0x3B,R30
;     423     MCUCR=0x03;   //처음은 상승 엣지로 설정
	LDI  R30,LOW(3)
	OUT  0x35,R30
;     424     SREG=0x80;    //인터럽트 허용
	LDI  R30,LOW(128)
	OUT  0x3F,R30
;     425 
;     426     oled_init();    //OLED 초기화
	RCALL _oled_init
;     427     delay_ms(50);
	RCALL SUBOPT_0x14
;     428     
;     429     bit_draw(gretting_screen);    //초기화면 DISTANACE MEASURER 출력
	LDI  R30,LOW(_gretting_screen*2)
	LDI  R31,HIGH(_gretting_screen*2)
	RCALL SUBOPT_0x10
	RCALL _bit_draw
;     430     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x10
	RCALL _delay_ms
;     431     
;     432     oled_clear();
	RCALL _oled_clear
;     433     //draw_dot(57);
;     434 
;     435     while(1)
_0x3D:
;     436     {
;     437         PORTD=0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
;     438         delay_us(10);    //초음파센서 트리거 발생
	__DELAY_USB 53
;     439         PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     440         draw_font_28x32(84,digit_1);       //1의 자리 출력
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	RCALL SUBOPT_0x10
	ST   -Y,R13
	ST   -Y,R12
	RCALL _draw_font_28x32
;     441         draw_font_28x32(56,digit_10);      //10의자리 출력
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	RCALL SUBOPT_0x10
	LDS  R30,_digit_10
	LDS  R31,_digit_10+1
	RCALL SUBOPT_0x10
	RCALL _draw_font_28x32
;     442         draw_font_28x32(28,digit_100);     //100의 자리 출력
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	RCALL SUBOPT_0x10
	LDS  R30,_digit_100
	LDS  R31,_digit_100+1
	RCALL SUBOPT_0x15
;     443         draw_font_28x32(0,digit_1000);     //1000의 자리 출력
	LDS  R30,_digit_1000
	LDS  R31,_digit_1000+1
	RCALL SUBOPT_0x15
;     444         draw_font_10x16(0,4,4);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x10
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x10
	RCALL _draw_font_10x16
;     445         delay_ms(50);
	RCALL SUBOPT_0x14
;     446     }
	RJMP _0x3D
;     447 }
_0x40:
	RJMP _0x40


;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(120)
	OUT  0x3,R30
	LDI  R30,LOW(132)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	OUT  0x3,R30
	LDI  R30,LOW(132)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	RCALL _com_write
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _com_write
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _com_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__ADDWRN 18,19,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	SBIW R28,4
	RCALL __SAVELOCR6
	LDI  R20,0
	LDI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	RCALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	MOVW R30,R16
	SUBI R30,LOW(-176)
	SBCI R31,HIGH(-176)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _com_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,0
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,16
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	MOVW R26,R30
	MOVW R30,R20
	__ADDWRN 20,21,1
	RCALL SUBOPT_0x6
	LPM  R30,Z
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	RCALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x10
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x10
	RCALL _draw_font_28x32
	RCALL SUBOPT_0x11
	RJMP SUBOPT_0x10

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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
