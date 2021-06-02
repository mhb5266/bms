'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200

$baud = 9600

Dim Ekeyid As Eram Byte
Dim Keyid As Byte
Keyid = Ekeyid
Waitms 5
'-------------------------------------------------------------------------------
Configs:


         _in Alias Pinc.5 : Config Portc.5 = Input
        Buzz Alias Portc.3 : Config Portc.3 = Output
        Led4 Alias Portd.6 : Config Portd.6 = Output
        Led3 Alias Portd.7 : Config Portd.7 = Output
        Led1 Alias Portb.0 : Config Portb.0 = Output
        Led2 Alias Portd.5 : Config Portd.5 = Output
        Led Alias Portb.5 : Config Portb.5 = Output
        'BUZZ Alias Portc.3 : Config Portc.3 = Output
        Touch2 Alias Pinb.1 : Config Portb.1 = Input
        Touch4 Alias Pinb.2 : Config Portb.2 = Input
        Touch3 Alias Pinb.3 : Config Portb.3 = Input
        Touch1 Alias Pinb.4 : Config Portb.4 = Input

        Sensor Alias Pinc.4 : Config Portc.4 = Input

        Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
        Config Timer0 = Timer , Prescale = 1024
        Enable Interrupts
        Enable Timer0
        On Timer0 T0rutin
        'Enable Urxc
        'On Urxc Rx

        En Alias Portd.2 : Config Portd.2 = Output

        'Pg Alias Portc.3 : Config Portc.3 = Output




Defines:

        Declare Sub Beep
        Declare Sub Beeppro
        Declare Sub Beeperror
        Declare Sub Pasword
        Declare Sub Ledflash
        Declare Sub Trefresh
        Declare Sub Remotelearn
        Declare Sub Remoteclear
        Declare Sub Findorder
        Declare Sub Checkkey

        Dim 4chcode As Eram Byte
        Dim 4ch As Boolean
        Dim Order As String * 6
        Dim Password As Word
        Dim Pass(4) As Byte
        Dim Z As Word
        Dim F As Byte
        Dim Din(5) As Byte
        Dim Maxin As Byte
        Dim Inok As Boolean

        Dim Light As Byte

        Dim Keytouched As Byte
        Const T1 = 20
        Const T2 = 30
        Const T3 = 60

        Dim Mmm As Byte
        Dim L4 As Boolean
        Dim 20ms As Byte
        Dim Secc As Byte

        Dim Endbit As Byte
        Dim Direct As Byte

        Const Tomaster = 252
        Const Tooutput = 232 : Direct = Tooutput


        Dim Tempen As Boolean
        Dim Tempon As Byte

        Dim Typ As Byte
        Dim Id As Byte
        Dim Cmd As Byte
        Const Mytyp = 101
        const relaymodule=110
        Dim Touchid1 As Byte
        Dim Touchid2 As Byte
        Dim Touchid3 As Byte

        Dim El(12) As Eram Byte


        Dim Sensoren As Bit
        Dim Beepen As Bit
        Dim Touch As Byte
        Dim X As Word
        Dim S(24)as Word
        Dim I As Byte
        I = 0
        Dim Saddress As String * 20
        Dim Scode As String * 4
        Dim Address As Long
        Dim Code As Byte
        ''''''''''''''''''''''''''''''''
        Dim Ra As Long                                      'fp address
        Dim Rnumber As Byte                                 'remote know
        Dim Rnumber_e As Eram Byte
        Dim Okread As Bit
        Dim Error As Bit
        Dim Keycheck As Bit
        Dim T As Word
        Dim P As Byte                                       'check for pushing lean key time
        Error = 0
        Okread = 0
        T = 0
        Keycheck = 0
        'Dim Eaddress As Word                                        'eeprom address variable
        'Dim E_read As Byte
        'Dim E_write As Byte
        Dim Eevar(2) As Eram Long



Startup:

        Set Sensoren
        Set Beepen

        Rnumber = Rnumber_e
        If Rnumber > 10 Then
        Rnumber = 0
        Rnumber_e = Rnumber
        Waitms 10
        End If
        '------------------- startup
        Waitms 500
        Set Buzz
        Beep
        Beep
        Reset Buzz
        Waitms 500
        Enable Interrupts



Noid:
        Reset Led1
        Reset Led2
        Reset Led3
        Reset Led4
        Waitms 500
        Reset Okread
        If Keyid = 255 Then
                Keyid = 0
                Do
                  If Touch1 = 0 Then
                     Set Okread
                     Reset Led1
                     Reset Led2
                     Reset Led3
                     Reset Led4
                     Incr Keyid
                     Beep
                     Do
                     Loop Until Touch1 = 1
                     Waitms 200
                  End If
                  If Touch2 = 0 Or Touch3 = 0 Then Beep
                  If Touch4 = 0 Then
                     If Keyid > 0 And Keyid < 50 Then
                        Ekeyid = Keyid
                        Waitms 5
                        Beep
                        Exit Do
                     End If
                  End If
                  Incr I
                  Waitms 15
                  If I = 40 Then
                     I = 0
                  End If
                  If Okread = 0 Then
                                    If I >= 0 And I < 11 Then
                                       Set Led1
                                       Reset Led2
                                       Reset Led3
                                       Reset Led4
                                    End If
                                    If I > 10 And I < 21 Then
                                       Reset Led1
                                       Set Led2
                                       Reset Led3
                                       Reset Led4
                                    End If
                                    If I > 20 And I < 31 Then
                                       Reset Led1
                                       Reset Led2
                                       Reset Led3
                                       Set Led4
                                    End If
                                    If I > 30 And I < 41 Then
                                       Reset Led1
                                       Reset Led2
                                       Set Led3
                                       Reset Led4
                                    End If

                  End If

                Loop
                Reset Led

        End If
        Ledflash
        Waitms 2
        For I = 1 To Keyid
            Set Led
            Beep
            Waitms 250
            Reset Led
        Next

        Touchid3 = Keyid * 3
        Touchid1 = Touchid3 - 2
        Touchid2 = Touchid3 - 1

Start Timer0




Main:

     Do

       If Keyid = 255 Or Keyid = 0 Then Gosub Noid
       '(
       Incr P
       If P > 0 And P < 60 Then
        Gosub Refresh
       End If

       If P > 60 And P < 100 Then
          'Stop Timer0
          Gosub _read
          'Start Timer0
       End If
       If P > 100 Then P = 0

')
         Gosub _read
'         Checkkey
       '(
       If Touch1 = 0 Then

          BEEP
          Waitms 100
          Gosub Keys

          End If
')

     Loop
'(
Sectic:
       'Toggle Pg
Return
  ')
Refresh:

        Touch = 0
        If Touch1 = 0 Then
           Touch = 1
           If Tempen = 0 Then
              Toggle Led1
           Else
               Set Led1
               Reset Tempen
               Tempon = 0
           End If

           X = 0
           Do
             Waitms 5
             Incr X
             If X = 750 Then Beeppro
             If X = 1000 Then Exit Do
           Loop Until Touch1 = 1
           If X >= 0 And X < 700 Then
              Beep
              Gosub Keyorder
           End If
           If X >= 750 And X < 1001 Then
              Order = "learn"
              Gosub Pasword
           End If
        End If
        Touch = 0


        If Touch2 = 0 Then
           Touch = 2
           Toggle Led2
           If Tempen = 1 Then
               Set Led1
               Reset Tempen
               Tempon = 0
           End If
           X = 0
           Do
             Waitms 5
             Incr X
             If X = 750 Then
                Toggle Beepen
                Beeppro
                if beepen=1 then beeppro
             End If
             If X = 1000 Then Exit Do
           Loop Until Touch2 = 1
           If X >= 0 And X < 700 Then
              Beep
              Gosub Keyorder
           End If
        End If

        Touch = 0
        If Touch3 = 0 Then
           Touch = 3
           Toggle Led3
           If Tempen = 1 Then
               Set Led1
               Reset Tempen
               Tempon = 0
           End If
           X = 0
           Do
             Waitms 5
             Incr X
             If X = 750 Then
             Beeppro
             if sensoren=1 then beeppro
             endif
             If X = 1000 Then Exit Do
           Loop Until Touch3 = 1
           If X >= 0 And X < 700 Then
              Incr Light
              Gosub Keyorder
              Beep
           End If
           If X => 750 And X < 1001 Then Toggle Sensoren

        End If

        Touch = 0
        If Touch4 = 0 Then
           Toggle Touch4
           If Tempen = 1 Then
               Reset Tempen
               Tempon = 0
           End If
           Touch = 4
           X = 0
           Do
             Waitms 5
             Incr X
             If X = 750 Then Beeppro
             If X = 1000 Then Exit Do
           Loop Until Touch4 = 1
           If X >= 0 And X < 700 Then
              Beep
              Gosub Keyorder
           End If
           If X => 750 And X < 1001 Then
              Order = "clear"
              Gosub Pasword
           End If
        End If




If Sensoren = 1 And Keytouched = 0 And Sensor = 1 Then
   If Tempen = 0 And Led1 = 0 And Led2 = 0 And Led3 = 0 Then
      Typ = Mytyp : Cmd = 182 : Id = Touchid1 : Direct = Tooutput
      Gosub Tx
      Set Tempen
      Tempon = 60
   End If
   If Tempen = 1 And Led2 = 0 And Led3 = 0 Then
      Tempon = 60
   End If
End If

Return


'--------------------------------------------------------------------------read
_read:
Okread = 0
If _in = 1 Then
   Do
      'Reset Watchdog
      If _in = 0 Then Exit Do
      Checkkey
   Loop
   Timer1 = 0
   Start Timer1
   While _in = 0
     Checkkey
   Wend
   Stop Timer1
   If Timer1 >= 9722 And Timer1 <= 23611 Then
      Do
            If _in = 1 Then
               Timer1 = 0
               Start Timer1
               While _in = 1
                     'Reset Watchdog
               Wend
               Stop Timer1
               Incr I
               S(i) = Timer1
            End If
               'Reset Watchdog
            Checkkey
            If I = 24 Then Exit Do
      Loop
      For I = 1 To 24
            Checkkey
            If S(i) >= 332 And S(i) <= 972 Then
               S(i) = 0
            Else
                If S(i) >= 1111 And S(i) <= 2361 Then
                   S(i) = 1
                Else
                    I = 0
                    Address = 0
                    Code = 0
                    Okread = 0
                    Return
                End If
            End If
      Next
      I = 0
      Saddress = ""
      Scode = ""
      For I = 1 To 20
          Saddress = Saddress + Str(s(i))
          Checkkey
      Next
      For I = 21 To 24
          Checkkey
          Scode = Scode + Str(s(i))
      Next
      Address = Binval(saddress)
      Code = Binval(scode)
      Gosub Check
      ''''''''''''''''''''''''''''''''''''''''''
      I = 0
   End If
End If
Return
'================================================================ keys  learning


'========================================================================= CHECK
Check:
      Okread = 1
      If Keycheck = 0 Then                                  'agar keycheck=1 bashad yani be ledeha farman nade
         For I = 1 To Rnumber
             Checkkey
             Ra = Eevar(i)
             Reset 4ch
             If Ra = Address Then                           'code
                If I = 2 Then Set 4ch
                Gosub Command
                Exit For
             End If
         Next
      End If
      Keycheck = 0
Return
'-------------------------------- leday command
Command:

        If 4ch = 0 Then
                Select Case Code
                       Typ = Mytyp
                       Case 1
                            Id = Touchid1
                            Touch = 1
                            If Tempen = 0 Then
                                Toggle Led1
                            Else
                                Set Led1
                                Reset Tempen
                                Tempon = 0
                            End If
                       Case 2
                            Id = Touchid2
                            Toggle Led2
                            Touch = 2
                            If Tempen = 1 Then
                                Set Led1
                                Reset Tempen
                                Tempon = 0
                            End If
                       Case 4
                            Id = Touchid3
                            Toggle Led3
                            Touch = 3
                            If Tempen = 1 Then
                                Set Led1
                                Reset Tempen
                                Tempon = 0
                            End If
                       Case 8
                            Touch = 4
                            If Tempen = 1 Then
                                Set Led1
                                Reset Tempen
                                Tempon = 0
                            End If
                End Select
        Else
            If Code = 4chcode Then Touch = 4 Else Return
        End If
        Beep
        Gosub Keyorder

        'Gosub Tx
        Waitms 200
Return

Sub Beep:

     Reset Led
     If Beepen = 1 Then Set Buzz
     Waitms 50
     Reset Buzz
     Waitms 30
     Set Led
End Sub

 Sub Beeperror:
     Reset Led
     If Beepen = 1 Then Set Buzz
     Waitms 100
     Reset Buzz
     Waitms 30
     Set Led
  End Sub

Sub Beeppro:
     Reset Led
     Set Buzz
     Waitms 100
     Reset Buzz
     Waitms 75
     Set Buzz
     Waitms 100
     Reset Buzz
     Waitms 75
     Set Led
End Sub



Sub Remotelearn
     For I = 1 To 8
         Toggle Led1
         Waitms 200
     Next
     Set Led1
     Wait 1
     Reset Led1

     Do
       Gosub _read
       If Okread = 1 Then
               Beep
               ''''''''''''''''''''''repeat check
               If Rnumber = 0 Then                          ' agar avalin remote as ke learn mishavad
                              Incr Rnumber
                              Rnumber_e = Rnumber
                              Waitms 10
                              Ra = Address
                              Eevar(rnumber) = Ra
                              Waitms 10
                              Exit Do
                              Else                          'address avalin khane baraye zakhire address remote
                              For I = 1 To Rnumber
                                  Ra = Eevar(i)
                                  If Ra = Address Then      'agar address remote tekrari bod yani ghablan learn shode
                                     Beeperror
                                     Error = 1
                                     Exit For
                                  Else
                                     Error = 0
                                  End If
                              Next
                              If Error = 0 Then             ' agar tekrari nabod
                                 Incr Rnumber               'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                                 If Rnumber > 2 Then        'agar bishtar az 100 remote learn shavad
                                    Rnumber = 2
                                    Beeppro
                                 Else                       'agar kamtar az 100 remote bod
                                    Rnumber_e = Rnumber     'meghdare rnumber ra dar eeprom zakhore mikonad
                                    Ra = Address
                                    If Rnumber = 2 Then 4chcode = Code
                                    Waitms 10
                                    Eevar(rnumber) = Ra
                                    Waitms 10
                                    For I = 1 To 8
                                        Toggle Led1
                                        Waitms 250
                                    Next
                                 End If
                              End If
               End If
               Exit Do
       End If
     Loop
End Sub

 Sub Remoteclear


       For I = 1 To 8
           Toggle Led1
           Rnumber = 0
           Rnumber_e = Rnumber
           waitms 50
           eevar(i)=0
           Waitms 50
           waitms 400
       Next
End Sub

Keyorder:
         Direct = Tooutput
         Typ = Mytyp

         Keytouched = 10
            Tempen = 0 : Tempon = 0


         If Touch = 1 Then
            If Led1 = 0 Then Cmd = 181 Else Cmd = 182
            Id = Touchid1
            Gosub Tx
         End If

         If Touch = 2 Then
            If Led2 = 0 Then Cmd = 181 Else Cmd = 182
            Id = Touchid2
            Gosub Tx
         End If

         If Touch = 3 Then
            Id = Touchid3
            cmd=180
            gosub tx
            If Light > 4 Then Light = 1
            If Light = 1 Then Cmd = 161
            If Light = 2 Then Cmd = 162
            If Light = 3 Then Cmd = 163
            If Light = 4 Then Cmd = 164

            Gosub Tx
         End If

         If Touch = 4 Then
            Mmm = 0
            If Led1 = 1 Then Incr Mmm
            If Led2 = 1 Then Incr Mmm
            If Led3 = 1 Then Incr Mmm

            If Mmm > 1 Then Set L4 Else Reset L4
            'Toggle L4
            If L4 = 1 Then Cmd = 181 Else Cmd = 182
            For I = 1 To 4
                If I = 1 Then
                   Id = Touchid1
                   If L4 = 1 Then Reset Led1 Else Set Led1
                End If

                If I = 2 Then
                   Id = Touchid2
                   If L4 = 1 Then Reset Led2 Else Set Led2
                End If

                If I = 3 Then
                   Id = Touchid3
                   If L4 = 1 Then Reset Led3 Else Set Led3
                End If

                If I = 4 Then
                   If L4 = 1 Then Reset Led4 Else Set Led4
                   Touch = 0
                   Return
                End If
                Gosub Tx
                Waitms 200

            Next
         End If
         Touch = 0


Return

Tx:
    If Direct = Tooutput Then Endbit = 210
    If Direct = Tomaster Then Endbit = 230
    typ=relaymodule
    Set En
    Waitms 10
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En

Return

T0rutin:
        Stop Timer0
             Incr 20ms
             If 20ms = 42 Then
                20ms = 0
                Incr Secc
                'Toggle Pg
                If Keytouched > 0 Then
                   Decr Keytouched
                   'Toggle Led
                   If Keytouched = 0 Then
                      'Reset Led
                   End If
                End If
                If Tempon > 0 Then
                   Decr Tempon
                   Toggle Led1
                   If Tempon < 13 And Tempon > 9 Then
                      Beep
                   End If
                   If Tempon = 0 Then
                      Cmd = 181 : Id = Touchid1 : Direct = Tooutput : Typ = Mytyp
                      Reset Led1
                      Reset Tempen
                      Gosub Tx
                   End If
                End If
             End If
        Start Timer0
Return

Rx:


      Incr F
      Inputbin Maxin


      If F = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then F = 1

      Din(f) = Maxin

      If Inok = 1 Then

        Typ = Din(2)
        If Typ = Mytyp Then
           Cmd = Din(3)
           Id = Din(4)
           For I = 1 To 8
               Toggle Led
               Waitms 100
           Next
           Findorder
        End If
        I = 0
        Reset Inok
      End If


Return

Sub Pasword
    Waitms 200
    Ledflash
    For I = 1 To 4
        X = 0
        Do
          Incr X
          If X > 400 Then
             Beeperror
             Exit For
          End If
          Waitms 50
          Trefresh
        Loop Until Touch > 0
        Pass(i) = Touch
        Waitms 100
        Do
          Trefresh
        Loop Until Touch = 0
    Next
    If Pass(1) = 4 And Pass(2) = 1 And Pass(3) = 1 And Pass(4) = 4 Then
       Beeppro
       If Order = "clear" Then Remoteclear
       If Order = "learn" Then Remotelearn
    Elseif Pass(1) = 2 And Pass(2) = 2 And Pass(3) = 3 And Pass(4) = 3 Then
           Keyid = 255
           Ekeyid = Keyid
           Waitms 30
           Beeppro
           Gosub Noid
    Else
        Beeperror
    End If
End Sub

Sub Trefresh
         Touch = 0
         If Touch1 = 0 Then
            Set Led1
            Touch = 1
            Beep
            Reset Led1
         End If

         If Touch2 = 0 Then
            Set Led2
            Touch = 2
            Beep
            Reset Led2
         End If
         If Touch3 = 0 Then
            Set Led3
            Touch = 3
            Beep
            Reset Led3
         End If
         If Touch4 = 0 Then
            Set Led4
            Touch = 4
            Beep
            Reset Led4
         End If

End Sub

Sub Ledflash
For I = 1 To 4
        Set Led1
        Reset Led2
        Reset Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Set Led2
        Reset Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Reset Led3
        Set Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Set Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Reset Led3
        Reset Led4
Next
End Sub



Sub Findorder
Stop Timer0
     Select Case Cmd
            Case 152
                 Set Beepen
            Case 153
                 Reset Beepen
            Case 154
                 Set Sensoren
            Case 155
                 Reset Sensoren
            Case 158
                 If Id = Keyid Then
                    Reset Led1
                    Reset Led2
                    Reset Led3
                    Reset Led4
                    Direct = Tooutput
                    Cmd = 181
                    Typ = Mytyp
                    For I = 1 To 3
                        If I = 1 Then Id = Touchid1
                        If I = 2 Then Id = Touchid2
                        If I = 3 Then Id = Touchid3
                        Gosub Tx
                        Waitms 750
                    Next
                 End If
             Case 159
                  Keyid = 255
                  Ekeyid = Keyid
                  Waitms 30
             Case 200
                  I = Id * 3
                  El(i) = Light
                  If Led2 = 1 Then El(i -1) = 1 Else El(i -1) = 0
                  If Led1 = 1 Then El(i -2) = 1 Else El(i -2) = 0
                  Beeppro
             Case 201
                  I = Id * 3
                  Light = El(i)
                  If Light < 4 Then Set Led3 Else Reset Led3
                  If El(i -1) = 1 Then Set Led2 Else Reset Led2
                  If El(i -2) = 1 Then Set Led1 Else Reset Led1
                  I = Keyid * 5
                  Wait I
                  For I = 1 To 3
                      Touch = I
                      Gosub Keyorder
                      Waitms 500
                  Next
     End Select
Start Timer0
End Sub

Sub Checkkey
    If Touch1 = 0 Or Touch2 = 0 Or Touch3 = 0 Or Touch4 = 0 Or Sensor = 1 Then Gosub Refresh
End Sub

End