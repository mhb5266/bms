$regfile = "m128def.dat"
$crystal = 11059200

Configs:

$baud = 115200
'$baud1 = 115200
'Config Print1 = Portc.3 , Mode = Set

Enable Interrupts
Enable Urxc
On Urxc Rx
'
'Enable Utxc
'On Utxc Issend


$lib "glcdKS108.lbx"
Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 1 , Ce2 = 0 , Cd = 4 , Rd = 3 , Reset = 2 , Enable = 5
Setfont Font8x8

'Config Com1 = Duumy , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0


Config Portc = Output
Em Alias Portc.3 : Config Portc.3 = Output
'Em Alias Portd.2 : Config Portd.2 = Output
Rt Alias Portb.0 : Config Portb.0 = Output

Learn Alias Pinb.1 : Config Pinb.1 = Input


Defines:


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

Dim Maxid As Byte

Dim Startbit As Byte : Startbit = 252
Dim Endbit As Byte : Endbit = 210


Dim Timeout As Boolean
Dim Sendok As Boolean
Dim Inok As Boolean
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
Const Outputblank = 16
Const Resetoutput = 17
Const Resetalloutput = 18
Const Setoutput = 19
Const Clearid = 20


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



'Cls
'Lcdat 1 , 1 , "hi"
'Wait 2
'Cls

Main:

     'Do
     'Toggle Portc.3
     'Wait 1
     'Loop

     Do
          Debounce Learn , 0 , Learnrutin , Sub
          If J = 100 Then
             Call Inrefresh
             J = 0
          End If
          Waitms 100
          Incr J
     Loop


Gosub Main:


Sub Learnrutin:


    Maxid = 1
    Id = Maxid
    Do
      Waitms 30

      Findorder = Setoutput
      Call Order
      Do
      Findorder = Learnkey
      Call Order
        Wait 1

      Loop Until Learnok = 1
      Reset Learnok
      Maxid = Id
      Findorder = Resetalloutput
      Call Order
      Incr Maxid
      Id = Maxid
      Findorder = Setoutput
    Loop Until Learn = 1
    Return

    Id = 1
    Do
        Waitms 100

        'Findorder = Outputblank
        'Call Order

        Do
          Findorder = Learnkey
          Call Order
          Wait 2
        Loop Until Learnok = 1
        Findorder = Resetoutput
        Call Order
        Reset Learnok
        Incr Id
    Loop Until Id = 5

End Sub

Sub Inrefresh:
    Findorder = Readallinput
    Call Order
    Reset Sendok


End Sub

Sub Tx:
    'Open "com2:" For Binary As #1
    Disable Urxc
    Set Em
    Printbin Startbit ; Typ ; Cmd ; Id ; Endbit
    Waitms 30
    Reset Em
    Enable Urxc
    'Gosub Rx

End Sub

Sub Sendqc:
    Typ = Din(2) : Cmd = Din(3) : Id = Din(4)
    Call Tx
End Sub

Sub Order

    Select Case Findorder



           Case Readallinput

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 150 : Id = 99

           Case Read1input

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 150 : Id = Id

           Case Learnkey

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 151 : Id = Id

           Case Enablebuz

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 152 : Id = 99

           Case Disablebuz

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 153 : Id = 99

           Case Enablesensor

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 154 : Id = 99

           Case Disablesensor

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 155 : Id = 99

           Case Enableinput

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 156 : Id = 99

           Case Disableinput

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 157 : Id = 99

           Case Readsteps

                Startbit = 252 : Endbit = 210 : Typ = 102 : Cmd = 150 : Id = 99

           Case Learnsteps

                Startbit = 252 : Endbit = 210 : Typ = 102 : Cmd = 151 : Id = Id

           Case Enablestep

                Startbit = 252 : Endbit = 210 : Typ = 102 : Cmd = 156 : Id = 99

           Case Disablestep

                Startbit = 252 : Endbit = 210 : Typ = 110 : Cmd = 157 : Id = 99

           Case Readsenario

                Startbit = 252 : Endbit = 210 : Typ = 103 : Cmd = 150 : Id = 99

           Case Readremote

                Startbit = 252 : Endbit = 210 : Typ = 104 : Cmd = 150 : Id = 99

           Case Outputblank

                Startbit = 242 : Endbit = 220 : Typ = 110 : Cmd = 183 : Id = Id

           Case Resetoutput

                Startbit = 242 : Endbit = 220 : Typ = 110 : Cmd = 181 : Id = Id

           Case Resetalloutput

                Startbit = 242 : Endbit = 220 : Typ = 110 : Cmd = 181 : Id = 99

           Case Setoutput

                Startbit = 242 : Endbit = 220 : Typ = 110 : Cmd = 180 : Id = Id

           Case Clearid

                Startbit = 252 : Endbit = 210 : Typ = 101 : Cmd = 167 : Id = Id

    End Select

    Call Tx


End Sub



Sub Checkanswer:
    Select Case Din(2)

           Case Keyin

                Cls
                Lcdat 5 , 1 , Din(4)
                Wait 1
                Cls

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
      'J = 0
      'Do

      Incr J
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

      'Waitms 1
      'Loop Until J = 100

Return




End

$include "font32x32.font"
$include "font16x16.font"
$include "font8x8.font"