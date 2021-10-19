$regfile="m8def.dat"
$crystal=11059200


configs:


config lcdpin=pin ,db7=portc.5,db6=portc.4,db5=portc.3,db4=portc.2,e=portc.1,rs=portc.0
cursor off
cls
enable interrupts
enable urxc
on urxc rxrutin

defines:

dim buffer as byte
dim a as byte
dim j as byte
dim strin as string*10

main:
     do
       waitms 10
     loop


rxrutin:
disable urxc
        buffer=inkey()
        if chr(buffer)="*" then
           strin=""
           j=0
           do
             waitms 3
             incr j
             buffer=inkey()
             if buffer="#" then exit do
             if j=30 then exit do
             strin=strin+chr(buffer)

           loop
        end if
        home
        lcd strin
enable urxc

return


end