$regfile = "m8def.dat"
$crystal = 11059200





Configs:

$baud = 115200

Enable Interrupts
Enable Urxc
On Urxc Rx

'Enable Utxc
'On Utxc Issend


Config Portc = Output
'Em Alias Portc.3 : Config Portc.3 = Output
Em Alias Portd.2 : Config Portd.2 = Output
Rt Alias Portb.0 : Config Portb.0 = Output

Learn Alias Pinb.2 : Config Pinb.2 = Input

Declare Sub Inrefresh
Declare Sub Checkanswer
Declare Sub Setid
Declare Sub Setout
Declare Sub Tx
Declare Sub Order
Declare Sub Learnrutin
Declare Sub Sendqc

Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte
Dim I As Byte
Dim J As Long
Dim Maxin As Byte
Dim A As Byte
Dim Reply As Byte
Dim Keyids As Byte : Dim Ekeyids As Eram Byte

Dim Findorder As Byte

Dim Din(5) As Byte


Dim Timeout As Boolean
Dim Sendok As Boolean
Dim Inok As Boolean
Dim Light As Byte
Dim Learnok As Boolean


Const D = 10
Const Allid = 99

Const Readallinput = 1
Const Read1input = 2
Const Learnkey = 3
Const Enablebuz = 4
Const Disablebuz = 5
Const Enablesensor = 6
Const Disablesensor = 7
Const Enableinput = 8
Const Disableinput = 9
Const Readsteps = 10
Const Learnsteps = 11
Const Enablestep = 12
Const Disablestep = 13
Const Readsenario = 14
Const Readremote = 15


Const Keyin = 101
Const Steps = 102
Const Senario = 103
Const Outlogic = 110
Const Outpwm = 111
Const Outstep = 112


Typ = 3
Cmd = 2
 Id = 1
'Wait 2
Reset Inok


Main:

     Do
          Debounce Learn , 0 , Learnrutin , Sub
          Call Inrefresh
          Wait 10
     Loop


Gosub Main:


Sub Learnrutin:

    Id = 1
    Do
        Waitms 100
        Findorder = Learnkey

        Do
          Toggle Portc.id
          Call Order
          Wait 1
        Loop Until Learnok = 1
        Reset Learnok
        Incr Id
    Loop Until Id = 3

End Sub

Sub Inrefresh:
    Findorder = Readallinput
    Call Order
    Reset Sendok


End Sub

Sub Tx:
    Disable Urxc
    Set Em
    Printbin 252 ; Typ ; Cmd ; Id ; 210
    Waitms 30
    Reset Em
    Enable Urxc

End Sub

Sub Sendqc:
    Typ = Din(2) : Cmd = Din(3) : Id = Din(4)
    Call Tx
End Sub

Sub Order

    Select Case Findorder

           Case Readallinput
                Typ = 101 : Cmd = 150 : Id = 99

           Case Read1input
                Typ = 101 : Cmd = 150 : Id = Id

           Case Learnkey
                Typ = 101 : Cmd = 151 : Id = Id

           Case Enablebuz
                Typ = 101 : Cmd = 152 : Id = 99

           Case Disablebuz
                Typ = 101 : Cmd = 153 : Id = 99

           Case Enablesensor
                Typ = 101 : Cmd = 154 : Id = 99

           Case Disablesensor
                Typ = 101 : Cmd = 155 : Id = 99

           Case Enableinput
                Typ = 101 : Cmd = 156 : Id = 99

           Case Disableinput
                Typ = 101 : Cmd = 157 : Id = 99

           Case Readsteps
                Typ = 102 : Cmd = 150 : Id = 99

           Case Learnsteps
                Typ = 102 : Cmd = 151 : Id = Id

           Case Enablestep
                Typ = 102 : Cmd = 156 : Id = 99

           Case Disablestep
                Typ = 110 : Cmd = 157 : Id = 99

           Case Readsenario
                Typ = 103 : Cmd = 150 : Id = 99

           Case Readremote
                Typ = 104 : Cmd = 150 : Id = 99




    End Select

    Call Tx


End Sub



Sub Checkanswer:
    Select Case Din(2)

           Case Keyin
                If Din(3) = 151 Then
                   If Din(4) = Id Then
                      Learnok = 1
                   End If
                End If
                If Din(3) = 180 Then Set Portc.din(4)
                If Din(3) = 181 Then Reset Portc.din(4)
                If Din(3) = 182 Then
                   Set Portc.id
                   Wait 2
                   Reset Portc.id
                End If
           Case Senario

           Case Steps

           Case Outlogic

           Case Outpwm

    End Select
    'Call Sendqc
    Call Setout


End Sub



Sub Setid

End Sub

Sub Setout:

          Typ = 110
          If Din(3) = 180 Then
             Cmd = 156
          Elseif Din(3) = 181 Then
             Cmd = 157
          End If
          Id = Din(4)
          Call Tx




End Sub


Issend:

       Set Sendok

Return

Rx:


      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
         I = 0
         Checkanswer
         Reset Inok
         Set Rt
         Waitms 50
         Reset Rt
      End If



Return




End