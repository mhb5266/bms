$regfile="m8def.dat"
$crystal=11059200


configs:


config lcdpin=16*2 ,db7=portc.5,db6=portc.4,db5=portc.3,db4=portc.2,e=portc.1,rs=portc.0
config lcd=16*2
cursor off
cls
enable interrupts
'enable urxc
'on urxc rxrutin
Config Serialin = Buffered , Size = 30


defines:

motor alias portb.0:config portb.0=output
heater alias portd.2:config portd.2=output
chiller alias portd.6:config portd.6=output

dim buffer as byte
dim a as byte
dim j as byte
dim strin as string*20
dim i as byte

for i=1 to 16
    lcd "*"
    waitms 500
next

cls

main:
     do
       if ischarwaiting()=1 then gosub rxrutin
     loop


rxrutin:
        buffer=inkey()

        select case chr(buffer)
               case "*"
                          strin=""
                          cls
               case "#"
                     home
                     lcd strin
                     gosub order

               case  else
                     strin=strin+chr(buffer)

        end select


return

order:

      select case strin
             case "Motor >> ON "
                   set motor

             case "Heater >> ON "
                   set heater

             case "Chiller >> ON "
                   set chiller

             case "Motor >> OFF "
                   reset motor

             case "Heater >> OFF "
                   reset heater

             case "Chiller >> OFF "
                   reset chiller

      end select


return


end