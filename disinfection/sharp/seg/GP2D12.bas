$regfile = "m8def.dat"
$crystal = 1000000
Config Adc = Single , Prescaler = Auto , Reference = Off
Config Portb = Output
Config Portd = Output
Config Portc.5 = Output
Enable Interrupts
Dim A As Long
Dim B As Long
Dim C As Word
Dim D As Word
Dim F As Byte
Dim G As Byte
Dim J As Word
Dim K As Byte
Declare Sub Yekan
Y Alias Portb.3
D0 Alias Portb.2
Enable Adc
Start Adc
'*******************************************************************************
Do
A = Getadc(0)
A = A - 3
B = 6787 / A
If B > 20 And B < 78 Then B = B -5 Else B = B -4
'*******************************************************************************
Call Yekan
Portb.4 = 1
Y = 1
Portd = F
Waitms 4
Y = 0
D0 = 1
Portd = G
Waitms 4
D0 = 0
'*******************************************************************************
Loop
End                                                         'end program
'*******************************************************************************
Hadi:
Data &B1000000 , &B1111001 , &B0100100 , &B0110000
Data &B0011001 , &B0010010 , &B0000010 , &B1111000
Data &B0000000 , &B0010000
'*******************************************************************************
Sub Yekan
C = B / 10
C = C * 10
C = B - C
F = C
F = Lookup(f , Hadi)
D = B / 100
D = D * 100
D = B - D
D = D / 10
G = D
G = Lookup(g , Hadi)
End Sub