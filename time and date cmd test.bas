$regfile = "m8def.dat"
$crystal = 8000000

Config Lcdpin = 16 * 2 , Db4 = Portd.4 , Db5 = Portd.5 , Db6 = Portd.6 , Db7 = Portd.7 , E = Portd.3 , Rs = Portd.2
Cursor Off
Config Clock = Soft
Config Date = Ymd , Separator = Slash
Config Timer0 = Timer , Prescale = 1

Enable Interrupts

Time$ = "16:09:13"
_year = 99
_month = 12
_day = 15

Key Alias Pinb.0 : Config Portb.0 = Input
Dim A As Byte

Dim S1 As Byte
Dim S2 As Byte

Dim M1 As Byte
Dim M2 As Byte

Main:
     Do
       Home
       'Lcd _hour ; ":" ; _min ; ":" ; _sec
       Lcd Time$
       Lowerline
       Lcd Date$
       Waitms 50

       Timer0 = 5
       Timer1 = 5
       Stop Timer0
       Stop Timer1

       If Key = 0 Then


             S1 = _sec
             M1 = _min
             M2 = M1
             S2 = S1 + 90
             A = S2 / 60
             M2 = M2 + A
             S2 = S2 Mod 60
             Lowerline
             Lcd M1 ; ":" ; S1 ; " " ; M2 ; ":" ; S2
             Waitms 30
             Do
             Loop Until Key = 1
       End If

     Loop

End