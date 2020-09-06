$regfile = "m16def.dat"
$crystal = 11059200
$baud = 115200


Configs:

Enable Interrupts
Enable Urxc
On Urxc Rx

'Enable Utxc
'On Utxc Issend


Declare Sub Findorder

Config Portc = Output
'Em Alias Portc.3 : Config Portc.3 = Output
En Alias Portd.2 : Config Portd.2 = Output
Rxtx Alias Portb.0 : Config Portb.0 = Output

Config Portc = Output

Learn Alias Pinb.2 : Config Pinb.2 = Input


Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte
Dim I As Byte
Dim J As Long
Dim Maxin As Byte
Dim A As Byte
Dim Reply As Byte
Dim Keyids As Byte : Dim Ekeyids As Eram Byte

'Dim Findorder As Byte

Dim Din(5) As Byte


Dim Timeout As Boolean
Dim Sendok As Boolean
Dim Inok As Boolean
Dim Light As Byte
Dim Learnok As Boolean
Dim Blank As Boolean : Reset Blank


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
Const Remote = 104
Const Outmoduls = 110



Typ = 110
Cmd = 2
 Id = 1
'Wait 2
Reset Inok
Reset En

Startup:


Main:

     Waitms 10
     Do

     Loop
Gosub Main

Sub Findorder:
    Id = Din(4)
    'Select Case Din(2)

           'Case Keyin
                If Din(3) = 180 Then
                   If Id < 30 Then Set Portc.id
                   If Id = 99 Then Portc = 255
                   Reset Blank
                End If
                If Din(3) = 181 Then
                   If Id < 30 Then Reset Portc.id
                   If Id = 99 Then Portc = 0
                   Reset Blank
                End If
                'If Din(3) = 183 Then Set Blank

           'Case Outpwm

    'End Select

End Sub

Rx:


      

      Incr I
      Inputbin Maxin

      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 252 Or Maxin = 232 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Toggle Rxtx
        If Din(2) = Keyin Or Din(2) = Outmoduls Or Din(2) = Remote Then Call Findorder
        I = 0
        Reset Inok
      End If



Return

End