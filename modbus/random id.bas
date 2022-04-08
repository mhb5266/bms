

'slave


$regfile="m8def.dat"
$CRYSTAL=11059200
$baud=9600


enable urxc
enable interrupts


on urxc rxin

dim b as byte
dim c as byte
dim id as byte
dim i as byte


key alias pinc.0:config pinc.0=input
config portb=OUTPUT

do


loop

do
   toggle portb.0
   waitms 500
loop until key=1

portb=0
for i=1 to 8
   toggle portb.4
   waitms 250
next
do
   incr i
   portb=id
   waitms 100
   if key=1 then incr id
loop until i=50
portb=0

main:
   do

      if key=1 then
         incr b
         portb=b
      end if
      waitms 250

   loop

rxin:
   c=inkey()
   if c=10 then
      c=waitkey()
      if c=id then
         gosub tx
      end if
   end if

return

tx:

   printbin b
return

end