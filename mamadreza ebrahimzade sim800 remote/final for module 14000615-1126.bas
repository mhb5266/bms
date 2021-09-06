
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

config lcdpin=16*2,db4=portc.2,db5=portc.3,db6=portc.4,db7=portc.5,e=portc.1,rs=portc.0
config lcd=16*2
cursor off
'cls:lcd "hi" :wait 2:cls

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
'num1=enum1
'waitms 10
'if left(num1,3)<>"+98" then num1="+989158530390"
'enum1=num1
'waitms 10
'Num(2) = "+989398291077"

'num2=enum2
'waitms 10
'if left(num2,3)<>"+98" then num2="+989158530390"
'enum2=num2
'waitms 10

'num3=enum3
'waitms 10
'if left(num3,3)<>"+98" then num3="+989158530390"
'enum3=num3
'waitms 10
'(
num4=enum4
waitms 10
if left(num4,3)<>"+98" then num4="+989155191622"
enum4=num4
waitms 10
')
'cls:lcd num1:lowerline:lcd "1":wait 2:cls
'cls:lcd num2:lowerline:lcd "2":wait 2:cls
'cls:lcd num3:lowerline:lcd "3":wait 2:cls
'cls:lcd num4:lowerline:lcd "4":wait 2:cls
'dim ncounter as byte

'Dim Sharj As String * 100

'dim a as byte

Dim Sheader(5) As String * 30
'Dim Sbody(5) As String * 30
Dim Net As String * 10
Dim Count As Byte
'Dim Scount As Byte
'Dim Length As Byte
'Dim Anten As Word





Simrst Alias Portd.2 : Config Simrst = Output

'we use a serial input buffer
Config Serialin = Buffered , Size = 100                     ' buffer is small a bigger chip would allow a bigger buffer

'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts

'define a constant to enable LCD feedback
'Const Uselcd = 1
'Const Senddemo = 1                                          ' 1= send an sms
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
'Const Phonenumber = "AT+CMGS=09376921503"                   ' phonenumber to send sms to


'Dim A As Bit
Dim R As Byte : R = 0
'Dim X As Byte : X = 0
'Dim B As Byte
'Dim G As Byte
'Dim P As Bit : P = 0
'Dim Sms As String * 70 : Sms = ""



Config_remote:
declare sub check
declare sub command
'declare sub _read
'declare sub do_learn
'declare sub del_remote
'-------------------------------------------------------------------------------

Config Portd.4 = Input :_in Alias Pind.4
'Config portd.6 = Output:buzz Alias Portd.6
config portb.0=input:key alias pinb.0
Config portb.1 = Output:led1 Alias Portb.1
config portd.3=OUTPUT:relay alias portd.3

'(
Config Portd.7 = Input :_in Alias Pind.7
'Config portd.6 = Output:buzz Alias Portd.6
config portd.5=input:key alias pind.5
Config portb.0 = Output:led1 Alias Portb.0
config portd.6=OUTPUT:relay alias portd.6
')
'ds1 alias pind.5:config portd.5=INPUT
'ds2 alias pind.6:config portd.6=INPUT
'ds3 alias pind.7:config portd.7=INPUT

dim timeout as  byte
'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
config timer0= timer ,prescale=1024
enable interrupts
enable timer0
on ovf0 t0rutin
dim t0 as byte
stop timer0
'--------------------------------- Variable ------------------------------------
Dim S(24) as Word

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
'Dim Eaddress As Word                                        'eeprom address variable
'Dim E_read As Byte
'Dim E_write As Byte
Dim Eevar(3) As Eram Long

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
       'Lcd Sret                                             ' feedback on display
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


Waitms 500


Print "At+Cusd=1"
Getline Sret



Flushbuf

'sms settings
Print "AT+CSMP=17,167,0,0"
'Print "AT+CSMP=17,167,2,25"
Getline Sret

'Print "AT+CNMI=0,1,2,0,0"
'Print "AT+CNMI=2,2,0,0,0"
'Print "AT+CNMI=1,2,0,0,0"
Print "AT+CNMI=2,1,0,0,0"
Getline Sret


  Flushbuf
   Print "AT+CSMP?"
   Getline Sret


  Flushbuf
   Print "AT+CNMI?"
   Getline Sret

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
        if i>40 then gosub del_remote else gosub do_learn
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
           if i>40 then gosub del_remote else gosub do_learn
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


          '(
          for i=1 to 10
              Print "AT+CMGS=" ; Chr(34) ; num4 ; Chr(34)             'send sms
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
'(
          for i=1 to 10
              Print "AT+CMGS=" ; Chr(34);"+989376921503"; Chr(34)             'send sms
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
  '(
          for i=1 to 10
              Print "AT+CMGS=" ; Chr(34) ; Num(3) ; Chr(34)             'send sms
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

      '(          '
          Print "AT+CMGS=" ; Chr(34) ; number ; Chr(34)             'send sms
          Waitms 250
          Print Msg ; Chr(26)
          Wait 1
        ')
    '(
      Print "AT"
      Waitms 250
      Print "AT+CMGF=1"
      Waitms 250
      Print "AT+CMGS=" ; Chr(34) ; "+989376921503" ; Chr(34)
      Waitms 250
      Print msg ; Chr(26)
      Waitms 800
      Print "AT"
      Waitms 250
      Print "AT+CMGF=1"
      Waitms 250
      Print "AT+CMGS=" ; Chr(34) ; "+989155191622" ; Chr(34)
      Waitms 250
      Print msg ; Chr(26)
      Waitms 800
      ')
 '(
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; num(1) ; Chr(34)
Waitms 500
Print msg ; Chr(26)
Waitms 600

Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; num(2) ; Chr(34)
Waitms 500
Print msg ; Chr(26)
Waitms 600

 ')

        '(
          for i=1 to 10
              Print "AT+CMGS=" ; Chr(34) ; number ; Chr(34)             'send sms
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


del_remote:
for i=1 to 20
    toggle led1
    waitms 100
next
     Rnumber = 0
     Rnumber_e = Rnumber
     waitms 20
     for i=1 to 20
         eevar(i)=0
         waitms 20
     next

return

Do_learn:

    Do
           gosub _read

           If Okread = 1 Then
                                                 'repeat check
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
    for i=1 to 10
        toggle led1
        waitms 200
    next
return

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
         For I = 1 To Rnumber

             Ra = Eevar(i)
             If Ra = Address Then
                Command
                'Call Beep
                Exit For
             End If
         Next
      End If
      Keycheck = 0
end sub
'-------------------------------- Relay command
sub Command
       set led1
       timeout=10
       set relay
       msg=""
          msg="ALARM"
          send_sms

end sub



end