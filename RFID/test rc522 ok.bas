'*******************************************************************************
' Test Demo RC522 NFC Chip Card RFID Module
' This is the Radio Frequency Identification (RFID) 13.56 Mhz module
'
' Hardware:
' http://www.amazon.de/SainSmart-Mifare-Module-KeyCard-Arduino/dp/B00G6FK4DQ
' http://www.ebay.de/itm/RC522-MFRC-522-Radiofrequenz-RFID-IC-Karte-s50-induktive-Modul-mit-fudan-Karte-/370881403775
' Spi Mode
'
'Date 08.09.2014
'
'Email: Hkipnik@aol.com
'Copyright (c) 2013 Hkipnik.  All rights reserved.
'Written by Hkipnik
'BSD license, check license.txt for more information
'All Text Above , And The Splash Screen Below Must Be Included In Any Redistribution.
'
'Version V1.12
'
'Read and Write Data - only Mifare Classic 1K (s50) tag ID -- 4Byte ID  ISO14443A
'
'Read 7Byte Tag ID  ISO14443A
'    Mifare Desfire EV1
'    Mifare Ultralight X
'    Topaz NFC
'    Mifare Classic S70
'
'Voltage = 3,3V
'PortB.5 --> SCK RC522
'PortB.4 --> MISO RC522                                              7
'PortB.3 --> MOSI RC522
'PortB 2 CS --> SDA RC522
'PortB.1 --> Rst RC522
'*******************************************************************************
$regfile = "m32def.dat"
$crystal = 11059200
$hwstack = 150
$swstack = 150
$framesize = 200
$baud = 9600


Const Read_write =0                                       ' 0= only Read TAG ID  1=Read and Write Data to Card

'*******************************************************************************
taghere alias porta.0:config taghere=output
good alias porta.1:config good=output
dim try as word
'irq alias pinc.0:config portc.0=INPUT
Config Portb.1 = Output                                     'Reset Pin
Rst522 Alias Portb.1
Set Rst522
Config Portb.2 = Output                                     'CS Pin
Cs_pn Alias Portb.2
Set Cs_pn
Config Spi = Hard , Interrupt = off , Data Order = Msb , Master = Yes , Polarity = Low , Phase = 0 , Clockrate = 16 , Noss = 1
Spiinit

'Config Sda = Portc.1

'Config Scl = Portc.0
'Config I2cdelay = 10
'i2cinit

'*******************************************************************************
Dim Rc522_buffer(18) As Byte                                'out Buffer
Dim Rc522_inbuffer(18) As Byte                              'in Buffer

Dim Tag_typ As Word                                         'Tag Typ
Dim Tag_typa(2) As Byte At Tag_typ Overlay
Dim Sak As Byte

Dim Tag_id(4) As Byte
Dim Tag_crc As Byte                                         'Byte5 CRC

Dim Id_leng As Byte
Dim Tag_id7(7) As Byte


Dim Textbyte(16) As Byte
Dim Text As String * 16 At Textbyte(1) Overlay

Const Pcd_authent = &H0E
Const Pcd_transceive = &H0C
Const Bitframingreg = &H0D
Const Commienreg = &H02
Const Commirqreg = &H04
Const Fifolevelreg = &H0A
Const Controlreg = &H0C
Const Fifodatareg = &H09
Const Commandreg = &H01
Const Errorreg = &H06
Const Picc_auth1a = &H60                                    'MadKeyA =FF, FF, FF, FF, FF, FF
Const Picc_auth1b = &H61                                    'MadKeyA =A0, A1, A2, A3, A4, A5

Dim Tag_fount As Byte
Dim Status As Byte
Dim Lastbits As Byte
Dim Backleng As Byte
Dim Error1 As Byte

Dim Crc_low As Byte
Dim Crc_high As Byte
'*******************************************************************************

Declare Sub Write522(byval Addr As Byte , Byval Daten As Byte)
Declare Function Read522(byval Addre As Byte) As Byte
Declare Sub Setbitmask(byval Reg As Byte , Byval Mask As Byte)
Declare Sub Clearbitmask(byval Reg As Byte , Byval Mask As Byte)
Declare Sub Initrc522()

Declare Sub Rc522to_card(byval Command As Byte , Byval Sendlen As Byte)

Declare Sub Is_card()
Declare Sub Anticoll(byval Selecttag As Byte )

Declare Sub Calculate_crc(byval Leng As Byte)
Declare Sub Rc522_reset()
Declare Sub Rc522_halt()
Declare Sub Rc522_selecttag()

Declare Sub Rc522_auth(byval Authmode As Byte , Byval Blockaddr As Byte)
Declare Sub Rc522_read(byval Block As Byte)
Declare Sub Rc522_write(byval Block As Byte)
Declare Sub Rc522_stop()
Declare Sub Read_chipid()

irq alias pinc.0:config portc.0=INPUT

'*******************************************************************************
print "starting"

Call Initrc522()
print "initializing"
Call Write522(commienreg , &H8C )
'do
 ' if irq=0 then set taghere else reset taghere
 ' print read522(errorreg)
 ' wait 2
'loop


'*******************************************************************************
'*******************************************************************************
main:
'do
   print "hi "
   wait 1
'loop

Do
   'print try
   'incr try
   Call Is_card()
   'toggle good

   If Tag_fount = 1 Then
      set taghere
      'waitms 500
      Call Read_chipid()                                    'Read Tag ID
      Print "Chip is OK"
      Print "Tag Typ= " ; Hex(tag_typ) ; " SAK= " ; Hex(sak)       'SAK Level1

     If Id_leng = 4 Then
       Print "Tag ID4= " ; Hex(tag_id(1)) ; " " ; Hex(tag_id(2)) ; " " ; Hex(tag_id(3)) ; " " ; Hex(tag_id(4))
     Elseif Id_leng = 7 Then
       Print "Tag ID7= " ; Hex(tag_id7(1)) ; " " ; Hex(tag_id7(2)) ; " " ; Hex(tag_id7(3)) ; " " ; Hex(tag_id7(4)) ; " " ; Hex(tag_id7(5)) ; " " ; Hex(tag_id7(6)) ; " " ; Hex(tag_id7(7))
     End If
     wait 5

'*******************************************************************************
     #if Read_write = 1
       If Id_leng = 4 Then                                  'only Mifare Classic 1K (s50)
         Call Rc522_selecttag()
         If Status = 1 Then
            Call Rc522_auth(picc_auth1a , 8)                'Authentication to enable Sector 2  8/4=2 Sector

            Call Rc522_read(8)                              'read Data Sector 2 0
            Call Rc522_read(9)                              'read Data Sector 2 +1
            Call Rc522_read(10)                             'read Data Sector 2 +2

            'Write Data To Card
          '(
            Text = "Hello Bascom    "
            Call Rc522_write(8)                             'write Data Sector 2 0
            Text = "NFC RC522 Demo  "
            Call Rc522_write(9)                             'write Data Sector 2 +1
            Text = "by Hkipnik      "
            Call Rc522_write(10)                            'write Data Sector 2 +2
')
         End If
       End If
     #endif
'*******************************************************************************
      Call Rc522_stop()                                     'Stop Auth Mode
      Call Rc522_halt()                                     'go to state Wait for new Card

   Else
      reset taghere
      Print "No Chip fount"
   End If

   ' Call Rc522_halt()
   waitms 100
Loop
End
'*******************************************************************************



'*******************************************************************************
' Reed 4Byte UID or 7Byte UID
'*******************************************************************************
Sub Read_chipid()

     Call Anticoll(&H93)                                    'Level 1 PICC_ANTICOLL_1

     If Tag_id(1) = &H88 Then                               'CT = Cascade Tag fount 7Byte UID
       Tag_id7(1) = Tag_id(2)                               'Cascade Level 1
       Tag_id7(2) = Tag_id(3)
       Tag_id7(3) = Tag_id(4)
       Call Rc522_selecttag()
       Call Anticoll(&H95)                                  'Cascade Level 2 PICC_ANTICOLL_2
       Tag_id7(4) = Tag_id(1)
       Tag_id7(5) = Tag_id(2)
       Tag_id7(6) = Tag_id(3)
       Tag_id7(7) = Tag_id(4)
       Id_leng = 7                                          '7Byte UID
     Else
       Id_leng = 4                                          '4Byte UID
     End If

End Sub

'*******************************************************************************
' Anti- collision detection , reading selected card serial number card
' only MIFARE Classic Chips 4Byte ID
'*******************************************************************************
Sub Anticoll(byval Selecttag As Byte)

   Call Write522(bitframingreg , &H00)                      'BitFramingReg         0x0D
   Rc522_buffer(1) = Selecttag                              'PICC_ANTICOLL         h93   95
   Rc522_buffer(2) = &H20
   Call Rc522to_card(pcd_transceive , 2)

   If Backleng = 40 Then                                    'fount 5 Bytes Byte 5 is CRC
      Tag_id(1) = Rc522_inbuffer(1)
      Tag_id(2) = Rc522_inbuffer(2)
      Tag_id(3) = Rc522_inbuffer(3)
      Tag_id(4) = Rc522_inbuffer(4)
      Tag_crc = Rc522_inbuffer(5)                           'use in Rc522_selecttag
   End If
End Sub

'*******************************************************************************
'  Writes a byte to the specified register in the MFRC522 chip
'*******************************************************************************
Sub Write522(byval Addr As Byte , Byval Daten As Byte)

   Shift Addr , Left , 1
   Addr = Addr And &H7E                                     '0XXXXXX0
   Reset Cs_pn
   Spiout Addr , 1
   Spiout Daten , 1
   Set Cs_pn

   'print "writing"
'(   'i2cinit
   i2cstart
   'Shift Addr , Left , 1
   'Addr = Addr And &H7E                                     '0XXXXXX0
   'Reset Cs_pn
   i2cwbyte Addr
   i2cwbyte Daten
   'Set Cs_pn
   i2cstop
   ')
   'print "finish writing"
End Sub
'*******************************************************************************
' Reads a byte from the specified register in the MFRC522 chip
'*******************************************************************************
Function Read522(byval Addre As Byte) As Byte
   Shift Addre , Left , 1
   Addre = Addre And &H7E                                   '1XXXXXX0
   Addre = Addre Or &H80

   Reset Cs_pn
   Spiout Addre , 1
   Spiin Read522 , 1
   Set Cs_pn
   print read522
   'Shift Addre , Left , 1
   'Addre = Addre And &H7E                                   '1XXXXXX0
   'Addre = Addre Or &H80

   'Reset Cs_pn
 ' print "reading"
  '(
   i2cinit
   i2cstart
   i2cwbyte Addre
   i2crbyte Read522 ,ack
   i2cstop
   ')
  'Set Cs_pn
End Function
'*******************************************************************************
' Sets the bits given in mask in register reg
'*******************************************************************************
Sub Setbitmask(byval Reg As Byte , Byval Mask As Byte)
   Local Rxin As Byte
   Rxin = Read522(reg)
   Rxin = Rxin Or Mask
   Call Write522(reg , Rxin)
End Sub
'*******************************************************************************
' Clears the bits given in mask from register reg
'*******************************************************************************
Sub Clearbitmask(byval Reg As Byte , Byval Mask As Byte)
   Local Inbyte As Byte
   Inbyte = Read522(reg)
   Mask = Not Mask
   Inbyte = Inbyte And Mask
   Call Write522(reg , Inbyte)
End Sub
'*******************************************************************************
' Soft Reset RC522
'*******************************************************************************
Sub Rc522_reset()
   Call Write522(commandreg , &H0F)                         'PCD_RESETPHASE        0x0F
End Sub
'*******************************************************************************
' Init RC522
'*******************************************************************************
Sub Initrc522()
   Reset Rst522
   Waitms 100
   Set Rst522
   Call Rc522_reset()
   Waitms 500
   Call Write522(&H2a , &H8D)                               'TModeReg   8d
   Call Write522(&H2b , &H3E)                               'TPrescalerReg  a9   3e
   Call Write522(&H2d , &H03)                               'TReloadRegL 25ms before timeout.
   Call Write522(&H2c , &HE8)                               'TReloadRegH

   Call Write522(&H15 , &H40)                               'TxAutoReg
   Call Write522(&H11 , &H3D)                               'ModeReg

   'antene On
   Call Setbitmask(&H14 , &H03)                             'TxControlReg

End Sub
'*******************************************************************************
' RC522 and ISO14443 card communication
'*******************************************************************************
Sub Rc522to_card(byval Command As Byte , Byval Sendlen As Byte)
   Local Irqen As Byte , Waitirq As Byte , Timeout As Byte
   Local Temps As Byte , N As Byte , Dum As Byte

   Select Case Command
      Case Pcd_authent:
         Irqen = &H12
         Waitirq = &H14
      Case Pcd_transceive:
         Irqen = &H77
         Waitirq = &H64
   End Select


   Dum = Irqen Or &H80
   dum=&H8C
   Call Write522(commienreg , Dum)                  'CommIEnReg CommIEnReg            0x02
   Call Clearbitmask(commirqreg , &H80)             'CommIrqReg            0x04
   Call Setbitmask(fifolevelreg , &H80)             'Fifolevelreg 0x0a

   Call Write522(commandreg , &H00)                 'CommandReg 01, PCD_IDLE 00

   For Dum = 1 To Sendlen

      Call Write522(fifodatareg , Rc522_buffer(dum) )       'FIFODataReg           0x09
   Next

   Call Write522(commandreg , Command)

   If Command = Pcd_transceive Then
      Call Setbitmask(bitframingreg , &H80)                 'BitFramingReg         0x0D
   End If

   Timeout = 250
   Do
      Dum = Read522(commirqreg)                             'CommIrqReg            0x04
      Decr Timeout
      If Dum = Waitirq Then Exit Do                         'Waitirq

   Loop Until Timeout = 0

   Call Clearbitmask(bitframingreg , &H80)                  'BitFramingReg         0x0D

   If Timeout > 0 Then
      Temps = Read522(errorreg)                             'ErrorReg
      Temps = Temps And &H1B

      If Temps = 0 Then                                     'todo
         Error1 = 0
      Else
         Error1 = 1
         Print "Error"
      End If

      If Command = Pcd_transceive Then                      'Read Back Data
         Dum = Read522(fifolevelreg)                        'FIFOLevelReg   = 0x0A
         N = Dum
         Lastbits = Read522(controlreg)                     '.ControlReg)0C & 0x07
         Lastbits = Lastbits And &H07
         If Lastbits > 0 Then
            Decr Dum
            Dum = Dum * 8
            Backleng = Dum + Lastbits
         Else
            Backleng = Dum * 8
         End If

         If N = 0 Then N = 1

         For Dum = 1 To N
            Rc522_inbuffer(dum) = Read522(fifodatareg)      '  FIFODataReg    = 0x09
         Next

      End If

   End If

End Sub
'*******************************************************************************
' Find cards , read the card type number
'  H4400 = Mifare_UltraLight
'  H0400 = Mifare_one(s50)
'  H0200 = Mifare_one(s70)
'  H0800 = Mifare_pro(x)
'  H4403 = Mifare_desfire
'  H000C = Topaz NFC
'*******************************************************************************
Sub Is_card()

   Call Write522(bitframingreg , &H07)                      'BitFramingReg  = 0x0D
   Rc522_buffer(1) = &H26
   backleng=0
   Call Rc522to_card(pcd_transceive , 1)
   print "backleng= ";backleng
   If Backleng = 16 Then
      Tag_fount = 1                                         'Chip fount
      Tag_typa(2) = Rc522_inbuffer(1)                       'Little Endian
      Tag_typa(1) = Rc522_inbuffer(2)
   Else
      Tag_fount = 0
   End If
End Sub
'*******************************************************************************
'Use the CRC coprocessor in the MFRC522 to calculate a CRC
'*******************************************************************************
Sub Calculate_crc(byval Leng As Byte)
   Local Zbv1 As Byte , Timeou As Word

   Call Clearbitmask(&H05 , &H04)                           ' DivIrqReg             0x05
   Call Setbitmask(fifolevelreg , &H80)                     'FIFOLevelReg          0x0A

   For Zbv1 = 1 To Leng
      Call Write522(fifodatareg , Rc522_buffer(zbv1) )      'FIFODataReg           0x09
   Next

   Call Write522(commandreg , &H03)                         'CommandReg            0x01

   Timeou = 2000
   Do
      Zbv1 = Read522(&H05)                                  ' DivIrqReg             0x05
      Decr Timeou
   Loop Until Timeou = 0 Or Zbv1 = &H04                     '04

   Crc_low = Read522(&H22)                                  'Crcresultregl 0x22
   Crc_high = Read522(&H21)                                 'Crcresultregm 0x21

End Sub
'*******************************************************************************
'Instructs a Chip in state ACTIVE(*) to go to state HALT.
'*******************************************************************************
Sub Rc522_halt()

   Rc522_buffer(1) = &H50                                   'PICC_HALT             0x50
   Rc522_buffer(2) = &H00

   Call Calculate_crc(2)

   Rc522_buffer(3) = Crc_low
   Rc522_buffer(4) = Crc_high

   Call Rc522to_card(pcd_transceive , 4)

End Sub
'*******************************************************************************
'Select card,and read Card storage volume
'*******************************************************************************
Sub Rc522_selecttag()

   Rc522_buffer(1) = &H93                                   'PICC_SElECTTAG = 0x93
   Rc522_buffer(2) = &H70
   Rc522_buffer(3) = Tag_id(1)
   Rc522_buffer(4) = Tag_id(2)
   Rc522_buffer(5) = Tag_id(3)
   Rc522_buffer(6) = Tag_id(4)
   Rc522_buffer(7) = Tag_crc
   Call Calculate_crc(7)
   Rc522_buffer(8) = Crc_low
   Rc522_buffer(9) = Crc_high

   Call Rc522to_card(pcd_transceive , 9)

   If Backleng = &H18 Then                                  '24Bit
      Status = 1
      Sak = Rc522_inbuffer(1)
     '  Print "Storage Volume KByte " ; Rc522_inbuffer(1)    'read card storage volume  /8
   Else
      Status = 0
   End If

End Sub
'*******************************************************************************
' authMode--password verify mode
' Block Sector 0 - 4 - 8 - 12 - 16 - 20 - 24 - 28 - 32 - 36 - 40 - 44 - 48 - 52 - 56 - 60
' per Sector read and write 4Byte
' Byte4 Config Data only write sector trailer when you know what you're doing
'*******************************************************************************
Sub Rc522_auth(byval Authmode As Byte , Byval Blockaddr As Byte)

   Rc522_buffer(1) = Authmode
   Rc522_buffer(2) = Blockaddr
   Rc522_buffer(3) = &HFF                                   'Defalt buffer A Password
   Rc522_buffer(4) = &HFF
   Rc522_buffer(5) = &HFF
   Rc522_buffer(6) = &HFF
   Rc522_buffer(7) = &HFF
   Rc522_buffer(8) = &HFF
   Rc522_buffer(9) = Tag_id(1)
   Rc522_buffer(10) = Tag_id(2)
   Rc522_buffer(11) = Tag_id(3)
   Rc522_buffer(12) = Tag_id(4)

   Call Rc522to_card(pcd_authent , 12)

End Sub
'*******************************************************************************
' Read data
' Block = Blockaddr or Blockaddr +1 or Blockaddr +2
' Blockaddr + 3 is Config Data from the Card
'*******************************************************************************
Sub Rc522_read(byval Block As Byte)
   Local Temp2 As Byte
   Rc522_buffer(1) = &H30                                   ' PICC_READ      = 0x30
   Rc522_buffer(2) = Block

   Call Calculate_crc(2)

   Rc522_buffer(3) = Crc_low
   Rc522_buffer(4) = Crc_high

   Call Rc522to_card(pcd_transceive , 4)

   If Backleng = 144 Then                                   '144Bit 18Byte
      Print "Read 16Byte-- " ;                              'Dump 16Byte Buffer
      For Temp2 = 1 To 16
         Print Chr(rc522_inbuffer(temp2)) ;
      Next
   End If
End Sub
'*******************************************************************************
' Write data
' Block = Blockaddr or Blockaddr +1 or Blockaddr +2
' Blockaddr + 3 is Config Data from the - Card Warning: only write sector trailer when you know what you're doing
'*******************************************************************************
Sub Rc522_write(byval Block As Byte)
   Local Zbv As Byte
   Print "Write Data"
   Rc522_buffer(1) = &HA0                                   ' PICC_WRITE            0xA0   PICC_CMD_UL_WRITE                = 0xA2
   Rc522_buffer(2) = Block

   Call Calculate_crc(2)

   Rc522_buffer(3) = Crc_low
   Rc522_buffer(4) = Crc_high

   Call Rc522to_card(pcd_transceive , 4)

   For Zbv = 1 To 16
      Rc522_buffer(zbv) = Textbyte(zbv)                     'Copy Text Data to RC522 Buffer
   Next

   Call Calculate_crc(16)
   Rc522_buffer(17) = Crc_low
   Rc522_buffer(18) = Crc_high
   Call Rc522to_card(pcd_transceive , 18)                   ' 18

End Sub
'*******************************************************************************
'Stop Auth Mode
'*******************************************************************************
Sub Rc522_stop()
   Call Clearbitmask(&H08 , &H08)                           'Status2Reg     = 0x08

End Sub