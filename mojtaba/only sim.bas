
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
   dim i as byte
   start timer0


startup:
   cls
   reset simrst
   waitms 100
   set simrst
   for i=1 to 16
      waitms 500:lcd "*"
   next
   enable urxc
   cls
   do
      answer=""
      print "ATE0"
      cls: lcd "ATE0"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)="ok"
   cls :lcd answer:wait 1:cls

   do
      answer=""
      print "AT"
      cls: lcd "AT"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT+cpin?"
      cls: lcd "AT+cpin?"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT&F"
      cls: lcd "AT&F"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)="ok"
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT+CMGF=1"
      cls: lcd "AT+CMGF=1"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "At+Cusd=1"
      cls: lcd "At+Cusd=1"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls


   do
      answer=""
      Print "AT+CSMP=17,167,0,0"
      cls: lcd "AT+CSMP=17,167,0,0"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print  "AT+CNMI=2,1,0,0,0"
      cls: lcd "AT+CNMI=2,1,0,0,0"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls

   do
      answer=""
      Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
      cls: lcd "AT+CSCS=GSM"
      lowerline :lcd "answer= ";answer :wait 1
   loop until lcase(answer)<>""
   lowerline
   cls :lcd answer:wait 1:cls

   answer=""
   Print "AT+CMGS=" ; Chr(34);"+989155609631"; Chr(34)
   waitms 100
   print "system is online"; Chr(26)
   do
      i=instr(answer,"ok")
      if i>0 then exit do
   loop
   cls:lcd "SMS WAS SENT":wait 3
main:

   do
      cls:lcd "main":wait 2:cls:waitms 500


   loop




t0rutin:
   incr t0
   if t0=40 then
      t0=0
      toggle led1
      if timeout>0 then
         decr timeout
      end if
   end if


return


rxin:
   timeout=10

   'disable urxc
      inputbin rx

      select case rx
         case 0

         case 10
           'answer=""
         case 13
            'answer=""
         case else
            answer=answer+chr(rx)
            answer=lcase(answer)
      end select
   'enable urxc
return



end