$regfile="m16def.dat"
$crystal=11059200
$baud=9600

configs:

config kbd=PORTa


defines:
dim key as byte



startup:



main:

   do

      key=getkbd()
       if key<16 then
         printbin key
         waitms 50
         do
            key=getkbd()
            if key=16 then exit do
         loop
       end if







   loop




end