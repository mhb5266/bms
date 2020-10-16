$regfile = "m16def.dat"                                     '
$crystal = 8000000

$baud = 115200

Configs:
Config Adc = Single , Prescaler = Auto
Config Lcdpin = 16 * 2 , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.3 , Rs = Portb.2
Defines:

Dim Ad30 As Word
Dim Temp As Single

Dim Vo As Single
Dim Rt As Single
Dim Adcin As Word

Dim W As Single
Dim Y As Single
Dim Z As Single
Dim Lnrt As Single
Dim Alloff As Boolean

Fan Alias Portd.5

Const A = 1.009249522 * 10 ^ -3
Const B = 2.378405444 * 10 ^ -4
Const C = 2.019202697 * 10 ^ -7
Lcd "hi"
Waitms 500
Cls
Main:

     Do

       Adcin = Getadc(7)
       Waitms 500
       Vo = 1023 / Adcin
       Vo = Vo - 1
       Rt = Vo * 10000
       Lnrt = Log(rt)
       W = Lnrt
       W = W ^ 3
       W = W * C
       Y = B * Lnrt
       Z = A + Y
       Z = Z + W

       Temp = 1 / Z
       Temp = Temp - 273
       Cls
       Lcd Temp
       Lowerline
       Lcd Adcin ; "  "
       If Temp < 45 Then Reset Fan
       If Temp > 50 Then Set Fan
       If Temp > 120 Then Set Alloff Else Reset Alloff



     Loop


End