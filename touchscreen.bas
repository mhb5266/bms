$regfile = "m16def.dat"
$crystal = 1000000

$hwstack = 64
$swstack = 64
$framesize = 64

$lib "glcdKS108.LBX"
$include "font8x8.font"

Config Graphlcd = 128 * 64sed , Dataport = Portc , Controlport = Portb , Ce = 1 , Ce2 = 2 , Cd = 5 , Rd = 4 , Reset = 0 , Enable = 3
Setfont Font8x8


Config Portb.6 = Output
Set Portb.6

Dim X As Word
Dim Y As Word
Dim X_e As Single
Dim X1 As Word
Dim X2 As Word
Dim Y_e As Single
Dim Y1 As Word
Dim Y2 As Word
Dim Var As Word
Dim Var1 As Single


Gosub Calibration_x1_y1

Calibration_x1_y1:
Cls
Pset 0 , 0 , 255
Pset 1 , 0 , 255
Pset 0 , 1 , 255
Pset 1 , 1 , 255
Lcdat 4 , 1 , " electronics 98 " , 1
Do
Gosub Scan
If X > 50 Then
Waitms 50
Gosub Scan
X1 = X
Y1 = Y
Cls
Lcdat 4 , 1 , " electronics 98 " , 1
Lcdat 5 , 1 , "     +Saved     " , 0
Do
Gosub Scan
If X < 50 Then Gosub Calibration_x2
Loop
End If
Loop
Return


Calibration_x2:
Cls
Pset 126 , 0 , 255
Pset 127 , 0 , 255
Pset 126 , 1 , 255
Pset 127 , 1 , 255
Lcdat 4 , 1 , " electronics 98 " , 1
Do
Gosub Scan
If X > 50 Then
Waitms 50
Gosub Scan
X2 = X
Cls
Lcdat 4 , 1 , " electronics 98 " , 1
Lcdat 5 , 1 , "     +Saved     " , 0
Do
Gosub Scan
If X < 50 Then Gosub Calibration_y2
Loop
End If
Loop
Return

Calibration_y2:
Cls
Pset 0 , 62 , 255
Pset 1 , 62 , 255
Pset 0 , 63 , 255
Pset 1 , 63 , 255
Lcdat 4 , 1 , " electronics 98 " , 1
Do
Gosub Scan
If Y > 50 Then
Waitms 50
Gosub Scan
Y2 = Y
Cls
Lcdat 4 , 1 , " electronics 98 " , 1
Lcdat 5 , 1 , "     +Saved     " , 0
Do
Gosub Scan
If Y < 50 Then Gosub Calibration
Loop
End If
Loop
Return

Calibration:
If X1 > X2 Then
Var = X1 - X2
X_e = Var / 128
Else
Var = X2 - X1
X_e = Var / 128
End If
If Y1 > Y2 Then
Var = Y1 - Y2
Y_e = Var / 64
Else
Var = Y2 - Y1
Y_e = Var / 64
End If
Gosub Paint
Return

Paint:
Cls
Lcdat 4 , 1 , " electronics 98 " , 1
Do
Gosub Scan
If X1 < X2 Then
Var = X - X1
Var1 = Var / X_e
X = Var1
End If
If X2 < X1 Then
Var = X - X2
Var1 = Var / X_e
X = Var1
X = 128 - x
End If

If Y1 < Y2 Then
Var = Y - Y1
Var1 = Var / Y_e
Y = Var1
End If
If Y2 < Y1 Then
Var = Y - Y2
Var1 = Var / Y_e
Y = Var1
Y = 64 - y
End If

If X < 128 And Y < 64 Then
Lcdat 5 , 1 , "X:" ; X ; "/ Y:" ; Y ; "    " , 0
Pset X , Y , 255
End If
Loop
Return

Scan:
Config Porta.0 = Output
Config Pina.1 = Input
Config Porta.2 = Output
Config Pina.3 = Input
Set Porta.0
Reset Porta.1
Reset Porta.2
Reset Porta.3
Config Adc = Single , Prescaler = Auto
Start Adc
X = Getadc(1)

Waitms 10

Config Pina.0 = Input
Config Porta.1 = Output
Config Pina.2 = Input
Config Porta.3 = Output
Reset Porta.0
Set Porta.1
Reset Porta.2
Reset Porta.3
Config Adc = Single , Prescaler = Auto
Start Adc
Y = Getadc(2)
Waitms 10
Return
End