$regfile="m32def.dat"
$crystal=11059200

configs:

Config Lcdpin = 20*4 , Db4 = PortA.4 , Db5 = PortA.5 , Db6 = PortA.6 , Db7 = PortA.7 , E = PortA.0 , Rs = Porta.2
cursor off

config portd.6=OUTPUT

configtemp:

config 1wire=PORTB.0

Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte

Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6


Dim Readsens As Integer




Dim Tmp1 As Integer



defines:

dim sesson as string*10

chiller alias portd.0:config chiller=output
motorseir alias portd.1:config  motorseir=output

heater alias portd.7:config heater=output

subs:

declare sub temp
declare sub conversion



do

  'cls
  'lcd"hi"
  waitms 500
  toggle portd.6

loop

end


Sub Temp


   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   if err=0 then
      1wwrite &HBE
      Readsens = 1wread(2)
      Conversion
      Sens1 = Temperature


   end if

end sub

sub Conversion
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub