

$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600

'HW stack 20, SW stack 8 , frame 10

'Config 'lcdpin = 16 * 2 , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
'Config 'lcd = 16 * 2
'Cursor Off

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
Dim Num As String * 13 :Num = "+09155191622"
'Num = "+989376921503"
Dim Sharj As String * 160
Dim Sheader(5) As String * 30
Dim Sbody(5) As String * 30
Dim Net As String * 10
Dim Count As Byte
Dim Scount As Byte
Dim Length As Byte
Dim Anten As Word
Simrst Alias Portd.2 : Config Simrst = Output

'we use a serial input buffer
Config Serialin = Buffered , Size = 50                     ' buffer is small a bigger chip would allow a bigger buffer

'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts

'define a constant to enable 'lcd feedback
'Const Use lcd = 1
Const Senddemo = 1                                          ' 1= send an sms
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
Const Phonenumber = "AT+CMGS=09376921503"                   ' phonenumber to send sms to
const password=1234


Config_remote:
declare sub check
declare sub command
declare sub _read
declare sub do_learn
declare sub del_remote
'-------------------------------------------------------------------------------
Config Portd.4 = Input :_in Alias Pind.4
'Config portd.6 = Output:buzz Alias Portd.6
config portb.0=input:key alias pinb.0
Config portb.1 = Output:led1 Alias Portb.1
config portd.3=OUTPUT:relay alias portd.3

ds1 alias portd.5:config portd.5=INPUT
ds2 alias portd.6:config portd.6=INPUT
ds3 alias portd.7:config portd.7=INPUT


'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
'config timer0= timer ,prescale=1024
'enable interrupts
'enable timer0
'on ovf0 t0rutin
dim t0 as byte
'start timer0
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
Rnumber=Rnumber_e
waitms 10
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
For I = 1 To 15
    Waitms 300
Next



Print "AT"                                                  ' send AT command twice to activate the modem
Print "AT"
Flushbuf
'Print "AT&F"
Flushbuf                                                    ' flush the buffer
Print "ATE0"



Do
  Flushbuf
   Print "AT" :                                             ' Waitms 100
   Getline Sret                                             ' get data from modem                                             ' feedback on display
Loop Until Sret = "OK"                                      ' modem must send OK
Flushbuf                                                    ' flush the input buffer




Print "AT+cpin?"                                            ' get pin status
Getline Sret



If Sret = "+CPIN: SIM PIN" Then
   Print Pincode                                            ' send pincode
End If
Flushbuf

Print "AT+CMGF=1"                                           ' set SMS text mode
Getline Sret                                                ' get OK status


Print "At+Cusd=1"
Getline Sret


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

  Flushbuf
   Print "AT+CNMI?"
   Getline Sret



Do
  Flushbuf
   Print "AT+CMGF=1"
   Getline Sret
   Waitms 300
Loop Until Sret = "OK"
Wait 1

  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret
Wait 1


Do
   Delall
   Waitms 500
Loop Until Sret = "OK"


Main:

Msg = "module is restarted"
Send_sms
for i=1 to 10
    toggle led1
    waitms 250
next
'set relay
waitms 500
'reset relay
reset led1

do
  'start timer0
  'if relay=0 then reset led1 else set led1

   _read
  if key=0 then
     'stop timer0
     reset led1
     waitms 250
     set led1
     i=0
     do
       waitms 50
       incr i
       if i>20 then exit do
     loop until  key=1
     if i>20 then del_remote else do_learn
     'start timer0
  end if


loop
'(
Do
  Flushbuf
  Cls : Wait 1
  Antenna

  Wait 1
  Cls : 'lcd  "ANTEN= " ; Anten : Lowerline : 'lcd Sharj : 'lcd " $"

 ' Print "AT+CNMI?"
  'Getline Sret
  'Cls : 'lcd Sret : Wait 2 : Cls
  'If Sret = "OK" Then
     'Cls : 'lcd "NEW SMS" : Wait 2 : Cls
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
          Cls : 'lcd Sbody(1)
          Msg = ""
          If Sbody(1) = "?" Then
             Flushbuf
             'If relay = 0 Then Msg = "LED IS OFF" Else Msg = "LED IS ON"
             'Msg = Msg + Chr(13)
             Msg = Msg + "ANTEN=" + Net
             Msg = Msg + Chr(13)
             Msg = Msg + Sharj + " $"
             Msg = Msg + Chr(13)
             Send_sms
          End If
          If Lcase(sbody(1)) = "off" Then
             Reset relay
             Msg = "LED IS OFF"


             Send_sms
          End If
          If Lcase(sbody(1)) = "on" Then
             Set relay
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
')


t0rutin:
'(
        'stop timer0
        incr t0
        if relay=1 then led1=1 else led1=0
        if t0>0 and t0<=4 then toggle led1
        if t0>4 then
           if relay=1 then  set led1 else reset led1
        end if
        if t0=42 then
           t0=0
           incr refresh
           if refresh=30 then
              antenna
              refresh=0
           end if
           if relay=1  and timeout>0 then
              decr timeout
              if timeout=0 then
                 reset relay
                 Msg = "alarm is off"
                 'Send_sms
              end if
           end if
           'toggle led1
        end if
        'start timer0
')
return
'--------------------------------------------------------------------------read
sub _read:
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
end sub
'================================================================ keys  learning


'========================================================================= CHECK
sub Check:
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
end sub
'-------------------------------- Relay command
sub Command:
       toggle led1
       'toggle relay
        Waitms 500
end sub

Sub Beep
    'Set led1
    'Waitms 80
    'Reset led1
    'Waitms 30
End Sub


Sub del_remote

     cls:'lcd "delete remote"
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
    'cls:lcd "learning new"
    Do
           _read

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
                        Set led1
                        Wait 1
                        Reset led1
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
                       Set led1
                       Wait 5
                       Reset led1
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
         Reset relay

    Loop


End Sub

'subroutine that is called when a sms is received
's hold the received string
'+CMTI: "SM",5
'(
Sub Showsms(s As String )
     #if Use'lcd = 1
         Cls
     #endif
     I = Instr(s , ",")                                     ' find comma
     I = I + 1
     Stemp = Mid(s , I)                                     ' s now holds the index number
     #if Use'lcd = 1
         'lcd "get " ; Stemp                                 'time to read the 'lcd
     #endif

     Print "AT+CMGR=" ; Stemp                               ' get the message
     Getline S                                              ' header +CMGR: "REC READ","+316xxxxxxxx",,"02/04/05,01:42:49+00"
     #if Use'lcd = 1
         Lowerline
         'lcd S
     #endif
     Do
       Getline S
       'lcd S
       Wait 2
       Cls
       Wait 1
                                               ' get data from buffer
       Select Case S
              Case "MHB" :                                  'when you send PORT as sms text, this will be executed
                   #if Use'lcd = 1
                       Cls : 'lcd "do something!"
                   #endif
              Case "OK" : Exit Do                           ' end of message
              Case Else
       End Select

     Loop
     #if Use'lcd = 1
         Home Lower : 'lcd "remove sms"
     #endif
     Print "AT+CMGD=" ; Stemp                               ' delete the message
     Getline S                                              ' get OK
     #if Use'lcd = 1
         'lcd S
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
     Flushbuf

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
      'lcd Sret
      If Sret <> "OK" Then
         Incr Lim
         If Lim = 5 Then
            Lim = 0
            Resetsim
            Cls
            'lcd "sim was reset"
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

'Print "At+Cusd=1," ; Chr(34) ; "*140#" ; Chr(34)

Print "At+Cusd=1," ; Chr(34) ; "*555*1*2#" ; Chr(34)
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