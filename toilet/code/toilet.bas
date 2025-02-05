$regfile = "m8def.dat"
$crystal = 8000000


Configs:

Config Timer1 = Timer , Prescale = 1024
Enable Interrupts
Enable Timer1
Timer1 = 57722
On Timer1 T1rutin
Start Timer1
Config Portd = Output
Config Portc = Output
Config Portb = Output

Out1 Alias Portb.6
Out2 Alias Portb.7
Out3 Alias Portd.5
'Out4 Alias Portd.5

Led1 Alias Portb.3
Led2 Alias Portb.4
Led3 Alias Portc.0
Led4 Alias Portc.1

In1 Alias Pind.4 : Config Portd.4 = Input
In2 Alias Pind.3 : Config Portd.3 = Input
In3 Alias Pind.2 : Config Portd.2 = Input
In4 Alias Pind.1 : Config Portd.1 = Input

Ind1 Alias Portd.0
Ind2 Alias Portc.5
Ind3 Alias Portc.4
Ind4 Alias Portc.3



Fan Alias Portb.2
Buz Alias Portb.5

L1 Alias Portd.6
L2 Alias Portd.7
L3 Alias Portb.0
L4 Alias Portb.1

K1 Alias Pinc.2 : Config Portc.2 = Input
'K2 Alias Pinb.5

Pg Alias Portc.3

Defines:

Dim T1 As Word
Dim T2 As Word
Dim T3 As Word
Dim T4 As Word

Dim Tt1 As Word
Dim Tt2 As Word
Dim Tt3 As Word
Dim Tt4 As Word


Dim Lf1 As Word
Dim Lf2 As Word
Dim Lf3 As Word
Dim Lf4 As Word

Dim Fant As Word
Dim _sec As Byte
Dim Lsec As Byte
Dim Z As Byte

Dim Fresh As Word
Dim Buzen As Bit
Dim I As Byte
Dim B As Byte
Dim Freshen As Bit

Const Mint = 30
Const Midt = 120
Const Maxt = 720
Const Over = 1202
Const Timefan = 900
Const Timelight = 30
Const Vtmin = 5
Const Vtmax = 12
B = 10
Do
  If B = 0 Then Exit Do
Loop
Set Buz
Wait 1
Reset Buz
Main:
   Do
     If Lsec <> _sec Then
          If In1 = 0 Then
             Fresh = 0
             Set Ind1
             If T1 < Over Then Incr T1
             Lf1 = Timelight
          Else
             Reset Ind1
             Reset Led1
             Select Case T1

                    Case Mint To Midt
                         Tt1 = Vtmin
                    Case Is > Midt
                         Tt1 = Vtmax

             End Select
             T1 = 0
          End If

          If In2 = 0 Then
             Fresh = 0
             Set Ind2
             If T2 < Over Then Incr T2
             Lf2 = Timelight
          Else
             Reset Ind2
             Reset Led2
             Select Case T2
                    Case Mint To Midt
                         Tt2 = Vtmin
                    Case Is > Midt
                         Tt2 = Vtmax
             End Select
             T2 = 0
          End If

          If In3 = 0 Then
             Fresh = 0
             Set Ind3

             If T3 < Over Then Incr T3
             Lf3 = Timelight
          Else
             Reset Ind3
             Reset Led3
             Select Case T3
                    Case Mint To Midt
                         Tt3 = Vtmin
                    Case Is > Midt
                         Tt3 = Vtmax
             End Select
             T3 = 0
          End If

          If In4 = 0 Then Set Ind4 Else Reset Ind4
          If In1 = 0 And In2 = 0 And In3 = 0 Then Set Led4 Else Reset Led4
          'If In1 = 0 Or In2 = 0 Or In3 = 0 Or In4 = 0 Then Lf4 = Timefan


          If In1 = 0 And T1 < Maxt Then Lf4 = Timefan       '1800
          If In2 = 0 And T2 < Maxt Then Lf4 = Timefan
          If In3 = 0 And T3 < Maxt Then Lf4 = Timefan
          If In4 = 0 Then Lf4 = Timefan

          If In1 = 0 And T1 < Maxt Then Fant = Timefan      '1800
          If In2 = 0 And T2 < Maxt Then Fant = Timefan
          If In3 = 0 And T3 < Maxt Then Fant = Timefan

          Lsec = _sec
     End If

     If K1 = 0 Then
        Set Buz
        Waitms 100


        Z = 0
        If K1 = 0 Then
                Fant = 0
                Lf4 = 0
                Lf1 = 0 : Lf2 = 0 : Lf3 = 0
                Reset Led1 : Reset Led2 : Reset Led3
                Reset Out1 : Reset Out2 : Reset Out3
                Do
                Loop Until K1 = 1
                Waitms 200
                Reset Buz
                Do
                  If Lsec <> _sec Then
                     Lsec = _sec
                     Incr Z
                     Select Case Z
                            Case 1
                                 Lf4 = 120
                            Case 5
                                 Fant = 110
                            Case 10
                                 Lf1 = 30
                                 Set Led1
                            Case 15
                                 Tt1 = Vtmin
                            Case 25
                                 Tt1 = Vtmax
                            Case 40
                                 Reset Led1
                            Case 45
                                 Lf2 = 30
                                 Set Led2
                            Case 50
                                 Tt2 = Vtmin
                            Case 60
                                 Tt2 = Vtmax
                            Case 75
                                 Reset Led2
                            Case 80
                                 Lf3 = 30
                                 Set Led3
                            Case 85
                                 Tt3 = Vtmin
                            Case 95
                                 Tt3 = Vtmax
                            Case 110
                                 Reset Led3
                            Case 129
                                 Set Buz
                                 Set L4
                                 Set Led4
                            Case 132
                                 Reset Buz
                                 Reset L4
                                 Reset Led4
                                 Exit Do
                     End Select
                  End If
                     If K1 = 0 Then
                        Waitms 50
                        If K1 = 0 Then
                                   Fant = 0
                                   Lf4 = 0
                                   Lf1 = 0 : Lf2 = 0 : Lf3 = 0
                                   Reset Led1 : Reset Led2 : Reset Led3
                                   Reset Out1 : Reset Out2 : Reset Out3
                                   Exit Do
                        End If
                     End If
                Loop
                Do
                Loop Until K1 = 1
                Wait 1
        End If
     End If





   Loop




End

T1rutin:
     'Toggle Pg
     Incr _sec



     If _sec = 60 Then
        _sec = 0
        Incr Fresh
     End If

     If B > 0 Then Decr B

     If T1 > Maxt Or T2 > Maxt Or T3 > Maxt Then
        If _sec = 30 Then Set Buz Else Reset Buz
     End If


     If Fant > 0 Then
        Decr Fant
        Set Fan
     Else
         Reset Fan
     End If

     If T1 > 0 And T1 < Maxt Then
        Set Led1
        Set L1
     Elseif T1 > 0 And T1 = Maxt Then
        Reset L1
     Elseif T1 > 0 And T1 > Maxt Then
        Toggle Led1
        Set L1
     End If

     If T2 > 0 And T2 < Maxt Then
        Set Led2
        Set L2
     Elseif T2 > 0 And T2 = Maxt Then
        Reset L2
     Elseif T2 > 0 And T2 > Maxt Then
        Toggle Led2
        Set L2
     End If

     If T3 > 0 And T3 < Maxt Then
        Set Led3
        Set L3
     Elseif T3 > 0 And T3 = Maxt Then
        Reset L3
     Elseif T3 > 0 And T3 > Maxt Then
        Toggle Led3
        Set L3
     End If


     If T1 > Maxt Or T2 > Maxt Or T3 > Maxt Then
        Toggle Led4
     End If
     If Tt1 > 0 Then
        Decr Tt1
        Set Out1
        If Tt1 = 0 Then
           Reset Out1
        End If
     End If

     If Tt2 > 0 Then
        Decr Tt2
        Set Out2
        If Tt2 = 0 Then
           Reset Out2
        End If
     End If

     If Tt3 > 0 Then
        Decr Tt3
        Set Out3
        If Tt3 = 0 Then
           Reset Out3
        End If
     End If

     If Lf1 > 0 Then
        Set L1
        Decr Lf1

     End If
     If Lf1 = 0 Then Reset L1
     If Lf2 > 0 Then
        Set L2
        Decr Lf2

     End If
     If Lf2 = 0 Then Reset L2
     If Lf3 > 0 Then
        Set L3
        Decr Lf3

     End If
     If Lf3 = 0 Then Reset L3
     If Lf4 > 0 Then
        Set L4
        Decr Lf4

     End If
     If Lf4 = 0 Then Reset L4

     Timer1 = 57722

Return
