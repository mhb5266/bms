$regfile = "m8def.dat"
$crystal = 11059200




Configs:

$baud = 115200

Config Debounce = 30

Enable Interrupts

Enable Urxc
On Urxc Ismax

'Enable Utxc
'On Utxc Issend

Config Portc = Output
config portb=INPUT

En Alias Portd.2 : Config Portd.2 = Output
Key Alias Pind.4 : Config Pind.4 = Input
Rt Alias Portb.0 : Config Portb.0 = Output



Declare Sub Answer
Declare Sub Findorder
Declare Sub Keytouched
Declare Sub Checkqc
Declare Sub Clrbuf



Dim Maxin As Byte

Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte

Typ = 104
Cmd = 181
 'Id = 2


Dim Eid As Eram Byte

Dim Startbit As Byte
Dim Endbit As Byte

Dim I As Byte
Dim J As Long
Dim A As Byte
Dim Reply As Byte

Dim Inok As Boolean
Dim Touch As Boolean
Dim Sendok As Boolean
Dim Isrequest As Boolean
Dim Timeout As Boolean
Dim Enbuz As Boolean
Dim Ensensor As Boolean
Dim Enkey As Boolean
Dim Wantid As Boolean

Dim Backtyp As Byte : Dim Backcmd As Byte : Dim Backid As Byte

Dim Din(5) As Byte

Const Allid = 99
Const Nonid = 0

Reset En



Main:



       Do

         Debounce Key , 1 , Keytouched , Sub
       Loop





Gosub Main


Sub Clrbuf:

    For J = 1 To 3
        Din(j) = 0
    Next J



End Sub

Sub Keytouched:


          If Wantid = 1 Then

             Startbit = 242 : Endbit = 220 : Typ = 101 : Cmd = 151 : Id = Din(4)
             'Do
               Call Answer
             'Loop Until Sendok = 1
             Reset Sendok
             Reset Wantid
             Reset Isrequest
             Return
          End If

          Toggle Touch
          If Isrequest = 1 Then
             If Touch = 1 Then
                Cmd = 180
                Set Portc.id
             Else
                 Cmd = 181
                 Reset Portc.id
             End If

             'Do
               Startbit = 232 : Endbit = 220
               Call Answer
             'Loop Until Sendok = 1
             Reset Sendok
          End If
          Do
          Loop Until Key = 0

End Sub


Sub Answer:
    Call Clrbuf
    Disable Urxc
    Set En
    Backtyp = Typ : Backcmd = Cmd : Backid = Id
    Printbin Startbit ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En
    Enable Urxc
    Waitms 100
    'Call Checkqc
End Sub

Sub Findorder

    If Din(2) = 101 Then
        If Din(4) = Id Or Din(4) = Allid Then
            Select Case Din(3)


                Case 150
                  Set Isrequest
                Case 151
                  Id = Din(4)
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
            End Select
        Elseif Id = Nonid Then
               If Din(3) = 151 Then

                  Set Wantid
               End If
        End If
    End If
End Sub


Sub Checkqc:

    If Backtyp = Din(2) And Backcmd = Din(3) And Backid = Din(4) Then Set Sendok


End Sub

Issend:

   Set Sendok



Return

Ismax:
      Reset Rt

      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 252 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Toggle Portc.5
        If Din(2) = Typ Then Call Findorder
        I = 0
        Reset Inok
      End If







Return

End