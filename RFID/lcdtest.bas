
$regfile = "m8def.dat"
$crystal = 11059200

'$hwstack = 250
'$swstack = 150
'$framesize = 200
'$baud = 9600
RFConfigs:
Config Spi = Hard , Interrupt = Off , Data Order = Msb , Master = Yes , Polarity = low , Phase = 0 , Clockrate = 16 , Noss =1
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



defines:
$lib "glcdKS108.lib"
Config Graphlcd = 128 * 64sed , Dataport = Portd , Controlport = Portc , Ce = 1 , Ce2 = 0 , Cd = 5 , Rd = 4 , Reset = 2 , Enable = 3



'$include "font8x8tt.font"
setfont font8x8



'$include "font8x8tt.font"
'setfont font16x16

config portd=OUTPUT
config portc=OUTPUT
Cs_pn alias portb.2   ' ,config portb.2=OUTPUT


'irq alias pinb.0:config portb.0=input
dim b as bit
Declare Sub Rc522_request(byval Reqmode As Byte)
Declare Sub Is_card()
Declare Sub Rc522_write(byval Block As Byte)
Declare Sub Write522(byval Addr As Byte , Byval Daten As Byte)
Declare Sub Rc522to_card(byval Command As Byte , Byval Sendlen As Byte)
Declare Sub Setbitmask(byval Reg As Byte , Byval Mask As Byte)
Declare Sub Clearbitmask(byval Reg As Byte , Byval Mask As Byte)

do
  cls
  waitms 500
  lcdat 1,1,"Hi",0


  lcdat 3,1,b
  wait 3
loop

end


Sub Is_card()
   Call Rc522_request(&H26)                                 'PICC_REQIDL           0x26
End Sub

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

Sub Write522(byval Addr As Byte , Byval Daten As Byte)
   Shift Addr , Left , 1
   Addr = Addr And &H7E                                     '0XXXXXX0
   Reset Cs_pn
   Spiout Addr , 1
   Spiout Daten , 1
   Set Cs_pn
End Sub

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

'$include "font16x16.font"
 $include "font8x8.font"
