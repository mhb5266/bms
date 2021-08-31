

$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600

'HW stack 20, SW stack 8 , frame 10

Config Lcdpin = 16 * 2 , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2
Cursor Off

config_sim:
'some subroutines
Declare Sub Getline(s As String)
Declare Sub Flushbuf()
declare sub beep
Declare Sub Send_sms

Declare Sub Resetsim


Declare Sub Antenna
Declare Sub Charge
Declare Sub Delall
Declare Sub Delread
'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 100

Dim Msg As String * 160
Dim Num As String * 13 : Num = "+989376921503"
Dim Sharj As String * 160
Dim Sheader(5) As String * 30
Dim Sbody(5) As String * 30
Dim Net As String * 10
Dim Count As Byte
Dim Scount As Byte
Dim Length As Byte
Dim Anten As Word
Simrst Alias Portb.1 : Config Simrst = Output

'we use a serial input buffer
Config Serialin = Buffered , Size = 50                     ' buffer is small a bigger chip would allow a bigger buffer

'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts

'define a constant to enable LCD feedback
Const Uselcd = 1
Const Senddemo = 1                                          ' 1= send an sms
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
Const Phonenumber = "AT+CMGS=09376921503"                   ' phonenumber to send sms to



Config_remote:


declare sub do_learn
declare sub del_remote
'-------------------------------------------------------------------------------
Config Portd.7 = Input :_in Alias Pind.7
Config portd.6 = Output:Buzz Alias Portd.6
config portd.5=input:key alias pind.5
Config portb.0 = Output:Led1 Alias Portb.0



'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
config timer0= timer ,prescale=1024
enable interrupts
enable timer0
on ovf0 t0rutin
dim t0 as byte
start timer0
'--------------------------------- Variable ------------------------------------
Dim S(24)as Word

Dim Saddress As String * 20
Dim Scode As String * 4
Dim Address As Long
Dim Code As Byte
''''''''''''''''''''''''''''''''
Dim Ra As Long                                              'fp address
Dim Rnumber As Byte                                         'remote know
Dim Rnumber_e As Eram Byte
Dim Okread As Bit
Dim Error As Bit
Dim Keycheck As Bit
Dim T As Word                                               'check for pushing lean key time
Error = 0
Okread = 0
T = 0
Keycheck = 0
Dim Eaddress As Word                                        'eeprom address variable
Dim E_read As Byte
Dim E_write As Byte
Dim Eevar(20) As Eram Long





Startup:



Resetsim
Cls
Lcd "     LOADING    "
Lowerline
For I = 1 To 15

    Lcd "."
    Wait 1
Next
Cls


Print "AT"                                                  ' send AT command twice to activate the modem
Print "AT"
Flushbuf
'Print "AT&F"
Flushbuf                                                    ' flush the buffer
Print "ATE0"
    Home Lower



'Do
  Flushbuf
   Print "AT" :                                             ' Waitms 100
   Getline Sret                                             ' get data from modem
       Lcd Sret                                             ' feedback on display
'Loop Until Sret = "OK"                                      ' modem must send OK
Flushbuf                                                    ' flush the input buffer



    Home Upper : Lcd "Get pin mode"

Print "AT+cpin?"                                            ' get pin status
Getline Sret

    Home Lower : Lcd Sret

If Sret = "+CPIN: SIM PIN" Then
   Print Pincode                                            ' send pincode
End If
Flushbuf

Print "AT+CMGF=1"                                           ' set SMS text mode
Getline Sret                                                ' get OK status

If Sret = "OK" Then
 Lcd "TEXTMODE OK"
Else
 Lcd "ERROR"
End If
Wait 1
Cls

Print "At+Cusd=1"
Getline Sret
Cls : Lcd "USSD CODE" : Lowerline : Lcd Sret : Wait 3 : Cls : Waitms 500


Flushbuf

'sms settings
'Print "AT+CSMP=17,167,0,0"
Print "AT+CSMP=17,167,2,25"
Getline Sret

'Print "AT+CNMI=0,1,2,0,0"
Print "AT+CNMI=2,2,0,0,0"
Getline Sret


  Flushbuf
   Print "AT+CSMP?"
   Getline Sret
       Cls : Lcd "CHR SETTING"
       Wait 1
       Cls
       Lcd Sret
       Wait 1

  Flushbuf
   Print "AT+CNMI?"
   Getline Sret
       Cls : Lcd "INDICATE CNG"
       Wait 1
       Cls
       Lcd Sret
       Wait 1
   Waitms 500
Wait 1
cls

'Do
  Flushbuf
   Print "AT+CMGF=1"
   Getline Sret
       Cls : Lcd "TEXT MODE" : Lowerline : Lcd Sret
   Waitms 500
'Loop Until Sret = "OK"
Wait 2

  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret
   Cls : Lcd "FONT SETTING"
   Wait 1
   Cls
   Lcd Sret
   Wait 1
Wait 2


'Do
   Delall
   Cls : Lcd "DEL ALL" : Lowerline : Lcd Sret : Wait 2 : Cls : Waitms 500
   Waitms 500
'Loop Until Sret = "OK"
Wait 2



Main:

Msg = "SIM800 IS ONLINE NOW"
'Send_sms

'Charge
Wait 5

cls

do
  gosub _read
  if key=0 then
     waitms 25
     i=0
     do
       waitms 50
       incr i
       if i>20 then exit do
     loop until  key=1
     if i>20 then del_remote else do_learn
  end if
  'waitms 50


loop

Do
  Flushbuf
  Cls : Wait 1
  Antenna

  Wait 1
  Cls : Lcd  "ANTEN= " ; Anten : Lowerline : Lcd Sharj : Lcd " $"

 ' Print "AT+CNMI?"
  'Getline Sret
  'Cls : Lcd Sret : Wait 2 : Cls
  'If Sret = "OK" Then
     'Cls : Lcd "NEW SMS" : Wait 2 : Cls
     Flushbuf
     Print "AT+CMGR=1"
     Getline Sret
     If Sret = "OK" Then
        Sret = ""
          Getline Sret
          Count = Split(sret , Sheader(1) , Chr(34))
          Getline Sret
          Scount = Split(sret , Sbody(1) , " ")
          Num = Sheader(2)
          Cls : Lcd Sbody(1)
          Msg = ""
          If Sbody(1) = "?" Then
             Flushbuf
             'If Led1 = 0 Then Msg = "LED IS OFF" Else Msg = "LED IS ON"
             'Msg = Msg + Chr(13)
             Msg = Msg + "ANTEN=" + Net
             Msg = Msg + Chr(13)
             Msg = Msg + Sharj + " $"
             Msg = Msg + Chr(13)
             Send_sms
          End If
          If Lcase(sbody(1)) = "off" Then
             Reset Led1
             Msg = "LED IS OFF"


             Send_sms
          End If
          If Lcase(sbody(1)) = "on" Then
             Set Led1
             Num = Sheader(2)
             Msg = "LED IS ON"
             Send_sms
          End If

          For I = 1 To 10
              Sheader(i) = ""
              Sbody(i) = ""
          Next

     End If
     Delread
Loop


t0rutin:
        stop timer0
        incr t0
        if t0=42 then
           t0=0
           toggle buzz
        end if
        start timer0
return
'--------------------------------------------------------------------------read
_read:
      Okread = 0
      If _in = 1 Then
         Do
           'Reset Watchdog
           If _in = 0 Then Exit Do
         Loop
         Timer1 = 0
         Start Timer1
         While _in = 0
               'Reset Watchdog
         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
            Do
              If _in = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While _in = 1
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
                       Return
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
            Gosub Check

            I = 0
         End If
      End If
Return
'================================================================ keys  learning


'========================================================================= CHECK
Check:
      Okread = 1
      If Keycheck = 0 Then                                  'agar keycheck=1 bashad yani be releha farman nade
         For I = 1 To Rnumber

             Ra = Eevar(i)
             If Ra = Address Then
                Gosub Command
                'Call Beep
                Exit For
             End If
         Next
      End If
      Keycheck = 0
Return
'-------------------------------- Relay command
Command:

       cls
       lcd code
       toggle led1

        Waitms 500
        cls
Return

Sub Beep
    Set Buzz
    Waitms 80
    Reset Buzz
    Waitms 30
End Sub


Sub del_remote

     cls:lcd "delete remote"
     Rnumber = 0
     Rnumber_e = Rnumber
     waitms 20
     for i=1 to 20
         eevar(i)=0
         waitms 20
     next
     beep
     beep
     beep
     beep
     cls

End Sub


Sub Do_learn:
    cls:lcd "learning new"
    Do
           Gosub _read

           If Okread = 1 Then
              Call Beep                                     'repeat check
              If Rnumber = 0 Then                           ' agar avalin remote as ke learn mishavad
                 Incr Rnumber
                 Rnumber_e = Rnumber
                 Waitms 10
                 Ra = Address
                 Eevar(rnumber) = Ra
                 Waitms 10
                 Exit Do
              Else                                          'address avalin khane baraye zakhire address remote
                 For I = 1 To Rnumber
                     Ra = Eevar(i)
                     If Ra = Address Then                   'agar address remote tekrari bod yani ghablan learn shode
                        Set Buzz
                        Wait 1
                        Reset Buzz
                        Error = 1
                        Exit For
                     Else
                        Error = 0
                     End If
                 Next
                 If Error = 0 Then                          ' agar tekrari nabod
                    Incr Rnumber                            'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                    If Rnumber > 20 Then                    'agar bishtar az 100 remote learn shavad
                       Rnumber = 20
                       Set Buzz
                       Wait 5
                       Reset Buzz
                       beep
                       beep
                       cls
                    Else                                    'agar kamtar az 100 remote bod
                       Rnumber_e = Rnumber                  'meghdare rnumber ra dar eeprom zakhore mikonad
                       Ra = Address
                       Eevar(rnumber) = Ra
                       Waitms 10
                    End If
                 End If
              End If


              Exit Do
           End If
         Okread = 0
         Reset Led1

    Loop


End Sub

'subroutine that is called when a sms is received
's hold the received string
'+CMTI: "SM",5
'(
Sub Showsms(s As String )
     #if Uselcd = 1
         Cls
     #endif
     I = Instr(s , ",")                                     ' find comma
     I = I + 1
     Stemp = Mid(s , I)                                     ' s now holds the index number
     #if Uselcd = 1
         Lcd "get " ; Stemp                                 'time to read the lcd
     #endif

     Print "AT+CMGR=" ; Stemp                               ' get the message
     Getline S                                              ' header +CMGR: "REC READ","+316xxxxxxxx",,"02/04/05,01:42:49+00"
     #if Uselcd = 1
         Lowerline
         Lcd S
     #endif
     Do
       Getline S
       Lcd S
       Wait 2
       Cls
       Wait 1
                                               ' get data from buffer
       Select Case S
              Case "MHB" :                                  'when you send PORT as sms text, this will be executed
                   #if Uselcd = 1
                       Cls : Lcd "do something!"
                   #endif
              Case "OK" : Exit Do                           ' end of message
              Case Else
       End Select

     Loop
     #if Uselcd = 1
         Home Lower : Lcd "remove sms"
     #endif
     Print "AT+CMGD=" ; Stemp                               ' delete the message
     Getline S                                              ' get OK
     #if Uselcd = 1
         Lcd S
     #endif
End Sub

')
'get line of data from buffer
Sub Getline(s As String)
    S = ""
    Do
      B = Inkey()
      Select Case B
             Case 0                                         'nothing
             Case 13                                        ' we do not need this one
             Case 10 : If S <> "" Then Exit Do              ' if we have received something
             Case Else
             S = S + Chr(b)                                 ' build string
      End Select
    Loop
End Sub

'flush input buffer
Sub Flushbuf()
    Waitms 100                                              'give some time to get data if it is there
    Do
    B = Inkey()                                             ' flush buffer
    Loop Until B = 0
End Sub

Sub Send_sms


     Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
     Getline Sret
     Print "AT+CMGS=" ; Chr(34) ; Num ; Chr(34)             'send sms
     Waitms 200
     Print Msg ; Chr(26)
     Wait 5
     Print "AT"
     Cls : Lcd Num : Wait 5 : Cls : Lcd Msg : Wait 5 : Cls : Waitms 500
     Flushbuf
     Charge
     Wait 5 : Cls : Lcd Sharj : Wait 5 : Cls : Waitms 500

End Sub

'(
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
')
Sub Resetsim
    Reset Simrst
    Wait 1
    Set Simrst
End Sub


'(
Sub Money
Print "ATD*140#"
Getline Sret
Getline Sret
Sharj = Left(sret , 33)
Sharj = Right(sharj , 6)
Sharj = Ltrim(sharj)
End Sub
')

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
     Getline Sret
End Sub

Sub Delread
     Flushbuf
     Print "AT+CMGDA=DEL READ"
     Getline Sret
End Sub