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
        Enable Timer0
        Start Timer0
        On Ovf0 T0rutin
        'Config Int1 = Rising
        'Enable Int1
        'On Int1 Int1rutin




Defports:
        Config Portb.2 = Output : buz Alias Portb.2

        Config Portd.3 = Input : Ziro Alias Pind.3



        Config Portc.5 = Output : out1 Alias Portc.5
        Config Portc.4 = Output : Out2 Alias Portc.4
        Config Portc.3 = Output : Out3 Alias Portc.3
        Config Portc.2 = Output : Out4 Alias Portc.2
        Config Portc.1 = Output : Out5 Alias Portc.1
        Config Portc.0 = Output : Out6 Alias Portc.0
        Config Portd.7 = Output : Out7 Alias Portd.7
        Config Portd.6 = Output : Out8 Alias Portd.6

        Config Portb.1 = Input : Key Alias Pinb.1

Maxconfig:
          Enable Urxc
          On Urxc Rx

          Rxtx Alias Portb.2 : Config Portb.2 = Output
          En Alias Portd.2 : Config Portd.2 = Output : Reset En
          Dim Din(5) As Byte
          Dim Maxin As Byte
          Dim Typ As Byte
          Dim Cmd As Byte
          Dim Id As Byte
          Dim Wantid As Boolean

          Const Maxlight = 0
          Const Dark = 65535
          Const Midlight = 8800
          Const Minlight = 11800
          Const Relaymodule = 110
          Const Pwmmodule = 111
          Const Remote = 104

          Dim Inok As Boolean
          Dim Wic As Byte

          Declare Sub Checkanswer
          Declare Sub Getid
          Declare Sub Keyorder


Defvals:
        dim test as word
        Dim Elight(8) As Eram Word
        Dim Light(8) As Word
        Dim Alllight As Eram Word
        'dim down as Word
        Dim Plus As Byte
        dim updown as Boolean
        Dim Secc As Word
        Dim Term As Byte
        Dim Pw As Word
        Dim Steps As Byte
        Dim Delay_ As Word
        Dim I As Byte


        const d = 0

        Dim Eoutid1(8) As Eram Byte
        Dim Eoutid2(8) As Eram Byte
        Dim Eoutid3(8) As Eram Byte

        Dim Outid1(8) As Byte
        Dim Outid2(8) As Byte
        Dim Outid3(8) As Byte

        For I = 1 To 8
            Outid1(i) = Eoutid1(i)
            Waitms 2
            Outid2(i) = Eoutid2(i)
            Waitms 2
            Outid3(i) = Eoutid3(i)
            Waitms 2
            Light(i) = Elight(i)
            Waitms 2
        Next
        Dim Gotid As Boolean
        'Dim Idgot As Boolean
        Dim K As Byte
        Dim J As Byte
        Dim X As Byte
        Dim Outs(8) As Byte
        Dim Status As Byte
        Const Refreshall = 1
        Const Stopall = 2



Start Timer0

Main:

     Do


       If Timer1 > Light(1) Then Set Out1 Else Reset Out1
       If Timer1 > Light(2) Then Set Out2 Else Reset Out2
       If Timer1 > Light(3) Then Set Out3 Else Reset Out3
       If Timer1 > Light(4) Then Set Out4 Else Reset Out4
       If Timer1 > Light(5) Then Set Out5 Else Reset Out5
       If Timer1 > Light(6) Then Set Out6 Else Reset Out6
       If Timer1 > Light(7) Then Set Out7 Else Reset Out7
       If Timer1 > Light(8) Then Set Out8 Else Reset Out8


       If Key = 1 Then
          Test = 0
          Do
            Waitms 100
            Incr Test
            Set Buz
            If Test > 30 Then
             For I = 1 To 8
                 Toggle Buz
                 Waitms 200
             Next
               Call Getid
            End If
          Loop Until Key = 0
          If Test < 10 Then
             For I = 1 To 4
                 Toggle Buz
                 Waitms 500
             Next
          End If
       End If


     Loop

Gosub Main


Rx:

      Incr I
      Inputbin Maxin


      If I = 5 Then
         If Maxin = 230 Or Maxin = 210 Then Set Inok
      End If
      If Maxin = 252 Or Maxin = 232 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Toggle Rxtx
        Id = Din(4)
        Typ = Din(2)
        If Typ = Remote Or Typ = Relaymodule Then Call Checkanswer
        I = 0
        Reset Inok
      End If


Return

T0rutin:

          Stop Timer1

'(
          Incr Test

          If Test = 300 Then
             Test = 0
             Toggle buz
             Incr I
             If I = 5 Then I = 1

                Select Case I
                       Case 1
                            Light = 0
                       Case 2
                            Light = 8800
                       Case 3
                            Light = 12000
                       Case 4
                            Light = 65535

                End Select
          End If
')


          Reset Out1
          Timer1 = 0
          Timer0 = 147
          Start Timer1

Return

Int1rutin:
          Stop Timer1

'(
          Incr Test

          If Test = 300 Then
             Test = 0
             Toggle buz
             Incr I
             If I = 5 Then I = 1

                Select Case I
                       Case 1
                            Light = 0
                       Case 2
                            Light = 8800
                       Case 3
                            Light = 12000
                       Case 4
                            Light = 65535

                End Select
          End If
')


          Reset Out1
          Timer1 = 0
          Start Timer1

Return

End



Sub Keyorder


End Sub

Sub Getid
    Reset En
    Set Buz
    Wait 3
    Reset Buz
    If Wantid = 1 Then
       'K = Idgot
       Do

         Do
         Loop Until Key = 1
         Portc = 0
         Portd = 0
         Waitms 30
         Test = 0
         Do
           Waitms 100
           Incr Test
           If Test > 30 Then
             Reset Wantid
             For I = 1 To 8
                 Toggle Buz
                 Waitms 200
             Next
              Return
           End If
         Loop Until Key = 0
         Incr K
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

       Loop
    Else
        Return
    End If

End Sub

Sub Checkanswer
    Cmd = Din(3)
    Select Case Cmd
           Case 151
                Set Wantid
                Set Buz
                Waitms 500
                Reset Buz

           Case 158
                    For I = 1 To 8
                        Eoutid1(i) = 0
                        Waitms 2
                        Eoutid2(i) = 0
                        Waitms 2
                        Eoutid3(i) = 0
                        Waitms 2
                        Light(i) = Dark
                        Waitms 2
                    Next
                                 For I = 1 To 8
                                     Toggle Buz
                                     Waitms 200
                                 Next
           Case 180
                If Wantid = 1 Then
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
                                 Waitms 2
                                 Eoutid2(i) = Outid2(i)
                                 Waitms 2
                                 Eoutid3(i) = Outid3(i)
                                 Waitms 250

                             Next
                          End If
                Else
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
                End If
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