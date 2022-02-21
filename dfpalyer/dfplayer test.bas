$regfile="m8def.dat"
$crystal=11059200

dim filecount as word
led alias portc.5:config portc.5=output
$include "lib_dfplayermini.bas"
main:
     mp3_clear_serialbuffer
     Mp3_SetVolume(17)
     mp3_setsource(1)
do
Mp3_SetVolume(20)
  mp3_next
  'mp3_playfromfolder 3,10
  toggle led
  wait 3
loop

end
