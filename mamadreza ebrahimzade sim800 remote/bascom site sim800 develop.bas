
$regfile = "m8def.dat"

'XTAL = 10 MHZ
$crystal = 11059200

'By default the modem works at 9600 baud
$baud = 9600

'HW stack 20, SW stack 8 , frame 10

'some subroutines
Declare Sub Getline(s As String)
Declare Sub Flushbuf()
Declare Sub Showsms(s As String )

configs:
Declare Sub Resetsim
declare sub delread
declare sub send_sms
declare sub delall
Config Portd.7 = Input :_in Alias Pind.7
'Config portd.6 = Output:buzz Alias Portd.6
config portd.5=input:key alias pind.5
Config portb.0 = Output:led1 Alias Portb.0
config portd.6=OUTPUT:relay alias portd.6




Simrst Alias Portb.1 : Config Simrst = Output

config lcdpin=16*2,db4=portc.2,db5=portc.3,db6=portc.4,db7=portc.5,e=portc.1,rs=portc.0
config lcd=16*2
cursor off
cls:lcd "hi" :wait 1:cls
resetsim

dim number as string*13
dim enum(3) as eram string*13
dim num(3) as  string*13

Num(1) = "+989155191622"

'Num(2) = "+989398291077"

Num(3) = "+989376921503"


dim r as byte
'Dim Net As String * 10
'Dim Anten As Word
Dim Msg As String * 50
dim count as byte
dim sheader(3) as string*15


config_bascom:
'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 66 , Stemp As String * 6

'we use a serial input buffer
Config Serialin = Buffered , Size = 12 ' buffer is small a bigger chip would allow a bigger buffer

'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts



'define a constant to enable LCD feedback
Const Uselcd = 1
Const Senddemo = 1 ' 1= send an sms
Const Pincode = "AT+CPIN=1234" ' pincode change it into yours!
Const Phonenumber = "AT+CMGS=+989376921503" ' phonenumber to send sms to


'wait until the mode is ready after power up
Waitms 3000


Print "AT" ' send AT command twice to activate the modem
Print "AT"
Flushbuf ' flush the buffer
Print "ATE0"
#if Uselcd = 1
 Home Lower
#endif

Do
 Print "AT" : ' Waitms 100
 Getline Sret ' get data from modem
 #if Uselcd = 1
 Lcd Sret ' feedback on display
 #endif
Loop Until Sret = "OK" ' modem must send OK
Flushbuf ' flush the input buffer
#if Uselcd = 1
 Home Upper : Lcd "Get pin mode"
#endif
Print "AT+cpin?" ' get pin status
Getline Sret
#if Uselcd = 1
 Home Lower : Lcd Sret
#endif
If Sret = "+CPIN: SIM PIN" Then
 Print Pincode ' send pincode
End If
Flushbuf
'do
'#if Uselcd = 1
 Home Upper : Lcd "set text mode":wait 1:cls
'#endif
do
Print "AT+CMGF=1" ' set SMS text mode
waitms 100
Getline Sret ' get OK status
 loop until sret="OK"
'#if Uselcd = 1
 Home Lower : Lcd Sret:wait 1:cls
'#endif

   Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret

 print "AT+CMGF?"
 getline sret
 cls:lcd sret:wait 1:cls

'sms settings

Print "AT+CSMP=17,167,2,25"
Getline Sret
cls:lcd sret:wait 1:cls
Print "AT+CNMI=2,2,0,0,0"
getline sret
cls:lcd sret:wait 1:cls
'(
do
Print "AT+CSMP=17,167,0,0"
Getline Sret
loop until lcase(sret)="ok"
do
Print "AT+CNMI=0,1,2,0,0"
Getline Sret
loop until lcase(sret)="ok"
')
'(
#if Senddemo = 1
 #if Uselcd = 1
 Home Upper : Lcd "send sms"
 #endif
 Print Phonenumber
 Waitms 100
 Print "BASCOM AVR SMS" ; Chr(26)
 Getline Sret
 #if Uselcd = 1
 Home Lower : Lcd Sret 'feedback
 #endif
#endif
  ')

delall
getline sret
cls:lcd sret:wait 2:cls
wait 5
for i=1 to 10
    toggle led1:waitms 200
next
'cls:lcd "send sms"
'msg="module is Powered on"
'send_sms
'cls




main:
'main loop
Do
'Print "AT+CSMP=17,167,0,0"
'Getline Sret
'Print "AT+CNMI=0,1,2,0,0"
'Getline Sret
 Getline Sret ' wait for a modem response
 #if Uselcd = 1
 Cls
 Lcd "Msg from modem"
 Home Lower : Lcd Sret
 #endif
 I = Instr(sret , ":") ' look for :
 If I > 0 Then 'found it
 Stemp = Left(sret , I)
 Select Case Stemp
 Case "+CMTI:" : Showsms Sret ' we received an SMS
 ' hanle other cases here
 End Select
 End If
Loop ' for ever


'subroutine that is called when a sms is received
's hold the received string
'+CMTI: "SM",5
Sub Showsms(s As String )
stop timer0
 #if Uselcd = 1
 Cls
 #endif
 I = Instr(s , ",") ' find comma
 I = I + 1
 stemp = Mid(s , I) ' s now holds the index number
 #if Uselcd = 1
 Lcd "get " ; Stemp
 Waitms 1000 'time to read the lcd
 #endif
 Print "AT+CMGR=1"
 'Print "AT+CMGR=" ; Stemp ' get the message
 Getline S ' header +CMGR: "REC READ","+316xxxxxxxx",,"02/04/05,01:42:49+00"

 I = Instr(s , "+98") ' find comma
 r = I + 10
 number = mid(s , I , r) ' s now holds the index number
 count=split(number,sheader(1),chr(34))
 for i=1 to 3
     cls:lcd sheader(i):lowerline :lcd i:wait 1:cls
 next
 number=sheader(1)
 '#if Uselcd = 1
  '   cls:Lcd number:wait 1:cls
 'Waitms 1000 'time to read the lcd
' #endif

 #if Uselcd = 1
 Lowerline
 Lcd S
 #endif
 Do
  Getline S ' get data from buffer
  cls:lcd s:wait 1:cls
  Select Case lcase(S)
         Case "on"  'when you send PORT as sms text, this will be executed
               #if Uselcd = 1
                   Cls : Lcd "do something!" :set relay
               #endif
         Case "ok"
               Exit Do ' end of message
         Case "off"
               reset relay
         Case "new1"
               enum(1)=number
               waitms 10
               cls:lcd "number1 is saved":lowerline: lcd number:wait 1:cls
               msg="new number is saved"
               'send_sms
         Case "new2"
               enum(2)=number
               waitms 10
               cls:lcd "number2 is saved":lowerline: lcd number:wait 1:cls
               msg="new number is saved"
               'send_sms
         Case "new3"
               enum(3)=number
               waitms 10
               cls:lcd "number3 is saved":lowerline: lcd number:wait 1:cls
               msg="new number is saved"
               'send_sms
         Case "del1"
               num(1)=""
               cls:lcd "num1 is deleted":wait 1:cls
               msg="number #1 is deleted"
               'send_sms
         Case "del2"
               num(2)=""
               cls:lcd "num2 is deleted":wait 1:cls
               msg="number #2 is deleted"
               'send_sms
         Case "del3"
               num(3)=""
               cls:lcd "num3 is deleted":wait 1:cls
               msg="number #3 is deleted"
               'send_sms
         Case Else
              set led1:wait 1: reset led1
  End Select
 Loop
 #if Uselcd = 1
 Home Lower : Lcd "remove sms" : wait 1:cls
 #endif
 Print "AT+CMGDA=DEL READ"
 'Print "AT+CMGD=" ; Stemp  ' delete the message
 Getline S ' get OK
 #if Uselcd = 1
 Lcd S
 #endif




     delread
     start timer0

End Sub


'get line of data from buffer
Sub Getline(s As String)
 S = ""
 Do
  B = Inkey()
  Select Case B
  Case 0 'nothing
  Case 13 :'If S <> "" Then Exit Do' we do not need this one
  Case 10 : If S <> "" Then Exit Do ' if we have received something
  Case Else
  S = S + Chr(b) ' build string
  End Select
  if key=0 then
     set relay:wait 1:reset relay
  end if
 Loop
End Sub

'flush input buffer
Sub Flushbuf()
 Waitms 100 'give some time to get data if it is there
 Do
 B = Inkey() ' flush buffer
 Loop Until B = 0
End Sub

Sub Resetsim
    Reset Simrst
    Wait 1
    Set Simrst
End Sub


Sub Delread
     Flushbuf
     Print "AT+CMGDA=DEL READ"
     Getline Sret
End Sub

Sub Delall
     Flushbuf
     Print "AT+CMGDA=DEL ALL"
     Getline Sret
End Sub


Sub Send_sms




stop timer0
'num(1)=enum(1)
'waitms 10
'num(2)=enum(2)
'waitms 10
'num(3)=enum(3)
'waitms 10
          for i=1 to 10
              Print "AT+CMGS=" ; Chr(34) ; Num(1) ; Chr(34)             'send sms
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
              Print "AT+CMGS=" ; Chr(34) ; Num(2) ; Chr(34)             'send sms
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


  '(
          Print "AT+CMGS=" ; Chr(34) ; Num(1) ; Chr(34)             'send sms
          Waitms 250
          Print Msg ; Chr(26)
          Wait 1
          Print "AT"
          Print "AT+CMGS=" ; Chr(34) ; Num(2) ; Chr(34)             'send sms
          Waitms 250
          Print Msg ; Chr(26)
          Wait 1
          Print "AT"
          Print "AT+CMGS=" ; Chr(34) ; Num(3) ; Chr(34)             'send sms
          Waitms 250
          Print Msg ; Chr(26)
          Wait 1
          Print "AT"
          ')
 '(
Print "AT"
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; num(1) ; Chr(34)
Waitms 500
Print msg ; Chr(26)
Waitms 600

Print "AT"
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; num(2) ; Chr(34)
Waitms 500
Print msg ; Chr(26)
Waitms 600

Print "AT"
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; num(3) ; Chr(34)
Waitms 500
Print msg ; Chr(26)
Waitms 600
')
end sub