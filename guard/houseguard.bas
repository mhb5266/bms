$REGFILE="m32def.dat"
$crystal=11059200

includes:



configs:
$baud=9600
enable interrupts
enable urxc
on urxc rxin

config lcdpin=pin,db4=porta.4,db5=porta.5,db6=porta.6,db7=porta.7,e=porta.3,rs=porta.2

config portd=INPUT

z1 alias pind.2:config portd.2=output
s1 alias pind.3:config portd.3=output
z2 alias pind.4:config portd.4=output
s2 alias pind.5:config portd.5=output
z3 alias pind.6:config portd.6=output
s3 alias pind.7:config portd.7=output


defines:

dim key as byte



startup:

cls
lcd "hi"
wait 1
cls


main:
do

  if z1=1 or z2=1 or z3=1 or s1=1 or s2=1 or s3=1 then
   gosub zoneint
  end if

loop

end


rxin:

   inputbin key
   if key<16 then
      cls
      waitms 200
      lcd key
      waitms 500
      cls
   end if

return

zoneint:
   cls
   lcd "zone alarm"
   wait 1
   cls

return