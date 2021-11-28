$regfile="m32def.dat"
$crystal=11059200


configs:

led1 alias porta.0 :config porta.0=OUTPUT
led3 alias porta.2 :config porta.2=OUTPUT
led4 alias porta.3 :config porta.3=OUTPUT

Tm1637_clk Alias Portc.3: config portc.3 =output
Tm1637_dout Alias Portc.2 :config portc.2=output
Tm1637_din Alias Pinc.2

rst alias portd.2:config portd.2=OUTPUT

defines:

declare sub flushbuf
declare sub resetsim
Declare Sub Getline(ss As String)
declare sub showsms(ss as string)
declare sub delall
declare sub adminsms
declare sub delread
declare sub send_sms
dim b as byte
dim r as byte
Dim Msg As String * 60
dim number as string*13
Dim Sheader(5) As String * 30
dim order as string*10
Dim Count As Byte
dim enum1 as eram string*13
dim enum2 as eram string*13
dim enum3 as eram string*13
'dim enum4 as eram string*13
dim num1 as  string*13
dim num2 as  string*13
dim num3 as  string*13
dim nobat as byte

Const Pincode = "AT+CPIN=1234"

Declare Sub disp(byval Bdispdata As integer)            'The display can only show numbers
declare sub dispstr(byval strshow as string*5)

Declare Sub wrbyte(byval Bdata As Byte)
Declare Sub dispon()
Declare Sub Tm1637_off()
Declare Sub _start()
Declare Sub _stop()
Declare Sub _ack()

dim showw as integer
dim strshow as string*5
Declare Sub Settime
declare sub readtime

Const Ds1307w = &HD0
Const Ds1307r = &HD1

declare sub delremote
declare sub learnnew

dim lsec as byte
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
dim timee as integer

Dim Sret As String * 100 , Stemp As String * 6


Config_remote:

'-------------------------------------------------------------------------------
_in Alias Pind.6  :Config portd.6 = Input
key1 Alias Pind.5  :Config portd.5 = input
Buzz Alias Porta.1 :Config porta.1 = Output
Config Pinb.1 = Input
Config Scl = Portc.0
Config Sda = Portc.1

Const write_address = 160                                         'eeprom write address
Const read_address = 161                                          'eeprom read address
'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
'Config Watchdog = 2048
'--------------------------------- Variable ------------------------------------
Dim S(24)as Word
Dim I As Byte
I = 0
Dim Saddress As String * 20
Dim Scode As String * 4
Dim Address As Long
Dim Code As Byte
''''''''''''''''''''''''''''''''
Dim Ra As Long                                              'fp address
Dim Rnumber As Byte                                         'remote know
Dim Okread As Bit
Dim Error As Bit
Dim Keycheck As Bit
Dim T As Word                                               'check for pushing lean key time
Error = 0
Okread = 0
T = 0
Keycheck = 0
Dim Eaddress As Word                                        'eeprom address variable
Dim dataread As Byte
Dim datawrite As Byte
Dim M As String * 8
Dim M1 As String * 2
Dim M2 As String * 2
Dim M3 As String * 2

dim raw as byte
'-------------------------- read rnumber index from eeprom
Gosub Rnumber_er
If Rnumber > 100 Then
Rnumber = 0
Gosub Rnumber_ew
End If
'------------------- startup
for i=1 to 8
    toggle led3
    waitms 250
next
reset led3
waitms 500


Startup:

Resetsim

For I = 1 To 30
   set led1
   waitms 250
Next
reset led1
Wait 5
Print "AT&F"
flushbuf
Print "AT"                                                  ' send AT command twice to activate the modem
Print "AT"
Flushbuf
'Print "AT&F"
Flushbuf
Print "AT&F"
flushbuf                                                   ' flush the buffer
Print "ATE0"




Do
  Flushbuf
   Print "AT" :                                             ' Waitms 100
   Getline Sret                                             ' get data from modem
       'Lcd Sret                                             ' feedback on display
Loop Until Sret = "OK"                                      ' modem must send OK
Flushbuf                                                    ' flush the input buffer





Print "AT+cpin?"                                            ' get pin status
'Getline Sret



If Sret = "+CPIN: SIM PIN" Then
   Print Pincode                                            ' send pincode
End If
Flushbuf

Print "AT+CMGF=1"                                           ' set SMS text mode
Getline Sret                                                ' get OK status


Waitms 500


Print "At+Cusd=1"
Getline Sret



Flushbuf

'sms settings
Print "AT+CSMP=17,167,0,0"
'Print "AT+CSMP=17,167,2,25"
'Getline Sret

'Print "AT+CNMI=0,1,2,0,0"
'Print "AT+CNMI=2,2,0,0,0"
'Print "AT+CNMI=1,2,0,0,0"
Print "AT+CNMI=2,1,0,0,0"
'Getline Sret


  Flushbuf
   Print "AT+CSMP?"
   'Getline Sret


  Flushbuf
   Print "AT+CNMI?"
   'Getline Sret

Waitms 500

Do
  Flushbuf
   Print "AT+CMGF=1"
   Getline Sret
   'cls:lcd "text mode":lowerline : lcd sret: wait 1:cls
Loop Until Sret = "OK"

print "AT+CMGF?"
waitms 100
getline sret
'cls:lcd "text mode?":lowerline : lcd sret: wait 1:cls

  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret





Do
   Delall
   Waitms 500
Loop Until Sret = "OK"

   msg="first time"
    adminsms

settime
dispon
 _start

 for i=1 to 16
     toggle buzz
     waitms 200
 next

Main:


Do
      Getline Sret ' wait for a modem response

      I = Instr(sret , ":") ' look for :
      If I > 0 Then 'found it
      Stemp = Left(sret , I)
      Select Case Stemp
      Case "+CMTI:" : Showsms Sret ' we received an SMS
      ' hanle other cases here
      End Select
      End If
Loop
'*****************************************
'-------------------------------------read
_read:
      Okread = 0
      If _in = 1 Then
         Do
           If _in = 0 Then Exit Do
         Loop
         Timer1 = 0
         Start Timer1
         While _in = 0

         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
            Do
              If _in = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While _in = 1

                 Wend
                 Stop Timer1
                 Incr I
                 S(i) = Timer1
              End If

              If I = 24 Then Exit Do
            Loop
            For I = 1 To 24
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

'========================================================================= keys  learning
Keys:

     t=0
     do
       waitms 10
       incr t
       if t>300 then exit do
     loop until key1=1
     if t>300 then
        delremote
     end if
     if t<200 and t>0 then
                    Reset Led1
                    for i=1 to 8
                       toggle led1
                       toggle buzz
                       waitms 500
                   next
                   gosub learnnew
     end if
'(
     Set Led1
     Keycheck = 1                                           'hengame learn kardan be releha farman nade
     Waitms 150
     Do
       If Key1 = 0 Then                                     ' agar kelid feshorde bemanad

          While Key1 = 0
                Incr T
                Waitms 10
                If T >= 100 Then
                   t=0

                   Rnumber = 0
                   Gosub Rnumber_ew
                   Set Buzz
                   Wait 1
                   Wait 1
                   Reset Buzz
                   Reset Led1
                   for i=1 to 16
                       toggle led1
                       waitms 250
                   next
                   for eaddress=0 to 100
                       datawrite=0
                       gosub eew
                   next
                   Return
                   Exit While
                End If
          Wend
          If T < 100 and t>0  Then
                      'gosub _read
                    T = 0
                    Reset Led1
                    for i=1 to 8
                       toggle led1
                       toggle buzz
                       waitms 500
                   next
                   gosub learnnew
                    exit do
          End If
       End If
       if key1=1 then exit do
     Loop
     ')
Return

sub learnnew:
do
     Gosub _read
      If Okread = 1 Then

            ''''''''''''''''''''''repeat check
            If Rnumber = 0 Then                             ' agar avalin remote as ke learn mishavad
             Incr Rnumber
             Gosub Rnumber_ew
             Ra = Address
             Gosub Ra_w
             Exit Do
                Else
             Eaddress = 10                                  'address avalin khane baraye zakhire address remote
             For I = 1 To Rnumber
                    Gosub Ra_r
                    If Ra = Address Then                    'agar address remote tekrari bod yani ghablan learn shode
                                  Set Buzz
                                  Wait 1
                                  Reset Buzz
                                  Error = 1
                                  Exit For
                                  Else
                                  Error = 0
                    End If
                    Eaddress = Eaddress + 1
             Next
             If Error = 0 Then                              ' agar tekrari nabod
                Incr Rnumber                                'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                If Rnumber > 100 Then                       'agar bishtar az 100 remote learn shavad
                                Rnumber = 100
                                Set Buzz
                                Wait 5
                                Reset Buzz
                                Else                                        'agar kamtar az 100 remote bod
                                Gosub Rnumber_ew                            'meghdare rnumber ra dar eeprom zakhore mikonad
                                Ra = Address
                                Gosub Ra_w
                End If


             End If
            End If
            Exit Do
      End If
 loop
end sub
'================================================================ CHECK   code chek ok
Check:
      Okread = 1
      If Keycheck = 0 Then                                  'agar keycheck=1 bashad yani be releha farman nade
         Eaddress = 10
         For I = 1 To Rnumber
             Gosub Ra_r
             If Ra = Address Then                                   'code
                Gosub Command
                Exit For
             End If
             Eaddress = Eaddress + 1
         Next
      End If
      Keycheck = 0
Return
'-------------------------------- Relay command
Command:

   dispon
  _start
  disp code
        toggle led4
        wait 1



Return
'---------------------- for write a byte to eeprom
Eew:
I2cstart
I2cwbyte write_address
I2cwbyte Eaddress                                           'A
I2cwbyte datawrite
I2cstop
Waitms 10
Return
'''''''''''''''''''''' for read a byte to eeprom
Eer:
I2cstart
I2cwbyte write_address
I2cwbyte Eaddress                                           'A
I2cstart
I2cwbyte read_address
I2crbyte dataread , Nack
I2cstop
Return

'--------------------------------- rnumber_er >eeprom read remote number learn
Rnumber_er:
Eaddress = 1
Gosub Eer
Rnumber = dataread
Return
'----------------------- rnumber_ew
Rnumber_ew:
Eaddress = 1
datawrite = Rnumber
Gosub Eew
Return
'----------------------ra_w   write address code to eeprom
Ra_w:
M = ""
M = Hex(ra)
M1 = Mid(m , 3 , 2)
M2 = Mid(m , 5 , 2)
M3 = Mid(m , 7 , 2)
Gosub Decode
datawrite = Hexval(m1)
Gosub Eew
Incr Eaddress
datawrite = Hexval(m2)
Gosub Eew
Incr Eaddress
datawrite = Hexval(m3)
Gosub Eew
Return
'----------------------ra_r  read address code from eeprom
Ra_r:
Gosub Eer
M1 = Hex(dataread)
Incr Eaddress
Gosub Eer
M2 = Hex(dataread)
Incr Eaddress
Gosub Eer
M3 = Hex(dataread)
M = ""
M = M + M1
M = M + M2
M = M + M3
Ra = Hexval(m)
Return
'------------------------------------------------------decode eeprom address
Decode:
       Select Case Rnumber
              Case 1
              Eaddress = 10
              Case 2
              Eaddress = 13
              Case 3
              Eaddress = 16
              Case 4
              Eaddress = 19
              Case 5
              Eaddress = 22
              Case 6
              Eaddress = 25
              Case 7
              Eaddress = 28
              Case 8
              Eaddress = 31
              Case 9
              Eaddress = 34
              Case 10
              Eaddress = 37
              Case 11
              Eaddress = 40
              Case 12
              Eaddress = 43
              Case 13
              Eaddress = 46
              Case 14
              Eaddress = 49
              Case 15
              Eaddress = 52
              Case 16
              Eaddress = 55
              Case 17
              Eaddress = 58
              Case 18
              Eaddress = 61
              Case 19
              Eaddress = 64
              Case 20
              Eaddress = 67
              Case 21
              Eaddress = 70
              Case 22
              Eaddress = 73
              Case 23
              Eaddress = 76
              Case 24
              Eaddress = 79
              Case 25
              Eaddress = 82
              Case 26
              Eaddress = 85
              Case 27
              Eaddress = 88
              Case 28
              Eaddress = 91
              Case 29
              Eaddress = 94
              Case 30
              Eaddress = 97
              Case 40
              Eaddress = 100
              Case 41
              Eaddress = 103
              Case 42
              Eaddress = 106
              Case 43
              Eaddress = 109
              Case 44
              Eaddress = 112
              Case 45
              Eaddress = 115
              Case 46
              Eaddress = 118
              Case 47
              Eaddress = 121
              Case 48
              Eaddress = 124
              Case 49
              Eaddress = 127
              Case 50
              Eaddress = 130
              Case 51
              Eaddress = 133
              Case 52
              Eaddress = 136
              Case 53
              Eaddress = 139
              Case 54
              Eaddress = 142
              Case 55
              Eaddress = 145
              Case 56
              Eaddress = 148
              Case 57
              Eaddress = 151
              Case 58
              Eaddress = 154
              Case 59
              Eaddress = 157
              Case 60
              Eaddress = 160
              Case 70
              Eaddress = 163
              Case 71
              Eaddress = 166
              Case 72
              Eaddress = 169
              Case 73
              Eaddress = 172
              Case 74
              Eaddress = 175
              Case 75
              Eaddress = 178
              Case 76
              Eaddress = 181
              Case 77
              Eaddress = 184
              Case 78
              Eaddress = 187
              Case 79
              Eaddress = 190
              Case 80
              Eaddress = 193
              Case 81
              Eaddress = 196
              Case 82
              Eaddress = 199
              Case 83
              Eaddress = 202
              Case 84
              Eaddress = 205
              Case 85
              Eaddress = 208
              Case 86
              Eaddress = 211
              Case 87
              Eaddress = 214
              Case 88
              Eaddress = 217
              Case 89
              Eaddress = 220
              Case 90
              Eaddress = 223
              Case 91
              Eaddress = 226
              Case 92
              Eaddress = 229
              Case 93
              Eaddress = 232
              Case 94
              Eaddress = 235
              Case 95
              Eaddress = 238
              Case 96
              Eaddress = 241
              Case 97
              Eaddress = 244
              Case 98
              Eaddress = 247
              Case 99
              Eaddress = 250
              Case 100
              Eaddress = 253
              Case Else
       End Select
Return
'-------------------------------------------------------------------------------
Sub _ack()

   Reset Tm1637_clk
   Waitus 5
   Reset Tm1637_dout
   Bitwait Tm1637_din , Reset
   Set Tm1637_clk
   Waitus 2
   Reset Tm1637_clk
   Set Tm1637_dout

End Sub



Sub Tm1637_off()
   _start
   wrbyte &H80                                       'Turn display off
   _ack
   _stop
End Sub



Sub dispon()
   _start
   wrbyte &H8A                                       'Turn display on and set PWM for brightness to 25%
   _ack
   _stop
End Sub



Sub _start()

   Set Tm1637_clk
   Set Tm1637_dout
   Waitus 2
   Reset Tm1637_dout
End Sub


Sub _stop()

   Reset Tm1637_clk
   Waitus 2
   Reset Tm1637_dout
   Waitus 2
   Set Tm1637_clk
   Waitus 2
   Set Tm1637_dout
End Sub





Sub disp(byval Bdispdata As integer)
   Local Bcounter As Byte
   Local Strdisp As String * 5

   Strdisp = Str(bdispdata)
   Strdisp = Format(strdisp , "     ")

   _start
   wrbyte &H40                                       'autoincrement adress mode
   _ack
   _stop
   _start
   wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
   _ack

   For Bcounter = 2 To 6
      Select Case Asc(strdisp , Bcounter)
         Case "0" : wrbyte &B00111111
         Case "1" : wrbyte &B00000110
         Case "2" : wrbyte &B01011011
         Case "3" : wrbyte &B01001111
         Case "4" : wrbyte &B01100110
         Case "5" : wrbyte &B01101101
         Case "6" : wrbyte &B01111101
         Case "7" : wrbyte &B00000111
         Case "8" : wrbyte &B01111111
         Case "9" : wrbyte &B01101111
         case "-" : wrbyte &B01000000
         case "c" : wrbyte &B01111001
         Case Else : wrbyte &B00000000
      End Select
      _ack
   Next
   _stop
End Sub

Sub dispstr(byval strshow as string*5)
   Local Bcounter As Byte
   Local Strdisp As String * 5

   'Strdisp = strshow
   Strdisp = Format(strshow , "     ")

   _start
   wrbyte &H40                                       'autoincrement adress mode
   _ack
   _stop
   _start
   wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
   _ack

   For Bcounter = 2 To 6
      Select Case Asc(strdisp , Bcounter)
         Case "0" : wrbyte &B00111111
         Case "1" : wrbyte &B00000110
         Case "2" : wrbyte &B01011011
         Case "3" : wrbyte &B01001111
         Case "4" : wrbyte &B01100110
         Case "5" : wrbyte &B01101101
         Case "6" : wrbyte &B01111101
         Case "7" : wrbyte &B00000111
         Case "8" : wrbyte &B01111111
         Case "9" : wrbyte &B01101111
         case "-" : wrbyte &B01000000
         case "c" : wrbyte &B01111001
         Case Else : wrbyte &B00000000
      End Select
      _ack
   Next
   _stop
End Sub


Sub wrbyte(byval Bdata As Byte)
   Local Bbitcounter As Byte

   For Bbitcounter = 0 To 7                                 'LSB first
      Reset Tm1637_clk
      Tm1637_dout = Bdata.bbitcounter
      Waitus 3
      Set Tm1637_clk
      Waitus 3
   Next
End Sub

Sub Settime:
   _sec = 0
   _sec = Makebcd(_sec) : _min = Makebcd(_min) : _hour = Makebcd(_hour)
   I2cstart                                                 ' Generate start code
   I2cwbyte Ds1307w                                         ' send address
   I2cwbyte 0                                               ' starting address in 1307
   I2cwbyte _sec                                            ' Send Data to SECONDS
   I2cwbyte _min                                            ' MINUTES
   I2cwbyte _hour                                           ' Hours
   I2cstop
End Sub


Sub Readtime
   I2cstart                                                 ' Generate start code
   I2cwbyte Ds1307w                                         ' send address
   I2cwbyte 0                                               ' start address in 1307
   I2cstart                                                 ' Generate start code
   I2cwbyte Ds1307r                                         ' send address
   I2crbyte _sec , Ack
   I2crbyte _min , Ack                                      ' MINUTES
   I2crbyte _hour , nAck                                     ' Hours
                                   ' Year
   I2cstop
   _sec = Makedec(_sec) : _min = Makedec(_min) : _hour = Makedec(_hour)


End Sub


Sub Flushbuf()                                             'give some time to get data if it is there
    Do
      B = Inkey()                                            ' flush buffer
    Loop Until B = 0
End Sub

Sub Resetsim
    Reset rst
    Wait 1
    Set rst
End Sub

Sub Getline(ss As String)
        'stop timer0
    ss = ""
    Do
      B = Inkey()
      Select Case B
             Case 0                                       'nothing
             Case 13
               'If S <> "" Then Exit Do                                       ' we do not need this one
             Case 10
               If ss <> "" Then
                  'if lcase(s)="error" then resetsim
                  Exit Do
               end if            ' if we have received something
             Case Else
             ss = ss + Chr(b)                                 ' build string
      End Select

        'stop timer0
        gosub _read
        'start timer0
        if key1=0 then
           set led1
           i=0
           do
             waitms 25
             incr i
             if i>40 or key1=1 then exit do
           loop until key1=1
           if i>40 then gosub delremote else learnnew
        end if
        readtime
        if _sec<>lsec then
           disp _sec
           lsec=_sec
           'toggle led1
        end if

      I = Instr(ss , ":") ' look for :
      If I > 0 Then 'found it
         Stemp = Left(ss , I)
         Select Case Stemp
                Case "+CMTI:" : Showsms ss ' we received an SMS
         ' hanle other cases here
         End Select
      End If

    Loop
    'start timer0
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

sub delremote
              Rnumber = 0
              Gosub Rnumber_ew
              for eaddress=0 to 100
                       datawrite=0
                       gosub eew
              next
              reset buzz
              for i=1 to 16
                       toggle led1
                       waitms 250
              next
end sub


sub adminsms
     for i=1 to 10
       Print "AT+CMGS=" ; Chr(34);"+989155609631"; Chr(34)             'send sms
       Waitms 250
       Print Msg ; Chr(26)
       Wait 1
       r=0
       do
         getline sret
         if lcase(sret)="ok" then exit do
         waitms 500
         incr r
         if r=10 then exit do
       loop until lcase(sret)="ok"
       if lcase(sret)="ok" then exit for
     next
end sub


Sub Showsms(ss As String )
'stop timer0
 '#if Uselcd = 1
 'Cls
 '#endif
 I = Instr(ss , ",") ' find comma
 I = I + 1
 stemp = Mid(ss , I) ' s now holds the index number
 '#if Uselcd = 1
 'Lcd "get " ; Stemp
 'Waitms 1000 'time to read the lcd
 '#endif
 Print "AT+CMGR=1"
 'Print "AT+CMGR=" ; Stemp ' get the message
 Getline Sret ' header +CMGR: "REC READ","+316xxxxxxxx",,"02/04/05,01:42:49+00"

 I = Instr(ss , "+98") ' find comma
 r = I + 10
 number = mid(ss , I , r) ' s now holds the index number
 count=split(number,sheader(1),chr(34))
 'for i=1 to 3
     'cls:lcd sheader(i):lowerline :lcd i:wait 1:cls
 'next
 number=sheader(1)
 '#if Uselcd = 1
  '   cls:Lcd number:wait 1:cls
 'Waitms 1000 'time to read the lcd
' #endif

 '#if Uselcd = 1
 Lowerline
 Lcd S
 '#endif
 Do
  Getline Sret ' get data from buffer
  'cls:lcd s:wait 1:cls
  order=""
  order=lcase(sret)

  Select Case lcase(sret)
         'Case "on"  'when you send PORT as sms text, this will be executed
               'set relay
               'msg="relay is on"
         Case "ok"
               Exit Do ' end of message
         'Case "off"
               'reset relay
               'msg="relay is off"
         Case "new1"
               enum1=number
               waitms 10
               msg="number#1 is saved"
         Case "new2"
               enum2=number
               msg="number#2 is saved"
         Case "new3"
               enum3=number
               msg="number#3 is saved"
         Case "del1"
               num1=""
               enum1=num1
               waitms 10
               msg="num#1 is deleted"
         Case "del2"
               num2=""
               enum2=num2
               waitms 10
               msg="num#2 is deleted"
         Case "del3"
               num3=""
               enum3=num3
               waitms 10
               msg="num#3 is deleted"
         case "status"
               order="status"

                 msg=""
                 num1=enum1:waitms 10
                 num2=enum2:waitms 10
                 num3=enum3:waitms 10
                 msg=" "
                 msg=num1+"/  /"
                 msg=msg+num2
                 msg=msg+"/  /"
                 msg=msg+num3
         '(
         case "rf1234"
               enum1="@@@@@@@@@@@@@":num1=enum1:waitms 10
               enum2="@@@@@@@@@@@@@":num2=enum2:waitms 10
               enum3="@@@@@@@@@@@@@":num3=enum3:waitms 10
               first=255:efirst=first:waitms 10
                    Rnumber = 0
                    Rnumber_e = Rnumber
                    waitms 20
                    for i=1 to 20
                        eevar(i)=0
                        waitms 20
                    next
         ')
         case  "mhb"
                for i=1 to 16
                    toggle led1:toggle led3:toggle buzz
                    waitms 250
                next
         Case Else
              msg="wrong sms"

              set led1:wait 1: reset led1

  End Select

 Loop
 '#if Uselcd = 1
 Home Lower : Lcd "remove sms" : wait 1:cls
 '#endif
do
 Print "AT+CMGDA=DEL READ"
 'Print "AT+CMGD=" ; Stemp  ' delete the message
 waitms 20
 Getline Sret ' get OK
 incr i
 if i=10 then exit do
 loop until lcase(sret)="ok"
 '#if Uselcd = 1
 'Lcd S
 '#endif

     if order<>"" and order<>"status" and order<>"rf1234"  then
        set led1
        for i=1 to 10
            toggle led1
            waitms 200
        next
        send_sms
     elseif order="status" then
            send_sms
     end if
     if order="new1" or order="new2" or order="new3" then
        msg=""
        msg="new number /  /"
        msg=msg+number
        adminsms
     end if
      if order="rf1234" then
        msg=""
        msg="Reset Factory is Done"
        msg=msg+number
        adminsms
     end if
     order=""
     delread
     'start timer0

End Sub

Sub Send_sms
'stop timer0

incr nobat
msg=msg+" *"
msg=msg+str(nobat)
num1=enum1
waitms 10
num2=enum2
waitms 10
num3=enum3
waitms 10
'num4=enum4
'waitms 10
'cls:lcd num1:wait 2:cls
'cls:lcd num2:wait 2:cls
'cls:lcd num3:wait 2:cls
'cls:lcd num4:wait 2:cls
     i=0
     I = Instr(num1 , "+98")
     if i<>0 then
     for i=1 to 10
       Print "AT+CMGS=" ; Chr(34);num1; Chr(34)             'send sms
       Waitms 250
       Print Msg ; Chr(26)
       Wait 1
       r=0
       do
         getline sret
         if lcase(sret)="ok" then exit do
         waitms 500
         incr r
         if r=10 then exit do
       loop until lcase(sret)="ok"
       if lcase(sret)="ok" then exit for
     next
     end if

     i=0
     I = Instr(num2 , "+98")
     if i<>0 then
     for i=1 to 10
            Print "AT+CMGS=" ; Chr(34) ; num2 ; Chr(34)             'send sms
            Waitms 250
            Print Msg ; Chr(26)
            Wait 1
            r=0
            do
              getline sret
              if lcase(sret)="ok" then exit do
              waitms 500
              incr r
              if r=10 then exit do
            loop until lcase(sret)="ok"
            if lcase(sret)="ok" then exit for
     next
     end if

     i=0
     I = Instr(num3 , "+98")
     if i<>0 then
     for i=1 to 10
         Print "AT+CMGS=" ; Chr(34) ; num3 ; Chr(34)             'send sms
         Waitms 250
         Print Msg ; Chr(26)
         Wait 1
         r=0
         do
           getline sret
           if lcase(sret)="ok" then exit do
           waitms 500
           incr r
           if r=10 then exit do
         loop until lcase(sret)="ok"
         if lcase(sret)="ok" then exit for
     next
     end if



End Sub
