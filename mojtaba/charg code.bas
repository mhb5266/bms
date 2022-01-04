
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
config lcdpin=pin;db7=porta.4;db6=portb.4;db5=portb.3;db4=portb.2;rs=portb.0;en=portb.1
config lcd=16*2
'cursor off
const uselcd=1
#if uselcd=1
    cls:lcd "hi" :wait 2:cls
#endif

dim aa as byte
dim bb as byte
config_sim:
'$hwstack = 30
'$swstack = 20
'$framesize = 20

config portd.5=input:key alias pind.5

'some subroutines
Declare Sub Getline(ss As String)
Declare Sub Flushbuf()
Declare Sub Showsms(ss As String )
Declare Sub Send_sms
declare sub adminsms
'declare sub emsms
'Declare Sub Dial
Declare Sub Resetsim
'Declare Sub Checksim
'Declare Sub Money
'Declare Sub Temp
Declare Sub Antenna
dim anten as byte
Declare Sub Charge
dim sharj as string*100
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

declare sub numsave
declare sub numread

declare sub settime
declare sub readtime
dim _sec as byte,_min as byte, _hour as byte, lsec as byte
dim _secc as byte
Const Ds1307w = &HD0
Const Ds1307r = &HD1

Tm1637_clk Alias Portc.3: config portc.3 =output
Tm1637_dout Alias Portc.2 :config portc.2=output
Tm1637_din Alias Pinc.2
Declare Sub disp(byval Bdispdata As integer)            'The display can only show numbers)

'declare sub sendtm
dim stri as string*4
dim strsc as string*1
dim smin as string*2
dim shour as string*2
dim ssec as string*2

declare sub conversion
declare sub temp
Config 1wire = Porta.5
Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6
Dim Readsens As Integer


Dim Tmpread As Boolean
Dim Tmp As Integer

dim timestr as string*8
dim ready as bit
dim license as byte :license=1

'used variables
Dim I As Byte , B As Byte
Dim Sret As String * 100 , Stemp As String * 6
'Dim U As Byte
'Dim Lim As Byte

Dim Msg As String * 140
dim number as string*13
'(
dim enum1 as eram string*13
dim enum2 as eram string*13
dim enum3 as eram string*13
'dim enum4 as eram string*13
dim num1 as  string*13
dim num2 as  string*13
dim num3 as  string*13
dim num4 as  string*13
')
dim order as string*10

dim efirst as eram byte
dim first as  byte

Dim Sheader(5) As String * 30
Dim Net As String * 10
Dim Count As Byte

Simrst Alias Portc.4 : Config Simrst = Output
Config Serialin = Buffered , Size = 100                     ' buffer is small a bigger chip would allow a bigger buffer
Enable Interrupts
Const Pincode = "AT+CPIN=1234"                              ' pincode change it into yours!
Dim R As Byte : R = 0



'-------------------------------------------------------------------------------

                                      'eeprom read address
'--------------------------------- Timer ---------------------------------------



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

dim num as string*13
dim num1(6) as string*8
dim x as byte


dim raw as byte
'-------------------------- read rnumber index from eeprom


'declare sub beep

dim nobat as byte


stop timer0

Startup:

Resetsim

For I = 1 To 30

   waitms 250
Next

Wait 1

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

    cls
do
  flushbuf
'Print "ATD*130#"
'Print "At+Cusd=1," ; Chr(34) ; "*130#" ; Chr(34)
 ' wait 5
    home : lcd "push button"
    if key=0 then
    charge
    adminsms
    end if
    waitms 100



loop


set ready
start timer0
Main:


Sub Getline(ss As String)
        'stop timer0
local try as byte
    ss = ""
    try=0
    Do

      B = Inkey()
      if b>0 then try=0
      'cls: lcd "getlinee":lowerline:lcd b:waitms 500:cls
      Select Case B
             Case 0
                  'exit do                                        'nothing
             Case 13

               If Ss <> "" Then Exit Do                                       ' we do not need this one
             Case 10
               If ss <> "" Then
                  'if lcase(s)="error" then resetsim
                  Exit Do
               end if            ' if we have received something

             Case else
             ss = ss + Chr(b)

                               ' build string
      End Select
      waitms 1
      incr try
      if try>100 then exit do


        'timestr=""
        'timestr=str(_hour)+":"+str(_min)+ ":"+str(_sec)
        'timestr=format(timestr,"00:00:00")

        'home : lcd timestr
        'temp
        'lowerline:lcd sens1;" 'C  "
        'disp tmp
        'disptime
        'home
        'lcd _hour;":";_min;":";_sec
        'start timer0
        '(
        if key=0 then
           stop timer0
           set led1
           i=0
           do
             waitms 25
             incr i
             if i>40 or key=1 then exit do
           loop until key=1
           if i>40 then gosub delremote else gosub newlearn
           start timer0
        end if

      if key2=0 or key3=0 then
         do
               if key2=0 then
                  waitms 250
                  incr _min
                  if _min>59 then _min=0
               end if

               if key3=0 then
                  waitms 250
                  incr _hour
                  if _hour>23 then _hour=0
               end if

                shour=str(_hour):smin=str(_min):ssec=str(_sec):_secc=_sec mod 2
                shour=format(shour,"00"): smin=format(smin,"00"): ssec=format(ssec,"00")
                timestr=shour+":"+smin+":"+ssec
                'timestr=format(timestr,"00000000")
                stri=shour:stri=stri+smin
                home : lcd timestr
                lowerline:lcd sens1;" 'C  "
                dispstr
           if key2=1 and key3=1 then exit do
         loop
         settime
      end if
     ')
    Loop


End Sub


'flush input buffer
Sub Flushbuf()                                             'give some time to get data if it is there
    Do
      B = Inkey()                                            ' flush buffer
    Loop Until B = 0
End Sub

Sub Send_sms
stop timer0
#if uselcd=1
   ' cls
    'lcd "send sms":lowerline:lcd number:wait 2:cls
    'lcd msg:wait 2
#endif

msg=msg+" *"
msg=msg+str(nobat)



     for i=1 to 10
       Print "AT+CMGS=" ; Chr(34);number; Chr(34)             'send sms
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
 incr nobat
 msg=""

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
stop timer0
#if uselcd=1
    cls
    lcd "send sms":lowerline:lcd number:wait 3:cls
    lcd msg:wait 2
#endif

     'for i=1 to 10
       Print "AT+CMGS=" ; Chr(34);"+989155609631"; Chr(34)             'send sms
       Waitms 250
       Print Msg ; Chr(26)
       Wait 200
       r=0
       '(
       do
         getline sret
         if lcase(sret)="ok" then exit do
         waitms 500
         incr r
         if r=10 then exit do
       loop until lcase(sret)="ok"
       ')
       getline sret
       do
       getline sret
         cls :lcd sret:wait 2
         if sret="+CMGS:1" then exit do
         if key=0 then exit do
       loop
       delall
       'if lcase(sret)="ok" then exit for
     'next


start timer0
end sub


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

Sub Antenna
  Flushbuf
  Print "AT+CSQ"
  Getline Sret
  Count = Split(sret , sheader(1) , " ")
  Anten = Val(sheader(2))
  Cls : Lcd "ANTEN= " : Lcd Anten : Lowerline : Lcd Sret : Wait 5 : Cls : Waitms 500
  Select Case Anten
         Case 0
              Net = "BAD"
         Case 1
              Net = "WEAK"
         Case 2 To 15
              Net = "Not Bad"
         Case 16 To 30
              Net = "GOOD"
         Case 31
              Net = "BEST"
         Case 99
              Net = "OFFLINE"
  End Select

End Sub


Sub Charge
'Print "At+Cusd=1," ; Chr(34) ; "*140#" ; Chr(34)

'wait 3
Print "ATD*140#"
'Flushbuf
'Print "At+Cusd=1," ; Chr(34) ; "*140#" ; Chr(34)
wait 5
'Print "At+Cusd=1," ; Chr(34) ; "*555*1*2#" ; Chr(34)
  Getline Sret
  cls:lcd sret:wait 1:cls :waitms 500
  Getline Sret
    cls:lcd sret:wait 1:cls :waitms 500
  Sharj = Right(sret , 17)
  Getline Sret
    cls:lcd sret:wait 2:cls :waitms 500
    msg=""
    aa=instr(sret,"003A")
    cls:lcd "aa":lowerline :lcd aa:wait 3:cls
    aa=aa+4
    bb=instr(sret,"0020")
    bb=bb-aa
     cls:lcd "bb":lowerline :lcd bb:wait 3:cls
    msg=mid(sret,aa,bb)
    'aa=split(msg,sheader(1),"003")
    aa=len(msg)
    cls:lcd msg:lowerline :lcd aa;"  ";bb:wait 3:cls
    sharj=""
    for i= 4 to aa step 4
        sharj=sharj+mid(msg,i,1)
    next
    msg=sret
    '(
    sharj=""
    for i=1 to aa
        lcd sheader(i):wait 1
        sharj=sharj+sheader(i)
    next
    ')
    wait 5
    'adminsms
    cls :lcd msg:lowerline: lcd sharj: wait 5:cls


End Sub

Sub Delall
     Flushbuf
     Print "AT+CMGDA=DEL ALL"
'     Getline Sret
End Sub

Sub Delread
     Flushbuf
     Print "AT+CMGDA=DEL READ"
'     Getline Sret
End Sub



end