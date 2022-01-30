
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

declare sub delremote
declare sub newlearn

Declare Sub ra_r
Declare Sub ra_w
declare sub rnumber_er
declare sub rnumber_ew
Declare Sub decode
declare sub eew
Declare Sub eer


declare sub settime
declare sub readtime
dim _sec as byte,_min as byte, _hour as byte, lsec as byte
dim _secc as byte
Const Ds1307w = &HD0
Const Ds1307r = &HD1

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


dim readkey as bit:dim readclock as bit  :dim a as byte
dim keytouched as bit   : dim touchtime as byte

'used variables
Dim I As Byte




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


   enable urxc
   config timer0=TIMER,prescale=1024
   enable timer0
   on urxc rxin   :disable urxc


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


Gosub Rnumber_er
If Rnumber > 5 Then
Rnumber = 0
Gosub Rnumber_ew
End If


simconfig:

   dim answer as string*120
   dim rx as byte



   simrst alias portc.4:config portc.4=output
   dim,j as byte
   dim number as string*14
   start timer0
   const qut="
   dim sms(10) as string*25
   dim msg as string*120
   dim text as string*14
   dim k as byte

   declare sub findorder
   declare sub readsms
   declare sub sendsms
   declare sub delall
   declare sub delread



stop timer0


Startup:

   cls
   reset simrst
   waitms 100
   set simrst
   for a=1 to 16
      waitms 500:lcd "*"
   next
   enable urxc
   cls

   do
      answer=""
      print "ATE0"
      cls: lcd "ATE0"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   cls :lcd answer:wait 1:cls


   do
      answer=""
      Print "AT&F"
      cls: lcd "AT&F"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      print "ATE0"
      cls: lcd "ATE0"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   cls :lcd answer:wait 1:cls

   do
      answer=""
      print "AT"
      cls: lcd "AT"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT+cpin?"
      cls: lcd "AT+cpin?"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls


   do
      answer=""
      Print "AT+CMGF=1"
      cls: lcd "AT+CMGF=1"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "At+Cusd=1"
      cls: lcd "At+Cusd=1"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls


   do
      answer=""
      Print "AT+CSMP=17,167,0,0"
      cls: lcd "AT+CSMP=17,167,0,0"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print  "AT+CNMI=2,1,0,0,0"
      cls: lcd "AT+CNMI=2,1,0,0,0"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
      cls: lcd "AT+CSCS=GSM"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   delall
   cls :lcd answer:wait 1:cls

   number="+989155609631":msg="system is online":sendsms
   cls:lcd answer:lowerline:lcd "SMS WAS SENT":wait 3:cls
   answer=""

start timer0


Main:


Do

      if lsec=1 then
         if key=0 then set keytouched
         lsec=0
         if key2=0 then incr _min
         if key3=0 then incr _hour
         if _min>59 then _min=0
         if _hour>23 then _hour=0
         if key2=0 or key3=0 then settime
         readtime
              timestr=""
              shour=str(_hour):smin=str(_min):ssec=str(_sec)
              shour=format(shour,"00"): smin=format(smin,"00"): ssec=format(ssec,"00")
              timestr=shour+":"+smin+":"+ssec

              #if uselcd=1
                  home : lcd timestr
                  lowerline
                  lcd sens1;" C  ";sens2; " C  "
              #endif


         temp
         if tmp1<maxtemp or tmp2<maxtemp then
            hightemp=0
         endif
         if tmp1>maxtemp or tmp2>maxtemp then
            incr hightemp
            if hightemp>30 then

            endif

         end if


               'cls:waitms 500:lcd "Online":wait 1
               if number<>"" then
               'lowerline:lcd number:wait 2
               end if

               i=0
               answer=lcase(answer)
               i=instr(answer,"+cmti")
               if i>0 then
                  cls:lcd "new sms"
                  answer=""
                  print "AT+CMGR=1"
               end if


               i=0
               waitms 500
               answer=lcase(answer)
               i=instr(answer,"+cmgr:")
               sms(10)=""
               if i>0 then
                  j=split(answer,sms(1),qut)
                  text=sms(9)
                  number=sms(4)
                  a=len(text)
                  a=a-2
                  text=mid(sms(9),1,a)
                  k=0
                  for j=1 to 10
                     a=j+12
                     incr k
                     'cls:lcd sms(j):lowerline:lcd j:wait 2:cls:waitms 500
                  next
                  'readsms
               end if
               if text<>"" then
                  cls:lcd "number":lowerline:lcd number:wait 2:cls:waitms 500
                  cls:lcd "text":lowerline:lcd text:wait 2:cls:waitms 500
                  findorder
               end if
      end if



      gosub _read



loop



t0rutin:

        stop timer0
             incr t0

            a=t0 mod 20
            if a=0 then
               toggle led1
               if keytouched=1 and key=0 then
                  incr touchtime
               end if
               if keytouched=1 and key=1 then
                  reset keytouched
                  if touchtime<5 then newlearn
               end if
               if touchtime>10 then delremote
               if key=1 then
                  touchtime=0
                  reset keytouched
               end if
            end if

           a=t0 mod 40
           if a=0 then
              lsec=1
           end if


            if t0=80 then
               t0=0
               'set readsms
            end if



        timer0=0
        start timer0
return



sub delremote
              Rnumber = 0
              Gosub Rnumber_ew
              for eaddress=0 to 25
                       datawrite=0
                       gosub eew
              next
              reset buzz
              for i=1 to 16
                       toggle buzz
                       waitms 250
              next
end sub

sub newlearn:
              for i=1 to 8
                       toggle buzz
                       waitms 500
              next
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
        'timer1=0
        'lowerline :lcd timer2
        reset triac
        incr syc
        poweroff=0

        if syc=100 then
           toggle led2
           syc=0
        endif

return

rxin:
   timeout=10

   'disable urxc
  ' do
      inputbin rx

      select case rx
         case 0

         case 10
           'if answer<>"" then exit do
         case 13
            'answer=""
         case else
            answer=answer+chr(rx)
            'answer=lcase(answer)
      end select
   'loop
      'findorder
   'enable urxc
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
            #if uselcd=1
                'cls
                'lcd code : lowerline : lcd address :wait 2
            #endif
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

         cls:lcd code:toggle relay
         wait 3
         cls

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

stop timer0
disable int0

Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()

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
          'dispstr
          endif



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
                    'dispstr

          end if

       end if

    end if

enable int0
start timer0

end sub


sub Conversion
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   tmp=readsens
   tmp=tmp/10
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub

sub findorder

   select case text
      case "on"
         msg="relay is on"
      case "off"
         msg="relay is off"
      case "new1"
         msg="Num#1 is Saved"
      case "new2"
         msg="Num#2 is Saved"
      case "new3"
         msg="Num#3 is Saved"
      case "del"
         msg="All numbers is deleted"
      case "?"
         msg="status"
      case  else
         msg="wrong sms"
   end select
   answer=""
   text=""
   sendsms


end sub

sub sendsms
   answer=""
   Print "AT+CMGS=" ; Chr(34);number; Chr(34)
   waitms 250
   print msg ; Chr(26)
   waitms 250

   'do
      'i=instr(answer,"ok")
      'if i>0 then exit do
   'loop
   answer=""
   text=""
   delall
   cls
end sub

sub readsms

   'a=instr(answer,"+989")
   'j=a+13
   'number=mid(answer,a,j)
   'cls:lcd "new sms":lowerline:lcd number:wait 2:cls:waitms 500
   'j=split(answer,sms(10),qut)
   'text=sms(6)
   'answer=""
end sub

end

sub delall
   do
      answer=""
      Print  "AT+CMGDA=DEL ALL"
      home: lcd "DEL ALL SMS"
      lowerline :lcd "answer= ";answer :waitms 250
   loop until lcase(answer)="ok"
end sub

sub delread
   do
      answer=""
      Print  "AT+CMGDA=DEL READ"
      cls: lcd "DEL READ SMS"
      lowerline :lcd "answer= ";answer :waitms 500
   loop until lcase(answer)="ok"

end sub
end