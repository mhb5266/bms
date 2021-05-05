$regfile = "m16def.dat"
$crystal = 11059200


Configs:
Config Lcdpin = 16x2 , Db7 = Portd.6 , Db6 = Portd.5 , Db5 = Portd.4 , Db4 = Portd.3 , E = Portc.0 , Rs = Portd.7
Cursor Off
Config Adc = Single , Prescaler = Auto

Defines:

Dim Adcin As Word
Dim In(5) As Word
Dim A As Single
Dim Amper As Integer
Dim Astr As String * 6
Dim I As Byte
Main:

     Do
          For I = 1 To 5
              Adcin = Getadc(7)
              Wait 1
              In(i) = Adcin
          Next
          Amper = 0
          For I = 1 To 5
              Amper = Amper + In(i)
          Next
          Amper = Amper / 5
          Waitms 10
          Amper = Amper - 512
          Amper = Amper * 48.89
          Astr = Str(amper)
          Astr = Format(astr , "0.000" )
          Cls : Lcd Adcin : Lowerline : Lcd Astr : Wait 2
     Loop

End