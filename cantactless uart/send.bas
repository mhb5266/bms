$regfile="m16def.dat"
$crystal=11059200

$baud=1200



configs:

     config porta=OUTPUT
defines:


   dim cmd as byte
   dim i as byte


   declare sub tx
startup:




main:

   do
      wait 5
      incr cmd
      if cmd=7 then cmd=0
      porta=cmd
      for i=0 to 50
      tx
      next

   loop


end


sub Tx


    Waitms 10
    Printbin cmd
    Waitms 50


end sub