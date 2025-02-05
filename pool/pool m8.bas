$regfile = "m8def.dat"
$crystal = 11059200

$hwstack = 64
$swstack = 100
$framesize = 100
$baud = 9600



Configs:



        Config Timer0 = Timer , Prescale = 1024
        Start Timer0
        Config Timer1 = Timer , Prescale = 8
        'Start Timer1
        Enable Interrupts
        Enable Timer0
        On Timer0 T0rutin
        Enable Urxc
        On Urxc Rxin

Config Graphlcd = 128x64sed , Rst = Portd.2 , Cs1 = Portd.3 , _
A0 = Portd.4 , Si = Portc.5 , Sclk = Portc.4

'$include "FONT/farsi_func.bas"
$lib "glcd-Nokia5110.lib"


   Setfont Font5x5
 Initlcd
        Config 1wire = Portc.2
        Declare Sub Ds18b20
        Dim P As Byte
'Dim Tempok As Bit
'Dim Tmpread As Boolean
Dim Tmp1 As Integer
'Dim Tmp2 As Integer
Dim Ds18b20_id_1(9) As Byte
'Dim Ds18b20_id_2(8) As Byte
'Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
'Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6

'Dim Refreshtemp As Byte
Dim Readsens As Integer
Dim Dift As Integer


'Dim St1(10) As Integer
'Dim St2(10) As Integer
'Dim Alarmtemp As Byte
'Dim Sahih1 As Integer

'Dim Ashar1 As Integer


        Pg Alias Portc.1 : Config Portc.1 = Output
        Buz Alias Portd.5 : Config Portd.5 = Output
        Pump Alias Portd.6 : Config Portd.6 = Output
        Heater Alias Portd.7 : Config Portd.7 = Output
        Fan Alias Portb.0 : Config Portb.0 = Output
        _in Alias Pinb.2 : Config Portb.2 = Input
        'Learn Alias Pinc.4 : Config Portc.4 = Input
        Learn Alias Pinb.1 : Config Portb.1 = Input



Declare Sub Send_unicode(phone As String , Text As String)
Dim D(71) As Byte
Dim Sms As String * 70 At D Overlay
Dim Phone_number As String * 13
'Dim Enumbers(3) As Eram String * 13
'Dim Numbers(3) As String * 13
Dim Auth As Bit
Const Admin = "+989376921503"
Defines:


Declare Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
'Dht_put Alias Portc.3                                       'Sensor pins test
'Dht_get Alias Pinc.3
'Dht_io_set Alias Ddrc.3
Dht_put Alias Portc.5                                       'main Sensor pins
Dht_get Alias Pinc.5
Dht_io_set Alias Ddrc.5
Dim Pos As Byte
'Dim Temperature As String * 6 ,
Dim Humidity As String * 5
Dim Temp As Single , Hum As Single                          ', B As Byte
'Dim Gtemp As Single , Ghum As Single
'Dim Htemp As Single , Hhum As Single
'Dim Egtemp As Eram Single , Eghum As Eram Single

'Gtemp = Egtemp : Waitms 20
'Ghum = Eghum : Waitms 20
'Htemp = Gtemp - 2
'Hhum = Ghum - 2


Dim _sec As Byte , Lsec As Byte                             ', _min As Byte , _hour As Byte
Dim Bytee As Byte , Checksumm As Byte
        Dim Z As Byte
        Dim T As Byte

        Dim Firstt As Bit

        Dim I As Byte

        Dim Ss As Bit

        Dim S(24)as Word

        I = 0
        Dim Saddress As String * 20
        Dim Scode As String * 4
        Dim Address As Long
        Dim Code As Byte
        ''''''''''''''''''''''''''''''''
        Dim Ra As Long                                      'fp address
        Dim Rnumber As Byte                                 'remote know
        Dim Rnumber_e As Eram Byte
        Dim Okread As Bit
        Dim Error As Bit
        Dim Keycheck As Bit
                                           'check for pushing lean key time
        'Error = 0
        'Okread = 0
        'T = 0
        'Keycheck = 0
        Dim Raw As Byte
        'Dim T As Word                                       'check for pushing lean key time
        Error = 0
        Okread = 0
        T = 0
        Keycheck = 0

        'Dim M As String * 8
        'Dim M1 As String * 2
        'Dim M2 As String * 2
        'Dim M3 As String * 2
        'Dim Eaddress As Word                                'eeprom address variable
       ' Dim E_read As Byte
       ' Dim E_write As Byte
        Dim Eevar(50) As Eram Long

        Declare Sub _read
        Declare Sub Keylearn

   Dim Recive As String * 1
   Dim Pack As String * 300
   Dim F(6) As String * 20
   Dim Msg As String * 50
   'Dim Turn As Byte
   'Dim P As Byte
   Dim Num As String * 14
Startup:

        For I = 1 To 3
            'Numbers(i) = Enumbers(i)
            'Waitms 20
        Next
        Cls
       Lcdat 1 , 1 , "hi"
        Wait 2
        Cls

   Wait 10
   Print "ATE0"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   Print "AT"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   Print "AT+CMGF=1"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   'Print "AT+CSMP=17,167,0,0"
   Print "AT+CSMP=17,167,2,25"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   Print "AT+CMGDA=DEL ALL"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 5
   Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   Print "AT+CNMI=2,2,0,0,0"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   Print "AT"
   Wait 1
   Cls
   Initlcd
   Lcdat 1 , 1 , Pack
   Wait 1
   '(
   Print "AT+CMGS=" ; Chr(34) ; "09376921503" ; Chr(34)
   Waitms 250
   Print "Startup" ; Chr(26)
   Waitms 800
')
   Sms = "»—ﬁ Ê’· ‘œ"
   Num = Admin
   Call Send_unicode(num , Sms)
   Set Buz
   Waitms 250
   'reset buz
Main:

     Do
        If _sec <> Lsec Then
           Lsec = _sec
           Ds18b20
           'Initlcd
           'Cls
           'Lcdat 1 , 1 , Sens1
           'Lcdat 2,1,tmp1

          Z = Dht_read(hum , Temp)
            If Z = 0 Then
               'Print "error read sensor dht"
               'Lcdat 6 , 1 , Z ; "*" ; Bytee ; "*" ; Checksumm ; "  "
            Else
              Humidity = Fusing(hum , "#.#") + "%"
              Temperature = Fusing(temp , "#.#") + "C"      'Chr(248) '"C"

              'Lcdat 1 , 1 , Farsi(lookupstr(typ , Bird))
              'Lcdat 2 , 1 , Day ; "/" ; Gday
              'Lcdat 3 , 1 , _hour ; ":" ; _min ; ":" ; _sec
              'Lcdat 4 , 56 , Farsi( "œ„«")
              'Lcdat 5 , 42 , Farsi( "—ÿÊ» ")
              'Lcdat 4 , 1 , Temperature
              'Lcdat 5 , 1 , Humidity
              'Lcdat 6 , 1 , A
            End If
            '(
            If Firstt = 1 Then
               If Temp > Gtemp Then
                  Reset Firstt
                  Sms = "”Ì” „ ¬„«œÂ «” "
               End If
            End If
            If Ss = 1 Then
               Set Pump
               If Hum > Ghum Then Set Fan
               If Temp > Gtemp Then
                  Reset Heater
               End If
            Else
               Reset Heater
               Reset Pump
               Reset Fan

            End If

')
        End If
       'Set Buz
       'Waitms 100
       'Reset Buz
       'Wait 1

       'If _in = 1 Then Set Pg Else Reset Pg
       If Learn = 0 Then

          Waitms 50
          If Learn = 0 Then
                  'Set Buz
                  Do
                    Waitms 500
                    Incr I
                    If I = 4 Then Exit Do
                  Loop Until Learn = 1
                  Reset Buz
                  Waitms 500
                  If I < 2 Then
                     Keylearn
                  Else
                      Rnumber = 0
                      Rnumber_e = Rnumber
                      Waitms 10
                      'Set Buz
                      Waitms 500
                      Reset Buz
                      Wait 1
                      'Set Buz
                      Waitms 250
                      Reset Buz
                      Wait 1
                  End If
          End If
       End If
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
                           Set Buz
                           Waitms 100
                           Reset Buz
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
                              'Initlcd
                              'Cls
                              'Lcdat 1 , 1 , Num
                              'Wait 2
                              'Cls

                                 'If F(4) = Admin Or F(4) = Numbers(1) Or F(4) = Numbers(2) Or F(4) = Numbers(3) Then
                                    Set Auth
                                ' Else
                                  '  Reset Auth
                                ' End If
                                 'Toggle Fan
                                 F(4) = ""
                                 I = 0
                                 F(6) = ""
                                 For I = 0 To 100
                                     F(6) = Mid(pack , I , 2)
                                     If F(6) = "#@" Or F(6) = "T=" Or F(6) = "H=" Then
                                        Exit For
                                     End If
                                 Next
                                 F(5) = Mid(pack , I , 4)
                                 Print "AT+CMGDA=DEL ALL"
                                 Wait 5
                                 'Pack = ""
                                 'Msg = ""
                                 'Msg = "œ—Ì«›  ‘œ"

                                 Select Case F(5)
                                     Case "#@11"
                                           If Auth = 1 Then
                                              Set Ss
                                              Set Firstt
                                              Msg = "”Ì” „ —Ê‘‰ ‘œ"
                                           Else
                                              Msg = "‘„«—Â ‰«„⁄ »— «” !"
                                           End If
                                     Case "#@00"
                                           If Auth = 1 Then
                                              Reset Ss
                                              Msg = "”Ì” „ Œ«„Ê‘ ‘œ"
                                           Else
                                              Msg = "‘„«—Â ‰«„⁄ »— «” !"
                                           End If
                                     Case "#@$&"
                                     '(
                                          If Numbers(1) = "" Then
                                             Numbers(1) = Num
                                          Elseif Numbers(2) = "" Then
                                               Numbers(2) = Num
                                          Elseif Numbers(3) = "" Then
                                                 Numbers(3) = Num
                                          End If
                                          Enumbers(1) = Numbers(1) : Waitms 20
                                          Enumbers(2) = Numbers(2) : Waitms 20
                                          Enumbers(3) = Numbers(3) : Waitms 20
                                          ')
                                     Case "#@??"
                                           If Auth = 1 Then
                                              Msg = "œ„«Ì ¬» " + Chr(10)
                                              Msg = Msg + Sens1 + Chr(10)
                                              'Msg = Msg + Chr(10)
                                              Msg = "œ„«Ì „ÕÌÿ" + Chr(10)
                                              Msg = Msg + Temperature + Chr(10)
                                              'Msg = Msg + Chr(10)
                                              Msg = "—ÿÊ» " + Chr(10)
                                              Msg = Msg + Humidity + Chr(10)
                                              'Msg = Msg + Chr(10)
                                           Else
                                              Msg = "‘„«—Â ‰«„⁄ »— «” !"
                                           End If
                                     Case "#@De"
                                     '(
                                          Enumbers(1) = "" : Waitms 20
                                          Enumbers(2) = "" : Waitms 20
                                          Enumbers(3) = "" : Waitms 20
                                          Numbers(1) = "" : Waitms 20
                                          Numbers(2) = "" : Waitms 20
                                          Numbers(3) = "" : Waitms 20
                                          ')
                                     Case "#@EN"
                                     Case Else
                                           If Auth = 1 Then
                                              Msg = "ÅÌ«„ ‰«„⁄ »— «” "
                                           Else
                                              Msg = "‘„«—Â ‰«„⁄ »— «” !"
                                           End If
                                 End Select

                                 If Msg <> "" Then

                                        'Msg = "œ—Ì«›  ‘œ"
                                        Sms = Msg
                                        Call Send_unicode(num , Sms)
                                                              'End If
                                                                         Wait 2
                                                                         F(5) = ""
                                                                         Pack = ""
                                                                         Recive = ""
                                 Else
                                            Pack = ""
                                 End If
                           End If
                        End If
                        Pack = ""
            End If

            _read

     Loop


T0rutin:
        Incr T
        If T = 42 Then
           Incr _sec
           If _sec = 60 Then _sec = 0
           T = 0
           'Toggle Pg

        End If
Return

Sub _read
'(
     If _in = 1 Then
               Timer1 = 0
               Start Timer1
               While _in = 1
               If _in = 1 Then Set Pg Else Reset Pg
               Wend

               T1 = Timer1
               Timer1 = 0
               Start Timer1
               While _in = 0
               If _in = 1 Then Set Pg Else Reset Pg
               Wend
               T2 = Timer1
               Tt = T2 / T1
               Timer1 = 0
               Start Timer1
               If Tt >= 31 And Tt <= 33 Then
                  Set Buz
                  Waitms 250
                  Reset Buz
                  For I = 1 To 20

                      If _in = 1 Then
                         Timer1 = 0
                         Do
                         If _in = 1 Then Set Pg Else Reset Pg
                         Loop Until _in = 0
                         T1 = Timer1
                         Timer1 = 0
                         Do
                         If _in = 1 Then Set Pg Else Reset Pg
                         Loop Until _in = 1
                         T2 = Timer1
                         Timer1 = 0
                         Tt = T2 / T1
                         If T2 > T1 Then
                            Tt = T2 / T1
                            If Tt >= 2 And Tt <= 4 Then
                               s(i) = 0
                            Else
                                I = 0
                                Exit For
                            End If
                         Else
                             Tt = T1 / T2
                             If Tt >= 2 And Tt <= 4 Then
                                s(i) = 1
                             Else
                                 I = 0
                                 Exit For
                             End If
                         End If
                      End If
                  Next
                  If I = 20 Then Set okread Else Reset okread


               End If
     End If
')
   '(
           Okread = 0
      If _in = 1 Then
         Do
           If _in = 0 Then Exit Do
           Reset Watchdog
         Loop
         Timer1 = 0
         Start Timer1
         While _in = 0
         Reset Watchdog
         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
            Do
              If _in = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While _in = 1
                 Reset Watchdog
                 Wend
                 Stop Timer1
                 Incr I
                 S(i) = Timer1
              End If
              Reset Watchdog
              If I = 24 Then Exit Do
            Loop
            Reset Watchdog
            For I = 1 To 24
                Reset Watchdog
                If S(i) >= 332 And S(i) <= 972 Then
                   S(i) = 0
                Else
                    If S(i) >= 1111 And S(i) <= 2361 Then
                       S(i) = 1
                    Else
                        I = 0
                        Address = 0
                        Code = 0
                        Okread = 0
                        Return
                    End If
                End If
            Next
            I = 0
            Saddress = ""
            Scode = ""
            For I = 1 To 20
               Reset Watchdog
                Saddress = Saddress + Str(s(i))
            Next
            For I = 21 To 24
            Reset Watchdog
                Scode = Scode + Str(s(i))
            Next
            Address = Binval(saddress)
            Code = Binval(scode)
            Gosub Check
            'Set Buz
            'Waitms 250
            'Reset Buz
            Reset Watchdog
            I = 0
         End If
         Reset Watchdog
      End If
')
End Sub

Sub Keylearn
'(
Do
Gosub _read
If Okread = 1 Then
''''''''''''''''''''''repeat check
    If Rnumber = 0 Then                                     ' agar avalin remote as ke learn mishavad
        Incr Rnumber
        Rnumber_e = Rnumber
        Waitms 10
        Ra = Address
        Eevar(rnumber) = Ra
        Waitms 10
        Exit Do
    Else                                                    'address avalin khane baraye zakhire address remote
        For I = 1 To Rnumber
            Ra = Eevar(i)
            If Ra = Address Then                            'agar address remote tekrari bod yani ghablan learn shode
               'Set Buz
               Wait 1
               Reset Buz
               Error = 1
               Exit For
            Else
                Error = 0
            End If
        Next
        If Error = 0 Then                                   ' agar tekrari nabod
           Incr Rnumber                                     'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
           If Rnumber > 100 Then                            'agar bishtar az 100 remote learn shavad
              Rnumber = 100
              'Set Buz
              Wait 2
              Reset Buz
           Else                                             'agar kamtar az 100 remote bod
              Rnumber_e = Rnumber                           'meghdare rnumber ra dar eeprom zakhore mikonad
              Ra = Address
              Eevar(rnumber) = Ra
              Waitms 10
           End If
        End If
    End If
    Exit Do
End If
Loop
Okread = 0
    ')
End Sub
'========================================================================= CHECK
Check:
'(
Okread = 1
If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
   For I = 1 To Rnumber
      Ra = Eevar(i)
      If Ra = Address Then                                  'code
            Gosub Command

            Exit For
      End If
   Next
End If
Keycheck = 0
')
Return
'-------------------------------- Relay command
Command:
'(

        If Code = 1 Then
           Set Ss
           Sms = "”Ì” „ »« —Ì„Ê  ›⁄«· ‘œ"
        Elseif Code = 2 Then
           Reset Ss
           Sms = "”Ì” „ »« —Ì„Ê  €Ì—›⁄«· ‘œ"
        End If
        Set Buz
        Waitms 100
        Reset Buz
        Waitms 100
        Num = Admin
        Call Send_unicode(num , Sms)

    ')
Return


Sub Ds18b20
'(
   Incr P
   If P > 12 Then P = 1
   'reset watchdog
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(2)
   1wwrite &HBE
   Readsens = 1wread(2)


      Gosub Conversion
      Sens1 = Temperature
      Tmp1 = Val(sens1)


         'If Readsens < 0 Then Readsens = Readsens * -1
         'Sahih1 = 0
         'If Readsens > 9 Then
           ' Sahih1 = Readsens / 10
           ' Ashar1 = Readsens Mod 10
        ' End If

    ')

End Sub

Conversion:
'(
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
   ')
Return

Function Dht_read(dht_hum As Single , Dht_temp As Single) As Byte
  '(

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
')
End Function

Rxin:
     Toggle Pg
     Recive = Inkey()
     Pack = Pack + Recive
     Recive = ""
Return

Sub Send_unicode(phone As String , Text As String)
    Local Str_len As Byte , Index As Byte , I As Byte
    Str_len = Len(text)
    Print "AT+CMGF=1"
    Waitms 200
    Print "AT+CSCS=" ; Chr(34) ; "HEX" ; Chr(34)
    Waitms 200
    Print "AT+CSMP=49,167,0,8"
    Waitms 200
    Print "AT+CMGS=" ; Chr(34) ; Phone ; Chr(34)
    Waitms 200
    For I = 1 To Str_len
        If D(i) > 127 Then
           Index = Lookdown(d(i) , Ascii , 37)
           If Index <> -1 Then
              Index = Index - 1
              If S(i) = 176 Then
                 Print "00" ; Hex(lookup(index , Unicode)) ;
              Else
                  Print "06" ; Hex(lookup(index , Unicode)) ;
              End If
           End If
        Elseif D(i) >= &H30 And D(i) <= &H39 Then
           D(i) = D(i) + &H30
           Print "06" ; Hex(d(i));
        Else
            Print "00" ; Hex(d(i));
        End If
    Next
    Print Chr(26)
    Wait 5
    Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
    Waitms 200
    'Print "AT+CSMP=17,167,0,16"
    Print "AT+CSMP=17,167,2,25"
    Waitms 200
End Sub



End

'$lib "glcd-Nokia5110.lib"
'$include "FONT/farsi_map.bas"
  $include "FONT/font5x5.font"

  Ascii:
'data "«" , "»" , "Å" , " " , "À" , "Ã" , "ç" , "Õ" , "Œ" , "œ" , "–" , "—" , "“" , "é" , "”" , "‘" , "’" , "÷" , "ÿ" , "Ÿ" , "⁄" , "€" , "›" , "ﬁ" , "ò" , "ò" , "ê" , "·" , "„" , "‰" , "Â" , "Ê" , "Ì" , "¬" , "°" , "Ì" , "∞"
Data 199 , 200 , 129 , 202 , 203 , 204 , 141 , 205 , 206 , 207 , 208 , 209 , 210 , 142 , 211 , 212 , 213 , 214 , 216 , 217 , 218 , 219 , 221 , 222 , 152 , 223 , 144 , 225 , 227 , 228 , 229 , 230 , 237 , 194 , 161 , 236 , 176
Unicode:
Data &H27 , &H28 , &H7E , &H2A , &H2B , &H2C , &H86 , &H2D , &H2E , &H2F , &H30 , &H31 , &H32 , &H98 , &H33 , &H34 , &H35 , &H36 , &H37 , &H38 , &H39 , &H3A , &H41 , &H42 , &HA9 , &H43 , &HAF , &H44 , &H45 , &H46 , &H47 , &H48 , &H4A , &H22 , &H0C , &H49 , &HB0