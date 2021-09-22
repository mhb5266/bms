$regfile = "m8def.dat"
$crystal = 1000000
Config Adc = Single , Prescaler = Auto , Reference = Off
Config Lcdpin = Pin , Db7 = Portd.7 , Db6 = Prtd.6 , Db5 = Portd.5 , Db4 = Portd.4 , E = Portd.3 , Rs = Portd.2
Config Lcd = 16 * 2
Cursor Off
Enable Interrupts
Dim A As Word
Dim B As Word
Enable Adc
Start Adc
'*******************************************************************************
Do
A = Getadc(0)
A = A - 3
B = 6787 / A
If B > 20 And B < 78 Then B = B -5 Else B = B -4
'*******************************************************************************
Home
Lcd B ; "   "
Loop
End                                                         'end program
'*******************************************************************************
