
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


config_sim:
'$hwstack = 30
'$swstack = 20
'$framesize = 20



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
Declare Sub dispstr()
Declare Sub wrbyte(byval Bdata As Byte)
Declare Sub dispon()
Declare Sub Tm1637_off()
Declare Sub _start()
Declare Sub _stop()
Declare Sub _ack()
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
Dim Tmp1 As Integer
Dim Tmp2 As Integer

dim maxtemp as integer :maxtemp=40
dim mintemp as integer :mintemp=5
dim hightemp as byte

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

dim aa as byte , bb as byte
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

Config_remote:
declare sub check
declare sub command

'-------------------------------------------------------------------------------

Config Portd.6 = Input :_in Alias Pind.6

config portd.5=input:key alias pind.5
key2 alias pind.3 :config portd.3=input
key3 alias pind.4 :config portd.4=input
Config porta.0 = Output:led1 Alias Porta.0
config porta.1=OUTPUT:buzz alias porta.1
config porta.2=OUTPUT:relay alias porta.2
config porta.3=OUTPUT:led2 alias porta.3


dim timeout as  byte
Config Scl = Portc.0
Config Sda = Portc.1

Const write_address = 160                                         'eeprom write address
Const read_address = 161                                          'eeprom read address
'--------------------------------- Timer ---------------------------------------

configint:

Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
'Config Watchdog = 2048
'start timer1
config timer2=TIMER,prescale=1024
'start timer2
'enable timer2
'on ovf2 t2rutin


config timer0= timer ,prescale=1024
enable interrupts
enable timer0
on ovf0 t0rutin
dim t0 as word
'start timer0

enable int0
config int0=RISING
on int0 powerin
dim syc as byte
dim poweroff as byte




triac alias porta.6:config porta.6=OUTPUT
dim fire as word,steps as byte,tfire as word

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
Gosub Rnumber_er
If Rnumber > 5 Then
Rnumber = 0
Gosub Rnumber_ew
End If

'declare sub beep

dim nobat as byte


stop timer0


Startup:

Resetsim

For I = 1 To 30
   set led1
   waitms 250
Next
reset led1
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

for i=1 to 20
    toggle led1
    waitms 100
next

set relay
waitms 200
reset relay
'(
first=efirst
waitms 10
if first=255 then
   msg="first time"
    adminsms
    efirst=0:waitms 10
end if
')
#if uselcd=1
    lcd "Ready":wait 2:cls
#endif

'eaddress=50
'numread
'license=binval(num)
#if uselcd=1
    lcd license
#endif



set ready
start timer0
Main:
          msg=""
          msg= "System Is Online Now"
          number="+09155191622"

          send_sms

          msg= "System Is Online Now"
          adminsms

          waitms 500
          flushbuf
          cls
start timer1
Do

     'stop timer0
     'gosub _read
     'start timer0

     '(
        readtime
                if lsec<>_sec then
                timestr=str(_hour)+":"+str(_min)+ ":"+str(_sec)
                timestr=format(timestr,"00:00:00")

                home : lcd timestr
                lowerline:lcd sens1;" 'C  "
                'disp tmp
                dispstr
                home
                lcd _hour;":";_min;":";_sec
                temp
                lsec=_sec
        end if
      ')
      '(
      if timer1>tfire then
         set triac
      else
          reset triac
      end if
      ')
      if license=1 then gosub _read

                             'if ready=1 then
                        'gosub _read


                                if lsec<>_sec then
                                'if _min=0 and _sec=0 then
                                   'msg="system is on"
                                   'send_sms
                                'end if

                                                if _sec=22 then antenna

                                                shour=str(_hour):smin=str(_min):ssec=str(_sec):_secc=_sec mod 2
                                                shour=format(shour,"00"): smin=format(smin,"00"): ssec=format(ssec,"00")
                                                timestr=shour+":"+smin+":"+ssec
                                                'timestr=format(timestr,"00000000")
                                                stri=shour:stri=stri+smin
                                                #if uselcd=1
                                                    home : lcd timestr
                                                #endif

                                                temp
                                                if tmp1<maxtemp or tmp2<maxtemp then
                                                   hightemp=0
                                                endif
                                                if tmp1>maxtemp or tmp2>maxtemp then
                                                   incr hightemp
                                                   if hightemp>30 then
                                                      msg="Hi Tempereture"
                                                      msg=msg+" Sensor1= "+str(tmp1)
                                                      msg=msg+" Sensor2= "+str(tmp2)
                                                      reset led1
                                                      reset buzz
                                                      reset relay
                                                      adminsms
                                                      cls
                                                      lcd "press any key"
                                                      do
                                                        if key=0 or key2=0 or key3=0 then exit do
                                                      loop
                                                      cls
                                                   endif

                                                end if

                                                #if uselcd=1
                                                    lowerline:lcd sens1;" ";sens2;"  "
                                                #endif

                                                'disp tmp
                                                'dispstr
                                                'home
                                                'lcd _hour;":";_min;":";_sec


                                                #if uselcd=1
                                                    locate 2,12:lcd stri;"  "
                                                #endif
                                                lsec=_sec


                                                      stop timer0
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
                                                      start timer0

                                end if
                        'end if


                     if key=0 then
                        stop timer0
                        set buzz
                        i=0
                        do
                          waitms 25
                          incr i
                          if i>40 or key=1 then exit do
                        loop until key=1
                        if i>40 then gosub delremote else gosub newlearn
                     end if
                     reset buzz

                         if key2=0 or key3=0 then
                             stop timer0
                              do


                                    if key2=0 then
                                       waitms 900
                                       incr _min
                                       if _min>59 then _min=0
                                    end if

                                    if key3=0 then
                                       waitms 900
                                       incr _hour
                                       if _hour>23 then _hour=0
                                    end if

                                     shour=str(_hour):smin=str(_min):ssec=str(_sec):_secc=_sec mod 2
                                     shour=format(shour,"00"): smin=format(smin,"00"): ssec=format(ssec,"00")
                                     timestr=shour+":"+smin+":"+ssec
                                     'timestr=format(timestr,"00000000")
                                     stri=shour:stri=stri+smin
                                     #if uselcd=1
                                         home : lcd timestr
                                         lowerline:lcd sens1;" 'C "
                                     #endif

                                     dispstr

                                if key2=1 and key3=1 then exit do
                              loop
                              settime
                              wait 2
                         end if
                         start timer0

loop
'Charge
'Wait 5

'get line of data from buffer


'get line of data from buffer
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


Sub Showsms(ss As String )

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

 #if Uselcd = 1
     Lowerline
     cls:Lcd number: wait 5:cls
 #endif
   order=""
 Do
  Getline Sret ' get data from buffer
  'cls:lcd s:wait 1:cls



  Select Case lcase(sret)

         Case "ok"
               Exit Do ' end of message

         Case "on"  'when you send PORT as sms text, this will be executed
               set relay
               msg="relay is on"
               order=lcase(sret)
         Case "off"
               order=lcase(sret)
               reset relay
               msg="relay is off"
         Case "new1"
               'enum1=number
               'waitms 10
               eaddress=25
               numsave
               msg="number#1 is saved"
               order=lcase(sret)
         Case "new2"
               order=lcase(sret)
               'enum2=number
               eaddress=32
               numsave
               msg="number#2 is saved"
         Case "new3"
               order=lcase(sret)
               'enum3=number
               eaddress=39
               numsave
               msg="number#3 is saved"
         Case "del1"
               order=lcase(sret)
               'num1=""
               'enum1=num1
               number="+980000000000"
               eaddress=25
               numsave
               msg="num#1 is deleted"
         Case "del2"
               order=lcase(sret)
               'num2=""
               'enum2=num2
               number="+980000000000"
               eaddress=32
               numsave
               msg="num#2 is deleted"
         Case "del3"
               order=lcase(sret)
               'num3=""
               'enum3=num3
               number="+980000000000"
               eaddress=39
               numsave
               msg="num#3 is deleted"
         case "delnums"
               order=lcase(sret)
               number="+980000000000"
               eaddress=25
               numsave
               number="+980000000000"
               eaddress=32
               numsave
               number="+980000000000"
               eaddress=39
               numsave
               msg="All numbers Was deleted"
         case "status"
               order=lcase(sret)
               msg=" "
               eaddress=25
               numread
               msg=num
               msg=msg+chr(10)
               eaddress=32
               numread
               msg=msg+num+chr(10)
               eaddress=39
               numread
               msg=msg+num+chr(10)

         case "rf1234"
               order=lcase(sret)
               'enum1="@@@@@@@@@@@@@":num1=enum1:waitms 10
               'enum2="@@@@@@@@@@@@@":num2=enum2:waitms 10
               'enum3="@@@@@@@@@@@@@":num3=enum3:waitms 10
               first=255:efirst=first:waitms 10
               number="+980000000000"
               eaddress=25
               numsave
               number="+980000000000"
               eaddress=32
               numsave
               number="+980000000000"
               eaddress=39
               numsave
               msg="All numbers Was deleted"
         case "active"
               order=lcase(sret)
               if number="+989155609631" then license=1
               msg="Module Was Activated"
               eaddress=50
               datawrite=license

         case "disactive"
               order=lcase(sret)
               if number="+989155609631" then license=0
               msg="Module Was Disactivated"
               eaddress=50



         Case Else
              msg="wrong sms"

              'set led1:wait 1: reset led1

  End Select

 Loop
 #if Uselcd = 1
     Home Lower : Lcd "remove sms" : wait 1:cls
 #endif
 'delread

do
 Print "AT+CMGDA=DEL READ"
 'Print "AT+CMGD=" ; Stemp  ' delete the message
 waitms 20
 Getline Sret ' get OK
 incr i
 if i=10 then exit do
 loop until lcase(sret)="ok"
 #if Uselcd = 1
     cls:lcd "order=":lowerline :lcd order:wait 5:cls
 #endif

     if order="on" or order="off" then
        set led1
        for i=1 to 10
            toggle led1
            waitms 200
        next
        send_sms
     elseif order="status" then
            msg=msg+chr(10)
            msg=msg+"sensor1= "
            msg=msg+sens1+"  'C"
            msg=msg+chr(10)
            msg=msg+"sensor2= "
            msg=msg+sens2 +"  'C"+chr(10)
            msg=msg+"NET= "+net+chr(10)
            msg=msg+"sharj= "+sharj+" rial"+chr(10)
            send_sms
     end if
     if order="new1" or order="new2" or order="new3" then
        msg=""
        msg="new number= "+chr(10)
        msg=msg+number
        adminsms
     end if
     if order="rf1234" then
        msg=""
        msg="Reset Factory is Done"
        msg=msg+number
        adminsms
     end if
     if order="active" then
               adminsms
               eew
     end if
     if order="disactive" then
               adminsms
               eer
               license=dataread
     end if

     order=""
     'delread
     'start timer0

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
 charge
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

charge
start timer0
end sub


t0rutin:

        stop timer0
             incr t0
             if ready=1 and poweroff< 10 then incr poweroff
             if poweroff=5 then
                disable int0
                tm1637_off
                reset led1
                reset led2
                reset buzz
                reset relay
                eaddress=25
                numread
                number=num
                msg="Power Is Off"
                send_sms
                      cls
                      lcd "press any key"
                      do
                        if key=0 or key2=0 or key3=0 then exit do
                      loop
                      cls
             end if
             'gosub _read
             if t0>20 then
                t0=0
                toggle led1
                readtime




                          '(
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
                              ')
             end if
        timer0=0
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

Sub Antenna
  Flushbuf
  Print "AT+CSQ"
  Getline Sret
  Count = Split(sret , sheader(1) , " ")
  Anten = Val(sheader(2))
  'Cls : Lcd "ANTEN= " : Lcd Anten : Lowerline : Lcd Sret : Wait 5 : Cls : Waitms 500
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
  'cls:lcd sret:wait 1:cls :waitms 500
  Getline Sret
    'cls:lcd sret:wait 1:cls :waitms 500
  'Sharj = Right(sret , 17)
  Getline Sret
    'cls:lcd sret:wait 2:cls :waitms 500
    msg=""
    aa=instr(sret,"003A")
    aa=aa+4
    bb=instr(sret,"0020")
    bb=bb-aa
    msg=mid(sret,aa,bb)
    'aa=split(msg,sheader(1),"003")
    aa=len(msg)
    'cls:lcd msg:wait 3:cls:lowerline :lcd aa:wait 3:cls
    sharj=""
    for i= 4 to aa step 4
        sharj=sharj+mid(msg,i,1)
    next
    '(
    sharj=""
    for i=1 to aa
        lcd sheader(i):wait 1
        sharj=sharj+sheader(i)
    next
    ')
    'wait 5
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
                If Rnumber > 5 Then                       'agar bishtar az 100 remote learn shavad
                                Rnumber = 5
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


powerin:
        'reset triac
        'home :lcd timer2
        timer1=0
        'lowerline :lcd timer2
        reset triac
        incr syc
        poweroff=0

        if syc=50 then
           toggle led2
           syc=0
        endif

return

 _read:
      Okread = 0
      If _in = 1 Then
         Do
           'Reset Watchdog
           If _in = 0 Then Exit Do

         Loop
         Timer2 = 0
         Start Timer2
         While _in = 0
               'Reset Watchdog
         Wend
         Stop Timer2
         If Timer2 >= 76 And Timer2 <= 185 Then
            Do
              If _in = 1 Then
                 Timer2 = 0
                 Start Timer2
                 While _in = 1
                    'Reset Watchdog
                 Wend
                 Stop Timer2
                 Incr I
                 S(i) = Timer2
              End If
              'Reset Watchdog
              If I = 24 Then Exit Do

            Loop
            For I = 1 To 24
                'Reset Watchdog
                If S(i) >= 3 And S(i) <= 8 Then
                   S(i) = 0
                Else
                   If S(i) >= 9 And S(i) <= 19 Then
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
            '#if uselcd=1
                'cls
                'lcd code : lowerline : lcd address :wait 2
            '#endif
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
         For I = 1 To 5
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
         'stop timer0
         cls:lcd code
         wait 3
         cls
        '(
         if license=1 then
                  toggle relay
                  #if uselcd=1
                      cls:lcd code:lowerline :lcd steps:lcd "   ":lcd tfire
                  #endif

                 dispon
                 _start
                 disp code
                 if code=8 then
                    eaddress=25
                    numread
                    #if uselcd=1
                        cls:lcd m:wait 1:cls
                    #endif
                    eaddress=32
                    numread
                    #if uselcd=1
                        cls:lcd m:wait 1:cls
                    #endif
                    eaddress=39
                    numread
                    #if uselcd=1
                        cls:lcd m:wait 1:cls
                    #endif
                 end if
                 _stop
                 wait 1
                 tm1637_off

                      'eaddress=25
                      'Gosub Ra_r
                      'lcd ra
                      'wait 1
                      'cls

         end if
           ')
       start timer0

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
              'Case 6
              'Eaddress = 25
              'Case 7
              'Eaddress = 28
              'Case 8
              'Eaddress = 31

              case else

       End Select
end sub

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
       Local Strdisp As String * 4
    if license=1 then
       Strdisp = Str(bdispdata)
       Strdisp = Format(strdisp , "    ")
       'home ; lcd _sec
       _start
       wrbyte &H40                                       'autoincrement adress mode
       _ack
       _stop
       _start
       wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
       _ack

       For Bcounter = 1 To 4
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
   end if
End Sub

Sub dispstr()

       Local Bcounter As Byte
       Local Strdisp As String * 4
    if license=1 then
       strdisp=stri
       'Strdisp = Format(strdisp , "0000")
       #if uselcd=1
           home ; lcd _sec
       #endif
               dispon
       _start
       wrbyte &H40                                       'autoincrement adress mode
       _ack
       _stop
       _start
       wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
       _ack
    '(
       strsc =mid (strdisp,1,1)
       sendtm
       wrbyte &HC1                                       'startaddress first digit (HexC0) = MSB display
       _ack
       strsc =mid (strdisp,2,1)
       sendtm
       wrbyte &HC2                                       'startaddress first digit (HexC0) = MSB display
       _ack
       strsc =mid (strdisp,3,1)
       sendtm
       wrbyte &HC3                                       'startaddress first digit (HexC0) = MSB display
       _ack
       strsc =mid (strdisp,4,1)
       sendtm
       ')

       For Bcounter = 1 To 4
          strsc =mid (strdisp,bcounter,1)
          'cls:lcd strdisp;"  ":lcd bcounter:lowerline :lcd strsc:waitms 500:cls
          'cls
          'lcd strdisp;"   "; bcounter
          'lowerline:lcd strin
          'wait 1
          if _secc=0 then
          select case strsc
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
             case "C" : wrbyte &B00111001
             Case Else : wrbyte &B00000000
          End Select
          _ack

          else
          select case strsc
             Case "0" : wrbyte &B10111111
             Case "1" : wrbyte &B10000110
             Case "2" : wrbyte &B11011011
             Case "3" : wrbyte &B11001111
             Case "4" : wrbyte &B11100110
             Case "5" : wrbyte &B11101101
             Case "6" : wrbyte &B11111101
             Case "7" : wrbyte &B10000111
             Case "8" : wrbyte &B11111111
             Case "9" : wrbyte &B11101111
             case "-" : wrbyte &B11000000
             case "C" : wrbyte &B00111001
             Case Else : wrbyte &B10000000
          End Select
          _ack
          end if

       Next

       _stop
     end if
End Sub
'(
sub sendtm
      if _secc=0 then
      select case strsc
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
         case "C" : wrbyte &B00111001
         Case Else : wrbyte &B00000000
      End Select
      _ack

      else
      select case strsc
         Case "0" : wrbyte &B10111111
         Case "1" : wrbyte &B10000110
         Case "2" : wrbyte &B11011011
         Case "3" : wrbyte &B11001111
         Case "4" : wrbyte &B11100110
         Case "5" : wrbyte &B11101101
         Case "6" : wrbyte &B11111101
         Case "7" : wrbyte &B10000111
         Case "8" : wrbyte &B11111111
         Case "9" : wrbyte &B11101111
         case "-" : wrbyte &B11000000
         case "C" : wrbyte &B00111001
         Case Else : wrbyte &B10000000
      End Select
      _ack
      end if
end sub
')

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

sub numsave
              ' eaddress=25
    nuM = ""
    'M = Hex(ra)
    #if uselcd=1
        'cls:lcd "save num":lowerline:lcd number:wait 3:cls
    #endif
    num=number
    x=0
    for i=1 to 6
        x=i*2
        num1(i)=mid(num,x,2)
        datawrite=hexval(num1(i))
        gosub eew
        incr eaddress
        #if uselcd=1
            'cls:lcd i:lowerline:lcd num1(i):wait 3:cls
        #endif
    next
    '(
    nuM1 = Mid(num , 1 , 8)
    cls:lcd num:lowerline:lcd num1:wait 3:cls
    nuM2 = Mid(num , 9 , 5)
    cls:lcd num:lowerline:lcd num2:wait 3:cls
    'M3 = Mid(m , 17 , 7)
    datawrite = Hexval(num1)
    Gosub Eew
    Incr Eaddress
    datawrite = Hexval(num2)
    Gosub Eew
    'Incr Eaddress
    'datawrite = Hexval(m3)
    'Gosub Eew
    ')
end sub

sub numread
    num="+"
    'eaddress=25
    for i=1 to 6
        gosub eer
        num1(i)=hex(dataread)
        #if uselcd=1
           ' cls:lcd i:lowerline:lcd num1(i):wait 3:cls
        #endif
        num=num+num1(i)
        incr eaddress
    next
    #if uselcd=1
        'cls:lcd "read num":lowerline:lcd num:wait 3:cls
    #endif
 '(   num=""
    eaddress=25
    Gosub Eer
    nuM1 = Hex(dataread)
    cls:lcd num:lowerline:lcd num1:wait 3:cls
    Incr Eaddress
    Gosub Eer
    nuM2 = Hex(dataread)
    cls:lcd num:lowerline:lcd num2:wait 3:cls
    'Incr Eaddress
    'Gosub Eer
    'M3 = Hex(dataread)
    nuM = ""
    nuM = nuM + nuM1
    nuM = nuM + nuM2
    cls:lcd "read num":lowerline:lcd num:wait 3:cls
    'M = M + M3
    'Ra = Hexval(m)
    ')
end sub

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


sub temp
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
    if license=1 then
       1wreset
       1wwrite &HCC
       1wwrite &H44
       Waitms 30
       1wreset
       1wwrite &H55
       1wverify Ds18b20_id_1(1)
       if err=0 then
          1wwrite &HBE
          Readsens = 1wread(2)


          tmp = Readsens

          Gosub Conversion
          tmp1=tmp
          Sens1 = Temperature
          'tmp=tmp-16

          if _sec<30 then

          stri=""
          if tmp1>0 then
             stri=str(tmp1)
             stri=stri+" C"
          else
             stri=str(tmp1)
             stri=stri+"C"
          end if


          _secc=0
          dispstr
          endif

       end if

       1wverify Ds18b20_id_2(1)
       if err=0 then
          1wwrite &HBE
          Readsens = 1wread(2)


          tmp = Readsens

          Gosub Conversion
          tmp2=tmp
          Sens2 = Temperature
          'tmp=tmp-16
          if _sec>30 then

                    stri=""
                    if tmp2>0 then
                       stri=str(tmp2)
                       stri=stri+" C"
                    else
                       stri=str(tmp2)
                       stri=stri+"C"
                    end if
                    _secc=0
                    dispstr

          end if

       end if

    end if

end sub


sub Conversion
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   tmp=readsens
   tmp=tmp/10
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub

end