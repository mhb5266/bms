$regfile="m8def.dat"
$crystal=11059200

$baud=1200



configs:
   enable interrupts
   enable urxc
   on urxc rx

   config lcdpin=16*2,db7=portb.0,db6=portb.1,db5=portb.5,db4=portb.4 ,e=portb.3,rs=portb.2

defines:
   dim f as Byte
   dim maxin as Byte
   dim inok as bit
   dim din(5) as Byte
   dim cmd as Byte

startup:

cls
lcd "hi"
wait 2
cls


main:

DO
   wait 1
   locate 2,1
   lcd f
   incr f

LOOP


end


Rx:


      Inputbin Maxin

      home
      lcd maxin



Return