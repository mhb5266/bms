$regfile = "m8def.dat"
$crystal = 8000000
Config Int0 = Falling
Config Int1 = Falling
Config Timer1 = Timer , Prescale = 8
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Config Pind.4 = Output
'Config Portb = Output
Config Pind.0 = Input
Config Pind.1 = Input
Enable Interrupts
Enable Int0
On Int0 Ex0_rut
Enable Int1
On Int1 Ex1_rut
Enable Ovf1
On Ovf1 T1_rut
Dim D As Word
Dim Analog As Word
Dim Control As Byte
Set Portd.4
Control = 1
D = 100
Start Adc
'****************
Do
   Select Case Control
   Case 1:
    Analog = Getadc(0)
    D = Analog * 9.2
    Portb = &B00000001
    Waitms 20
   Case 2:
    If Pind.0 = 1 Then
     If D < 9400 Then Incr D
    End If
    If Pind.1 = 1 Then
     If D > 0 Then Decr D
    End If
    Portb = &B00000010
    Waitus 300
   Case 3:
    Analog = Getadc(1)
    D = Analog * 9.2
    Portb = &B00000100
    Waitms 20
   Case Else
    Waitms 2
  End Select
Loop
End
'****************
Ex0_rut:
 Timer1 = &HFFFF - D
 Start Timer1
Return
'****************
Ex1_rut:
 Incr Control
 If Control = 4 Then
  Control = 1
 End If
Return
'****************
T1_rut:
 Stop Timer1
 Reset Portd.4
 Waitus 30
 Set Portd.4
Return