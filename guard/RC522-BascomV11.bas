'*******************************************************************************
' Test Demo RC522 NFC Chip
'
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
'Version V1.1  Working Version
'
'for read and write only Mifare Classic 1K (S50) Tag ID -- 4Byte ID  ISO14443A
'
'in working read 7Byte Tag ID
'*******************************************************************************
$regfile = "m32def.dat"
$crystal = 11059200

$hwstack = 250
$swstack = 150
$framesize = 200
$baud = 9600


Const Read_write = 1                                        ' 0= only Read TAG ID  1=Read and Write Data to Card

'Voltage = 3,3V
'PortB.7 --> SCK RC522
'PortB.6 --> MISO RC522
'PortB.5 --> MOSI RC522
'PortD 5 CS --> SDA RC522
'PortD.6 --> Rst RC522
 Print "besmellahe rahmane rahim"
'*******************************************************************************
Config Pina.0 = Output
Led Alias Porta.0

Config Pina.1 = Output
Led_popwer_on Alias Porta.1
Led_popwer_on = 1

Config Pinb.0 = Output
Buzeer Alias Portb.0

Config Pinb.1 = Input
Key Alias Pinb.1

Config Pina.5 = Output
Led_write Alias Porta.5

Config Pind.6 = Output                                      'Reset Pin
Rst522 Alias Portd.6
Set Rst522

Config Pind.5 = Output                                      'CS Pin
Cs_pn Alias Portd.5
Set Cs_pn

Config Spi = Soft , Din = Pinb.6 , Dout = Portb.5 , Ss = None , Clock = Portb.7 , Mode = 3
'Config Spi = Hard , Interrupt = Off , Data Order = Msb , Master = Yes , Polarity = low , Phase = 0 , Clockrate = 16 , Noss =1
Spiinit
'*******************************************************************************
Dim Rc522_buffer(18) As Byte                                'out Buffer
Dim Rc522_inbuffer(18) As Byte                              'in Buffer

Dim Tag_typ As Word                                         'Tag Typ
Dim Tag_typa(2) As Byte At Tag_typ Overlay

Dim Tag_idw As Dword                                        'Tag ID
Dim Tag_id(4) As Byte At Tag_idw Overlay
Dim Tag_crc As Byte                                         'Byte5 CRC

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
Const Picc_auth1a = &H60

Dim Tag_fount As Byte
Dim Status As Byte
Dim Lastbits As Byte
Dim Backleng As Byte
Dim Error1 As Byte

Dim Crc_low As Byte
Dim Crc_high As Byte
'=============================
Dim Geyma_long As Long
Dim Geymat_arr(10) As Byte
Dim S2 As String * 2
Dim Crc32_long As Long
Dim Crc16_word As Word
Dim Longg As Long

Dim Sector_one As String * 16
Dim Sector_two As String * 16
Dim Sector_tree As String * 16
Dim Str_data_16 As String * 16
'*******************************************************************************


Declare Sub Write522(byval Addr As Byte , Byval Daten As Byte)
Declare Function Read522(byval Addre As Byte) As Byte
Declare Sub Setbitmask(byval Reg As Byte , Byval Mask As Byte)
Declare Sub Clearbitmask(byval Reg As Byte , Byval Mask As Byte)
Declare Sub Initrc522()

Declare Sub Rc522to_card(byval Command As Byte , Byval Sendlen As Byte)
Declare Sub Rc522_request(byval Reqmode As Byte)
Declare Sub Is_card()
Declare Sub Anticoll()
Declare Sub Calculate_crc(byval Leng As Byte)
Declare Sub Rc522_reset()
Declare Sub Rc522_halt()
Declare Sub Rc522_selecttag()
Declare Sub Rc522_auth(byval Authmode As Byte , Byval Blockaddr As Byte)
Declare Sub Rc522_read(byval Block As Byte)
Declare Sub Rc522_write(byval Block As Byte)
Declare Sub Rc522_stop()
'*******************************************************************************
Print "Initrc522"
Led_popwer_on = 0
Call Initrc522()
'*******************************************************************************
Waitms 500
Led_popwer_on = 1
Print "Start"
'*******************************************************************************
Buzeer = 1 : Waitms 500 : Buzeer = 0

Do
   Led_write = Key
   Toggle Led_write


   Call Is_card()
   'Print "tag found=" ; Tag_fount ; "       "


   If Tag_fount = 1 Then
      Buzeer = 1 : Waitms 100 : Buzeer = 0

      Call Anticoll()                                       'Read Tag ID
      Print "Chip fount"
      Print "Tag Typ= " ; Hex(tag_typ)
      Print "Tag ID= " ; Hex(tag_id(1)) ; "-" ; Hex(tag_id(2)) ; "-" ; Hex(tag_id(3)) ; "-" ; Hex(tag_id(4))
'*******************************************************************************

     #if Read_write = 1
            Call Rc522_selecttag()

            If Status = 1 Then
               Call Rc522_auth(picc_auth1a , 12)            'Authentication to enable Sector 2  8/4=2 Sector

              If Key = 1 Then
                'Read Data From Card
                Led_write = 0
                Call Rc522_read(12)                         'read Data Sector 2 0
                Sector_one = "                "
                Sector_one = Str_data_16

                Call Rc522_read(13)                         'read Data Sector 2 +1
                Sector_two = "                "
                Sector_two = Str_data_16

                Call Rc522_read(14)                         'read Data Sector 2 +2
                Sector_tree = "                "
                Sector_tree = Str_data_16

                '-------------------------------
                Geyma_long = Val(sector_one)
                If Geyma_long > 0 Then Geyma_long = Geyma_long - 1000
                Goto Write1

              Else
               'Write Data To Card
               Geyma_long = 10100

               Write1:
               Led_write = 1

               Text = "                "
               Text = Str(geyma_long)
               Text = Format(text , "0000000000000000")

               'Text = "Hello Bascom    "
               Call Rc522_write(12)                         'write Data Sector 2 0
               '--------------------
               Text = "                "
               Text = Str(geyma_long)
               Text = Format(text , "0000000000000000")

               Geymat_arr(1) = 0
               S2 = Mid(text , 1 , 2)
               Geymat_arr(1) = Val(s2)

               Geymat_arr(2) = 0
               S2 = Mid(text , 3 , 2)
               Geymat_arr(2) = Val(s2)

               Geymat_arr(3) = 0
               S2 = Mid(text , 5 , 2)
               Geymat_arr(3) = Val(s2)

               Geymat_arr(4) = 0
               S2 = Mid(text , 7 , 2)
               Geymat_arr(4) = Val(s2)

               Geymat_arr(5) = 0
               S2 = Mid(text , 9 , 2)
               Geymat_arr(5) = Val(s2)

               Geymat_arr(6) = 0
               S2 = Mid(text , 11 , 2)
               Geymat_arr(6) = Val(s2)

               Geymat_arr(7) = 0
               S2 = Mid(text , 13 , 2)
               Geymat_arr(7) = Val(s2)

               Geymat_arr(8) = 0
               S2 = Mid(text , 15 , 2)
               Geymat_arr(8) = Val(s2)

               Crc32_long = Crc32(geymat_arr(1) , 8)
               Crc16_word = Crc16(geymat_arr(1) , 8)
               Longg = Crc16_word

               Crc32_long = Crc32_long And Longg
               Shift Crc32_long , Left
               Crc32_long = Crc32_long + 110

               Text = Str(crc32_long)
               Text = Format(text , "0000000000000000")

               'Text = "NFC RC522 Demo  "
               Call Rc522_write(13)                         'write Data Sector 2 +1
               '--------------------
               Text = "(0010-0020-0030)"
               Call Rc522_write(14)                         'write Data Sector 2 +2
               '************************************
                Call Rc522_read(12)                         'read Data Sector 2 0
                Sector_one = "                "
                Sector_one = Str_data_16

                Call Rc522_read(13)                         'read Data Sector 2 +1
                Sector_two = "                "
                Sector_two = Str_data_16

                Call Rc522_read(14)                         'read Data Sector 2 +2
                Sector_tree = "                "
                Sector_tree = Str_data_16
               '************************************
              End If

            End If
     #endif
'*******************************************************************************
      Call Rc522_stop()                                     'Stop Auth Mode
      Call Rc522_halt()                                     'go to state Wait for new Card
     Waitms 500

     Do
       Call Is_card()
       Toggle Led

       'Print "tag2=" ; Tag_fount ; "   "

       If Tag_fount = 1 Then
          Call Anticoll()
          Call Rc522_stop()                                 'Stop Auth Mode
          Call Rc522_halt()
       End If

       Waitms 200
     Loop Until Tag_fount = 0

     Buzeer = 1 : Waitms 500 : Buzeer = 0
   Else
      'Print "No Chip fount"
   End If

   ' Call Rc522_halt()
   Waitms 400
   Toggle Led
Loop
End
'*******************************************************************************
'*******************************************************************************
' is Chip Card fount Call RC522 Request (Help Sub)
'*******************************************************************************
Sub Is_card()
   Call Rc522_request(&H26)                                 'PICC_REQIDL           0x26
End Sub
'*******************************************************************************
' Anti- collision detection , reading selected card serial number card
' only MIFARE Classic Chips 4Byte ID
'*******************************************************************************
Sub Anticoll()

   Call Write522(bitframingreg , &H00)                      'BitFramingReg         0x0D
   Rc522_buffer(1) = &H93                                   'PICC_ANTICOLL         0x93
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
   Call Write522(commienreg , Dum)                          'CommIEnReg CommIEnReg            0x02
   Call Clearbitmask(commirqreg , &H80)                     'CommIrqReg            0x04
   Call Setbitmask(fifolevelreg , &H80)                     '  Fifolevelreg 0x0a

   Call Write522(commandreg , &H00)                         'CommandReg 01, PCD_IDLE 00

   For Dum = 1 To Sendlen

      Call Write522(fifodatareg , Rc522_buffer(dum) )       'FIFODataReg           0x09
   Next

   Call Write522(commandreg , Command)

   If Command = Pcd_transceive Then
      Call Setbitmask(bitframingreg , &H80)                 'BitFramingReg         0x0D
   End If

   Timeout = 200
   Do
      Dum = Read522(commirqreg)                             'CommIrqReg            0x04
      Decr Timeout
      If Dum = Waitirq Then Exit Do                         'Waitirq
      ' If Dum = &H44 Then Exit Do
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
'*******************************************************************************
Sub Rc522_request(byval Reqmode As Byte)
   Tag_fount = 0
   Call Write522(bitframingreg , &H07)                      'BitFramingReg  = 0x0D
   Rc522_buffer(1) = Reqmode

   Call Rc522to_card(pcd_transceive , 1)

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
       'Print "Storage Volume KByte " ; Rc522_inbuffer(1)    'read card storage volume  /8
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
      'Print "Read Daten- " ; Block ; "("                    'Dump 16Byte Buffer

      Str_data_16 = "                "
      Str_data_16 = Trim(str_data_16)

      For Temp2 = 1 To 16
         'Print Chr(rc522_inbuffer(temp2)) ;
         Str_data_16 = Str_data_16 + Chr(rc522_inbuffer(temp2))
      Next


        Print "Block=(" ; Block ; ")" ; Str_data_16 ; "   "
   End If
End Sub
'*******************************************************************************
' Write data
' Block = Blockaddr or Blockaddr +1 or Blockaddr +2
' Blockaddr + 3 is Config Data from the - Warning: only write sector trailer when you know what you're doing
'*******************************************************************************
Sub Rc522_write(byval Block As Byte)
   Local Zbv As Byte
   Print "Write Data"
   Rc522_buffer(1) = &HA0                                   ' PICC_WRITE            0xA0
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
   Call Rc522to_card(pcd_transceive , 18)

End Sub
'*******************************************************************************
'Stop Auth Mode
'*******************************************************************************
Sub Rc522_stop()
   Call Clearbitmask(&H08 , &H08)                           'Status2Reg     = 0x08

End Sub