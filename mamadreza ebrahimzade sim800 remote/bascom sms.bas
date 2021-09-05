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

declare sub check
declare sub command
'declare sub _read
'declare sub do_learn
'declare sub del_remote
'-------------------------------------------------------------------------------


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
Dim Eevar(3) As Eram Long

declare sub beep

dim nobat as byte

config_sim:
'HW stack 20, SW stack 8 , frame 10



'some subroutines
'Declare Sub Getline(s As String)
'Declare Sub Flushbuf()
'Declare Sub Showsms(s As String )
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
Dim Sret As String * 50 , Stemp As String * 6
dim massage as string *160
Dim U As Byte
Dim Lim As Byte

Dim Msg As String * 50
Dim Num(3) As  String * 13

Num(1) = "09155191622"

Num(2) = "+989398291077"

Num(3) = "+989376921503"

'Num(3) = "09218782318"

dim number as string*13


dim ncounter as byte

Dim Sharj As String * 100

'dim a as byte

Dim sbody(3) As String * 10
Dim sheader(10) As String * 20
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


Dim A As Bit
Dim R As Byte : R = 0
Dim X As Byte : X = 0
'Dim B As Byte
Dim G As Byte
Dim P As Bit : P = 0
Dim Sms As String * 70 : Sms = ""


config_remote:

Config Portd.7 = Input :_in Alias Pind.7
'Config portd.6 = Output:buzz Alias Portd.6
config portd.5=input:key alias pind.5
Config portb.0 = Output:led1 Alias Portb.0
config portd.6=OUTPUT:relay alias portd.6



config lcdpin=16*2,db4=portc.2,db5=portc.3,db6=portc.4,db7=portc.5,e=portc.1,rs=portc.0
config lcd=16*2
cursor off
cls:lcd "hi" :wait 1:cls

'used variables
'Dim I As Byte , B As Byte
'Dim Sret As String * 66 , Stemp As String * 6

'we use a serial input buffer
'Config Serialin = Buffered , Size = 12 ' buffer is small a bigger chip would allow a bigger buffer

'enable the interrupts because the serial input buffer works interrupts driven
Enable Interrupts

'define a constant to enable LCD feedback
Const Uselcd = 1
Const Senddemo = 1 ' 1= send an sms
Const Pincode = "AT+CPIN=1234" ' pincode change it into yours!
Const Phonenumber = "AT+CMGS=09376921503" ' phonenumber to send sms to
'(
#if Uselcd = 1
 Cls
 Lcd "SMS Demo"
#endif

'wait until the mode is ready after power up
Waitms 3000

#if Uselcd = 1
 Lcd "Init modem"
#endif


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
#if Uselcd = 1
 Home Upper : Lcd "set text mode"
#endif
Print "AT+CMGF=1" ' set SMS text mode
Getline Sret ' get OK status
#if Uselcd = 1
 Home Lower : Lcd Sret
#endif

'sms settings
Print "AT+CSMP=17,167,0,0"
Getline Sret
Print "AT+CNMI=0,1,2,0,0"
Getline Sret

#if Senddemo = 1
 #if Uselcd = 1
 Home Upper : Lcd "send sms"
 #endif
 'Print Phonenumber

 Print "AT+CMGS=" ; Chr(34) ; "09376921503" ; Chr(34)
 Waitms 100
 Print "BASCOM AVR SMS" ; Chr(26)
 Getline Sret
 #if Uselcd = 1
 Home Lower : Lcd Sret 'feedback
 #endif
#endif
')


Startup:

Resetsim

For I = 1 To 30
   set led1
   waitms 250
Next
reset led1


Print "AT"                                                  ' send AT command twice to activate the modem
Print "AT"
Flushbuf
'Print "AT&F"
Flushbuf                                                    ' flush the buffer
Print "ATE0"




Do
  Flushbuf
   Print "AT" :                                             ' Waitms 100
   Getline Sret                                             ' get data from modem
       Lcd Sret                                             ' feedback on display
Loop Until Sret = "OK"                                      ' modem must send OK
Flushbuf                                                    ' flush the input buffer

Sub Resetsim
    Reset Simrst
    Wait 1
    Set Simrst
End Sub




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
'(
'sms settings
'Print "AT+CSMP=17,167,0,0"
Print "AT+CSMP=17,167,2,25"
Getline Sret

'Print "AT+CNMI=0,1,2,0,0"
Print "AT+CNMI=2,2,0,0,0"
Getline Sret
  ')
Print "AT+CSMP=17,167,0,0"
Getline Sret
Print "AT+CNMI=0,1,2,0,0"
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

   Waitms 500
Loop Until Sret = "OK"


  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
   Getline Sret


Wait 1


Do
   Delall
   Waitms 500
Loop Until Sret = "OK"

for i=1 to 20
    toggle led1
    waitms 100
next

set relay
waitms 250
reset relay
cls:lcd "config finished":wait 2:cls



main:
'main loop
Do
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
 Case "+CMTI:"
        cls:lcd "new sms" : wait 2:cls:Showsms Sret ' we received an SMS
 ' hanle other cases here
 End Select
 End If
Loop ' for ever


t0rutin:
        stop timer0
             incr t0
             if relay=0 then
                if t0=24 then
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

'subroutine that is called when a sms is received
's hold the received string
'+CMTI: "SM",5
Sub Showsms(s As String )
 #if Uselcd = 1
 Cls
 #endif
 I = Instr(s , ",") ' find comma
 I = I + 1
 Stemp = Mid(s , I) ' s now holds the index number
 #if Uselcd = 1
 Lcd "get " ; Stemp
 Waitms 1000 'time to read the lcd
 #endif

 Print "AT+CMGR=" ; Stemp ' get the message
 Getline S ' header +CMGR: "REC READ","+316xxxxxxxx",,"02/04/05,01:42:49+00"
 #if Uselcd = 1
 Lowerline
 Lcd S
 #endif
 Do
 Getline S ' get data from buffer
 Select Case S
 Case "On" : 'when you send PORT as sms text, this will be executed
 #if Uselcd = 1
 Cls : Lcd "do something!":wait 2
 #endif
 Case "OK" : Exit Do ' end of message
 Case Else
 End Select
 Loop
 #if Uselcd = 1
 Home Lower : Lcd "remove sms"
 #endif
 Print "AT+CMGD=" ; Stemp  ' delete the message
 Getline S ' get OK
 #if Uselcd = 1
 Lcd S
 #endif
End Sub

Sub Delall
     Flushbuf
     Print "AT+CMGDA=DEL ALL"
     'Getline Sret
End Sub

'get line of data from buffer
Sub Getline(s As String)
 S = ""
 Do
 B = Inkey()
 Select Case B
 Case 0 'nothing
 Case 13 : 'If S <> "" Then Exit Do' we do not need this one
 Case 10 : If S <> "" Then Exit Do ' if we have received something
 Case Else
 S = S + Chr(b) ' build string
 End Select
 Loop
End Sub

'flush input buffer
Sub Flushbuf()
 Waitms 100 'give some time to get data if it is there
 Do
 B = Inkey() ' flush buffer
 Loop Until B = 0
End Sub