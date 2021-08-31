
' SMS.BAS
' (c) 2002 MCS Electronics
' This sample shows how to use AT command on a GSM mode
' The GSM modems are available from www.mcselec.com
'------------------------------------------------------------------------------
'tested on a 2314
$regfile = "m8def.dat"

'XTAL = 10 MHZ
$crystal = 11059200

'By default the modem works at 9600 baud
$baud = 9600

'HW stack 20, SW stack 8 , frame 10

Config Lcdpin = 16 * 2 , Db4 = Portc.2 , Db5 = Portc.3 , Db6 = Portc.4 , Db7 = Portc.5 , E = Portc.1 , Rs = Portc.0
Config Lcd = 16 * 2
Cursor Off


'some subroutines
Declare Sub Getline(s As String)
Declare Sub Flushbuf()
Declare Sub Showsms(s As String )
Declare Sub Send_sms
Declare Sub Dial
Declare Sub Resetsim
Declare Sub Checksim
Declare Sub Money
Declare Sub Temp
Declare Sub Antenna
Declare Sub Charge
Declare Sub Delall
Declare Sub Delread
'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 160 , Stemp As String * 6
Dim U As Byte
Dim Lim As Byte
Dim Msg As String * 160
Dim Num As String * 13 : Num = "+989376921503"
Dim Sharj As String * 160
Dim Sheader(10) As String * 10
Dim Sbody(10) As String * 10
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

'Led1 Alias Porta.0 : Config Porta.0 = Output


Configtemp:

'Config 1wire = Portc.3


'Dim Ds18b20_id_1(9) As Byte
'Dim Ds18b20_id_2(8) As Byte
''Dim Action As Byte
'Ds18b20_id_1(1) = 1wsearchfirst()

'Dim Temperature As String * 6
'Dim Sens1 As String * 6
'Dim Sens2 As String * 6


'Dim Refreshtemp As Byte

'Dim Readsens As Integer
'Dim Tmp1 As Integer

Startup:


Resetsim
Cls
Lcd "    LOADING    "
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



Do
  Flushbuf
   Print "AT" :                                             ' Waitms 100
   Getline Sret                                             ' get data from modem
       Lcd Sret                                             ' feedback on display
Loop Until Sret = "OK"                                      ' modem must send OK
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

Do
  Flushbuf
   Print "AT+CMGF=1"
   Getline Sret
       Cls : Lcd "TEXT MODE" : Lowerline : Lcd Sret
   Waitms 500
Loop Until Sret = "OK"
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


Do
   Delall
   Cls : Lcd "DEL ALL" : Lowerline : Lcd Sret : Wait 2 : Cls : Waitms 500
   Waitms 500
Loop Until Sret = "OK"
Wait 2



Main:

Msg = "SIM800 IS ONLINE NOW"
'Send_sms

Charge
Wait 5

Do
  Flushbuf
  Cls : Wait 1
  Antenna
  Temp
  Wait 1
 ' Cls : Lcd "TEMP=" ; Sens1 ; "ANTEN= " ; Anten : Lowerline : Lcd Sharj : Lcd " $"

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
             Msg = Msg + Chr(13)
             Msg = Msg + "ANTEN=" + Net
             Msg = Msg + Chr(13)
             Msg = Msg + Sharj + " $"
             Msg = Msg + Chr(13)
            ' Msg = Msg + Sens1 + Chr(39) + "C"
             Send_sms
          End If
          If Lcase(sbody(1)) = "off" Then
             'Reset Led1
             Msg = "LED IS OFF"


             Send_sms
          End If
          If Lcase(sbody(1)) = "on" Then
             'Set Led1
             Num = Sheader(2)
             Msg = "LED IS ON"
             Send_sms
          End If

          If Lcase(sbody(1)) = "temp" Then
             Temp
             Wait 5
             'Msg = Sens1
             Send_sms
          End If
          For I = 1 To 10
              Sheader(i) = ""
              Sbody(i) = ""
          Next

     End If
     Delread
Loop



Sub Temp
   '1wreset
  ' 1wwrite &HCC
  ' 1wwrite &H44
  ' Waitms 30
  ' 1wreset
  ' 1wwrite &H55
  ' 1wverify Ds18b20_id_1(1)
  ' 1wwrite &HBE
  ' Readsens = 1wread(2)


   'Tmp1 = Readsens

  ' Readsens = Readsens * 10 : Readsens = Readsens \ 16
  ' Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
    '  Sens1 = Temperature
End Sub


'subroutine that is called when a sms is received
's hold the received string
'+CMTI: "SM",5
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
       '(                                           ' get data from buffer
       Select Case S
              Case "MHB" :                                  'when you send PORT as sms text, this will be executed
                   #if Uselcd = 1
                       Cls : Lcd "do something!"
                   #endif
              Case "OK" : Exit Do                           ' end of message
              Case Else
       End Select
')
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
    Reset Simrst
    Wait 1
    Set Simrst
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
     Getline Sret
End Sub

Sub Delread
     Flushbuf
     Print "AT+CMGDA=DEL READ"
     Getline Sret
End Sub