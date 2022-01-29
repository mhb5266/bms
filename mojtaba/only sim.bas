
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
config lcdpin=pin;db7=porta.4;db6=portb.4;db5=portb.3;db4=portb.2;rs=portb.0;en=portb.1
config lcd=16*2
'cursor off
const uselcd=1

cls
lcd "hi"
wait 3




simconfig:
   enable interrupts
   enable urxc
   config timer0=TIMER,prescale=1024
   enable timer0
   on timer0 t0rutin
   on urxc rxin   :disable urxc
   dim answer as string*120
   dim rx as byte
   dim timeout as byte
   dim t0 as byte
   led1 alias porta.0:config led1=output
   simrst alias portc.4:config portc.4=output
   dim i as byte,a as byte ,j as byte,number as string*14
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



startup:
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
main:

   do
      cls:waitms 500:lcd "Online":wait 1
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
         'cls:lcd "number":lowerline:lcd number:wait 2:cls:waitms 500
         'cls:lcd "text":lowerline:lcd text:wait 2:cls:waitms 500
         findorder
      end if
   loop




t0rutin:
stop timer0
   incr t0
   if t0=40 then
      t0=0
      toggle led1
      if timeout>0 then
         decr timeout
      end if
   end if


start timer0
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
      cls: lcd "DEL ALL SMS"
      lowerline :lcd "answer= ";answer :waitms 500
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