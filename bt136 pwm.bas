$regfile = "m8def.dat"
$crystal = 11059200
$baud = 115200

Configs:
        'Config Timer1 = Pwm , Pwm = 10 , Compare_A_Pwm = Clear_Up , Compare_B_Pwm = Clear_Down , Prescale = 1
        Config Timer1 = Timer , Prescale = 8
        Config Timer0 = Timer , Prescale = 1024
        Enable Interrupts
        'Enable Timer1
        'on Timer1 T1rutin
        'Start Timer1
        'Enable Ovf0
       ' On Ovf0 T0rutin
        Config Int1 = Rising
        Enable Int1
        On Int1 Int1rutin


Configntc:
'(
Config Adc = Free , Prescaler = Auto

Dim Ad30 As Word
Dim Temp As Single

Dim Vo As Single
Dim Rt As Single
Dim Adcin As Word

111111111111111111111111111Dim W As Single
Dim Y As Single
Dim Z As Single
Dim Lnrt As Single
Dim Alloff As Boolean



Const A = 1.009249522 * 10 ^ -3
Const B = 2.378405444 * 10 ^ -4
Const C = 2.019202697 * 10 ^ -7
')
Defports:
        Config Portd.7 = Output : Buz Alias Portd.7

        Config Portd.3 = Input : Ziro Alias Pind.3

        Fan Alias Portd.5 : Config Portd.5 = Output


        Config Portc.3 = Output : Out1 Alias Portc.3
        Config Portc.4 = Output : Out2 Alias Portc.4
        Config Portc.5 = Output : Out3 Alias Portc.5
        Config Portd.4 = Output : Out4 Alias Portd.4
        Config Portc.2 = Output : Out5 Alias Portc.2
        Config Portc.1 = Output : Out6 Alias Portc.1
        Config Portc.0 = Output : Out7 Alias Portc.0
        Config Portb.2 = Output : Out8 Alias Portb.2

        Config Portd.6 = Input : Key Alias Pind.6

Maxconfig:
          Enable Urxc
          On Urxc Rx

          Rxtx Alias Portb.0 : Config Portb.0 = Output
          En Alias Portd.2 : Config Portd.2 = Output : Reset En
          Dim Din(5) As Byte
          Dim Maxin As Byte
          Dim Typ As Byte
          Dim Cmd As Byte
          Dim Id As Byte
          Dim Wantid As Boolean

          Const Maxlight = 0
          Const Dark = 65535
          Const Midlight = 6500
          Const Minlight = 9500
          Const Relaymodule = 110
          Const Triacmodule = 111
          Const Remote = 104
          Const Keyin = 101

          Dim Q As Byte
          Dim T0back As Boolean
          Dim Inok As Boolean
          Dim Wic As Byte
          Dim F As Byte
          Dim Heat As Byte
          Dim P As Word

          Declare Sub Checkanswer
          Declare Sub Getid
          Declare Sub Keyorder
          Declare Sub Pfrutin
         ' Declare Sub Ntc


Defvals:
        Dim Test As Word
        Dim Elight(8) As Eram Word
        Dim Light(8) As Word
        Dim Alllight As Eram Word
        'dim down as Word
        Dim Plus As Byte
        Dim Updown As Boolean
        Dim Secc As Word
        Dim Term As Byte
        Dim Pw As Word
        Dim Steps As Byte
        Dim Delay_ As Word
        Dim I As Byte


        Const D = 0

        Dim Eoutid1(8) As Eram Byte
        Dim Eoutid2(8) As Eram Byte
        Dim Eoutid3(8) As Eram Byte

        Dim Poweroff As Byte

        Dim Outid1(8) As Byte
        Dim Outid2(8) As Byte
        Dim Outid3(8) As Byte

        Dim Rxtxoff As Byte

        Dim Gotid As Boolean
        'Dim Idgot As Boolean
        Dim K As Byte
        Dim J As Byte
        Dim X As Byte
        Dim Outs(8) As Byte
        Dim Status As Byte
        Const Refreshall = 1
        Const Stopall = 2


        For I = 1 To 8
            Outid1(i) = Eoutid1(i)
            Waitms 4
            Outid2(i) = Eoutid2(i)
            Waitms 4
            Outid3(i) = Eoutid3(i)
            Waitms 4
            Light(i) = Elight(i)
            Waitms 4
        Next






Main:
     Do
       '(
       If Alloff = 1 Then
          For I = 1 To 8
              Light(i) = Dark
          Next
       End If
')
       If Timer1 > Light(1) Then Set Out1 Else Reset Out1
       If Timer1 > Light(2) Then Set Out2 Else Reset Out2
       If Timer1 > Light(3) Then Set Out3 Else Reset Out3
       If Timer1 > Light(4) Then Set Out4 Else Reset Out4
       If Timer1 > Light(5) Then Set Out5 Else Reset Out5
       If Timer1 > Light(6) Then Set Out6 Else Reset Out6
       If Timer1 > Light(7) Then Set Out7 Else Reset Out7
       If Timer1 > Light(8) Then Set Out8 Else Reset Out8
       Heat = 0
       For I = 1 To 8
           If Light(i) < Dark Then
              Incr Heat
           End If
       Next
       If Heat > 2 Then Set Fan Else Reset Fan
'(
       If Timer1 > 13900 Then
          Timer1 = 0
          Incr Poweroff
          If Poweroff > 100 Then Call Pfrutin
          Start Timer1
       End If
')
       If Key = 0 Then
          Waitms 50
          If Key = 0 Then
             Disable Int1
             Stop Timer0
             For I = 1 To 8
                 Toggle Rxtx
                 Waitms 200
             Next I
             Call Getid
             Enable Int1
             Start Timer0
          End If
          Do
          Loop Until Key = 1
       End If


     Loop

Gosub Main





T0rutin:


Return

Int1rutin:


          Incr Q
          Poweroff = 0
          If Q = 100 Then
             Q = 0
             Toggle Buz

          End If
'(
          If Rxtx = 1 Then
             Incr Rxtxoff
             If Rxtxoff = 20 Then
                Reset Rxtx
                Rxtxoff = 0
             End If
          End If

')
          Reset Out1
          Reset Out2
          Reset Out3
          Reset Out4
          Reset Out5
          Reset Out6
          Reset Out7
          Reset Out8

          Timer1 = 0

Return


Rx:



      Incr F
      Inputbin Maxin



      If F = 5 Then
         If Maxin = 230 Or Maxin = 210 Then Set Inok
      End If
      If Maxin = 252 Or Maxin = 232 Then F = 1

      Din(f) = Maxin

      If Inok = 1 Then

        Id = Din(4)
        Typ = Din(2)
        If Typ = Remote Or Typ = Keyin Or Typ = Relaymodule Then Call Checkanswer
        F = 0
        Reset Inok
      End If




Return


End


Sub Pfrutin
    Do
      Reset Out1
      Reset Out2
      Reset Out3
      Reset Out4
      Reset Out5
      Reset Out6
      Reset Out7
      Reset Out8

    Loop
End Sub

Sub Getid
    K = 0
    Reset En
    Set Rxtx
    Wait 3
    Reset Rxtx
    Set Wantid
       Do
          Incr P
          Waitus 10
          If P = 10000 Then
             P = 0
             Toggle Buz
          End If
         If Cmd = 180 And Id > 0 And Id < 100 Then
                          Reset Gotid
                          If Outid1(k) > 100 Or Outid1(k) = 0 Then
                             Outid1(k) = Id
                             Set Gotid
                          Else
                              If Outid2(k) > 100 Or Outid2(k) = 0 Then
                                 If Outid1(k) <> Id Then
                                    Outid2(k) = Id
                                    Set Gotid
                                 End If
                              Else
                                  If Outid3(k) > 100 Or Outid3(k) = 0 Then
                                     If Outid1(k) <> Id And Outid2(k) <> Id Then
                                        Outid3(k) = Id
                                        Set Gotid
                                     End If
                                  End If
                              End If
                          End If
                          If Gotid = 1 Then
                             For I = 1 To 8
                                 Select Case K
                                         Case 1
                                              Toggle Out1
                                         Case 2
                                              Toggle Out2
                                         Case 3
                                              Toggle Out3
                                         Case 4
                                              Toggle Out4
                                         Case 5
                                              Toggle Out5
                                         Case 6
                                              Toggle Out6
                                         Case 7
                                              Toggle Out7
                                         Case 8
                                              Toggle Out8
                                 End Select
                                 Eoutid1(i) = Outid1(i)
                                 Waitms 4
                                 Eoutid2(i) = Outid2(i)
                                 Waitms 4
                                 Eoutid3(i) = Outid3(i)
                                 Waitms 250

                             Next
                          End If
                          Cmd = 0
                          Id = 0
         End If
         If Key = 0 Then
            Waitms 50
            If Key = 0 Then
               Reset Wantid
               Enable Int1
               Exit Do
            End If
         End If
       Loop

       For I = 1 To 8
          Toggle Rxtx
          Waitms 200
       Next

       Reset Wantid

End Sub

Sub Checkanswer
    Toggle Rxtx
    Cmd = Din(3)
    Select Case Cmd
           Case 151
                If Wantid = 1 Then
                                Incr K
                                Reset Out1
                                Reset Out2
                                Reset Out3
                                Reset Out4
                                Reset Out5
                                Reset Out6
                                Reset Out7
                                Reset Out8
                                If K > 8 Then K = 1
                                Select Case K
                                       Case 1
                                            Set Out1
                                       Case 2
                                            Set Out2
                                       Case 3
                                            Set Out3
                                       Case 4
                                            Set Out4
                                       Case 5
                                            Set Out5
                                       Case 6
                                            Set Out6
                                       Case 7
                                            Set Out7
                                       Case 8
                                            Set Out8
                                End Select
                End If

           Case 158
                    For I = 1 To 8
                        Eoutid1(i) = 0
                        Waitms 2
                        Eoutid2(i) = 0
                        Waitms 2
                        Eoutid3(i) = 0
                        Waitms 2
                        Light(i) = Dark
                        Waitms 200
                        Toggle Buz
                        Outid1(i) = 0
                        Outid2(i) = 0
                        Outid3(i) = 0
                    Next

           Case 180
                    For I = 1 To 8
                        If Id = 0 Or Id > 100 Then Return
                        If Outid1(i) = Id Or Outid2(i) = Id Or Outid3(i) = Id Then
                           If Light(i) = Dark Then
                              Light(i) = Minlight
                           Elseif Light(i) = Minlight Then
                              Light(i) = Midlight
                           Elseif Light(i) = Midlight Then
                              Light(i) = Maxlight
                           Elseif Light(i) = Maxlight Then
                              Light(i) = Dark
                           End If
                        End If

                    Next

           Case 181
                    For I = 1 To 8
                        If Id = 0 Or Id > 100 Then Return
                        If Outid1(i) = Id Or Outid2(i) = Id Or Outid3(i) = Id Then
                           Light(i) = Dark
                        End If
                    Next
           Case 182
                    For I = 1 To 8
                        If Id = 0 Or Id > 100 Then Return
                        If Outid1(i) = Id Or Outid2(i) = Id Or Outid3(i) = Id Then
                           Light(i) = Maxlight
                        End If
                    Next


           Case 161
                Alllight = Minlight
           Case 162
                Alllight = Midlight
           Case 163
                Alllight = Maxlight
           Case 164
                Alllight = Dark
    End Select

End Sub