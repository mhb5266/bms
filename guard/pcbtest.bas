$regfile = "m16def.dat"
$crystal = 11059200

enable interrupts
enable timer1
config timer1=TIMER,prescale=1024
on timer1 t1rutin
start timer1


SIMRST ALIAS PORTD.6 : CONFIG PORTD.6 = OUTPUT
SIMON ALIAS PORTD.5 : CONFIG PORTD.5 = OUTPUT
LED1 ALIAS PORTb.0 : CONFIG PORTb.0 = OUTPUT
LED2 ALIAS PORTA.1 : CONFIG PORTA.1 = OUTPUT
LED3 ALIAS PORTA.0 : CONFIG PORTA.0 = OUTPUT
LED4 ALIAS PORTc.1 : CONFIG PORTc.1 = OUTPUT
'pir alias pinc.0 : config portc.0 = INPUT



main:
do



loop



t1rutin:
        stop timer1
        toggle led1
        toggle led2
        toggle led3
        timer1=54735
        start timer1
return

end

