$regfile = "m328def.dat"
$crystal = 11059200

$hwstack = 128
$swstack = 200
$framesize = 200
$baud = 9600




Configs:

        Enable Interrupts
        Enable Timer0
        Enable Urxc

        Config Timer0 = Timer , Prescale = 1024
        Start Timer0
        Config Timer1 = Timer , Prescale = 8
        Start Timer1

        On Urxc Rxin
        On Timer0 T0rutin


'Config Graphlcd = 128x64sed , Rst = Portd.2 , Cs1 = Portd.3 , _
'A0 = Portd.4 , Si = Portc.5 , Sclk = Portc.4

'$include "FONT/farsi_func.bas"
'$lib "glcd-Nokia5110.lib"


  ' Setfont Font5x5
 'Initlcd
        Config 1wire = Portc.2
        Declare Sub Ds18b20
        Dim P As Byte
'Dim Tempok As Bit
'Dim Tmpread As Boolean
Dim Tmp1 As Single , Ltsensor As Single

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
Dim Tsensor As Single

'Dim St1(10) As Integer
'Dim St2(10) As Integer
'Dim Alarmtemp As Byte
'Dim Sahih1 As Integer

'Dim Ashar1 As Integer

        Ind Alias Portc.3 : Config Portc.3 = Output
        Pg Alias Portc.1 : Config Portc.1 = Output
        Buz Alias Portd.5 : Config Portd.5 = Output
        Pump Alias Portd.6 : Config Portd.6 = Output
        Heater Alias Portd.7 : Config Portd.7 = Output
        Fan Alias Portb.0 : Config Portb.0 = Output
        _in Alias Pinb.2 : Config Portb.2 = Input
        Learn Alias Pinc.4 : Config Portc.4 = Input
        Green Alias Portb.1 : Config Portb.1 = Output



Declare Sub Send_unicode(phone As String , Text As String)
Dim D(71) As Byte
Dim Sms As String * 70 At D Overlay
'Dim Phone_number As String * 13
Dim Euser1 As Eram String * 13
Dim Euser2 As Eram String * 13
Dim Euser3 As Eram String * 13
Dim User1 As String * 13
Dim User2 As String * 13
Dim User3 As String * 13
Dim Auth As Bit
Const Admin1 = "+989376921503"
Const Admin2 = "+989155191622"
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
Dim Gtemp As Single , Ghum As Single
Dim Htemp As Single , Hhum As Single
Dim Egtemp As Eram Single , Eghum As Eram Single




Dim _sec As Byte , Lsec As Byte                             ', _min As Byte , _hour As Byte
Dim _min As Byte , _hour As Byte
Dim Ontime As Dword
Dim Bytee As Byte , Checksumm As Byte
        Dim Z As Byte
        Dim T As Byte
        'Dim T1 As Word
        'Dim T2 As Word
        'Dim Tt As Word
        Dim Firstt As Bit
        Dim Wt As Byte
        Dim I As Byte
        Dim W As Byte
        Dim Ss As Byte
        Dim Ess As Eram Byte
        Ss = Ess
        Waitms 20
        If Ss = 255 Then
           Ss = 0
           Ess = 0
           Waitms 20
        End If
        Dim Error As Byte
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
        Rnumber = Rnumber_e : Waitms 20
        Dim Okread As Bit
        Dim Errors As Bit
        Dim Keycheck As Bit
        Dim X As Byte
        Dim Flag As Bit
                                           'check for pushing lean key time
        'errors = 0
        'Okread = 0
        'T = 0
        'Keycheck = 0
        Dim Raw As Byte
        'Dim T As Word                                       'check for pushing lean key time
        Errors = 0
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
        Declare Sub Simcheck
   Dim Recive As String * 1
   Dim Pack As String * 300
   Dim F(6) As String * 20
   Dim Msg As String * 50
   'Dim Msg2 As String * 50
   'Dim Msg3 As String * 50
   'Dim Turn As Byte
   'Dim P As Byte
   Dim Num As String * 14
Startup:


            User1 = Euser1
            Waitms 20
            I = Instr(user1 , "+98")
            If I = 0 Then User1 = ""
            User2 = Euser2
            Waitms 20
            I = Instr(user2 , "+98")
            If I = 0 Then User2 = ""
            User3 = Euser3
            Waitms 20
            I = Instr(user3 , "+98")
            If I = 0 Then User3 = ""
Gtemp = Egtemp : Waitms 20
Ghum = Eghum : Waitms 20
If Gtemp > 45 Then Gtemp = 35
If Gtemp < 15 Then Gtemp = 35
Egtemp = Gtemp : Waitms 20
If Ghum > 80 Then Ghum = 55
If Ghum < 20 Then Ghum = 55
Eghum = Ghum : Waitms 20
Htemp = Gtemp - 2
Hhum = Ghum - 2
        'Cls
       'Lcdat 1 , 1 , "hi"
       ' Wait 2
       ' Cls

   Wait 10
   Print "ATE0"
   Wait 1
   'Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
  ' Wait 1
   Print "AT"
   Wait 1
  ' Cls
  ' Initlcd
   'Lcdat 1 , 1 , Pack
  ' Wait 1
   Print "AT+CMGF=1"
   Wait 1
  ' Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
  ' Wait 1
   'Print "AT+CSMP=17,167,0,0"
   Print "AT+CSMP=17,167,2,25"
   Wait 1
   'Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT+CMGDA=DEL ALL"
   'Wait 1
   'Cls
   'Initlcd
  ' Lcdat 1 , 1 , Pack
   Wait 5
   Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Wait 1
   'Cls
   'Initlcd
   'Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT+CNMI=2,2,0,0,0"
   Wait 1
   'Cls
   'Initlcd
   'Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT"
   Wait 1
   'Cls
   'Initlcd
   'Lcdat 1 , 1 , Pack
   'Wait 1

   'Print "AT+CMGS=" ; Chr(34) ; "09376921503" ; Chr(34)
  ' Waitms 250
  ' Print "Startup" ; Chr(26)
   'Waitms 800


   Sms = "»—ﬁ Ê’· ‘œ"
   I = Instr(user1 , "+98")
   If I = 0 Then
      Num = Admin1
   Else
       Num = User1
   End If

   Call Send_unicode(num , Sms)
   Set Buz
   Waitms 250
   Reset Buz

Main:

     Do



       Wt = 0
        If _sec <> Lsec Then
           Toggle Green
           Lsec = _sec
           Ds18b20




          Z = Dht_read(hum , Temp)
            If Z = 0 Then
               'Print "errors read sensor dht"
               'Lcdat 6 , 1 , Z ; "*" ; Bytee ; "*" ; Checksumm ; "  "
            Else
              Humidity = Fusing(hum , "#.#") + "%"
              Temperature = Fusing(temp , "#.#") + "C"      'Chr(248) '"C"

            End If

            If Firstt = 1 Then
               'If Temp > Gtemp Then
               If Tsensor > Gtemp Then
                  Reset Firstt
                  Sms = "”Ì” „ ¬„«œÂ «” "
                  I = Instr(user1 , "+98")
                  If I = 0 Then
                     Num = Admin1
                  Else
                      Num = User1
                  End If

                     Call Send_unicode(num , Sms)

               End If
            End If
            If Ss = 1 Then
               If Ontime > 0 Then
                  Decr Ontime
                  If Ontime = 0 Then
                     'Ontime = 86400
                     'Ontime = 43200
                     Ontime = 21600
                     Sms = "—Ê‘‰" + Chr(10)
                  I = Instr(user1 , "+98")
                  If I = 0 Then
                     Num = Admin1
                  Else
                      Num = User1
                  End If
                     Call Send_unicode(num , Sms)
                  End If
               End If
               Hhum = Ghum - 2
               Htemp = Gtemp - 2
               Set Pump
               If Hum > Ghum Then Set Fan
               If Hum < Hhum Then Reset Fan
               If Tsensor > Gtemp Then
                  Reset Heater
               End If
               If Tsensor < Htemp Then Set Heater
            Else
               Reset Heater
               Reset Pump
               Reset Fan

            End If

            'If Temp < 3 Then
               'Sms = "œ„«Ì ∆«ÌÌ‰" + Chr(10)
              ' Sms = Msg + "Œÿ—  —òÌœêÌ œ— ’Ê—  «‰Ã„«œ! "
              ' Num = User1
              ' Call Send_unicode(num , Sms)
            'End If



            If Pack <> "" Then
                           'Initlcd
                           'Cls
                           'Lcdat 1 , 1 , Pack
                           'Wait 2
                           'Cls
                       ' Wait 2
                        'Toggle Fan
                       '
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
                        '(
                        If F(1) <> "+CMT:" And F(1) <> "" Then
                           Pack = ""
                           Print "AT+CMGR=1"
                           Waitms 200
                           Pos = Instr(pack , "UNREAD")
                           If Pos > 0 Then F(1) = "UNREAD"
                        End If
')
                        'If F(1) = "+CMT:" Or F(1) = "UNREAD" Then
                        'If F(1) = "+CMT:" Then
                        'If F(1) = "UNREAD" Then
                           'Set Buz
                           'Waitms 50
                           'Reset Buz
                           'Cls
                           'If F(1) = "+CMT:" Then
                              Print "AT+CMGR=1"
                              F(1) = ""
                           'End If
                           'Lcdat 1 , 1 , "AT+CMGR=1"
                           Waitms 100
                           F(6) = ""
                           Pack = Ucase(pack)
                           For I = 1 To 100
                               F(6) = Mid(pack , I , 3)
                               If F(6) = "+98" Then
                                  Set Buz
                                  Waitms 50
                                  Reset Buz
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
                              Print "AT+CMGDA=DEL ALL"
                                 Wait 5
                                 If Num = Admin1 Or Num = Admin2 Or Num = User1 Or Num = User2 Or Num = User3 Then
                                    Set Auth
                                 Else
                                    Reset Auth
                                 End If
                                 'Toggle Fan
                                 F(4) = ""
                                 I = 0
                                 F(6) = ""
                                 For I = 0 To 100
                                     F(6) = Mid(pack , I , 2)
                                     If F(6) = "*#" Or F(6) = "TH" Then
                                        Exit For
                                     End If
                                 Next
                                 F(5) = Mid(pack , I , 4)
                                 If Num = Admin1 Or Num = Admin2 Or Num = User1 Then
                                    If F(5) = "*#+9" Then
                                       I = I + 2
                                       F(6) = Mid(pack , I , 13)
                                    End If
                                 End If
                                 If F(6) = "TH" Then
                                    I = I + 2
                                    F(6) = Mid(pack , I , 2)
                                    Gtemp = Val(f(6))
                                    I = I + 2
                                    F(6) = Mid(pack , I , 2)
                                    Ghum = Val(f(6))
                                    F(5) = "TH"
                                 End If

                                 'Pack = ""
                                 'Msg = ""
                                 'Msg = "œ—Ì«›  ‘œ"
                                 Select Case F(5)
                                     Case "*#11"
                                           If Auth = 1 Then
                                               Ss = 1
                                              Ess = 1
                                              Waitms 25
                                              'Ontime = 86400
                                              'Ontime = 43200
                                              Ontime = 21600
                                              Set Firstt
                                              Msg = "—Ê‘‰" + Chr(10)
                                              Msg = Msg + "«” Œ—"
                                              Msg = Msg + Sens1 + "C" + Chr(10)       'Str(tsensor)
                                              'Msg = Msg + Chr(10)
                                              Msg = Msg + "”«·‰"
                                              Msg = Msg + Temperature + Chr(10)
                                              'Msg = Msg + Chr(10)
                                              Msg = Msg + "—ÿÊ» "
                                              Msg = Msg + Humidity       '+ Chr(10)
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If
                                     Case "*#00"
                                           If Auth = 1 Then
                                               Ss = 0
                                               Ess = 0
                                              Waitms 25
                                              Msg = "Œ«„Ê‘ ‘œ"
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If
                                     Case "*#+9"
                                           If Auth = 1 Then
                                              I = Instr(f(6) , "+98")
                                              X = Len(f(6))
                                              If I > 0 And X = 13 Then
                                                 If User1 = "" And User2 <> F(6) And User3 <> F(6) Then
                                                    User1 = F(6)
                                                 Else
                                                     If User2 = "" And User1 <> F(6) And User3 <> F(6) Then
                                                        User2 = F(6)
                                                     Else
                                                         If User1 <> F(6) And User2 <> F(6) Then
                                                            User3 = F(6)
                                                         End If
                                                     End If
                                                 End If
                                                  Euser1 = User1 : Waitms 20
                                                  Euser2 = User2 : Waitms 20
                                                  Euser3 = User3 : Waitms 20
                                                  Msg = F(6) + Chr(10)
                                                  Msg = Msg + "–ŒÌ—Â ‘œ"
                                                  Set Flag
                                              Else
                                                  Msg = F(6) + Chr(10)
                                                  Msg = Msg + "‘„«—Â ‰«„⁄ »—"
                                                  Reset Flag
                                              End If
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If

                                     Case "*#??"
                                           If Auth = 1 Then
                                              If Ss = 1 Then
                                                 Msg = "—Ê‘‰" + Chr(10)
                                              Else
                                                  Msg = "Œ«„Ê‘" + Chr(10)
                                              End If
                                              Msg = Msg + "«” Œ—"
                                              Msg = Msg + Sens1 + "C" + Chr(10)       'Str(tsensor)
                                              'Msg = Msg + Chr(10)
                                              Msg = Msg + "”«·‰"
                                              Msg = Msg + Temperature + Chr(10)
                                              'Msg = Msg + Chr(10)
                                              Msg = Msg + "—ÿÊ» "
                                              Msg = Msg + Humidity + Chr(10)
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If
                                     Case "*#D1"
                                           If Auth = 1 Then
                                          Msg = "Õ–› ‘œ" + Chr(10)
                                          Msg = Msg + User1
                                          Euser1 = "" : Waitms 20
                                          User1 = ""
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If

                                     Case "*#D2"
                                           If Auth = 1 Then
                                          Msg = "Õ–› ‘œ" + Chr(10)
                                          Msg = Msg + User2
                                          Euser2 = "" : Waitms 20
                                          User2 = ""
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If

                                     Case "*#D3"
                                           If Auth = 1 Then
                                          Msg = "Õ–› ‘œ" + Chr(10)
                                          Msg = Msg + User3
                                          Euser3 = "" : Waitms 20
                                          User3 = ""
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If

                                     Case "*#ST"

                                           If Auth = 1 Then

                                              Msg = Str(gtemp) + " "

                                              Msg = Msg + Str(ghum) + Chr(10)

                                              If User1 <> "" Then
                                                 Msg = Msg + User1 + Chr(10)
                                              End If
                                              If User2 <> "" Then
                                                 Msg = Msg + User2 + Chr(10)
                                              End If
                                              If User3 <> "" Then
                                                 Msg = Msg + User3
                                              End If
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If



                                     Case "TH"
                                           If Auth = 1 Then
                                           Msg = "À»   ‰ŸÌ„« " + Chr(10)
                                           If Gtemp > 45 Then
                                              Gtemp = 35
                                              Msg = Msg + "œ„« ‰«„⁄ »—" + Chr(10)
                                           End If
                                           If Gtemp < 15 Then
                                              Gtemp = 35
                                              Msg = Msg + "œ„« ‰«„⁄ »—" + Chr(10)
                                           End If
                                           Egtemp = Gtemp : Waitms 20
                                           If Ghum > 80 Then
                                              Ghum = 55
                                              Msg = Msg + "—ÿÊ»  ‰«„⁄ »—" + Chr(10)
                                           End If
                                           If Ghum < 20 Then
                                              Ghum = 55
                                              Msg = Msg + "—ÿÊ»  ‰«„⁄ »—" + Chr(10)
                                           End If
                                           Eghum = Ghum : Waitms 20
                                           Htemp = Gtemp - 2
                                           Hhum = Ghum - 2
                                           Msg = Msg + Str(gtemp) + " C" + Chr(10)
                                           Egtemp = Gtemp
                                           Waitms 20
                                           Msg = Msg + Str(ghum) + " %" + Chr(10)
                                           Eghum = Ghum
                                           Waitms 20
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "⁄œ„ œ” —”Ì „Ã«“"
                                           End If


                                     Case Else
                                           If Auth = 1 Then
                                              Msg = ""
                                              Msg = Msg + "*#11" + Chr(10)
                                              'Msg = Msg + "" + Chr(10)
                                              Msg = Msg + "*#00" + Chr(10)
                                              'Msg = Msg + "" + Chr(10)
                                              Msg = Msg + "*#+98xx" + Chr(10)
                                              'Msg2 = Msg2 + "–ŒÌ—Â ‘„«—Â " + Chr(10)
                                              Msg = Msg + "*#??" + Chr(10)
                                              'Msg2 = Msg2 + "«” ⁄·«„" + Chr(10)
                                              Msg = Msg + "*#ST" + Chr(10)
                                              'Msg3 = Msg3 + "„‘«ÂœÂ  ‰ŸÌ„« " + Chr(10)
                                              Msg = Msg + "TH1234" + Chr(10)
                                              'Msg3 = Msg3 + " ‰ŸÌ„« " + Chr(10)
                                              'Msg2 = ""
                                              'Msg3 = ""
                                           Else
                                              Msg = "‘„«—Â ‰«„⁄ »—!"
                                           End If
                                 End Select
                                 If Msg <> "" Then
                                        Wait 1
                                        'Msg = "œ—Ì«›  ‘œ"
                                        Sms = Msg
                                        Call Send_unicode(num , Sms)
                                                              'End If
                                        'If Msg2 <> "" Then
                                           'Sms = Msg2
                                          ' Sms = Sms + "*"
                                          ' Call Send_unicode(num , Sms)
                                           'Msg2 = ""

                                        'End If
                                        'If Msg3 <> "" Then
                                          ' Sms = Msg3
                                          ' Sms = Sms + "**"
                                          ' Call Send_unicode(num , Sms)
                                          ' Msg3 = ""
                                        'End If
                                        I = Instr(f(6) , "+98")
                                        X = Len(f(6))
                                        If F(5) = "*#+9" And Flag = 1 And I > 0 And X = 13 Then
                                           Reset Flag
                                              Msg = ""
                                              Msg = Msg + "*#11" + Chr(10)
                                              'Msg = Msg + "" + Chr(10)
                                              Msg = Msg + "*#00" + Chr(10)
                                              'Msg = Msg + "" + Chr(10)
                                              Msg = Msg + "*#+98xx" + Chr(10)
                                              'Msg2 = Msg2 + "–ŒÌ—Â ‘„«—Â " + Chr(10)
                                              Msg = Msg + "*#??" + Chr(10)
                                              'Msg2 = Msg2 + "«” ⁄·«„" + Chr(10)
                                              Msg = Msg + "*#ST" + Chr(10)
                                              'Msg3 = Msg3 + "„‘«ÂœÂ  ‰ŸÌ„« " + Chr(10)
                                              Msg = Msg + "TH1234" + Chr(10)
                                              'Msg3 = Msg3 + " ‰ŸÌ„« " + Chr(10)
                                              'Msg2 = ""
                                              'Msg3 = ""
                                              Sms = Msg
                                           Call Send_unicode(f(6) , Sms)
                                              'Sms = Msg2
                                           'Call Send_unicode(f(6) , Sms)
                                              'Sms = Msg3
                                           'Call Send_unicode(f(6) , Sms)
                                           Msg = ""
                                           'Msg2 = ""
                                           'Msg3 = ""
                                        End If
                                        Wait 1
                                        F(5) = ""
                                        Pack = ""
                                        Recive = ""
                                 Else
                                       Pack = ""
                                 End If
                                 Msg = ""

                                 'Msg2 = ""
                                 'Msg3 = ""
                           End If
                           '(
                        Else
                            Sms = "sim800 errorss" + Chr(10)
                            Sms = Sms + F(1)
                            Num = Admin1
                            Call Send_unicode(num , Sms)
')
                        'End If
                        Pack = ""
            End If


        End If

            If Learn = 0 Then
               Waitms 50
               If Learn = 0 Then
                  Set Buz
                  'X = 10
                  I = 0
                  Do
                    Waitms 500
                    Reset Buz
                    Incr I
                    If I = 4 Then Exit Do
                    'If X = 0 Then Exit Do
                  Loop Until Learn = 1
                  Reset Buz
                  Waitms 500
                  If I < 2 Then
                     Keylearn
                  Else
                      Rnumber = 0
                      Rnumber_e = Rnumber
                      Waitms 10
                      Set Buz
                      Waitms 500
                      Reset Buz
                      Wait 1
                      Set Buz
                      Waitms 250
                      Reset Buz
                      Wait 1
                  End If
               End If
            End If

           If _in = 1 Then Set Pg Else Reset Pg
          _read

     Loop


T0rutin:
        Disable Interrupts
        Incr T
        If _in = 1 Then Set Pg Else Reset Pg

        If T = 42 Then
           Incr _sec
           'Incr Wt
           If X > 0 Then
              Decr X
           End If
           If _sec = 60 Then
              _sec = 0
              Incr _min
              If _min = 60 Then
                 Incr _hour
                If _hour = 24 Then
                    _hour = 0
               End If
              End If
           End If
           T = 0
           'Toggle Pg

        End If

        'If Wt = 60 Then Gosub Main
        'Stcheck
        'If Error <> 0 Then Gosub Main                       ' Popall
        Enable Interrupts
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
               If Tt >= 24 And Tt <= 33 Then
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
 'Disable Interrupts
           Okread = 0
          ' X = 10
      If _in = 1 Then
         Do
           If _in = 0 Then Exit Do
          ' If X = 0 Then Exit Do
         Loop
         Timer1 = 0
         Start Timer1
         'X = 10
         While _in = 0
        ' If X = 0 Then Exit While
         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
           ' X = 10
           W = 0
           'Wt = 0
            Do

              If _in = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While _in = 1

                 Wend
                 Stop Timer1
                 Incr W
                 S(w) = Timer1
                 'If Wt = 20 Then
                    'Wt = 0
                    'Exit Do
                 'End If
              End If

              If W = 24 Then Exit Do
              'If X = 0 Then Exit Do
            Loop

            For W = 1 To 24

                If S(w) >= 332 And S(w) <= 972 Then
                   S(w) = 0
                Else
                    If S(w) >= 1111 And S(w) <= 2361 Then
                       S(w) = 1
                    Else
                        W = 0
                        Address = 0
                        Code = 0
                        Okread = 0
                        Return
                    End If
                End If
            Next
            W = 0
            Saddress = ""
            Scode = ""
            For W = 1 To 20

                Saddress = Saddress + Str(s(w))
            Next
            For W = 21 To 24

                Scode = Scode + Str(s(w))
            Next
            Address = Binval(saddress)
            Code = Binval(scode)
            Set Okread
            Gosub Check
            'Set Buz
            'Waitms 250
            'Reset Buz

            W = 0
         End If

      End If
 ' Enable Interrupts
End Sub

Sub Keylearn
   ' X = 10
Do
   _read
  If Okread = 1 Then
  ''''''''''''''''''''''repeat check
      If Rnumber = 0 Then                                   ' agar avalin remote as ke learn mishavad
          Incr Rnumber
          Rnumber_e = Rnumber
          Waitms 10
          Ra = Address
          Eevar(rnumber) = Ra
          Waitms 10
          Exit Do
      Else                                                  'address avalin khane baraye zakhire address remote
          For W = 1 To Rnumber
              Ra = Eevar(w)
              If Ra = Address Then                          'agar address remote tekrari bod yani ghablan learn shode

                 Errors = 1
                 Exit For
              Else
                  Errors = 0
              End If
          Next
          If Errors = 0 Then                                ' agar tekrari nabod
             Incr Rnumber                                   'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
             If Rnumber > 100 Then                          'agar bishtar az 100 remote learn shavad
                Rnumber = 100

             Else                                           'agar kamtar az 100 remote bod
                Rnumber_e = Rnumber                         'meghdare rnumber ra dar eeprom zakhore mikonad
                Ra = Address
                Eevar(rnumber) = Ra
                Waitms 10
             End If
          End If
      End If
      Exit Do
  End If
  'If X = 0 Then Exit Do
Loop
Okread = 0

End Sub
'========================================================================= CHECK
Check:

Okread = 1
If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
   For W = 1 To Rnumber
      Ra = Eevar(w)
      If Ra = Address Then                                  'code
            Gosub Command

            Exit For
      End If
   Next
End If
Keycheck = 0

Return
'-------------------------------- Relay command
Command:


        If Code = 1 Then
           Set Ss
           'Ontime = 86400
           'Ontime = 43200
           Ontime = 21600
           Set Firstt
           Sms = "”Ì” „ »« —Ì„Ê  ›⁄«· ‘œ"
        Elseif Code = 2 Then
           Reset Ss
           Sms = "”Ì” „ »« —Ì„Ê  €Ì—›⁄«· ‘œ"
        Elseif Code = 4 Then
           Set Fan
           Sms = "›‰ —Ê‘‰ ‘œ"
        Elseif Code = 8 Then
           Set Fan
           Sms = "›‰ Œ«„Ê‘ ‘œ"
        End If
        Ess = Ss
        Waitms 25
        Set Buz
        Waitms 100
        Reset Buz
        Waitms 100
        I = Instr(user1 , "+98")
        If I > 0 Then
           Num = User1
        Else
            Num = Admin1
        End If
        Call Send_unicode(num , Sms)


Return


Sub Ds18b20

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
      'Tmp1 = Val(sens1)
      Tsensor = Val(sens1)

         'If Readsens < 0 Then Readsens = Readsens * -1
         'Sahih1 = 0
         'If Readsens > 9 Then
           ' Sahih1 = Readsens / 10
           ' Ashar1 = Readsens Mod 10
        ' End If



End Sub

Conversion:

   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")

Return

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
             Dht_read = 0                                   'CRC errors!!!
         End If

End Function

Rxin:
     Disable Interrupts
     Toggle Ind
     Recive = Inkey()
     Pack = Pack + Recive
     Pack = Ucase(pack)
     Recive = ""
     Enable Interrupts
Return

Sub Send_unicode(phone As String , Text As String)
    Disable Interrupts
    Local Str_len As Byte , Index As Byte , I As Byte
    Str_len = Len(text)
    Print "AT+CMGF=1"
    Waitms 200
    Print "AT+CSCS=" ; Chr(34) ; "HEX" ; Chr(34)
    Waitms 200
    Print "AT+CSMP=49,167,0,8"
    Waitms 200
    Print "AT+CMGS=" ; Chr(34) ; Phone ; Chr(34)
    Waitms 500
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
    Waitms 500
    Print Chr(26)
    Wait 1
    Print "AT+CMGDA=DEL ALL"
    Wait 5
    'Print "AT+CMGDA=DEL SENT"
    'Wait 5
    Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
    Waitms 500
    Print "AT+CSMP=17,167,0,16"
    'Print "AT+CSMP=17,167,2,25"
    Waitms 200
    Set Buz
    Waitms 50
    Reset Buz
    Waitms 50
    Set Buz
    Waitms 50
    Reset Buz
    Pack = ""
    Enable Interrupts
End Sub

Sub Simcheck
    Print "ATE0"
   Wait 1
   'Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
  ' Wait 1
   Print "AT"
   Wait 1
  ' Cls
  ' Initlcd
   'Lcdat 1 , 1 , Pack
  ' Wait 1
   Print "AT+CMGF=1"
   Wait 1
  ' Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
  ' Wait 1
   'Print "AT+CSMP=17,167,0,0"
   Print "AT+CSMP=17,167,2,25"
   Wait 1
   'Cls
  ' Initlcd
  ' Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT+CMGDA=DEL ALL"
   'Wait 1
   'Cls
   'Initlcd
  ' Lcdat 1 , 1 , Pack
   Wait 5
   Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Wait 1
   'Cls
   'Initlcd
   'Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT+CNMI=2,2,0,0,0"
   Wait 1
   'Cls
   'Initlcd
   'Lcdat 1 , 1 , Pack
   'Wait 1
   Print "AT"
   Wait 1
End Sub

End

'$lib "glcd-Nokia5110.lib"
'$include "FONT/farsi_map.bas"
 ' $include "FONT/font5x5.font"

  Ascii:
'data "«" , "»" , "Å" , " " , "À" , "Ã" , "ç" , "Õ" , "Œ" , "œ" , "–" , "—" , "“" , "é" , "”" , "‘" , "’" , "÷" , "ÿ" , "Ÿ" , "⁄" , "€" , "›" , "ﬁ" , "ò" , "ò" , "ê" , "·" , "„" , "‰" , "Â" , "Ê" , "Ì" , "¬" , "°" , "Ì" , "∞"
Data 199 , 200 , 129 , 202 , 203 , 204 , 141 , 205 , 206 , 207 , 208 , 209 , 210 , 142 , 211 , 212 , 213 , 214 , 216 , 217 , 218 , 219 , 221 , 222 , 152 , 223 , 144 , 225 , 227 , 228 , 229 , 230 , 237 , 194 , 161 , 236 , 176
Unicode:
Data &H27 , &H28 , &H7E , &H2A , &H2B , &H2C , &H86 , &H2D , &H2E , &H2F , &H30 , &H31 , &H32 , &H98 , &H33 , &H34 , &H35 , &H36 , &H37 , &H38 , &H39 , &H3A , &H41 , &H42 , &HA9 , &H43 , &HAF , &H44 , &H45 , &H46 , &H47 , &H48 , &H4A , &H22 , &H0C , &H49 , &HB0