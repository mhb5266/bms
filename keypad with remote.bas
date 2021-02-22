            $regfile = "m8def.dat"
$crystal = 11059200


Const Keyid = 1

Configs:

$baud = 9600

Config Debounce = 30

Enable Interrupts

Config Timer1 = Timer , Prescale = 1024
Enable Timer1
On Timer1 T1rutin
Enable Urxc
On Urxc Rx

'Enable Utxc
'On Utxc Issend

Config Portc = Output
Config Portb = Input

En Alias Portd.2 : Config Portd.2 = Output

Rt Alias Portc.5 : Config Portc.5 = Output

Touch4 Alias Pind.5 : Config Portd.5 = Input
Touch2 Alias Pind.6 : Config Portd.6 = Input
Touch1 Alias Pind.7 : Config Portd.7 = Input
Touch3 Alias Pinb.0 : Config Portb.0 = Input

Led1 Alias Portb.1 : Config Portb.1 = Output
Led2 Alias Portb.2 : Config Portb.2 = Output
'Led3 Alias Portb.5 : Config Portb.5 = Output
'Led4 Alias Portd.4 : Config Portd.4 = Output

Sensor Alias Pinc.4 : Config Portc.4 = Input

Led Alias Portc.2 : Config Portc.2 = Output
Buz Alias Portc.3 : Config Portc.3 = Output


Declare Sub Findorder
Declare Sub Keytouched
Declare Sub Tx
Declare Sub Refreshkey
Declare Sub Beep
Declare Sub Errorbeep

Dim Maxin As Byte
Dim Touchdelay As Byte
Dim Istouched As Bit
Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte

Dim Touchid1 As Byte
Dim Touchid2 As Byte
Dim Touchid3 As Byte

Touchid3 = Keyid * 3
Touchid2 = Touchid3 - 1
Touchid1 = Touchid3 - 2

Dim Alloffon As Boolean

Dim Tempid As Byte

Dim S1 As Boolean
Dim S2 As Boolean
Dim S3 As Boolean
Dim S4 As Boolean

Dim Tempon As Word
Dim Tempen As Boolean

Dim P As Byte
Dim Count As Word

Typ = 101
Cmd = 181
 'Id = 2


Dim Eid As Eram Byte

Dim Direct As Byte
Dim Endbit As Byte

Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

Dim L1 As Boolean
Dim L2 As Boolean
Dim L3 As Boolean

Dim I As Byte
Dim J As Long
Dim A As Byte
Dim Reply As Byte

Dim Inok As Boolean
Dim Touch As Byte
Dim Sendok As Boolean
Dim Isrequest As Boolean
Dim Timeout As Boolean
Dim Enbuz As Boolean
Dim Ensensor As Boolean
Dim Enkey As Boolean

Dim Wantid As Boolean

'Dim Wantid1 As Boolean
'Dim Wantid2 As Boolean
'Dim Wantid3 As Boolean
'Dim Wantid4 As Boolean

Dim Backtyp As Byte : Dim Backcmd As Byte : Dim Backid As Byte

Dim Din(5) As Byte

Const Allid = 99
Const Alltyp = 115
Const Nonid = 0
Const Mytyp = 101

Reset En




Main:



       Do

         Call Refreshkey

         If Touch > 0 Then Call Keytouched

         If Tempon = 1 Then
            Waitms 50
            Incr Count
            If Count = 2400 Then
               Count = 0
               Id = Touchid1
               Cmd = 181
               Direct = Tooutput
               Call Tx
               Reset Tempon
            End If
         End If
       Loop





Gosub Main




Issend:

   Set Sendok



Return

T1rutin:
        Stop Timer1
        If Istouched = 1 Then
           Incr Touchdelay
           If Touchdelay > 30 Then
              Reset Istouched
              Touchdelay = 0
           End If
        End If

        Timer1 = 54735
        Start Timer1
Return

Rx:


      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then

        Typ = Din(2)
        If Typ = Mytyp Then Call Findorder
        I = 0
        Reset Inok
      End If







Return

End

Sub Beep
    Set Buz
    Waitms 80
    Reset Buz
End Sub


Sub Refreshkey
    Touch = 0
    If Touch1 = 0 Then Touch = 1
    If Touch2 = 0 Then Touch = 2
    If Touch3 = 0 Then Touch = 3
    If Touch4 = 0 Then Touch = 4
    If Sensor = 0 Then Touch = 5
End Sub

Sub Keytouched:
                   Typ = Mytyp
                   Direct = Tooutput
                   If Touch > 0 And Touch < 5 Then Set Istouched
    Select Case Touch
           Case 1
                Toggle L1
                Id = Touchid1
                If L1 = 0 Then
                   Cmd = 181
                Else
                   Cmd = 182
                End If
                Call Tx
                Reset Tempon
           Case 2
                Toggle L2
                Id = Touchid2
                If L2 = 0 Then
                   Cmd = 181
                Else
                   Cmd = 182
                End If
                Call Tx
                Reset Tempon
           Case 3
                Toggle L3
                Id = Touchid3
                If L3 = 0 Then
                   Cmd = 181
                Else
                   Cmd = 182
                End If
                Call Tx
                Reset Tempon
           Case 4
                Toggle Alloffon
                If Alloffon = 1 Then
                   Cmd = 182
                   Set L1
                   Set L2
                   Set L3
                Else
                    Cmd = 181
                   Reset L1
                   Reset L2
                   Reset L3
                End If
                Id = Touchid1
                Call Tx
                Waitms 200
                Id = Touchid2
                Call Tx
                Waitms 200
                Id = Touchid3
                Call Tx
                Waitms 200
                Reset Tempon
           Case 5
                If L1 = 0 And L2 = 0 And L3 = 0 And Istouched = 0 Then
                   Id = Touchid1
                   Cmd = 159
                   Call Tx
                   Set Istouched
                   Set Tempon
                End If
    End Select
    Wait 1
End Sub

Sub Tx
    If Direct = Tooutput Then Endbit = 210
    If Direct = Tomaster Then Endbit = 230

    Set En
    Waitms 10
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En

End Sub



Sub Findorder

Cmd = Din(3)
Id = Din(4)
Toggle Rt

            Select Case Cmd

                Case 150
                  Set Isrequest
                   Reset Wantid
                Case 151
                     Set Wantid
                     Tempid = Id
                Case 152
                  Set Enbuz
                Case 153
                  Reset Enbuz
                Case 154
                  Set Ensensor
                Case 155
                  Reset Ensensor
                Case 156
                  Set Enkey
                Case 157
                  Reset Enkey
                Case 158
                  Touchid1 = 0
                  Waitms 2
                  Touchid2 = 0
                  Waitms 2
                  Touchid3 = 0
                  Waitms 2
                  Call Beep
            End Select

End Sub
