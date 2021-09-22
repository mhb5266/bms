

$regfile="m328pdef.dat"
$crystal=16000000

'$regfile = "m8def.dat"
'$crystal = 1000000
Config Adc = single , Prescaler = Auto , Reference = Off
'Config Lcdpin = Pin , Db7 = Portd.7 , Db6 = Prtd.6 , Db5 = Portd.5 , Db4 = Portd.4 , E = Portd.3 , Rs = Portd.2
'Config Lcd = 16 * 2
'Cursor Off
Enable Interrupts
Dim A As Word
dim f(10) as word
dim x as word
Dim B As word
dim i as byte
Enable Adc
Start Adc

red alias portc.2:config portc.2=OUTPUT
green alias portc.3:config portc.3=OUTPUT
blue alias portc.4:config portc.4=OUTPUT

buzz alias portc.5:config portc.5=OUTPUT

motor alias portd.5:config portd.5=OUTPUT


dip1 alias pind.3:config portd.3=INPUT
dip2 alias pind.4:config portd.4=INPUT

pg alias portd.6:config portd.6=OUTPUT
'*******************************************************************************



Do

A = Getadc(0)





if a>315 then   'less than 20 cm
      reset red:reset green:set blue
      set buzz
      set motor
      wait 1
      reset green
      reset blue
      reset buzz
      reset motor
      waitms 200
      if dip2=0 then
            set buzz
            set motor
            wait 1
            reset green
            reset blue
            reset buzz
            reset motor
      end if
      do
        A = Getadc(0)
        toggle red
        waitms 300
      loop until a<307 'more then 20cm
      set blue
      set red
      wait 1
      reset blue
end if

if a<307 then 'more then 20cm
      reset red:set green:reset blue
      reset buzz
end if



'A = A - 3
'B = 6787 / A
'If B > 20 And B < 78 Then B = B -5 Else B = B -4
'*******************************************************************************
''Home
'Lcd B ; "   "

'(

if a=>409 then
   reset red:set green:reset blue
   set buzz
end if

if a<409 then
   set red:reset green:reset blue
   reset buzz
end if
  ')

'(

if a>la then
   if a=>300 then
      reset red:set green:reset blue
      set buzz
      wait 1
      set blue
      reset buzz
      do
        A = Getadc(0)
      loop until a<143
   end if


end if
la=a+50
   if a<300 then
      set red:reset green:reset blue
      reset buzz
   end if

   ')


'a=a*5
'a=a/1023


'distance = 12343.85 * (10bit reading)^-1.15
'Distance (cm) = 29.988 X POW(Volt , -1.173)

'(
'distance (cm) = 27.86 (voltage reading)^-1.15
b = -1.15
distance = a^b
distance=distance*5697.37
if distance>50 then
   reset red:set green:reset blue
   set buzz
end if

if distance<50 then
   set red:reset green:reset blue
   reset buzz
end if
  ')
Loop
End                                                         'end program
'*********



'(
$regfile="m328pdef.dat"
$crystal=16000000

Dim D As Byte 'distance value
Dim T As Byte
Dim I As Byte
Dim S As String * 20
'Config Lcd = 16 * 2 'configure lcd screen

'Cls

Set P1.0 'set powerdown for sensor
Waitms 10 'default wait

Do
 Reset P1.0 'Start cycle
 Waitms 70 'time to calculate
 Set P1.0
 Shiftin P1.1 , P1.0 , D , 0 'clock bits in MSB first on falling edge
 Set P1.0 'set powerdown for sensor
 Waitms 2 'minimum delay for sensor
 'Cls
 T = D / 16 'we use a 16 char. display (255/x)= 16 max
 'Lcd "Distance : " ; D 'display the distance
 'Lowerline
 If T > 0 Then 'else string will fail
 S = String(t , 61)
 'Lcd S
 End If
Loop
End
')