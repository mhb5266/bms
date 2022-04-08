

'MASTER


$regfile="m8def.dat"
$CRYSTAL=11059200
$baud=9600
enable urxc
enable interrupts


on urxc rxin

dim b as byte
dim id as byte:id=3
dim i as byte
dim test as word
config lcdpin=pin;db7=portc.5;db6=portc.4;db5=portc.3;db4=portc.2;rs=portc.1;e=portc.0
lcd "hi"

config portb=OUTPUT

wait 2

cls



main:
   do

    wait 1
    for i=1 to id
      printbin 10
      printbin i
      waitms 100
    next

   loop

rxin:
   b=inkey()
   cls
   if id=1 then lcd b
   if id =2 then lowerline :lcd b
   portb=b

return

end