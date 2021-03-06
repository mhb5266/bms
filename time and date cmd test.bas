$regfile = "m8def.dat"
$crystal = 11059200

Config Lcdpin = 16 * 2 , Db4 = Portd.4 , Db5 = Portd.5 , Db6 = Portd.6 , Db7 = Portd.7 , E = Portd.3 , Rs = Portd.2
Cursor Off
Config Clock = Soft , Gosub = Sectic
Config Date = Ymd , Separator = Slash
'Config Timer0 = Timer , Prescale = 1

config TIMER1=TIMER,prescale=256

Enable Interrupts

Time$ = "16:09:13"
_year = 99
_month = 12
_day = 15

Key Alias Pinb.1 : Config Portb.1 = Input
Pg Alias Portc.3 : Config Portc.3 = Output

Config Portc.5 = Output
Dim A As Byte

Dim Secc As Byte

Dim S1 As Byte
Dim S2 As Byte

Dim M1 As Byte
Dim M2 As Byte

Main:
     Do


       A = _sec Mod 2
       If A = 0 Then Toggle Pg
     '(
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
       If Secc > _sec Or Secc < _sec Then
          Toggle Pg
          Secc = _sec
       End If
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
')
     Loop


Sectic:
Toggle Pg
Return


End