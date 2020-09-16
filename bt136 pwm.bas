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
        Start Timer0
        Config Int1 = Rising
        Enable Int1
        On Int1 Int1rutin

Defports:
        'Config Portb.2 = Output : Blink_ Alias Portb.2
        Config Portc.5 = Output : Led1 Alias Portc.5
        Config Portc.4 = Output : Led2 Alias Portc.4
        Config Portd.3 = Input : Ziro Alias Pind.3
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
          Dim Direct As Byte
          Dim Endbit As Byte

          Const Tomaster = 242
          Const Toslave = 232




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
        Dim Light As Word : Light = Dark
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
        Dim Baseid As Eram Byte
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


       If Timer1 > Light Then Set Led1 Else Reset Led1





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
        Wic = Din(4)
        If Din(2) = Remote Or Din(2) = Pwmmodule Then Call Checkanswer
        I = 0
        Reset Inok
      End If


Return

Int1rutin:
          Stop Timer1

'(
          Incr Test

          If Test = 300 Then
             Test = 0
             Toggle Blink_
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
          Reset Led1
          Timer1 = 0
          Start Timer1

Return

End

Sub Tx
    If Direct = Tomaster Then
       Endbit = 220
    Elseif Direct = Toslave Then
           Endbit = 210
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
       If Timer1 > Light Then Set Led1 Else Reset Led1
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
                If Din(2) = Pwmmodule Then
                   Id = Din(4)
                   Call Getid
                End If
           Case 180
                Incr Steps
                If Steps > 4 Then Steps = 1
           Case 159
    End Select
    Select Case Steps
           Case 4
                Light = Maxlight
           Case 3
                Light = Midlight
           Case 2
                Light = Minlight
           Case 1
                Light = Dark
    End Select


End Sub