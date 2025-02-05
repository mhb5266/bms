
$regfile = "m32def.dat"
$crystal = 11059200
Open "COMC.2:9600,8,n,1" For Output As #1
$baud = 9600

Subs:

Declare Sub Getline(s As String)
Declare Sub Flushbuf()
Declare Sub Showsms(s As String )
Declare Sub Sendsms
Declare Sub Dial
Declare Sub Resetsim
Declare Sub Checksim
Declare Sub Money
Declare Sub Temp
Declare Sub Antenna
Declare Sub Charge
Declare Sub Delall
Declare Sub Delread
Declare Sub Sendtx(s As String)
Declare Sub Simcheck
Declare Sub Findorder
Declare Sub Readremote


Defines:


'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 160 , Stemp As String * 6
Dim U As Byte
Dim Lim As Byte
Dim Msg As String * 100
Dim Num As String * 13 : Num = "+989376921503"
Dim Sharj As String * 100
Dim Sheader(5) As String * 30
Dim Sbody(5) As String * 30
Dim Net As String * 10
Dim Order As String * 10
Dim Count As Word
Dim Scount As Byte
Dim Length As Byte
Dim Anten As Word
Dim Status As Byte
Dim _sec As Byte
Dim Lsec As Byte
Dim Tt As Byte
Dim Errors As Byte
Dim A As Byte
Dim Sendok As Bit
Dim Ttt As Byte
Dim Hh As Byte
Dim Mm As Byte
Dim Ss As Byte
Dim Timeout As Byte : Timeout = 60
Dim Eadmin As Eram String * 13
Dim Euser(5) As Eram String * 13
Dim Admin As String * 13 : Admin = "+989376921503"
Dim User(5) As String * 13
Dim Epassword As Eram String * 4
Dim Password As String * 4 : Password = "1234"
Dim Lock As Bit
Dim Id As String * 20

Dim Decode As Dword

Dim Lpulse As Word
Dim Hpulse As Word
Dim Pulse As Word

Dim Saddress As String * 20
Dim Scode As String * 4
Dim S(25)as Word
Dim Address As Long
Dim Code As Byte
Dim Okread As Bit
Configs:


Datain Alias Pina.7 : Config Porta.7 = Input
Simrst Alias Portd.4 : Config Portd.4 = Output
Relay Alias Porta.3 : Config Porta.3 = Output
Red Alias Portb.0 : Config Portb.0 = Output
Blue Alias Porta.1 : Config Porta.1 = Output
Green Alias Porta.0 : Config Porta.0 = Output
'red ALIAS PORTc.1 : CONFIG PORTc.1 = OUTPUT
pir alias pinc.5 : config portc.5 = INPUT
En485 Alias Portc.4 : Config Portc.4 = Output
Config Serialin = Buffered , Size = 50                      ' buffer is small a bigger chip would allow a bigger buffer
'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts
'Enable Timer0
'Config Timer0 = Timer , Prescale = 1024
'On Timer0 T0rutin

Config Timer1 = Timer , Prescale = 8
'define a constant to enable LCD feedback
Const Uselcd = 1
Const Senddemo = 1                                          ' 1= send an sms
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
Const Phonenumber = "AT+CMGS=09376921503"                   ' phonenumber to send sms to



Startup:
'Password = Epassword

        Print#1 , "system is restarting"
        Print#1 , "password= " ; Password
        'Resetsim

        Set Relay
        Wait 2
        Reset Relay
        Count = 0
        Msg = "Module Is Restarted Now"
        'Sendsms
       Do
         Print#1 , "HI"
         wait 1
       Loop
Main:


Do
         '(
         If _sec <> Lsec Then
            Lsec = _sec
            Select Case Count
                  Case 1
                       Simcheck

            End Select

            Getline Sret
            A = Instr(sret , "+CMT")
            If A > 0 Then
                        'Sret = "AT+CMGR=1"
                        'Sendtx Sret

                        Count = Split(sret , Sheader(1) , Chr(34))
                        Getline Sret
                        Scount = Split(sret , Sbody(1) , " ")
                                Num = Sheader(2)
                                Order = Sbody(1)
                                Print#1 , Num
                                Print#1 , Order
                                Findorder
                                Sendsms
                                Delall
                        Getline Sret

            End If
         End If
         If Pir = 0 Then
            Set Blue
            If Timeout = 0 And Lock = 1 Then
               Timeout = 60
               Msg = "alarm"
               Num = Admin
               Sendsms
            End If
         Else
             Reset Blue
         End If
')
         'If Datain = 0 Then Set Red Else Reset Red
         Readremote
         'Waitms 200
Loop


'get line of data from buffer
Sub Getline(s As String)
    S = ""
    Tt = 3
    Do
      B = Inkey()
      Select Case B
             Case 0                                         'nothing
             Case 13                                        ' we do not need this one
             Case 10
                  If S <> "" Then Exit Do                   ' if we have received something
             Case Else
                  S = S + Chr(b)                            ' build string
      End Select
      If Tt = 0 Then Exit Do
    Loop
    Sret = S
    Sret = Ucase(sret)
    If Sret <> "" Then
       Print #1 , Sret
       Print #1 , Str(hh) ; ":" ; Str(mm) ; ":" ; Str(ss)
    End If
End Sub
'flush input buffer
Sub Flushbuf()
    Waitms 100                                              'give some time to get data if it is there
    Do
     B = Inkey()                                            ' flush buffer
    Loop Until B = 0
End Sub


Sub Sendsms


    Sret = "AT+CSCS=" + Chr(34) + "GSM" + Chr(34)
    Sendtx Sret
    Getline Sret
    Sret = "AT+CMGS=" + Chr(34) + Num + Chr(34)
    Sendtx Sret
     Ttt = 2
     Do
       Getline Sret
       If Sret = ">" Or Ttt = 0 Then Exit Do
     Loop
     Msg = Msg + Chr(10)
     msg=msg+str(hh)+":"+str(mm)+":"+str(ss)
     Sret = Msg + Chr(26)
    Sendtx Sret
     Ttt = 15
     Do
       Getline Sret
       A = Instr(sret , "+CMGS")
       If A > 0 Or Ttt = 0 Then
          If A > 1 Then Set Sendok
          Exit Do
       End If

     Loop

End Sub
Sub Dial
    Print "Atd" ; 09376921503 ; ";"
    Wait 20
    Print "Ath"
End Sub
Sub Checksim
      Flushbuf
      Print "AT"
      Getline Sret
      Lcd Sret
      If Sret <> "OK" Then
         Incr Lim
         If Lim = 5 Then
            Lim = 0
            Resetsim
            Cls
            Lcd "sim was reset"
            Wait 2
            Cls
         End If
      Else
         Lim = 0
      End If
End Sub
Sub Resetsim
_sec = 0
Do
  If _sec <> Lsec Then
     Lsec = _sec
     Select Case _sec
           Case 0
                Reset Simrst
           Case 2
                Set Simrst
           Case 3 To 30
                Flushbuf
                Sret = "AT"
                Sendtx Sret
                Getline Sret
                If Sret = "AT" Then
                   _sec = 31
                End If
           Case 31 To 33
                Flushbuf
                Sret = "ATE0"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.0 = 1
                   _sec = 36
                End If
           Case 37 To 40
                Flushbuf
                Sret = "AT"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.1 = 1
                   _sec = 41
                End If
           Case 41 To 43
                Flushbuf
                Sret = "AT+CMGF=1"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.2 = 1
                   _sec = 44
                End If
           Case 44 To 46
                Flushbuf
                Sret = "At+Cusd=1"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.3 = 1
                   _sec = 47
                End If
           Case 47 To 50
                Flushbuf
                Sret = "AT+CSMP=17,167,2,25"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.4 = 1
                   _sec = 51
                End If
           Case 51 To 53
                Flushbuf
                Sret = "AT+CNMI=2,2,0,0,0"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.5 = 1
                   _sec = 54
                End If
           Case 54 To 57
                Flushbuf
                Sret = "AT+CSCS=" + Chr(34) + "GSM" + Chr(34)
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.6 = 1
                   _sec = 58
                End If
           Case 58 To 90
                Flushbuf
                Sret = "AT+CMGDA=DEL ALL"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then
                   Status.7 = 1
                   _sec = 91
                End If
           Case 92
                Flushbuf
                Sret = "AT+GSN"
                Sendtx Sret
                Getline Sret
                Id = Sret
           Case 94
                If Status < 255 Then _sec = 0
                Exit Do
     End Select
  End If
Loop
End Sub
Sub Money
Print "ATD*140#"
Getline Sret
Getline Sret
Sharj = Left(sret , 33)
Sharj = Right(sharj , 6)
Sharj = Ltrim(sharj)
End Sub
Sub Antenna
  Flushbuf
  Print "AT+CSQ"
  Getline Sret
  Count = Split(sret , Sbody(1) , " ")
  Anten = Val(sbody(2))
'  Cls : Lcd "ANTEN= " : Lcd Anten : Lowerline : Lcd Sret : Wait 5 : Cls : Waitms 500
  Select Case Anten
         Case 0
              Net = "BAD"
         Case 1
              Net = "WEAK"
         Case 2 To 15
              Net = "MID"
         Case 16 To 30
              Net = "GOOD"
         Case 31
              Net = "BEST"
         Case 99
              Net = "OFFLINE"
  End Select
End Sub
Sub Charge
'Print "ATD*140#"
Flushbuf
Print "At+Cusd=1," ; Chr(34) ; "*140#" ; Chr(34)
'Print "At+Cusd=1," ; Chr(34) ; "*555*1*2#" ; Chr(34)
  Getline Sret
  Getline Sret
  Sharj = Right(sret , 17)
  Getline Sret
End Sub
Sub Delall
     Flushbuf
     Print "AT+CMGDA=DEL ALL"
     A = 0
     Do
       Incr A
       Getline Sret
       If Sret = "OK" Or A = 10 Then Exit Do
     Loop
End Sub
Sub Delread
     Flushbuf
     Print "AT+CMGDA=DEL READ"
     A = 0
     Do
       Incr A
       Getline Sret
       If Sret = "OK" Or A = 10 Then Exit Do
     Loop
End Sub

Sub Sendtx(sret As String)
    Print Sret
    Print #1 , Sret
    Print #1 , bin(status)
    Print #1 , Str(hh) ; ":" ; Str(mm) ; ":" ; Str(ss)
End Sub

Sub Simcheck
_sec = 0
Do
  If _sec <> Lsec Then
     Lsec = _sec


     Select Case _sec
           Case 1
                Flushbuf
                Sret = "ATE0"
                Sendtx Sret
                Getline Sret


           Case 3
                Flushbuf
                Sret = "AT"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.1 = 1

           Case 5
                Flushbuf
                Sret = "AT+CMGF=1"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.2 = 1

           Case 7
                Flushbuf
                Sret = "At+Cusd=1"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.3 = 1

           Case 9
                Flushbuf
                Sret = "AT+CSMP=17,167,2,25"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.4 = 1

           Case 11
                Flushbuf
                Sret = "AT+CNMI=2,2,0,0,0"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.5 = 1

           Case 13
                Flushbuf
                Sret = "AT+CSCS=" + Chr(34) + "GSM" + Chr(34)
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.6 = 1

           Case 15
                Flushbuf
                Sret = "AT+CMGDA=DEL ALL"
                Sendtx Sret
                Getline Sret
                If Sret = "OK" Then Status.7 = 1

           Case 17
                If Status < 255 Then Incr Errors Else Errors = 0
                If Errors = 5 Then Resetsim
                Exit Do
     End Select
  End If
Loop
End Sub

Sub Findorder
    Select Case Order
           Case "ON"
                 Set Red
                 Msg = "Led Is On"
           Case "OFF"
                 Reset Red
                 Msg = "Led Is Off"
           Case "LOCK"
                 Set Lock
                 Msg = "System is Locked"
           Case "UNLOCK"
                 Reset Lock
                 Msg = "System is Unlocked"

    End Select
    Order = ""
End Sub

Sub Readremote

  '(
      Okread = 0
      If datain = 1 Then
         Do
           'Reset Watchdog
           If datain = 0 Then Exit Do
         Loop
         Timer1 = 0
         Start Timer1
         While datain = 0
               'Reset Watchdog
         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
                   'Toggle Red
               'Waitms 500
            Do
              If datain = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While Datain = 1
                    'Reset Watchdog
                 Wend
                 Stop Timer1
                 Incr I
                 S(i) = Timer1
              End If
              'Reset Watchdog
              If I = 24 Then Exit Do
            Loop
            For I = 1 To 24
                'Reset Watchdog
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
                       Exit For
                   End If
                End If
            Next
            I = 0
            Saddress = ""
            Scode = ""
            For I = 1 To 20
                Saddress = Saddress + Str(s(i))
            Next
            For I = 21 To 24
                Scode = Scode + Str(s(i))
            Next
            Address = Binval(saddress)
            Code = Binval(scode)
            'Gosub Check
            Print #1 , "address" ; Address ; Chr(10)
            Print #1 , "code" ; Code ; Chr(10)

            I = 0
         End If
      End If
   ')

    Saddress = ""
    Scode = ""
    Do
      Timer1 = 0
      If Datain = 1 Then
         Start Timer1
         Do
           'Reset Watchdog
           If datain = 0 Then Exit Do
         Loop
         Pulse = Timer1
         Hpulse = Pulse
         Timer1 = 0
         Start Timer1
         While datain = 0
               'Reset Watchdog
         Wend
         Lpulse = Timer1
         Stop Timer1
      End If
      If Lpulse > Hpulse Then
         A = 0
         A = Lpulse / Hpulse

         If A = 31 Then
             Print#1 , "hpulse--> " ; Hpulse
             Print#1 , "lpulse--> " ; Lpulse
             Print#1 , A
            Do
              If datain = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While Datain = 1
                    'Reset Watchdog
                 Wend
                 Stop Timer1
                 Incr I
                 S(i) = Timer1
              End If
              'Reset Watchdog
              If I = 24 Then Exit Do
            Loop
              For I = 1 To 24
                A = S(i) / Pulse
                Print#1 , I ; " --> " ; A

                If A = 1 Then
                   S(i) = 0
                Elseif A = 3 Then
                   S(i) = 1
                Else
                     ' Return
                End If


              Next
            For I = 1 To 20
                Saddress = Saddress + Str(s(i))
            Next
            For I = 21 To 24
                Scode = Scode + Str(s(i))
            Next

              Print#1 , Binval(saddress)
              Print#1 , Binval(scode)

              If Binval(scode) > 0 And Binval(scode) < 16 Then
                 Print#1 , Saddress
                 Print#1 , Scode
                 Toggle Red
                 Print#1 , "led is on"
                 'Waitms 500
              End If
         End If
      Else
          'Exit Do
      End If
    Loop

End Sub

T0rutin:
        Stop Timer0
        Incr U
        If U = 42 Then
        U = 0
                Toggle Green
                'Toggle Relay
                Incr Ss
                If Ss > 59 Then
                   Ss = 0
                   Incr Mm
                   If Mm > 59 Then
                      Mm = 0
                      Incr Hh
                      If Hh > 23 Then
                         Hh = 0
                      End If
                   End If
                End If
                Incr _sec
                Incr Count

                If Tt > 0 Then Decr Tt
                If Ttt > 0 Then Decr Ttt
                If Timeout > 0 Then Decr Timeout
         End If
             'red=datain
         'If Datain = 1 Then Set Red Else Reset Red
       '(
         If Pir = 0 Then
            Set Blue
            If Timeout = 60 Then
               Msg = "alarm"
               Num = Admin
               Sendsms
            End If
         Else
             Reset Blue
         End If
')
        'If Datain = 1 Then Set Red Else Reset Red


        Start Timer0
        ' = 54735
Return