$regfile = "m16def.dat"
$crystal = 11059200
$baud = 9600

SIMRST ALIAS PORTD.6 : CONFIG PORTD.6 = OUTPUT
SIMON ALIAS PORTD.5 : CONFIG PORTD.5 = OUTPUT
LED1 ALIAS PORTb.0 : CONFIG PORTb.0 = OUTPUT
LED2 ALIAS PORTA.1 : CONFIG PORTA.1 = OUTPUT
LED3 ALIAS PORTA.0 : CONFIG PORTA.0 = OUTPUT
LED4 ALIAS PORTc.1 : CONFIG PORTc.1 = OUTPUT
pir alias pinc.0 : config portc.0 = INPUT


do
 toggle led1
  wait 1
 toggle led2
  wait 1
 toggle led3
 wait 1

loop


end