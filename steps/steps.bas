$regfile = "m8def.dat"
$crystal = 11059200

Configs:
Config Portd = Output
Config Portc = Output
Config Portb = Output
Config Portd.0 = Input
Config Portd.1 = Input
Config Portd.2 = Input

Enable Interrupts
Enable Timer1
On Timer1 T1rutin
Config Timer1 = Timer , Prescale = 1024
Config Rnd = 16
Defines:

Declare Sub Refresh
Declare Sub R2on
Declare Sub R2off
Declare Sub L2on
Declare Sub L2off



Dim Index As Byte
Dim Id As Byte
Dim I As Byte
Dim D As Byte
Dim W As Word
Dim _delay As Word
Dim Timeout As Word : Timer1 = 64755
Dim Etimeout As Eram Word
Timeout = Etimeout
Waitms 25
If Timeout > 20 Then Timeout = 1
Etimeout = Timeout
Dim Of As Bit
Dim A1t As Byte
Dim A2t As Byte
Dim Timeoff As Byte
Dim Tf As Word
Dim Etimeoff As Eram Byte
Timeoff = Etimeoff
Waitms 50
If Timeoff > 15 Then Timeoff = 1
Etimeoff = Timeoff
Waitms 50
Tf = Timeoff * 30
Dim Finish As Bit

K1 Alias Pind.3
K2 Alias Pind.4

Alarm1 Alias Portb.6
Alarm2 Alias Portb.7

In1 Alias Pind.0
In2 Alias Pind.1

Alarmin Alias Pind.2

Main:



     Do


       If In1 = 0 And A2t = 0 And Alarmin = 1 And Finish = 0 Then
          Waitms 50
          If In1 = 0 Then
                    R2on
                    Do
                    Loop Until In1 = 1
                    Tf = Timeoff * 30
                    Do
                    Loop Until Tf = 0
                    R2off
          End If
       End If

       If In2 = 0 And A2t = 0 And Alarmin = 1 And Finish = 0 Then
          Waitms 50
          If In2 = 0 Then
                    L2on
                    Do
                    Loop Until In2 = 1
                    Tf = Timeoff * 30
                    Do
                    Loop Until Tf = 0
                    L2off
          End If

       End If

       If Finish = 1 Then
          R2off
          Reset Finish
       End If

       If K1 = 1 Then
          W = 1
          Timeout = 0
          Do
            If K1 = 1 Then

                        Incr Timeout
                        W = 2 ^ Timeout
                        Waitms 350
                        If Timeout > 15 Then
                           Timeout = 0
                           W = 1
                        End If
                        Refresh
            End If
            If K1 = 0 Then Exit Do
          Loop
          'W = 0
          'Refresh
           Etimeout = Timeout
           Waitms 50
         ' W = Timeout
          'Refresh
         ' Wait 2
          W = 0
          Refresh
          R2on
          R2off

       End If


       If K2 = 1 Then
          Timeoff = 0
          W = 2 ^ Timeoff
          Refresh
          Do
            If K2 = 1 Then
               Incr Timeoff
               If Timeoff > 15 Then Timeoff = 0
               W = 2 ^ Timeoff
               Refresh
            End If
            Waitms 300
            If K2 = 0 Then Exit Do
          Loop
          Etimeoff = Timeoff
          'W = 0
          'Refresh
          'W = Timeoff
         ' Refresh
          'Wait 2
          W = 0
          Refresh
       End If

        If Alarmin = 0 Then
           Waitms 50
           If Alarmin = 0 Then
                If In1 = 0 Or In2 = 0 Then
                   Set Alarm1
                   Set Alarm2
                   A1t = 20
                   A2t = 100
                End If
           End If
        End If
        If A2t > 0 Then
           Toggle W
           Refresh
           Reset Of
           Do
           Loop Until Of = 1
        End If
     Loop


End

Sub R2on
       For I = 1 To 15
              If W = 0 Then W = 1
              Shift W , Left
              Incr W
              Refresh
              Reset Of
              _delay = 0
              Do
              Loop Until Of = 1
       Next
End Sub

Sub R2off
       For I = 1 To 16
              Shift W , Left
              Reset Of
              _delay = 0
              Do
              Loop Until Of = 1
              Refresh
       Next
End Sub

Sub L2on
       W = 32768
       For I = 1 To 15
              Shift W , Right
              W = W + 32768
              Reset Of
              _delay = 0
              Do
              Loop Until Of = 1
              Refresh
       Next
End Sub

Sub L2off
       For I = 1 To 15
              Shift W , Right
              Reset Of
              _delay = 0
              Do
              Loop Until Of = 1
              Refresh
       Next
End Sub

Sub Refresh
    If W.1 = 1 Then Set Portd.5 Else Reset Portd.5
    If W.2 = 1 Then Set Portd.6 Else Reset Portd.6
    If W.3 = 1 Then Set Portd.7 Else Reset Portd.7
    If W.4 = 1 Then Set Portb.0 Else Reset Portb.0
    If W.5 = 1 Then Set Portb.1 Else Reset Portb.1
    If W.6 = 1 Then Set Portb.2 Else Reset Portb.2
    If W.7 = 1 Then Set Portb.3 Else Reset Portb.3
    If W.8 = 1 Then Set Portb.4 Else Reset Portb.4
    If W.9 = 1 Then Set Portb.5 Else Reset Portb.5
    If W.10 = 1 Then Set Portc.0 Else Reset Portc.0
    If W.11 = 1 Then Set Portc.1 Else Reset Portc.1
    If W.12 = 1 Then Set Portc.2 Else Reset Portc.2
    If W.13 = 1 Then Set Portc.3 Else Reset Portc.3
    If W.14 = 1 Then Set Portc.4 Else Reset Portc.4
    If W.15 = 1 Then Set Portc.5 Else Reset Portc.5
End Sub

T1rutin:
        'Toggle Portd.5
        Timer1 = 64755
        'Toggle Alarm2
        If Tf > 0 Then Decr Tf
        If Of = 0 Then
           Incr _delay
        End If

        D = _delay Mod Timeout
        If D = 0 Then
           _delay = 0
           Set Of
        End If
        If A1t > 0 Then
           Decr A1t
           Set Alarm1
           If A1t = 0 Then Reset Alarm1
        End If

        If A2t > 0 Then
           Decr A2t
           Set Alarm2
           If A2t = 0 Then
            Reset Alarm2
            Set Finish
           End If
        End If
        '(
        Reset Alarm1
        If Alarmin = 0 Then
           Set Alarm1
        End If
        ')
Return

'(
Sdata:
Data "portd.5" , "portd.6" , "portd.7" , "portb.0" , "portb.1" , "portb.2" , "portb.3" , "portb.4" , "portb.5" , "portc.0" , "portc.1" , "portc.2" , "portc.3" , "portc.4" , "portc.5"

')