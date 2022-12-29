$regfile="m16def.dat"
$crystal=1000000


configs:
config lcdpin=pin ,db7=portb.5,db6=portb.4,db5=portb.3,db4=portb.2,e=portb.1,rs=portb.0
'Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Portc.7 , Rs = Portc.6
'config adc=single ,prescaler=auto


defines:

l1k1 alias portd.0:config  portd.0=OUTPUT
l2k2 alias portd.1:config portd.1=OUTPUT
l1g alias portd.2:config portd.2=OUTPUT
l2g alias portd.3:config portd.3=OUTPUT
sw alias portd.4:config portd.4=OUTPUT
startt alias portd.5:config portd.5=OUTPUT


dim adcin as word

'declare sub readvolt


startup:

cls
lcd "hi"

main:

do

   'readvolt
   wait 1
   toggle l1k1

loop

'sub readvolt
   'adcin=getadc(0)
  ' home :lcd adcin

'end sub


end

