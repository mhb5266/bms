$regfile = "m16def.dat"
$crystal = 11059200
$baud = 115200

Portconfig:



Config Porta = Output
Config Portb = Output
Config Portc = Output
Config Portd = Output

           Out1 Alias Portd.3
           Out2 Alias Portd.4
           Out3 Alias Portd.5
           Out4 Alias Portd.6
           Out5 Alias Portc.2
           Out6 Alias Portc.1
           Out7 Alias Portc.0
           Out8 Alias Portd.7
           Out9 Alias Portc.3
           Out10 Alias Portc.4
           Out11 Alias Portc.5
           Out12 Alias Portc.6
           Out13 Alias Porta.5
           Out14 Alias Porta.6
           Out15 Alias Porta.7
           Out16 Alias Portc.7
           Out17 Alias Porta.4
           Out18 Alias Porta.3
           Out19 Alias Porta.2
           Out20 Alias Porta.5
           Out21 Alias Portb.2
           Out22 Alias Portb.1
           Out23 Alias Portb.0
           Out24 Alias Porta.0
           Out25 Alias Portb.3
           Out26 Alias Portb.4
           Out27 Alias Portb.5
           Out28 Alias Portb.6

           Key Alias Pinb.7 : Config Portb.7 = Input



           Declare Sub Setouts
           Declare Sub Keyorder

           Const Stopall = 1
           Const normal = 2
           Const Refreshall = 3

           Config Portc = Output

           En Alias Portd.2 : Config Portd.2 = Output
           Rxtx Alias Portb.0 : Config Portb.0 = Output

           Config Portc = Output

Configs:

Enable Interrupts
Enable Urxc
On Urxc Rx


Defines:

Dim Outs(28) As Byte
Dim Eoutnum(28) As Eram Byte
Dim Eoutid(28) As Eram Byte
Dim Eouts(28) As Eram Byte
Dim D As Byte
Dim Moduleid As Eram Byte

Dim Tempid As Byte

Dim status As Byte

Dim Efirst As Eram Byte

Dim Togglekey As Boolean

Dim Idwasgot As Boolean
Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte
Dim I As Byte
Dim J As Long
Dim Maxin As Byte
Dim A As Byte
Dim Reply As Byte
Dim Keyids As Byte : Dim Ekeyids As Eram Byte
Dim Counterid As Byte : Counterid = 28
Dim Baseid As Byte

Dim Minid As Byte : Minid = Baseid + 1
Dim Maxid As Byte : Maxid = Counterid + Baseid

Dim Temponid(28) As Byte
Dim Tempontime(28) As Word
Dim Tempon As Boolean
Dim wantnum As Boolean
Dim Sycid As Boolean
Dim Setid As Byte
Dim Din(5) As Byte


Dim Timeout As Boolean
Dim Sendok As Boolean
Dim Inok As Boolean
Dim Light As Byte
Dim Learnok As Boolean
Dim Blank As Boolean : Reset Blank
Dim Idblank As Byte

Dim Direct As Byte
Dim Endbit As Byte



Subs:

Declare Sub Findorder

Declare Sub Tx


Consts:

'Const D = 10
Const Allid = 99

Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

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
Const Relaymodules = 110


Const Mytyp = 110

Startup:
Reset Inok
Reset En
If Efirst > 0 Then
   Efirst = 0
   For I = 1 To 28
       Eouts(i) = 0
   Next
End If




Main:

     Do

       If Blank = 1 Then
          Toggle Outs(idblank)
          J = Idblank
          Call Setouts
          Waitms 200
       End If

       If Tempon = 1 Then
          For I = 1 To Counterid
              If Temponid(i) = 1 Then
                 Incr Tempontime(i)
                 Wait 1
                 If Tempontime(i) = 120 Then
                    Tempontime = 0
                    Tempon(i) = 0
                    Outs(i) = 0
                    J = I
                    Call Setouts
                 End If
              End If
          Next
       End If

       If Key = 1 Then
          If wantnum = 1 Then
             Reset wantnum
             Baseid = Id
             For I = 1 To Counterid
                 Baseid = Baseid + 1
                 Eoutnum(i) = Baseid
             Next
             Id = Eoutnum(counterid)
             Direct = Tomaster
             Portc = Id
             Cmd = 165
             Call Tx
             Wait 1
             Portc = 0



          Else
              D = 0
              Set Out1
              Waitms 20

              Do
                Waitms 100
                Incr D
                If D > 10 Then Reset Out1
              Loop Until Key = 0

              If D < 10 Then
                 Toggle Togglekey
                 If Togglekey = 1 Then Status = Stopall Else Status = Normal
              Elseif D > 10 Then
                     Status = Refreshall
              End If
              D = 0
              Call Keyorder
          End If
          Do
          Loop Until Key = 0
       End If

     Loop


Gosub Main




Sub Tx
    If Direct = Tomaster Then
       Endbit = 230
    Elseif Direct = Toinput Then
       Endbit = 220
    End If
    Set En
    Waitms 1
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 30
    Reset En
End Sub


Sub Keyorder

    Select Case status
           Case Stopall
                 For J = 1 To 28
                    Outs(j) = 0
                    Call Setouts
                    Waitms 200
                Next


           Case Normal

                For J = 1 To 28
                    Outs(j) = Eouts(j)
                    Call Setouts
                Next

           Case Refreshall
                For J = 1 To 28
                    Outs(j) = 1
                    Call Setouts
                    Waitms 250
                Next

    End Select

End Sub

Sub Setouts

        If Status = Normal Then Eouts(j) = Outs(j)
        Select Case J
               Case 1
                    Out1 = Outs(1)
               Case 2
                    Out2 = Outs(2)
               Case 3
                    Out3 = Outs(3)
               Case 4
                    Out4 = Outs(4)
               Case 5
                    Out5 = Outs(5)
               Case 6
                    Out6 = Outs(6)
               Case 7
                    Out7 = Outs(7)
               Case 8
                    Out8 = Outs(8)
               Case 9
                    Out9 = Outs(9)
               Case 10
                    Out10 = Outs(10)
               Case 11
                    Out11 = Outs(11)
               Case 12
                    Out12 = Outs(12)
               Case 13
                    Out13 = Outs(13)
               Case 14
                    Out14 = Outs(14)
               Case 15
                    Out15 = Outs(15)
               Case 16
                    Out16 = Outs(16)
               Case 17
                    Out17 = Outs(17)
               Case 18
                    Out18 = Outs(18)
               Case 19
                    Out19 = Outs(19)
               Case 20
                    Out20 = Outs(20)
               Case 21
                    Out21 = Outs(21)
               Case 22
                    Out22 = Outs(22)
               Case 23
                    Out23 = Outs(23)
               Case 24
                    Out24 = Outs(24)
               Case 25
                    Out25 = Outs(25)
               Case 26
                    Out26 = Outs(26)
               Case 27
                    Out27 = Outs(27)
               Case 28
                    Out28 = Outs(28)
        End Select


End Sub

Sub Findorder


        Select Case Cmd
               Case 151
                    If Typ = Mytyp Then
                       Set Wantnum
                    End If
               Case 158
                    For I = 1 To Counterid
                        Eoutid(i) = 0
                        Eoutnum(i) = 0
                        Eouts(i) = 0
                        For J = 1 To Counterid
                            Call Setouts
                        Next
                    Next
               Case 159
                    If Id >= Minid And Id <= Maxid Then
                       For I = 1 To Counterid
                           If Eoutid(i) = Id Then
                              Set Tempon
                              If Outs(i) = 0 Then Temponid(i) = 1
                           End If
                       Next
                    End If
               Case 160
                    For I = 1 To Counterid
                        If Eoutnum(i) = Id Then
                           Set Outs(i)
                           J = I
                           Tempid = I
                           Set Sycid
                           Call Setouts
                        End If
                    Next
               Case 180
                    'If Sycid = 1 Then
                       'Outsid(setid) = Id
                       'Reset Sycid
                    'Else
                       If Sycid = 1 Then
                          Eoutid(tempid) = Id
                          Reset Sycid
                       End If
                       For I = 1 To Counterid
                           'If Eoutsnum(i) = Id Then
                           If Eoutid(i) = Id Then
                              Tempon(id) = 0
                              J = I
                              Status = Normal
                              Outs(j) = 1
                              Call Setouts
                           End If
                       Next I
                    'End If
               Case 181
                    If Sycid = 1 Then
                          Eoutid(tempid) = Id
                          Reset Sycid
                    End If
                    If Id = Allid Then
                       For I = 1 To Counterid
                           Outs(i) = 0
                           J = I
                           Call Setouts
                       Next
                    End If
                    For I = 1 To Counterid
                        'If Eoutsnum(i) = Id Then
                        If Eoutid(i) = Id Then
                           J = I
                           Status = Normal
                           Outs(j) = 0
                           Call Setouts
                        End If
                    Next I
               Case 183
                       Set Blank
                       Idblank = Id


        End Select


End Sub

Rx:




      Incr I
      Inputbin Maxin

      If I = 5 And Maxin = 210 Then Set Inok
      If Maxin = 232 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Typ = Din(2)
        If Typ = Keyin Or Typ = Remote Or Typ = Relaymodules Then
           Toggle Rxtx
           Typ = Din(2) : Cmd = Din(3) : Id = Din(4)
           Call Findorder
        End If
        I = 0
        Reset Inok
      End If



Return

End