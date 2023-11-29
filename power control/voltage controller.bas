$regfile="m8def.dat"
$crystal=11059200

config portc.5=OUTPUT
config adc=free ,prescaler=AUTO

dim i as byte
dim j as byte
dim b as word
dim sensorvalue as word
dim value(100) as word
dim maxv as word
dim vmaxd as word
dim veffd as single
dim veff as single
do

   for  j=0 to 100
      sensorValue = getadc(0)
      if sensorvalue> 507 then
        value(j) = sensorValue
      else
          value(j)=0
      end if
      waitus 500
      'print j;"-->"; value(j)
   next

   maxv=0
   for j=0 to 100
       if value(j)>maxv then
          maxv=value(j)
       end if
   next
   'toggle portc.5
    'VmaxD = maxv
    'VeffD = VmaxD/1.41
    'Veff = VeffD - 420.76
    'veff=veff / 90.24

    'veff=veff* 210.2
    'veff=veff+210.2
    if maxv>511 then
       veffd=maxv-507
       veff=veffd*0.897
    else
        veff=0
    end if

   print maxv; "--> veff= " ;veff ; " v"
   waitms 500


loop