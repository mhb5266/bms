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

Dim Fresh As Word
Dim Buzen As Bit
Dim I As Byte
Dim B As Byte
Dim Freshen As Bit

Const Mint = 30                                             'ê5                   '30
Const Midt = 120                                            '10                '120
Const Maxt = 720                                            '20                     '720
Const Timefan = 900                                         ' 25       '900
Const Timelight = 300                                       '30                    '300
Const Vtmin = 3
Const Vtmax = 6
B = 15
Do
  If B = 0 Then Exit Do
Loop
Main:
   Do
     If Lsec <> _sec Then
          If In1 = 0 Then
             Fresh = 0
             Set Ind1
             Set Led1
             Set L1
             If T1 < Maxt Then Incr T1
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
             Set Led2
             Set L2
             If T2 < Maxt Then Incr T2
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
             Set Led3
             Set L3
             If T3 < Maxt Then Incr T3
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
          If In1 = 0 Or In2 = 0 Or In3 = 0 Or In4 = 0 Then Lf4 = Timefan
          If In1 = 0 Or In2 = 0 Or In3 = 0 Then Fant = Timefan       '1800

          Lsec = _sec
     End If

     If K1 = 0 Then
        Do
                Incr I
                If I > 16 Then I = 0
                Ind1 = I.0
                Ind2 = I.1
                Ind3 = I.2
                Ind4 = I.3
                Wait 1
        Loop Until K1 = 1
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

     If T1 = Maxt Or T2 = Maxt Or T3 = Maxt Then
        If _sec = 30 Then Set Buz Else Reset Buz
     End If


     If Fant > 0 Then
        Decr Fant
        Set Fan
     Else
         Reset Fan
     End If

     If T1 = Maxt Then
        Toggle Led1
        Toggle L1
     End If
     If T2 = Maxt Then
        Toggle Led2
        Toggle L2
     End If
     If T3 = Maxt Then
        Toggle Led3
        Toggle L3
     End If

     If T1 = Maxt Or T2 = Maxt Or T3 = Maxt Then
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
        If Lf1 = 0 Then Reset L1
     End If

     If Lf2 > 0 Then
        Set L2
        Decr Lf2
        If Lf2 = 0 Then Reset L2
     End If

     If Lf3 > 0 Then
        Set L3
        Decr Lf3
        If Lf3 = 0 Then Reset L3
     End If

     If Lf4 > 0 Then
        Set L4
        Decr Lf4
        If Lf4 = 0 Then Reset L4
     End If


     Timer1 = 57722

Return


