$regfile="m16def.dat"
$crystal=11059200

configs:


Enable Interrupts

defines:

dim msg as string*25

msg="start#set#out1#end"

main:
     do

       wait 1
       print msg


     loop


gosub main

rx:

return


end
