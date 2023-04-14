$regfile="m16def.dat"

$crystal=11059200

$baud=9600



configs:
   'enable interrupts
   'enable urxc
   'on urxc uartin
   Open "comd.7:9600,8,n,1" For Output As #2

   'config timer0=TIMER,prescale=1024
   'stop timer0
   'disable timer0
subs:

   declare sub uartin
   declare sub clearbuf
   declare sub readsms
defines:
   DIM SREGISTER AS BYTE
   CSQ ALIAS SREGISTER.0
   CREG ALIAS SREGISTER.1
   dim rxin as string *200
   dim header as string*200
   dim text as string*200
   dim t as word
   dim b as byte
   dim i as word
   dim x as word
   good alias porta.0:config porta.0=OUTPUT
   ready alias porta.1:config porta.1=OUTPUT
   simrst alias portd.6:config portd.6=OUTPUT




startup:
  ' reset simrst
   'wait 1
   set simrst
  for i= 1 to 120
   waitms 250
   toggle good
  next

    do
      wait 1
      clearbuf
      'print#2, "ate0"
      print "ate0"
      uartin
      if rxin="ok" then exit do
    loop
    do
      wait 1
      clearbuf
      'print#2, "AT&F"
      print "AT&F"
      uartin
      if rxin="ok" then exit do
    loop
    do
      wait 1
      clearbuf
      'print#2, "ate0"
      print "ate0"
      uartin
      if rxin="ok" then exit do
    loop
    do
      wait 1
      clearbuf
      'print#2, "AT"
      print "at"
      uartin
      if rxin="ok" then exit do
    loop

    do
      wait 1
      'print#2,"AT+cpin?"
      print "AT+cpin?"
      uartin
      if rxin="+cpin: ready" then exit do
    loop



    do
      wait 1
      clearbuf
      'print#2,"AT+CMGF=1"
      print  "AT+CMGF=1"
      uartin
      if rxin="ok" then exit do
    loop

    'do
      wait 1
      clearbuf
      'print#2,"AT+CMGF?"
      print  "AT+CMGF?"
      uartin
      'if rxin="ok" then exit do
    'loop

    do
      wait 1
      clearbuf
      'print#2,"At+Cusd=1"
      print "At+Cusd=1"
      uartin
      if rxin="ok" then exit do

    loop

    do
      wait 1
      clearbuf
      'print#2,"AT+CSMP=17,167,2,25"
      print "AT+CSMP=17,167,2,25"
      uartin
      if rxin="ok" then exit do
    loop

    do
      wait 1
      clearbuf
      'print#2,"AT+CNMI=2,2,0,0,0"
      Print "AT+CNMI=2,2,0,0,0"
      ''print#2,"AT+CNMI=1,1,0,0,0"
      'Print "AT+CNMI=1,1,0,0,0"
      uartin
      if rxin="ok" then exit do

    loop

    do
      wait 1
      clearbuf
      'print#2,"AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
      Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
      uartin
      if rxin="ok" then exit do

    loop

    do
      wait 1
      clearbuf
      'print#2,"AT+CMGDA=DEL READ"
      Print "AT+CMGDA=DEL READ"
      uartin
      if rxin="ok" then exit do

    loop

main:
      set good
      reset ready
   do
      toggle good
      incr x
      waitms 250
      if x=20 then

         readsms

      end if
      if x=40 then
         x=0

         print "AT+CSQ"
      end if
   loop



end


 sub uartin:
   rxin=""
   t=0
   do
      incr t
      'waitms 10
      b=inkey()
      waitms 1
      if b=0 then incr t
      if b>0 then t=0
      if t>3000 then exit do
      select case b
         case 0

         case 10
              If rxin <> "" Then Exit Do
         case 13

         case else
            rxin=rxin+chr(b)
      end select
      'if t=2000 then exit do

   loop
   rxin=lcase(rxin)
   'if rxin<>"" then print#2 ,rxin


end sub

sub clearbuf

   do
      b=inkey()
      if b=0 then exit do

   loop

end sub

sub readsms
   'uartin


   'clearbuf
   ''print#2, "at+cmgr=1"
   print "AT+CMGR=1"
      uartin
      header=rxin
      ''print#2,header;"11111"
      uartin
      text=rxin
      ''print#2,text ;"22222"
      uartin
      text=rxin
     ' 'print#2,text;"33333"
 '(
    do
      wait 1
      clearbuf
      'print#2,"AT+CMGDA=DEL READ"
      Print "AT+CMGDA=DEL READ"
      uartin
      if rxin="ok" then exit do

    loop
    ')

end sub