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

startt alias portb.0:config portb.0=OUTPUT
l1k1 alias portd.1:config portd.1=OUTPUT
l2k2 alias portd.2:config portd.2=OUTPUT
l1g alias portd.3:config portd.3=OUTPUT
l2g alias portd.4:config portd.4=OUTPUT
sw alias portd.5:config portd.5=OUTPUT

defines:


dim b as byte
dim i as word
dim adcin as dword
dim vin as single
dim in1 as single
dim in2 as single
dim ing as single

dim min1(5) as single
dim min2(5) as single
dim ming(5) as single

dim backup as  single
dim volt as string*5
dim v(3) as string*5

declare sub calvolt

dim test as byte
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
         for i=1 to 5
           adcin=getadc(0)
           calvolt
           v(1)=volt
           min1(i)=vin

           adcin=getadc(1)
           calvolt
           v(2)=volt
           min2(i)=vin

           adcin=getadc(2)
           calvolt
           v(3)=volt
           ming(i) =vin
           waitms 200
         next

         'for i=1 to 10
             in1=max (min1)
             in2=max (min2)
             ing=max(ming)
         'next

         in1=in1/10
         in2=in2/10
         ing=ing/10
'(
         adcin=getadc(0)
         calvolt
         v(1)=volt
         in1=vin

         adcin=getadc(1)
         calvolt
         v(2)=volt
         in2=vin

         adcin=getadc(2)
         calvolt
         v(3)=volt
         ing =vin
   ')

      if in1>170 and in1<230 then
         set l1k1
      else
         reset l1k1
      end if

      if in2>170 and in2<230 then
         set l2k2
      else
         reset l2k2
      end if

      if l1k1=0 or l2k2=0 then
         set sw
         set move
      end if
      incr i
      'if i=20 then
         i=0
         home
         lcd v(2);" 1 ";v(1);" 2 "
         lowerline
         lcd v(3);" 3 "

         'incr test
         'if test=5 then
            toggle pg
         'end if
      'end if



   loop




sub calvolt
      vin=adcin
      vin=vin/0.0033
      vin=vin*0.633
      vin=vin/132
      vin=vin*1.14
      volt=fusing(vin,"##.#")
end sub

intisr:



return

end