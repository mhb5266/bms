$regfile="m8def.dat"
$crystal=1000000

configs:
config lcdpin=pin;db7=portb.7;db6=portb.6;db5=portb.5;db4=portb.4;enable=portb.3;rs=portb.2

CONFIG ADC = free, PRESCALER = AUto

config timer1=timer ,prescale=1

'enable interrupts
'enable int0
'on int0 intisr
'config int0=FALLING
'
'trig alias pind.2:config portd.2=INPUT

pg alias portd.7:config portd.7 =output

startt alias portd.0:config portd.0=OUTPUT
l1k1 alias portd.1:config portd.1=OUTPUT
l2k2 alias portd.2:config portd.2=OUTPUT
l1g alias portd.3:config portd.3=OUTPUT
l2g alias portd.4:config portd.4=OUTPUT
sw alias portd.5:config portd.5=OUTPUT

defines:


dim b as byte
dim i as word
dim adcin as word
dim vin as single
dim in1 as single
dim in2 as single
dim ing as single
dim backup as  single
dim volt as string*5
dim v(3) as string*5

declare sub calvolt

dim test as word
dim move as Boolean
dim t as byte

   cls
    lcd "hi"
    wait 1
    cls:waitms 500
start ADC

timer1=0
start timer1

main:

do
  adcin=getadc(0)
  if adcin=0 then
     i=0
     do
     incr i
     loop until i=4980
     adcin=getadc(0)
     home
     lcd adcin;"   "
     wait 2
     toggle pg
  end if



loop


intisr:



return

end