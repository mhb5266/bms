$regfile="m8def.dat"
$crystal=11059200
$baud=9600

configs:

pg alias portB.0:config portB.0=output
simrst alias portc.4:config portc.4=OUTPUT
'Config Serialout = Buffered , Size = 20
CONFIG PORTA=OUTPUT
bb alias porta.0
'reset simrst
'waitms 100
set simrst

enable interrupts
enable urxc
on urxc rxin

defines:

dim answer as string*10
dim rx as byte
DIM AA AS BYTE



do
  printbin rx
  incr rx
  porta=rx
  toggle pg
  waitms 500

loop



main:
     do
       if lcase(answer)="on" then
          set bb
          answer=""
          print "it is on"
       end if
       if lcase(answer)="off" then
          reset bb
          answer=""
          print "it is off"
       end if
       if lcase(answer)="blink" then
          toggle pg
          print "it is blinking"
       end if
       WAITMS 500


     loop





rxin:

     answer=""
   do
      inputbin rx
      select case rx
         case 0

         case 10
           if answer<>"" then exit do
         case 13
         case else
            answer=answer+chr(rx)
      end select
   loop


return


end