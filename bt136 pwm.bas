$regfile = "m8def.dat"
$crystal = 11059200
$baud = 115200

Configs:
        'Config Timer1 = Pwm , Pwm = 10 , Compare_A_Pwm = Clear_Up , Compare_B_Pwm = Clear_Down , Prescale = 1
        Config Timer1 = Timer , Prescale = 8
        Config Timer0 = Timer , Prescale = 1024
        Enable Interrupts
        'Enable Timer1
        'On Timer1 T1rutin
        Start Timer1

        'Start Timer0
        'Enable Ovf0
        'On Timer0 T0rutin

        Config Int1 = Rising
        Enable Int1
        On Int1 Int1rutin



Defports:
        'Config Portb.2 = Output : Blink_ Alias Portb.2
        Config Portc.5 = Output : out1 Alias Portc.5
        Config Portc.4 = Output : out2 Alias Portc.4
        Config Portc.3 = Output : Out3 Alias Portc.3
        Config Portc.2 = Output : Out4 Alias Portc.2
        Config Portc.1 = Output : Out5 Alias Portc.1
        Config Portc.0 = Output : Out6 Alias Portc.0
        Config Portd.6 = Output : out7 Alias Portd.6
        Config Portd.7 = Output : out8 Alias Portd.7

        Config Portd.3 = Input : Ziro Alias Pind.3
        Config Portb.5 = Input : Key Alias Pinb.5

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
          Dim Direct As Byte
          Dim Endbit As Byte
          Dim Wantnum As Boolean
          Dim Baseid As Byte
          Dim Eoutnum(8) As Eram Byte
          Dim Default_light As Word
          Dim Tempon As Boolean
          Dim Timee(8) As Word
          Dim X As Byte


          Const Tomaster = 252
          Const Toinput = 242


          Const Timeout = 6000

          Const Maxlight = 0
          Const Dark = 65535
          Const Midlight = 8800
          Const Minlight = 11800

          Const Remote = 104
          Const Pwmmodule = 111
          Const Mytyp = 111

          Dim Inok As Boolean
          Dim Wic As Byte

Defvals:
        dim test as word
        Dim Light(8) As Word
        'dim down as Word
        Dim Plus As Byte
        dim updown as Boolean
        Dim Secc As Word
        Dim Term As Byte
        Dim Pw As Word
        Dim Steps As Byte
        Dim Delay_ As Word
        Dim Usdelay As Dword
        Dim I As Byte

        Dim Idwasgot As Boolean
       ' Dim Baseid As Eram Byte
        Dim Minid As Byte
        Dim Maxid As Byte
        Dim Counterid As Byte : Counterid = 8



        const d = 0

Subs:

          Declare Sub Checkanswer
          Declare Sub Getid
          Declare Sub Tx
          Declare Sub Refreshout

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
          If Wantnum = 1 Then
             Reset wantnum
             Baseid = Id
             For I = 1 To Counterid
                 Baseid = Baseid + 1
                 Eoutnum(i) = Baseid
             Next
             Id = Eoutnum(counterid)
             Direct = Tomaster
             Portc = Id
             Typ = Pwmmodule
             Cmd = 165
             Call Tx
             Wait 1
             Portc = 0
           End If
        End If

     Loop

Gosub Main


Rx:

      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 210 Then Set Inok
      If Maxin = 232 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Toggle Rxtx
        Wic = Din(4)
        If Din(2) = Remote Or Din(2) = Pwmmodule Then Call Checkanswer
        I = 0
        Reset Inok
      End If


Return

T0rutin:
        Portc = 0
        Portb = 0
        Stop Timer0
        Timer0 = 147

        If Tempon = 1 Then

           For X = 1 To 8
               If Light(x) < Dark Then Incr Timee(x)
               If Timee(x) = Timeout Then Light(x) = Dark
           Next X

        End If

        For X = 1 To 8
            Light(x) = Default_light
        Next X
Return

Int1rutin:
          Stop Timer1


          Reset out1
          Reset Out2
          Reset Out3
          Reset Out4
          Reset Out5
          Reset Out6
          Reset Out7
          Reset Out8

          Timer1 = 0
          Start Timer1
        For X = 1 To 8
            Light(x) = Default_light
        Next X

Return

End

Sub Tx
    If Direct = Tomaster Then
       Endbit = 230
    Elseif Direct = Toinput Then
           Endbit = 220
    End If

    Set En
    Waitms 10
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En
End Sub

Sub Getid

    Do
        If Key = 1 Then
           Set Idwasgot
           Baseid = Id
           Minid = Baseid + 1
           Maxid = Counterid + Baseid
           Typ = Mytyp : Cmd = 165 : Id = Maxid

           Direct = Tomaster
           Call Tx
           Call Refreshout
        End If
    Loop Until Idwasgot = 1
    Reset Idwasgot

End Sub

Sub Refreshout
    Light = Dark
    Do
       If Timer1 > Light Then Set Out1 Else Reset Out1
       Waitus 1
       Incr Usdelay
       If Usdelay > 1000000 Then
          Incr Steps
          Select Case Steps
                 Case 1
                      Light = Dark
                 Case 2
                      Light = Minlight
                 Case 3
                      Light = Midlight
                 Case 4
                      Light = Maxlight
                 Case 5
                      Light = Dark
                      Steps = 0
                      Exit Do
          End Select
       End If
    Loop

End Sub

Sub Checkanswer
    Cmd = Din(3)
    Select Case Cmd
           Case 160
                'If Din(2) = Pwmmodule Then
                   'Id = Din(4)
                  ' Call Getid
                'End If
           Case 161
                Default_light = Dark

           Case 162
                Default_light = Minlight

           Case 163
                Default_light = Midlight

           Case 164
                Default_light = Maxlight

           Case 180
                Incr Steps
                If Steps > 4 Then Steps = 1
           Case 159
    End Select
    Select Case Steps
           Case 4
                Default_light = Maxlight
           Case 3
                Default_light = Midlight
           Case 2
                Default_light = Minlight
           Case 1
                Default_light = Dark
    End Select


End Sub