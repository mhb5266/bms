$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600

Portconfig:



'Config Porta = Output
'Config Portb = Output
'Config Portc = Output
'Config Portd = Output

           Out1 Alias Portd.4:Config Portd.4 = Output
           Out2 Alias Portd.3:Config Portd.3 = Output
           Out3 Alias Portc.5:Config Portc.5 = Output
           Out4 Alias Portc.4:Config Portc.4 = Output
           Out5 Alias Portc.3:Config Portc.3 = Output
           Out6 Alias Portc.2:Config Portc.2 = Output
           Out7 Alias Portc.1:Config Portc.1 = Output
           Out8 Alias Portc.0:Config Portc.0 = Output
           Out9 Alias Portb.2:Config Portb.2 = Output
           Out10 Alias Portb.1:Config Portb.1 = Output
           Out11 Alias Portb.0:Config Portb.0 = Output
           Out12 Alias Portd.7:Config Portd.7 = Output
           Out13 Alias Portd.6:Config Portd.6 = Output
           out14 alias portd.5:Config Portd.5 = Output


           Key Alias Pinb.5 : Config Portb.5 = Input



           Declare Sub Setouts
           Declare Sub Keyorder
           declare sub readouts


           'Config Portc = Output

           En Alias Portd.2 : Config Portd.2 = Output
           Rxtx Alias Portb.4 : Config Portb.4 = Output
           led alias portb.3:config portb.3=OUTPUT

           'Config Portc = Output

Configs:

Enable Interrupts
Enable Urxc
On Urxc Rx


Defines:

Dim Esenario1 As Eram Dword
Dim Esenario2 As Eram Dword
Dim Esenario3 As Eram Dword

Dim Senario1 As Dword
Dim Senario2 As Dword
Dim Senario3 As Dword

If Esenario1 = 4294967295 Then Esenario1 = 0
If Esenario2 = 4294967295 Then Esenario2 = 0
If Esenario3 = 4294967295 Then Esenario3 = 0

Senario1 = Esenario1
Senario2 = Esenario2
Senario3 = Esenario3

Dim Setsenario As Byte



Dim F As Byte
Dim M As Byte
Dim Tblank As Byte
Dim Test As Byte
Dim Wantid As Boolean
Dim Gotid As Boolean

Dim Outs As Dword
Dim Eoutnum(14) As Eram Byte

Dim Eoutid1(14) As Eram Byte
Dim Eoutid2(14) As Eram Byte
Dim Eoutid3(14) As Eram Byte
Dim Eoutid4 As Eram Byte

'Dim Outid1 As Byte
'Dim Outid2 As Byte
'Dim Outid3 As Byte
'Dim Outid4 As Byte

dim outid1(14) as byte
dim outid2(14) as byte
dim outid3(14) as byte

Dim Eouts(14) As Eram Byte
Dim Idgot As Eram Byte
Dim D As Byte
'Dim Moduleid As Eram Byte

Dim Tempid As Byte

Dim Status As Byte

Dim Efirst As Eram Byte

Dim Togglekey As Boolean

Dim Idwasgot As Boolean
Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte
Dim I As Byte
Dim J As Byte
Dim K As Byte
Dim Maxin As Byte
Dim A As Byte
Dim Reply As Byte
Dim Keyids As Byte : Dim Ekeyids As Eram Byte
Dim Counterid As Byte : Counterid = 14
Dim Baseid As Byte

Dim Minid As Byte : Minid = Baseid + 1
Dim Maxid As Byte : Maxid = Counterid + Baseid

Dim Temponid(14) As Byte
Dim Tempontime(14) As Word
Dim Tempon As Boolean
Dim Wantnum As Boolean
Dim Sycid As Boolean
Dim Setid As Byte
Dim Din(5) As Byte
Dim Z As Byte
Dim Onoff As Boolean

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
Declare Sub Clearids
Declare Sub Findorder
Declare Sub Getid
Declare Sub Turnout
Declare Sub Tx


Consts:

Const Stopall = 1
Const Normal = 2
Const Refreshall = 3
Const Resetall = 4

'Const D = 10
Const Allid = 99

Const Relaymodule = 110
Const Pwmmodule = 111

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
   For I = 1 To 14
       Eouts(i) = 0
   Next
End If




Main:

     Do
      '(
       If Blank = 1 Then
          Toggle Outs(idblank)
          J = Idblank
          Call Setouts
          Waitms 200
       End If
')
'(
       If Tempon = 1 Then
          For I = 1 To Counterid
              If Temponid(i) = 1 Then
                 Incr Tempontime(i)
                 Wait 1
                 If Tempontime(i) = 120 Then
                    Tempontime(i) = 0
                    Tempon(i) = 0
                    Outs.i = 0
                    J = I
                    Call Setouts
                 End If
              End If
          Next
       End If
  ')


       If Key = 1 Then
          Waitms 30
          If Key = 1 Then
             Stop Timer0
             M = 0
             Do
               Waitms 50
               Incr M
               If M < 80 Then
                  Tblank = M Mod 10
                  If Tblank = 0 Then Toggle Rxtx
               Else
                  Tblank = M Mod 4
                  If Tblank = 0 Then Toggle Rxtx
               End If
             Loop Until Key = 0
             Reset Rxtx
             If M < 80 Then
                Call Getid
             Else
                 Call Clearids
             End If
             Start Timer0
          End If
       End If

'(

       If Key = 1 Then
          Waitms 50
          If Key = 1 Then
             Stop Timer0
             For I = 1 To 8
                 Toggle Rxtx
                 Waitms 200
             Next I
             Call Getid
             Start Timer0
          End If
          Do
          Loop Until Key = 1
       End If
')
     Loop


Gosub Main


Sub Getid
    K = 0
    Reset En
    Set Rxtx
    Wait 3
    Reset Rxtx
    Set Wantid
       Do
         If Cmd = 180 Or Cmd = 181 And Id > 0 And Id < 100 Then
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
                                         Case 9
                                              Toggle Out9
                                         Case 10
                                              Toggle Out10
                                         Case 11
                                              Toggle Out11
                                         Case 12
                                              Toggle Out12
                                         Case 13
                                              Toggle Out13
                                         Case 14
                                              Toggle Out14


                                 End Select

                                 Waitms 250

                             Next
                             For I = 1 To 14
                                 Eoutid1(i) = Outid1(i)
                                 Waitms 4
                                 Eoutid2(i) = Outid2(i)
                                 Waitms 4
                                 Eoutid3(i) = Outid3(i)
                                 Waitms 4
                             Next
                          End If
                          Cmd = 0
                          Id = 0
         End If
       If Key = 1 Then
          Waitms 30
          If Key = 1 Then
             M = 0
             Do
               Waitms 50
               Incr M
               If M < 80 Then
                  Tblank = M Mod 10
                  If Tblank = 0 Then Toggle Rxtx
               Else
                  Tblank = M Mod 4
                  If Tblank = 0 Then Toggle Rxtx
               End If
             Loop Until Key = 0
             Reset Rxtx
             If M < 80 Then
                Call Turnout
             Else
                  Exit Do
             End If
             Start Timer0
          End If
       End If
       Loop

       For I = 1 To 4
          Toggle Rxtx
          Waitms 500
       Next
       Status = Stopall
       Call Keyorder
       Reset Wantid
       Return
End Sub

Sub Clearids
                    For I = 1 To Counterid
                        Eoutid1(i) = 0
                        Waitms 4
                        Eoutid2(i) = 0
                        Waitms 4
                        Eoutid3(i) = 0
                        Waitms 4
                        Eoutnum(i) = 0
                        Waitms 4
                        Eouts(i) = 0
                        Waitms 4
                        Idgot = 0
                        Waitms 150
                        Toggle Rxtx
                    Next
                    Reset Rxtx
                'Porta = 0
                Portb = 0
                Portc = 0
                Portd = 0

End Sub

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

    Select Case Status
           Case Stopall
                 For J = 1 To 14
                    Outs.j = 0
                    Call Setouts
                    Waitms 200
                Next


           Case Normal

                For J = 1 To 14
                    If Eouts(j) = 1 Then Outs.j = 1 Else Outs.j = 0

                    Call Setouts
                Next

           Case Refreshall
                For J = 1 To 14
                    Outs.j = 1
                    Call Setouts
                    Waitms 200
                Next

           Case Resetall
                'Porta = 0
                Portb = 0
                Portc = 0
                Portd = 0

    End Select

End Sub

Sub Setouts

        If Status = Normal Then
           If Outs.j = 1 Then Eouts(j) = 1 Else Eouts(j) = 0
        End If
        Select Case J
               Case 1
                    Out1 = Outs.1
               Case 2
                    Out2 = Outs.2
               Case 3
                    Out3 = Outs.3
               Case 4
                    Out4 = Outs.4
               Case 5
                    Out5 = Outs.5
               Case 6
                    Out6 = Outs.6
               Case 7
                    Out7 = Outs.7
               Case 8
                    Out8 = Outs.8
               Case 9
                    Out9 = Outs.9
               Case 10
                    Out10 = Outs.10
               Case 11
                    Out11 = Outs.11
               Case 12
                    Out12 = Outs.12
               Case 13
                    Out13 = Outs.13
               Case 14
                    Out14 = Outs.14

        End Select


End Sub

Sub Turnout

           Incr K
                                Reset Out1
                                Reset Out2
                                Reset Out3
                                Reset Out4
                                Reset Out5
                                Reset Out6
                                Reset Out7
                                Reset Out8
                                Reset Out9
                                Reset Out10
                                Reset Out11
                                Reset Out12
                                Reset Out13
                                Reset Out14


                                If K > 14 Then K = 1
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
                                         Case 9
                                              Set Out9
                                         Case 10
                                              Set Out10
                                         Case 11
                                              Set Out11
                                         Case 12
                                              Set Out12
                                         Case 13
                                              Set Out13
                                         Case 14
                                              Set Out14


                                End Select
End Sub

sub readouts
    outs.1=out1
    outs.2=out2
    outs.3=out3
    outs.4=out4
    outs.5=out5
    outs.6=out6
    outs.7=out7
    outs.8=out8
    outs.9=out9
    outs.10=out10
    outs.11=out11
    outs.12=out12
    outs.13=out13
    outs.14=out14

end sub

Sub Findorder


        Select Case Cmd
               Case 151
                If Wantid = 1 Then
                                Call Turnout
                End If
               Case 158
                    Call Clearids
               Case 159
                    If Id >= Minid And Id <= Maxid Then
                       For I = 1 To Counterid
                           If Eoutid1(i) = Id Then
                              Set Tempon
                              If Outs.i = 0 Then Temponid(i) = 1
                              Outs.i = 1
                              J = I
                              Call Setouts
                           End If
                       Next
                    End If
               Case 160

               Case 180

                           If Id > 0 And Id < 100 Then
                           For I = 1 To Counterid
                               'If Eoutsnum(i) = Id Then
                               If Eoutid1(i) = Id Or Eoutid2(i) = Id Or Eoutid3(i) = Id Then
                                  Tempon(id) = 0
                                  J = I
                                  Status = Normal
                                  If Outs.j = 1 Then Outs.j = 0 Else Outs.j = 1
                                  Call Setouts
                               End If
                           Next
                           End If
               Case 181

                           If Id > 0 And Id < 100 Then
                           For I = 1 To Counterid
                               'If Eoutsnum(i) = Id Then
                               If Eoutid1(i) = Id Or Eoutid2(i) = Id Or Eoutid3(i) = Id Then
                                  Tempon(id) = 0
                                  J = I
                                  Status = Normal
                                  Outs.j = 0
                                  Call Setouts
                               End If
                           Next
                           End If
               Case 182
                           If Id > 0 And Id < 100 Then
                           For I = 1 To Counterid
                               'If Eoutsnum(i) = Id Then
                               If Eoutid1(i) = Id Or Eoutid2(i) = Id Or Eoutid3(i) = Id Then
                                  Tempon(id) = 0
                                  J = I
                                  Status = Normal
                                  Outs.j = 1
                                  Call Setouts
                               End If
                           Next
                           End If


               Case 183
                       Set Blank
                       Idblank = Id

               case 200

                    if id=1 then
                       readouts
                       for i= 0 to 14

                       next
                    end if
                    if id=2 then

                    end if
                    if id=3 then

                    end if
                    if id=4 then

                    end if

               case 201


        End Select


End Sub

Rx:

      Disable Urxc
      Do
      Incr f
        Inputbin Maxin
        If Maxin = 232 Then f = 1
        If Maxin = 210 Then f = 5
        Din(f) = Maxin
        waitms 1
      Loop Until Ischarwaiting() = 0
      If f = 5 Then
         typ=din(2):cmd=din(3):id=din(4)
         if typ=relaymodule then
            findorder
         end if
      End If
      Enable Urxc
Return

'(

Rx:
      Incr F
      Inputbin Maxin

      If F = 5 And Maxin = 210 Then Set Inok
      If Maxin = 232 Then F = 1

      Din(f) = Maxin

      If Inok = 1 Then
        Typ = Din(2)
        If Typ = Keyin Or Typ = Remote Or Typ = Relaymodules Then
           Toggle Rxtx
           Typ = Din(2) : Cmd = Din(3) : Id = Din(4)
           Call Findorder
        End If
        F = 0
        Reset Inok
      End If
Return

')

End