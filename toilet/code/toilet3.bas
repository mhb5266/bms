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

Dim T(4) As Word

Dim Tt(4) As Word

Dim Lf(4) As Word

Dim Fant As Word
Dim _sec As Byte
Dim Lsec As Byte
Dim Z As Byte

Dim Fresh As Word
Dim Buzen As Bit
Dim I As Byte
Dim B As Byte
Dim Freshen As Bit
Dim D As Byte
Dim L As Byte
Dim V As Byte
Dim Ledb As Byte
Const Mint = 5                                              '30
Const Midt = 10                                             '120
Const Maxt = 20                                             '720
Const Over = 40                                             '1202
Const Timefan = 20                                          '900
Const Timel4 = 15
Const Timelight = 10                                        '30
Const Vtmin = 3                                             '5
Const Vtmax = 6

'(                                             '12
B = 10
Do
  If B = 0 Then Exit Do
Loop
Set Buz
Wait 1
Reset Buz

')


Main:
   Do

     If In1 = 0 Then
        Waitms 25
        If D.1 = 0 Then Decr Lsec
        If In1 = 0 Then
           Set D.1
           Set Ind1
        End If
     Else
         Reset D.1
         Reset Ind1
     End If

     If In2 = 0 Then
        Waitms 25
        If D.2 = 0 Then Decr Lsec
        If In2 = 0 Then
           Set D.2
           Set Ind2
        End If
     Else
         Reset D.2
         Reset Ind2
     End If

     If In3 = 0 Then
        Waitms 25
        If D.3 = 0 Then Decr Lsec
        If In3 = 0 Then
           Set D.3
           Set Ind3
        End If
     Else
         Reset D.3
         Reset Ind3
     End If

     If In4 = 0 Then
        Waitms 25
        If D.4 = 0 Then Decr Lsec
        If In4 = 0 Then
           Set D.4
           Set Ind4
           Lf(4) = Timel4
        End If
     Else
         Reset D.4
         Reset Ind4
     End If

     If Lsec <> _sec Then
                For I = 1 To 3
                    If D.i = 1 Then
                       Lf(4) = Timefan
                       If T(i) < Over Then Incr T(i)
                            Select Case T(i)
                                   Case 0
                                        Set Ledb.i
                                        Lf(i) = Timelight
                                        Lf(4) = Timel4
                                        Fant = Timefan
                                   Case 1 To Maxt
                                        Lf(4) = Timel4
                                        Fant = Timefan
                                        Set Ledb.i
                                        Lf(i) = Timelight
                                        Incr T(i)

                                   Case Over
                                        Toggle Ledb.i

                            End Select
                    End If
                    If D.i = 0 Then
                       Reset Ledb.i
                       Select Case T(i)
                              Case 0 To Mint

                              Case Mint To Midt
                                   Tt(i) = Vtmin

                              Case Midt To Maxt
                                   Tt(i) = Vtmax

                              Case Is >= Maxt

                              Case Over

                       End Select
                       T(i) = 0
                    End If
                Next
        Lsec = _sec
     End If



     
     If Fant > 0 Then Set Fan Else Reset Fan

     If Lf(4) > 0 Then Set L4 Else Reset L4

     For I = 1 To 3
         If Tt(i) > 0 Then Set V.i Else Reset V.i
         If Lf(i) > 0 Then Set L.i Else Reset L.i
     Next

     If Ledb.1 = 1 Then Set Led1 Else Reset Led1
     If Ledb.2 = 1 Then Set Led2 Else Reset Led2
     If Ledb.3 = 1 Then Set Led3 Else Reset Led3

     If V.1 = 1 Then Set Out1 Else Reset Out1
     If V.2 = 1 Then Set Out2 Else Reset Out2
     If V.3 = 1 Then Set Out3 Else Reset Out3

     If L.1 = 1 Then Set L1 Else Reset L1
     If L.2 = 1 Then Set L2 Else Reset L2
     If L.3 = 1 Then Set L3 Else Reset L3

     If K1 = 0 Then
        Set Buz
        Waitms 100


        Z = 0
        If K1 = 0 Then
                Fant = 0
                Lf(4) = 0
                Lf(1) = 0 : Lf(2) = 0 : Lf(3) = 0
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
                                 Lf(4) = 120
                            Case 5
                                 Fant = 110
                            Case 10
                                 Lf(1) = 30
                                 Set Led1
                            Case 15
                                 Tt(1) = Vtmin
                            Case 25
                                 Tt(1) = Vtmax
                            Case 40
                                 Reset Led1
                            Case 45
                                 Lf(2) = 30
                                 Set Led2
                            Case 50
                                 Tt(2) = Vtmin
                            Case 60
                                 Tt(2) = Vtmax
                            Case 75
                                 Reset Led2
                            Case 80
                                 Lf(3) = 30
                                 Set Led3
                            Case 85
                                 Tt(3) = Vtmin
                            Case 95
                                 Tt(3) = Vtmax
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
                                   Lf(4) = 0
                                   Lf(1) = 0 : Lf(2) = 0 : Lf(3) = 0
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

     For I = 1 To 3
         If Tt(i) > 0 Then
            Decr Tt(i)
         End If
         If Lf(i) > 0 Then
            Decr Lf(i)
         End If
         If Tt(i) > 0 Then Set V.i Else Reset V.i
         If Lf(i) > 0 Then Set L.i Else Reset L.i
     Next

     If Fant > 0 Then Decr Fant
     If Fant > 0 Then Set Fan Else Reset Fan

     If Lf(4) > 0 Then Decr Lf(4)
     If Lf(4) > 0 Then Set L4 Else Reset L4

     If V.1 = 1 Then Set Out1 Else Reset Out1
     If V.2 = 1 Then Set Out2 Else Reset Out2
     If V.3 = 1 Then Set Out3 Else Reset Out3
     If L.1 = 1 Then Set L1 Else Reset L1
     If L.2 = 1 Then Set L2 Else Reset L2
     If L.3 = 1 Then Set L3 Else Reset L3

     Timer1 = 57722

Return