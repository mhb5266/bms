$regfile="m8def.dat"
$crystal=8000000


Config Kbd = Portb

dim b as byte


main:

do
   b=0
   b=getkbd()
   if b>15 then b=0

   if b>0 then
    toggle portc.5
    wait 1
  endif
loop


end