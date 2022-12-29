$regfile="m8def.dat"
$crystal=8000000
$baud=9600


configs:

config lcdpin=pin;db7=portb.7;db6=portb.6;db5=portb.5;db4=portb.4;rs=portb.2;e=portb.3

open "comc.0:9600,8,n,1" for output as #2
open "comc.1:9600,8,n,1" for input as #3

led alias portb.0:config portb.0=OUTPUT

defines:

dim i as byte
dim b as byte

main:

   do
      wait 1
      incr i
      print #2,i
      'waitms 100
      'inputbin b
      'cls:lcd b
      'toggle led



   loop



end