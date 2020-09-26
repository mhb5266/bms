$regfile = "m8def.dat"
$crystal = 11059200




Configs:

$baud = 115200

Config Debounce = 30

Enable Interrupts

Enable Urxc
On Urxc Rx

'Enable Utxc
'On Utxc Issend

Config Portc = Output
config portb=INPUT

En Alias Portd.2 : Config Portd.2 = Output

Rt Alias Portc.5 : Config Portc.5 = Output

Touch1 Alias Pind.7 : Config Portd.7 = Input
Touch2 Alias Pinb.0 : Config Portb.0 = Input
Touch3 Alias Pinb.1 : Config Portb.1 = Input
Touch4 Alias Pinb.2 : Config Portb.2 = Input

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

Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte

Dim Touchid1 As Eram Byte
Dim Touchid2 As Eram Byte
Dim Touchid3 As Eram Byte
Dim Touchid4 As Eram Byte

Dim Tempid As Byte

Dim S1 As Boolean
Dim S2 As Boolean
Dim S3 As Boolean
Dim S4 As Boolean

Typ = 101
Cmd = 181
 'Id = 2


Dim Eid As Eram Byte

Dim Direct As Byte
Dim Endbit As Byte

Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

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
       Loop





Gosub Main

Sub Beep
    Set Buz
    Waitms 80
    Reset Buz
End Sub

Sub Errorbeep
    Set Buz
    Waitms 500
    Reset Buz
End Sub

Sub Refreshkey

         Touch = 0
         If Touch1 = 1 Then
            Waitms 25
            If Touch1 = 1 Then
               Touch = 1
            End If
         End If
         If Touch2 = 1 Then
            Waitms 25
            If Touch2 = 1 Then
               Touch = 2
            End If
         End If
         If Touch3 = 1 Then
            Waitms 25
            If Touch3 = 1 Then
               Touch = 3
            End If
         End If
         If Touch4 = 1 Then
            Waitms 25
            If Touch4 = 1 Then
               Touch = 4
            End If
         End If

         If Sensor = 1 Then
            Touch = 5
         End If

End Sub

Sub Keytouched:
          '(
          If Wantid = 1 Then
             Select Case Touch
                    Case 1
                         Touchid1 = Id
                    Case 2
                         Touchid2 = Id
                    Case 3
                         Touchid3 = Id
                    Case 4
                         Touchid4 = Id
             End Select
             Call Beep
             Reset Wantid
             Reset Isrequest
          End If
')

          If Isrequest = 1 Then
             Call Beep
             Select Case Touch
                    Case 1
                         If Wantid = 1 Then
                            If Touchid1 = 0 Or Touchid1 > 50 Then
                               If Tempid > 0 Then
                                  Touchid1 = Tempid
                                  Tempid = 0
                                  Reset Wantid
                                  Direct = Tomaster : Cmd = 156
                               End If
                            End If
                         Else
                            If Touchid1 > 0 And Touchid1 < 50 Then
                               Direct = Tooutput : Id = Touchid1 : Cmd = 180
                            End If
                         End If
                    Case 2
                         If Wantid = 1 Then
                            If Touchid2 = 0 Or Touchid2 > 50 Then
                               If Tempid > 0 Then
                                  Touchid2 = Tempid
                                  Tempid = 0
                                  Reset Wantid
                                  Direct = Tomaster : Cmd = 156
                               End If
                            End If
                         Else
                            If Touchid2 > 0 And Touchid2 < 50 Then
                               Direct = Tooutput : Id = Touchid2 : Cmd = 180
                            End If
                         End If
                    Case 3
                         If Wantid = 1 Then
                            If Touchid3 = 0 Or Touchid3 > 50 Then
                               If Tempid > 0 Then
                                  Touchid3 = Tempid
                                  Tempid = 0
                                  Reset Wantid
                                  Direct = Tomaster : Cmd = 156
                               End If
                            End If
                         Else
                            If Touchid3 > 0 And Touchid3 < 50 Then
                               Direct = Tooutput : Id = Touchid3 : Cmd = 180
                            End If
                         End If
                    Case 4
                         If Wantid = 1 Then
                            If Touchid4 = 0 Or Touchid4 > 50 Then
                               If Tempid > 0 Then
                                  Touchid4 = Tempid
                                  Tempid = 0
                                  Reset Wantid
                                  Direct = Tomaster : Cmd = 156
                               End If
                            End If
                         Else
                            If Touchid4 > 0 And Touchid4 < 50 Then
                               Direct = Tooutput : Id = Touchid4 : Cmd = 180
                            End If
                         End If
                    Case 5
                         If Touchid1 < 50 And Touchid1 > 0 Then
                            Id = Touchid1
                            Cmd = 159
                         End If
             End Select
             Call Tx
          End If

          Do
            Call Refreshkey
          Loop Until Touch = 0
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
                  Touchid4 = 0
                  Waitms 2
                  Call Beep
            End Select

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

        Typ = Din(2)
        If Typ = Mytyp Then Call Findorder
        I = 0
        Reset Inok
      End If







Return

End