$regfile = "m8def.dat"
$crystal = 11059200
$hwstack = 150
$swstack = 150
$framesize = 200
$baud = 9600


Const Read_write = 1                                        ' 0= only Read TAG ID  1=Read and Write Data to Card

'*******************************************************************************
taghere alias portd.7:config taghere=output
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

'*******************************************************************************

'*******************************************************************************
'*******************************************************************************
   Reset Rst522
   Waitms 100
   Set Rst522

main:

wait 1


   Waitms 500
   Call Write522(&H2a , &H8D)

   read522


end

Sub Write522(byval Addr As Byte , Byval Daten As Byte)
   Shift Addr , Left , 1
   Addr = Addr And &H7E                                     '0XXXXXX0
   Reset Cs_pn
   Spiout Addr , 1
   Spiout Daten , 1
   Set Cs_pn
End Sub

Function Read522(byval Addre As Byte) As Byte
   Shift Addre , Left , 1
   Addre = Addre And &H7E                                   '1XXXXXX0
   Addre = Addre Or &H80

   Reset Cs_pn
   Spiout Addre , 1
   Spiin Read522 , 1
   Set Cs_pn
End Function