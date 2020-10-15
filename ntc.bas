$regfile = "m16def.dat"                                     '
$crystal = 11059200

$baud = 115200

Configs:
Config Adc = Free , Prescaler = Auto
Config Lcdpin = 16 * 2 , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.3 , Rs = Portb.2
Defines:

Dim Ad30 As Word
Dim Temp As Single

Dim Vo As Single
Dim Rt As Single
Dim Adcin As Word

Dim X As Single
Dim Y As Single
Dim Z As Single

Const A = 1.009249522 * 10 ^ 3
Const B = 2.378405444 * 10 ^ 4
Const C = 2.019202697 * 10 ^ 7
Main:

     Do

       Adcin = Getadc(7)
       Vo = Adcin * 5
       Vo = Vo / 1023
       Vo = 5 / Vo
       Vo = Vo * 10
       Rt = Vo - 1
       X = Log(rt)
       X = X * B
       X = X + A
       Y = Rt ^ 3
       Y = Log(y)
       Y = Y * C
       Z = X + Y
       Temp = 1 / Z
       Temp = Temp - 273

     Loop


End
