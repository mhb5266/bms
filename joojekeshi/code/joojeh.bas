
   $regfile = "m32def.dat"
   $crystal = 11059200

   $hwstack = 80
   $swstack = 100
   $framesize = 100
   $baud = 9600

Configs:

   Config Timer1 = Timer , Prescale = 256 : Timer1 = 22335  ' Timer1 = 34285

   Enable Interrupts
   Enable Urxc
   'Enable Utxc
   On Urxc Rxin
   Enable Timer1
   On Timer1 T1rutin

   'Enable Int0
   'Config Int0 = Rising
   'On Int0 Ispower


   'Enable Urxc
   'On Urxc Getline
   '(
   Config Lcdpin = Pin , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
   Config Lcd = 16x2
   Cursor Off
')
   Config Portd.5 = Output : Pg Alias Portd.5
   Config Portd.6 = Input : K1 Alias Pind.6
   Config Portd.7 = Input : K2 Alias Pind.7

$include "FONT/farsi_func.bas"
$lib "glcd-Nokia5110.lib"
'1.RST
'2.CE-------CS1
'3.DC  -----A0
'4.DIN -----Si
'5.CLK -----SCLK
'6.VCC------3.3V
'7.BL ------3.3V
'8.GND
'Config Graphlcd = 128x64sed , Rst = Portc.1 , Cs1 = Portc.0 , _
'A0 = Portc.2 , Si = Portc.3 , Sclk = Portc.4
Config Graphlcd = 128x64sed , Rst = Portc.7 , Cs1 = Portc.6 , _
A0 = Portc.5 , Si = Portc.4 , Sclk = Portc.3
' Rst & Cs1 is optional
Const Contrast_lcd = 72
'Contrast 0 to 127, if not defined - 72
'Const Negative_lcd = 1       'Inverting screen
'Const Rotate_lcd = 1          'Rotate screen to 180∞
Initlcd
Cls

Heater Alias Portd.3 : Config Portd.3 = Output
Motor Alias Portd.4 : Config Portd.4 = Output
Fan Alias Portd.5 : Config Portd.5 = Output
Led Alias Portd.6 : Config Portd.6 = Output
Emfan Alias Portd.7 : Config Portd.7 = Output
Buz Alias Portc.1 : Config Portc.1 = Output
Humid Alias Portc.2 : Config Portc.2 = Output

Defines:
   Dim A As Byte
   Dim Text As String * 10
   Dim Ii As Byte
   Dim I As Byte
   Dim Hang As Dword
   Dim Etyp As Eram Byte
   Dim Eday As Eram Byte
   Dim Z As Byte
   Dim Typ As Byte : Typ = Etyp : Waitms 50

   Dim Recive As String * 1
   Dim Pack As String * 300
   Dim F(6) As String * 20

   Dim Day As Byte : Day = Eday : Waitms 50 : If Day > 100 Then Day = 0
   Dim Gday As Byte

   Dim Msg As String * 50
   Dim Turn As Byte
   Dim P As Byte
   Dim Num As String * 14
'(
   pinb.1
    Incr A
    Lcd A
    Waitms 500
    Cls

   Loop
')
Subs:
Declare Sub Getline

Dim Inmsg As String * 70 : Dim Gps As Byte : Dim Datain As String * 50
Declare Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
Dht_put Alias Porta.0                                       'Sensor pins
Dht_get Alias Pina.0
Dht_io_set Alias Ddra.0

'Dht_put Alias Portb.0                                       'Sensor pins
'Dht_get Alias Pinb.0
'Dht_io_set Alias Ddrb.0
Dim Pos As Byte
Dim Temperature As String * 6 , Humidity As String * 5
Dim Temp As Single , Hum As Single , B As Byte
Dim _sec As Byte , Lsec As Byte , _min As Byte , _hour As Byte
Dim Bytee As Byte , Checksumm As Byte
Startup:

   Stop Timer1
   Setfont Font8x8

   Cls
   Lcdat 1 , 1 , "HI"
   Wait 5
   Cls


   Start Timer1
   Timer1 = 34285
   Typ = 0
   '(
   If Typ > 20 Then
      Typ = 0
      Lcdat 1 , 72 , "^"
      Lcdat 2 , 1 , Farsi(lookupstr(typ , Bird))

      pinb.1

      If K1 = 0 Then
         Waitms 50
         If K1 = 0 Then
            Incr Typ
            If Typ > 19 Then Typ = 0
                  Cls
                  Lcdat 1 , 72 , "^"
                  Lcdat 2 , 1 , Farsi(lookupstr(typ , Bird))

         End If
         pinb.1
         Loop Until K1 = 1
      End If
      If K2 = 0 Then
         Waitms 50
         If K2 = 0 Then
            Etyp = Typ
            Waitms 50
            Exit pinb.1
         End If
      End If

      Loop

   End If
')
   Gday = Lookup(typ , Period)
   Cls
   Lcdat 1 , 1 , Farsi(lookupstr(typ , Bird)) , 1
   Wait 5

   Cls

   Print "ATE0"
   Lcdat 1 , 1 , "ATE0"
   Wait 1

   Print "AT"
   Lcdat 1 , 1 , "AT"
   Wait 1

   Print "AT+CMGF=1"
   Lcdat 1 , 1 , "AT+CMGF=1"
   Wait 1
   Initlcd
   Cls
   'Print "AT+CSMP=17,167,0,0"
   Print "AT+CSMP=17,167,2,25"
   Wait 1
   Lcdat 1 , 1 , "CSMP"
   Wait 1
   Initlcd
   Cls
   Print "AT+CMGDA=DEL ALL"
   Wait 5
   Lcdat 1 , 1 , "DEL ALL"
   Wait 1
   Initlcd
   Cls
   Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Wait 1
   Lcdat 1 , 1 , "GSM"
   Wait 1
   Initlcd
   Cls
   Print "AT+CNMI=2,2,0,0,0"
   Wait 1
   Lcdat 1 , 1 , "CNMI"
   Wait 1
   Initlcd
   Cls
   Print "AT"
   Wait 1
      Lcdat 1 , 1 , "AT"
      Wait 1

   'Print "ATD+989376921503;"

   'Wait 10



 '  Print "ATE0"
 '  Clearbuf
   '(
    Turn = 0
    pinb.1
             If _sec <> Lsec Then
                Lsec = _sec
                Incr Turn
                Select Case Turn
                 Case 1
                      Msg = "ATE0"
                 Case 2
                      Msg = "AT"
                 Case 4
                      Msg = "AT+CMGF=1"
                 Case 6
                      Msg = "AT+CSMP=17,167,0,16"
                 Case 8
                      Msg = "AT+CNMI=0,1,2,0,0"
                 Case 10
                      Msg = "AT"
                 Case 12
                      Exit Do
                 Case Else
                      Msg = ""
                End Select
                If Msg <> "" Then Print Msg
                Lcdat 1 , 1 , Msg
                Lcdat 2 , 1 , Datain
                Lcdat 4 , 1 , Turn
                Initlcd
             End If

                  Do
                    A = Ischarwaiting()
                    If A > 0 Then Exit Do
                    Incr Hang
                    If Hang > 22059200 Then Exit Do
                  Loop
                  If A > 0 Then Getline

    Loop
')
   'Simconfig
   '(
   Do
   'Cls
     Inmsg = ""
     Clearbuf
     'B = I Mod 2
     Incr Turn
     If Turn > 6 Then Turn = 1
     If Turn = 1 Then Msg = "AT"
             If Turn = 2 Then Msg = "AT+CMGF=1"
               If Turn = 3 Then Msg = "AT+CSMP=17,167,0,16"
                 If Turn = 4 Then Msg = "AT+CNMI=0,1,2,0,0"
                 If Turn = 5 Then Msg = "AT+CSCS=" + Chr(34) + "GSM" + Chr(34)
     If Turn = 6 Then Exit Do                               ' "AT+CSQ"
     Print Msg
     Hang = 0
     Do
       A = Ischarwaiting()
       If A > 0 Then Exit Do
       Incr Hang
       If Hang > 22059200 Then Exit Do
     Loop
     If A > 0 Then Getline
     'Getline
     'Do
       Lcdat 1 , 1 , Msg ; "%"
       Lcdat 2 , 1 , Datain ; "%"
       If Datain = "OK" Then Toggle Heater
       Lcdat 4 , 1 , I
       If A = 0 Then Lcdat 5 , 1 , "ERROR"
       Initlcd
      Wait 1
       Datain = Inmsg
       'If Datain <> "" Then Exit Do
     'Loop
     Datain = Inmsg
     Incr I


   Loop
   Print "AT+CMGS=" ; Chr(34) ; "09376921503" ; Chr(34)
   Do
       A = Ischarwaiting()
       If A > 0 Then Exit Do
       Incr Hang
       If Hang > 22059200 Then Exit Do
   Loop
   If A > 0 Then Getline
   If Datain = ">" Then
      Print "POWER ON" ; Chr(26)
   End If
')

      'Print "AT+CMGS=" ; Chr(34) ; "09376921503" ; Chr(34)
      'Waitms 250
      'Print "Startup" ; Chr(26)
      'Waitms 800
  Initlcd
  Cls
  Lcdat 1 , 1 , "ready!"
  Wait 3
  Cls
  Pack = ""
Main:
               Initlcd
            Cls
   Do

     'Wait 3

      If _sec <> Lsec Then
            Lsec = _sec
            'Initlcd
            'Cls

            If Pack <> "" Then
               Initlcd
               Cls
               Lcdat 1 , 1 , Pack
               Wait 2
               Cls

           ' Wait 2
            'Toggle Fan
            For I = 1 To 10
                F(6) = Mid(pack , I , 1)
                If F(6) = "+" Then
                   'Toggle Fan
                   Exit For
                End If
            Next
            F(1) = Mid(pack , I , 5)
            I = I + 5
            F(2) = Mid(pack , I , 5)
            F(3) = F(1) + F(2)
            'Initlcd
            'Cls
            'Lcdat 1 , 1 , F(3)
            'Wait 2
            I = 0
                        If F(1) = "+CMT:" Then
                           'Cls
                           F(1) = ""
                           Print "AT+CMGR=1"
                           'Lcdat 1 , 1 , "AT+CMGR=1"
                           'Wait 1
                           F(6) = ""
                           Pack = Ucase(pack)
                           For I = 1 To 100
                               F(6) = Mid(pack , I , 3)
                               If F(6) = "+98" Then
                                  Exit For
                               End If
                           Next
                           F(4) = Mid(pack , I , 13)
                           Pos = Instr(f(4) , "+98")
                           If Pos = 1 Then
                              Num = F(4)
                           'If F(4) = "+989376921503" Then
                              'Toggle Fan
                              F(4) = ""
                              I = 0
                              F(6) = ""
                              For I = 0 To 100
                                  F(6) = Mid(pack , I , 2)
                                  If F(6) = "#L" Then
                                     Exit For
                                  End If
                              Next
                              F(5) = Mid(pack , I , 5)
                              Print "AT+CMGDA=DEL ALL"
                              Wait 5
                              Pack = ""
                              Msg = ""
                              Select Case F(5)
                                     Case "#L1ON"
                                           Set Fan
                                     Case "#L1OF"
                                           Reset Fan
                                     Case "#L2ON"
                                           Set Motor
                                     Case "#L2OF"
                                           Reset Motor
                                     Case "#L???"
                                           Msg = "T= " + Temperature
                                           Msg = Msg + Chr(10)
                                           Msg = Msg + "H= "
                                           Msg = Msg + Humidity
                                           Msg = Msg + Chr(10)
                                     Case Else
                                          Msg = "wrong msg!!!"
                              End Select
                              If Msg <> "" Then
                                    Print "AT+CMGS=" ; Chr(34) ; Num ; Chr(34)
                                    'Print "AT+CMGS=" ; Chr(34) ; "+989376921503" ; Chr(34)
                                    Waitms 250
                                    Print Msg ; Chr(26)
                                    Waitms 800
                                    Initlcd
                                    Cls
                              End If
                              Wait 2
                              F(5) = ""
                              Pack = ""
                              Recive = ""
                           End If
                        Else
                            Pack = ""
                        End If

            End If
            Hum = Hum + 0.1
            If Hum > 33 Or Hum < 26 Then Hum = 26
            If Temp > 26 Or Temp < 21 Then Temp = 21
            Temp = Temp + 0.1
            Humidity = Fusing(hum , "#.#") + "%"
            Temperature = Fusing(temp , "#.#") + "C"        'Chr(248) '"C"


              Cls
              Lcdat 1 , 1 , Farsi(lookupstr(typ , Bird))
              Lcdat 2 , 1 , Day ; "/" ; Gday
              Lcdat 3 , 1 , _hour ; ":" ; _min ; ":" ; _sec
              Lcdat 4 , 56 , Farsi( "œ„«")
              Lcdat 5 , 42 , Farsi( "—ÿÊ» ")
              Lcdat 4 , 1 , Temperature
              Lcdat 5 , 1 , Humidity
              Lcdat 6 , 1 , A
            '(

            Incr A
            Initlcd
            Cls
            Lcdat 6 , 1 , A
            'Lsec = _sec

            Z = Dht_read(hum , Temp)
            If Z = 0 Then
               'Print "error read sensor dht"
               Lcdat 6 , 1 , Z ; "*" ; Bytee ; "*" ; Checksumm ; "  "
            Else

              Humidity = Fusing(hum , "#.#") + "%"
              Temperature = Fusing(temp , "#.#") + "C"      'Chr(248) '"C"
              Cls
              Lcdat 1 , 1 , Farsi(lookupstr(typ , Bird))
              Lcdat 2 , 1 , Day ; "/" ; Gday
              Lcdat 3 , 1 , _hour ; ":" ; _min ; ":" ; _sec
              Lcdat 4 , 56 , Farsi( "œ„«")
              Lcdat 5 , 42 , Farsi( "—ÿÊ» ")
              Lcdat 4 , 1 , Temperature
              Lcdat 5 , 1 , Humidity
              Lcdat 6 , 1 , A                               '; "*" ; Bytee ; "*" ; Checksumm ; "  "
            I = Ii
            'Text = Lookupstr(i , Typ)
            'Lcdat 3 , 1 , Farsi(text)
            'Lcdat 3 , 1 , Farsi(lookupstr(i , Bird))
            'Lcdat 5 , 1 , Ii
            '             Incr Ii
            'If Ii > 19 Then Ii = 0
              'Lcd Temperature
              'Lowerline
              'Lcd Humidity ; "  " ; _sec ; "   "
              'Print "Temp=" ; Temperature ; "    ";
              'Print "Hum=" ; Humidity
              'Print "type sensor : dht" ; Str(b)
            End If
')
      End If

   Loop


End

T1rutin:
        Toggle Heater
        Timer1 = 22335                                      ' 34285
        Incr _sec
        Initlcd
        Cls
        Lcdat 6 , 42 , _sec
        If _sec = 60 Then
           _sec = 0
           Incr _min
           If _min = 60 Then
              _min = 0
              Incr _hour
              If _hour = 24 Then
                 _hour = 0
                 Incr Day
              End If                                        '
           End If
        End If
Return

Ispower:
        Incr P
        If P = 100 Then
           'Toggle Fan
           P = 1
        End If
Return


Sub Getline
 Hang = 0
 Inmsg = ""
 Do

  Gps = Inkey()
  If Gps = 0 Then Incr Hang
  If Hang > 11059200 Then Exit Do
  If Gps > 0 Then
    Hang = 0                                                '++++++++++++++++++++++++++++++++++++++++++
    Select Case Gps
           Case 13
                 If Inmsg <> "" Then Exit Do                ' if we have received something'+++++++++++++++++
           Case 10
                 If Inmsg <> "" Then Exit Do                ' if we have received something '++++++++++++++++++++
           Case Else
                Inmsg = Inmsg + Chr(gps)                    ' build string
    End Select
  End If

 Loop
 Datain = Inmsg
End Sub




Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
         Local Number_dht As Byte , Byte_dht As Byte
         Local Hum_msb As Byte , Hum_lsb As Byte , Temp_msb As Byte , Temp_lsb As Byte , Check_sum As Byte
         Set Dht_io_set                                     'bus is output
         Reset Dht_put : Waitms 1                           'bus=0
         Set Dht_put : Waitus 40                            'bus=1
         Reset Dht_io_set : Waitus 40                       'bus is input
         If Dht_get = 1 Then                                'not DHT22?
            Goto Dht11_check                                'try DHT11
         Else
            Waitus 80
            If Dht_get = 0 Then
               Dht_read = 0                                 'DHT22 not response!!!
               Exit Function
            Else
               Dht_read = 22                                'really DHT22
               Goto Read_dht_data
            End If
         End If
         Dht11_check:
         Set Dht_io_set                                     'bus is output
         Reset Dht_put : Waitms 20                          'bus=0
         Set Dht_put : Waitus 40                            'bus=1
         Reset Dht_io_set : Waitus 40                       'bus is input
         If Dht_get = 1 Then
            Dht_read = 0                                    'DHT11 not response!!!
            Exit Function
         End If
         Waitus 80
         If Dht_get = 0 Then
             Dht_read = 0                                   'DHT11 not response!!!
            Exit Function
         Else
            Dht_read = 11                                   'really DHT11
         End If
         Read_dht_data:
         Bitwait Dht_get , Reset                            'wait for transmission
         For Number_dht = 1 To 5
            For Byte_dht = 7 To 0 Step -1
               Bitwait Dht_get , Set
               Waitus 35
               If Dht_get = 1 Then
               Select Case Number_dht
               Case 1 : Hum_msb.byte_dht = 1
               Case 2 : Hum_lsb.byte_dht = 1
               Case 3 : Temp_msb.byte_dht = 1
               Case 4 : Temp_lsb.byte_dht = 1
               Case 5 : Check_sum.byte_dht = 1
               End Select
                  Bitwait Dht_get , Reset
               Else
               Select Case Number_dht
               Case 1 : Hum_msb.byte_dht = 0
               Case 2 : Hum_lsb.byte_dht = 0
               Case 3 : Temp_msb.byte_dht = 0
               Case 4 : Temp_lsb.byte_dht = 0
               Case 5 : Check_sum.byte_dht = 0
               End Select
               End If
            Next
         Next
         Set Dht_io_set : Set Dht_put
         If Dht_read = 22 Then                              'CRC check
            Byte_dht = Hum_msb + Hum_lsb
            Byte_dht = Byte_dht + Temp_msb
            Byte_dht = Byte_dht + Temp_lsb
         Else
            Byte_dht = Hum_msb + Temp_msb
         End If
            Bytee = Byte_dht
            Checksumm = Check_sum
         If Byte_dht = Check_sum Then
            If Dht_read = 22 Then
               Dht_hum = Hum_msb * 256
               Dht_hum = Dht_hum + Hum_lsb
               Dht_hum = Dht_hum / 10
               Dht_temp = Temp_msb * 256
               Dht_temp = Dht_temp + Temp_lsb
               Dht_temp = Dht_temp / 10
               If Temp_msb.7 = 1 Then
               Dht_temp = Dht_temp * -1
               End If
            Elseif Dht_read = 11 Then
               Dht_temp = Temp_msb
               Dht_hum = Hum_msb
            End If
         Else
             Dht_read = 0                                   'CRC error!!!
         End If
End Function

Rxin:
     'Toggle Motor
     Recive = Inkey()
     Pack = Pack + Recive
     Recive = ""
Return

Pic:
'$bgf "image/graph.bgf"
$include "FONT/farsi_map.bas"

 ' $include "FONT/font5x5.font"
 ' $include "FONT/font5x12.font"
 ' $include "FONT/font6x8.font"                              ' œ«—«Ì ›Ê‰  ›«—”Ì
 ' $include "FONT/font6x10.font"
 ' $include "FONT/font7x11TT.font"
 ' $include "FONT/font7x12.font"
  $include "FONT/font8x8.font"                              ' œ«—«Ì ›Ê‰  ›«—”Ì
 ' $include "FONT/font8x12.font"
 ' $include "FONT/font8x13TT.font"
 ' $include "FONT/font8x14TT.font"
 ' $include "FONT/font10x16TT.font"
 ' $include "FONT/my12_16.font"
 ' $include "FONT/font12x16dig.font"                         '›ﬁÿ ›Ê‰  «—ﬁ«„ œ«—œ
 ' $include "FONT/font16x16.font"





 Bird:

 Data "„—€       " , "»Êﬁ·„Ê‰   " , "«—œò      " , "€«“       " , "»·œ—çÌ‰   " , "ﬁ—ﬁ«Ê·    " , "‘ —„—€    " , "ò»ò       " , "ò»Ê —     " , "ﬁÊ        " , "„—€ ⁄‘ﬁ   " , "„—€ „Ì‰«  " , "⁄—Ê” Â·‰œÌ" , "ò«”òÊ     " , "ò«ò«œÊ    " , "„«ò«∆Ê    " , "›‰ç       " , "ﬁ‰«—Ì     " , "ÿ«ÊÊ”     " , "„—€ êÌ‰Â  "
  'Data "dfgd" , "dgdfg" , "dgfgdg" , "dggd" , "dfgfd" , "dgdgd" , "dgdgf" , "dfg" , "dgdg" , "gf" , "dfgf dd" , "dfgg dfg" , "fdgfgf ddg" , "dgdgf" , "dfgfg" , "fdd" , "dgf" , "dfgdf" , "dfgg" , "dgfdfg dfd dfgf"
 Tmpgh:

 Data 37.5 , 38 , 38 , 38 , 37.7 , 37.6 , 36.3 , 37.5 , 37.5 , 37.5 , 37.5 , 38 , 37.5 , 37.5 , 37.5 , 37.5 , 37.5 , 38 , 37.7 , 37.5

 Tmpgs:

 Data 37.2 , 37.2 , 37.2 , 37.2 , 37.2 , 37.2 , 36.6 , 37 , 37 , 37 , 37.2 , 37.5 , , 37.2 , 37.2 , 37.2 , 37.2 , 37.2 , 37.2 , 37.2 , 37.2

 Humgh:

 Data 70 , 70 , 75 , 75 , 70 , 75 , 30 , 70 , 70 , 75 , 75 , 70 , 70 , 75 , 75 , 75 , 70 , 72 , 75 , 65

 Humgs:

 Data 60 , 60 , 65 , 65 , 65 , 65 , 25 , 60 , 60 , 65 , 63 , 60 , 60 , 63 , 60 , 63 , 58 , 60 , 65 , 60

 Period:

 Data 21 , 28 , 28 , 30 , 17 , 25 , 42 , 24 , 18 , 38 , 19 , 18 , 21 , 28 , 30 , 26 , 13 , 14 , 29 , 27