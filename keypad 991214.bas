'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200

$baud = 9600

Dim Keyid As Byte
Keyid = 1
'-------------------------------------------------------------------------------
Configs:
         _in Alias Pinc.5 : Config Portc.5 = Input
        Buzz Alias Portc.3 : Config Portc.3 = Output
        Led4 Alias Portd.5 : Config Portd.5 = Output
        Led3 Alias Portd.6 : Config Portd.6 = Output
        Led1 Alias Portd.7 : Config Portd.7 = Output
        Led2 Alias Portb.0 : Config Portb.0 = Output
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


        En Alias Portd.2 : Config Portd.2 = Output

        'Pg Alias Portc.3 : Config Portc.3 = Output




Defines:

        Declare Sub Beep
        Declare Sub Beeppro
        Declare Sub Beeperror

        Dim Z As Word
        Dim F As Byte
        Dim Din(5) As Byte
        Dim Maxin As Byte
        Dim Inok As Boolean

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

        Dim Touchid1 As Byte
        Dim Touchid2 As Byte
        Dim Touchid3 As Byte

        Touchid3 = Keyid * 3
        Touchid1 = Touchid3 - 2
        Touchid2 = Touchid3 - 1

        Dim Sensoren As Bit
        Dim Beepen As Bit
        Dim Touch As Byte
        Dim X As Byte
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
        Dim Eevar(10) As Eram Long

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


        Reset Led1
        Reset Led2
        Reset Led3
        Reset Led4



Start Timer0




Main:

     Do

       Incr P
       If P > 0 And P < 50 Then
        Gosub Refresh
       End If

       If P > 50 And P < 100 Then
          'Stop Timer0
          Gosub _read
          'Start Timer0
       End If
       If P > 100 Then P = 0



       '(
       If Touch1 = 0 Then

          BEEP
          Waitms 100
          Gosub Keys

          End If
')

     Loop

Sectic:
       'Toggle Pg
Return

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
             Waitms 50
             Incr X
             If X = 75 Then Beeppro
             If X = 100 Then Exit Do
           Loop Until Touch1 = 1
           If X > 0 And X < 25 Then
              Beep
              Gosub Keyorder
           End If
           If X >= 75 And X < 101 Then
              Gosub Remotelearn
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
             Waitms 50
             Incr X
             If X = 75 Then
                Toggle Beepen
                Beeppro
             End If
             If X = 100 Then Exit Do
           Loop Until Touch2 = 1
           If X > 0 And X < 25 Then
              Beep
              Gosub Keyorder
           End If
        End If
'
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
             Waitms 50
             Incr X
             If X = 75 Then Beeppro
             If X = 100 Then Exit Do
           Loop Until Touch3 = 1
           If X > 0 And X < 25 Then

              Gosub Keyorder
              Beep
           End If
           If X => 75 And X < 101 Then Toggle Sensoren
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
             Waitms 50
             Incr X
             If X = 75 Then Beeppro
             If X = 100 Then Exit Do
           Loop Until Touch4 = 1
           If X > 0 And X < 25 Then
              Beep
              Gosub Keyorder
           End If
           If X => 75 And X < 101 Then Gosub Remoteclear
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
   Loop
   Timer1 = 0
   Start Timer1
   While _in = 0
      'Reset Watchdog
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
            If I = 24 Then Exit Do
      Loop
      For I = 1 To 24
            'Reset Watchdog
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
      Next
      For I = 21 To 24
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
             Ra = Eevar(i)
             If Ra = Address Then                           'code
                Gosub Command
                Exit For
             End If
         Next
      End If
      Keycheck = 0
Return
'-------------------------------- leday command
Command:

        Select Case Code
               Typ = Mytyp
               Case 1
                    Id = Touchid1
                    Toggle Led1
                    Touch = 1
               Case 2
                    Id = Touchid2
                    Toggle Led2
                    Touch = 2
               Case 4
                    Id = Touchid3
                    Toggle Led3
                    Touch = 3
               Case 8
                    Touch = 4

        End Select
        Beep
        Gosub Keyorder

        'Gosub Tx
        Waitms 200
Return

Sub Beep:
     If Beepen = 0 Then Return
     Set Buzz
     Waitms 80
     Reset Buzz
     Waitms 30
End Sub

 Sub Beeperror:
     If Beepen = 0 Then Return
     Set Buzz
     Waitms 300
     Reset Buzz
     Waitms 30
  End Sub

Sub Beeppro:

     Set Buzz
     Waitms 200
     Reset Buzz
     Waitms 100
     Set Buzz
     Waitms 200
     Reset Buzz
     Waitms 100
End Sub



Remotelearn:
     For I = 1 To 8
         Toggle Led1
         Waitms 500
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
                                 If Rnumber > 10 Then       'agar bishtar az 100 remote learn shavad
                                    Rnumber = 10
                                    Beeppro
                                 Else                       'agar kamtar az 100 remote bod
                                    Rnumber_e = Rnumber     'meghdare rnumber ra dar eeprom zakhore mikonad
                                    Ra = Address
                                    Eevar(rnumber) = Ra
                                    Waitms 10
                                    For I = 1 To 8
                                        Toggle Led2
                                        Waitms 250
                                    Next
                                 End If
                              End If
               End If
               Exit Do
       End If
     Loop
Return

Remoteclear:

       Rnumber = 0
       Rnumber_e = Rnumber
       For I = 1 To 8
           Toggle Led1
           Waitms 500
       Next
Return

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
            Cmd = 180
            Id = Touchid3
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
                   Toggle Led4
                   If Keytouched = 0 Then
                      Reset Led4
                   End If
                End If
                If Tempon > 0 Then
                   Decr Tempon
                   Toggle Led1
                   If Tempon < 10 Then
                      Beep
                   End If
                   If Tempon = 0 Then
                      Cmd = 181 : Id = Touchid1 : Direct = Tooutput : Typ = Mytyp
                      Reset Led1
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
        If Typ = Mytyp Then Gosub Findorder
        I = 0
        Reset Inok
      End If


Return

Findorder:


Start Timer0
Return

End