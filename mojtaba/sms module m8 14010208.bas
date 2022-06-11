$regfile="m8def.dat"
$crystal=11059200
$baud=9600

configs:
config lcdpin=pin ,db7=portc.5,db6=portc.4,db5=portc.3,db4=portc.2,e=portc.0,rs=portc.1
pg alias portB.0:config portB.0=output
'simrst alias portc.4:config portc.4=OUTPUT
'Config Serialout = Buffered , Size = 20

simrst alias portd.7:config portd.7=OUTPUT
'reset simrst
'waitms 100


enable interrupts
enable urxc
on urxc rxin

defines:

dim answer as string*10
dim rx as byte
DIM AA AS BYTE
dim i as byte
lcd "hi"
wait 2
cls

reset simrst
waitms 100
set simrst

do
print "ATE0"
wait 2
toggle pg
 if answer="ok" then exit do
loop

for i=1 to 8
    toggle pg
    waitms 500
next
reset pg
main:


     do
       print "AT"
       wait 2



     loop




rxin:


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
   answer=lcase(answer)
   cls
   lcd answer
   wait 1


return


end