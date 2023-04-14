

$REGFILE="m8def.dat"
$crystal=11059200
$baud=9600


dim b as byte

main:

do



   if ischarwaiting()<>0 then
      input b
      wait 5
      if b>0 then print b
   end if


loop



end