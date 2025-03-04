
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
config lcdpin=pin;db7=porta.4;db6=portb.4;db5=portb.3;db4=portb.2;rs=portb.0;en=portb.1
config lcd=16*2
cursor off
cls:lcd "hi" :wait 2:cls

config_sim:
'HW stack 20, SW stack 8 , frame 10



'some subroutines
Declare Sub Getline(ss As String)
Declare Sub Flushbuf()
Declare Sub Showsms(ss As String )
Declare Sub Send_sms
declare sub adminsms
'Declare Sub Dial
Declare Sub Resetsim
'Declare Sub Checksim
'Declare Sub Money
'Declare Sub Temp
'Declare Sub Antenna
'Declare Sub Charge
Declare Sub Delall
Declare Sub Delread
declare sub delremote
declare sub newlearn

Declare Sub ra_r
Declare Sub ra_w
declare sub rnumber_er
declare sub rnumber_ew
Declare Sub decode
declare sub eew
Declare Sub eer


'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 100 , Stemp As String * 6
'Dim U As Byte
'Dim Lim As Byte

Dim Msg As String * 60
dim number as string*13
dim enum1 as eram string*13
dim enum2 as eram string*13
dim enum3 as eram string*13
'dim enum4 as eram string*13
dim num1 as  string*13
dim num2 as  string*13
dim num3 as  string*13
'dim num4 as  string*13
dim order as string*10

dim efirst as eram byte
dim first as  byte

Dim Sheader(5) As String * 30
Dim Net As String * 10
Dim Count As Byte

Simrst Alias Portd.2 : Config Simrst = Output
Config Serialin = Buffered , Size = 100                     ' buffer is small a bigger chip would allow a bigger buffer
Enable Interrupts
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
Dim R As Byte : R = 0
const uselcd=1
Config_remote:
declare sub check
declare sub command

'-------------------------------------------------------------------------------

Config Portd.6 = Input :_in Alias Pind.6

config portd.5=input:key alias pind.5
Config porta.0 = Output:led1 Alias Porta.0
config porta.1=OUTPUT:buzz alias porta.1
config porta.2=OUTPUT:relay alias porta.2


dim timeout as  byte
Config Scl = Portc.0
Config Sda = Portc.1

Const write_address = 160                                         'eeprom write address
Const read_address = 161                                          'eeprom read address
'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
'Config Watchdog = 2048



config timer0= timer ,prescale=1024
enable interrupts
enable timer0
on ovf0 t0rutin
dim t0 as byte
start timer0


'--------------------------------- Variable ------------------------------------
Dim S(24)as Word

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

'declare sub beep

dim nobat as byte



Startup:

Resetsim

For I = 1 To 30
   set led1
   waitms 500
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
#if uselcd=1
cls:lcd "At?":lowerline : lcd sret: wait 1:cls
#endif                                            ' feedback on display
Loop Until Sret = "OK"                                      ' modem must send OK
Flushbuf                                                    ' flush the input buffer





Print "AT+cpin?"                                            ' get pin status
Getline Sret
#if uselcd=1
cls:lcd "AT+cpin?":lowerline : lcd sret: wait 1:cls
#endif


If Sret = "+CPIN: SIM PIN" Then
   Print Pincode                                            ' send pincode
End If
Flushbuf

Print "AT+CMGF=1"                                           ' set SMS text mode
Getline Sret                                                ' get OK status
#if uselcd=1
cls:lcd "AT+CMGF=1":lowerline : lcd sret: wait 1:cls
#endif

Waitms 500


Print "At+Cusd=1"
Getline Sret
#if uselcd=1
cls:lcd "At+Cusd=1":lowerline : lcd sret: wait 1:cls
#endif


Flushbuf

'sms settings
Print "AT+CSMP=17,167,0,0"
'Print "AT+CSMP=17,167,2,25"
Getline Sret
#if uselcd=1
cls:lcd "AT+CSMP":lowerline : lcd sret: wait 1:cls
#endif
'Print "AT+CNMI=0,1,2,0,0"
'Print "AT+CNMI=2,2,0,0,0"
'Print "AT+CNMI=1,2,0,0,0"
Print "AT+CNMI=2,1,0,0,0"
Getline Sret
#if uselcd=1
cls:lcd "AT+CNMI=":lowerline : lcd sret: wait 1:cls
#endif

  Flushbuf
   Print "AT+CSMP?"
   Getline Sret
#if uselcd=1
cls:lcd "AT+CSMP?":lowerline : lcd sret: wait 1:cls
#endif

  Flushbuf
   Print "AT+CNMI?"
   Getline Sret
   #if uselcd=1
cls:lcd "AT+CNMI?":lowerline : lcd sret: wait 1:cls
#endif

Waitms 500

Do
  Flushbuf
   Print "AT+CMGF=1"
   Getline Sret
   #if uselcd=1
cls:lcd "AT+CMGF=1":lowerline : lcd sret: wait 1:cls
#endif
Loop Until Sret = "OK"

print "AT+CMGF?"
waitms 100
getline sret
#if uselcd=1
cls:lcd "AT+CMGF?":lowerline : lcd sret: wait 1:cls
#endif
  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret

#if uselcd=1
cls:lcd "AT+CSCS=":lowerline : lcd sret: wait 1:cls
#endif



Do
   Delall
   Waitms 500
Loop Until Sret = "OK"

for i=1 to 20
    toggle led1
    waitms 100
next

set relay
waitms 200
reset relay

first=efirst
waitms 10
if first=255 then
   msg="first time"
    adminsms
    efirst=0:waitms 10
end if

Main:
          msg=""
          msg= "System Is Online Now"
          send_sms

          waitms 500
          flushbuf
          'cls

Do
 start timer0
     'stop timer0
     gosub _read
     'start timer0
     if key=0 then
        set led1
        i=0
        do
          waitms 25
          incr i
          if i>40 or key=1 then exit do
        loop until key=1
        if i>40 then gosub delremote else gosub newlearn
     end if


      Getline Sret ' wait for a modem response
      'start timer0
      '#if Uselcd = 1
      'Cls
      'Lcd "Msg from modem"
      'Home Lower : Lcd Sret
      '#endif
      I = Instr(sret , ":") ' look for :
      If I > 0 Then 'found it
      Stemp = Left(sret , I)
      Select Case Stemp
      Case "+CMTI:" : Showsms Sret ' we received an SMS
      ' hanle other cases here
      End Select
      End If


loop
'Charge
'Wait 5

'get line of data from buffer


'get line of data from buffer
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
        if key=0 then
           set led1
           i=0
           do
             waitms 25
             incr i
             if i>40 or key=1 then exit do
           loop until key=1
           if i>40 then gosub delremote else gosub newlearn
        end if


    Loop
    'start timer0
End Sub


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
         Case "on"  'when you send PORT as sms text, this will be executed
               set relay
               msg="relay is on"
         Case "ok"
               Exit Do ' end of message
         Case "off"
               reset relay
               msg="relay is off"
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
         case "rf1234"
               enum1="@@@@@@@@@@@@@":num1=enum1:waitms 10
               enum2="@@@@@@@@@@@@@":num2=enum2:waitms 10
               enum3="@@@@@@@@@@@@@":num3=enum3:waitms 10
               first=255:efirst=first:waitms 10


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

'flush input buffer
Sub Flushbuf()                                             'give some time to get data if it is there
    Do
      B = Inkey()                                            ' flush buffer
    Loop Until B = 0
End Sub

Sub Send_sms
'stop timer0

incr nobat
msg=msg+" *"
msg=msg+str(nobat)



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


 '(

     for i=1 to 10
            Print "AT+CMGS=" ; Chr(34) ; "+989155191622" ; Chr(34)             'send sms
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
  ')






End Sub

sub adminsms
     for i=1 to 10
       Print "AT+CMGS=" ; Chr(34);"+989155191622"; Chr(34)             'send sms
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

t0rutin:
        stop timer0
             incr t0
             if relay=0 then
                if t0=12 then
                   t0=0
                   toggle led1
                end if
             end if
             if t0=42 and relay=1 then
                t0=0

                   toggle led1

                   if timeout>0 then
                      decr timeout
                      if timeout=0 then
                         reset relay
                      end if
                   end if

             end if

        start timer0
return
'(
Sub Dial
    Print "Atd" ; 09376921503 ; ";"
    Wait 20
    Print "Ath"
End Sub
')
'(
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
'(
Sub Antenna
  Flushbuf
  Print "AT+CSQ"
  Getline Sret
  'Count = Split(sret , Sbody(1) , " ")
  'Anten = Val(sbody(2))
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
  ')
 '(
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
   ')
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

sub newlearn:

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
            Check

            I = 0
         End If
      End If
return
'================================================================ keys  learning


'========================================================================= CHECK
sub Check
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
end sub
'-------------------------------- Relay command
sub Command
       'set led1
       'timeout=10
       'set relay
       'msg=""
         ' msg="ALARM"
         ' send_sms
                 toggle led1
        cls:lcd code
        wait 1
end sub


'---------------------- for write a byte to eeprom
sub Eew:
I2cstart
I2cwbyte write_address
I2cwbyte Eaddress                                           'A
I2cwbyte datawrite
I2cstop
Waitms 10
end sub
'''''''''''''''''''''' for read a byte to eeprom
sub Eer:
I2cstart
I2cwbyte write_address
I2cwbyte Eaddress                                           'A
I2cstart
I2cwbyte read_address
I2crbyte dataread , Nack
I2cstop
end sub

'--------------------------------- rnumber_er >eeprom read remote number learn
sub Rnumber_er:
Eaddress = 1
Gosub Eer
Rnumber = dataread
end sub
'----------------------- rnumber_ew
sub Rnumber_ew:
Eaddress = 1
datawrite = Rnumber
Gosub Eew
end sub
'----------------------ra_w   write address code to eeprom
sub Ra_w:
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
end sub
'----------------------ra_r  read address code from eeprom
sub Ra_r:
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
end sub
'------------------------------------------------------decode eeprom address
sub Decode:
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
end sub


end