$regfile="m8def.dat"
$crystal=8000000

defines:
   dim adcin as word
   dim volt as single





configs:

   config lcdpin=pin ,db4=portd.4,db5=portd.5,db6=portd.6,db7=portd.7,rs=portd.3,e=portd.2

   config adc=free,prescaler=AUTO



main:

     do
       adcin=getadc(0)
       lcd adcin



     loop


end








