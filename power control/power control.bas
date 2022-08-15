$regfile = "m16def.dat"
$crystal=1000000

configs:
Config Lcdpin = Pin ; Db7 = Portb.5 ; Db6 = Portb.4 ; Db5 = Portb.3 ; Db4 = Portb.2 ; Enable = Portb.1 ; Rs = Portb.0

CONFIG ADC = free, PRESCALER = AUto

config timer1=timer ,prescale=1

'enable interrupts
'enable int0
'on int0 intisr
'config int0=FALLING
'
'trig alias pind.2:config portd.2=INPUT

pg alias portd.7:config portd.7 =output

Startt Alias Portd.5 : Config Portd.5 = Output
L1k1 Alias Portd.0 : Config Portd.0 = Output
L2k2 Alias Portd.2 : Config Portd.2 = Output
L1g Alias Portd.1 : Config Portd.1 = Output
L2g Alias Portd.3 : Config Portd.3 = Output
Sw Alias Portd.4 : Config Portd.4 = Output

Buzzer Alias Portd.6 : Config Portd.6 = Output

defines:


Dim B As Byte
dim i as word
dim adcin as dword
Dim Vin As Single
dim in1 as single
dim in2 as single
dim ing as single

dim min1(5) as single
dim min2(5) as single
dim ming(5) as single

dim backup as  single
dim volt as string*5
dim v(3) as string*5

Declare Sub Calvolt
Declare Sub Startgen
Declare Sub Readvolt
Declare Sub Showvolt

dim test as byte
Dim Move As Byte
dim t as byte

   cls
    lcd "hi"
    wait 1
    cls:waitms 500
start ADC

timer1=0
start timer1

Set Buzzer
Waitms 500
Reset Sw
Reset Buzzer
'(
Portd = 0
Wait 2
Set Sw
Wait 1
Reset Sw
Set Startt
Wait 1
Reset Startt
Set L1k1
Wait 1
Reset L1k1
Set L2k2
Wait 1
Reset L2k2
Set L1g
Wait 1
Reset L1g
Set L2g
Wait 1
Reset L2g
  ')
main:

   Do
         for i=1 to 5
             Readvolt
         next

         'for i=1 to 10
             in1=max (min1)
             in2=max (min2)
             ing=max(ming)
         'next

         'in1=in1/10
         'in2=in2/10
         'ing=ing/10
         In1 = Val(v(1))
         In2 = Val(v(2))
         Ing = Val(v(3))
'(
         adcin=getadc(0)
         calvolt
         v(1)=volt
         in1=vin

         Adcin = Getadc(1)
         calvolt
         v(2)=volt
         in2=vin

         adcin=getadc(2)
         calvolt
         v(3)=volt
         ing =vin
   ')

      If In1 > 170 And In1 < 250 Then
         If L1g = 1 Then
            Wait 3
            Reset L1g
         End If
         Set L1k1
      Else
         Reset L1k1
      End If

      If In2 > 170 And In2 < 250 Then
         If L2g = 1 Then
            Wait 3
            Reset L2g
         End If
         Set L2k2
      Else
         Reset L2k2
      End If

      If L1k1 = 0 Or L2k2 = 0 Then
         If Move = 0 Then
            Move = 1
            Gosub Startgen
         End If
      Else
          Reset Sw
          Reset Startt
          Move = 0
      end if
      incr i
      'if i=20 then
         i=0
         Showvolt

         'incr test
         'if test=5 then
           ' toggle pg
         'end if
      'end if



   loop




sub calvolt
      vin=adcin
      vin=vin/0.0033
      vin=vin*0.633
      vin=vin/132
      vin=vin*1.14
      volt=fusing(vin,"##.#")
end sub

intisr:



Return


Sub Startgen
    I = 0
    Do
      If Move = 2 Then Exit Do
      Set Sw
      Wait 3
      Set Startt
      Wait 1
      Reset Startt

      Wait 2

           Readvolt
           Showvolt


             Ing = Val(v(3))

           If Ing > 170 And Ing < 250 Then
              Move = 2
              If L1k1 = 0 Then Set L1g
              If L2k2 = 0 Then Set L2g
              Exit Do
           End If

           Incr I
    Loop Until I > 5

End Sub

Sub Readvolt
           adcin=getadc(0)
           calvolt
           v(1)=volt
           min1(i)=vin

           Adcin = Getadc(2)
           calvolt
           v(2)=volt
           min2(i)=vin

           Adcin = Getadc(1)
           Calvolt
           V(3) = Volt
           Ming(i) = Vin
           Waitms 200

End Sub

Sub Showvolt

         home
         Lcd V(1) ; " 1 " ; V(2) ; " 2"
         lowerline
         Lcd V(3) ; " G "

End Sub
End