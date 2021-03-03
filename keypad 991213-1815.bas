'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 9600
'-------------------------------------------------------------------------------
Configs:
         _in Alias Pinb.0 : Config Portb.0 = Input
        Buzz Alias Portc.5 : Config Portc.5 = Output
        Led1 Alias Portd.3 : Config Portd.3 = Output
        Led2 Alias Portd.4 : Config Portd.4 = Output
        Led3 Alias Portd.6 : Config Portd.6 = Output
        Led4 Alias Portd.7 : Config Portd.7 = Output
        Ledout Alias Portc.4 : Config Portc.4 = Output
        Touch1 Alias Pinb.1 : Config Portb.1 = Input
        Touch2 Alias Pinb.2 : Config Portb.2 = Input
        Touch3 Alias Pinb.3 : Config Portb.3 = Input
        Touch4 Alias Pinb.4 : Config Portb.4 = Input

        Sensor Alias Pinc.0 : Config Portc.0 = Input

        Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
        Config Timer0 = Timer , Prescale = 1024
        Enable Interrupts
        Enable Timer0
        On Timer0 T0rutin


        En Alias Portd.2 : Config Portd.2 = Output
Defines:

        Dim F As Byte
        Dim Din(5) As Byte
        Dim Maxin As Byte
        Dim Inok As Boolean

        Dim Alloffon As Boolean
        Dim Keytouched As Word : Const Timeout = 30
        Const T1 = 20
        Const T2 = 30
        Const T3 = 60

        Dim M As Byte
        Dim L4 As Boolean
        Dim 20ms As Byte
        Dim Secc As Word

        Dim Endbit As Byte
        Dim Direct As Byte

        Const Tomaster = 252
        Const Tooutput = 232


        Dim Tempon As Word
        Dim Tempen As Boolean

        Dim Typ As Byte
        Dim Id As Byte
        Dim Cmd As Byte
        Const Mytyp = 101

        Dim Touchid1 As Eram Byte
        Dim Touchid2 As Eram Byte
        Dim Touchid3 As Eram Byte
        Dim Touchid4 As Eram Byte

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
        Dim T As Word                                       'check for pushing lean key time
        Error = 0
        Okread = 0
        T = 0
        Keycheck = 0
        'Dim Eaddress As Word                                        'eeprom address variable
        'Dim E_read As Byte
        'Dim E_write As Byte
        Dim Eevar(10) As Eram Long

Startup:

        Rnumber = Rnumber_e
        If Rnumber > 10 Then
        Rnumber = 0
        Rnumber_e = Rnumber
        Waitms 10
        End If
        '------------------- startup
        Waitms 500
        Set Ledout
        Gosub Beep
        Gosub Beep
        Reset Ledout
        Waitms 500
        Enable Interrupts


        For I = 1 To 8
            Toggle Led1
            Waitms 200
        Next

Main:

     Do

       Gosub _read

       If Secc > 70 Then
                Reset Keytouched
                Reset Tempon
                Stop Timer0
       End If
       If Tempon = 1 Then

          If Secc = T2 Then
             If Led1 = 1 Then
                Reset Led1
                Reset Ledout
                Reset Buzz
                Reset Tempon
                Stop Timer0
                Cmd = 181
                Gosub Tx
             End If
          End If

       Else

           Stop Timer0
           Timer0 = 0

       End If


       Gosub Refresh
       '(
       If Touch1 = 0 Then

          Gosub Beep
          Waitms 100
          Gosub Keys

          End If
')
     Loop

Refresh:

        If Touch1 = 0 Then
           Waitms 30
           Set Ledout
           Touch = 1
           X = 0
           Do
             Waitms 50
             Incr X
             If X = 45 Then Gosub Beepprogram
             If X > 60 Then Exit Do
           Loop Until Touch1 = 1
           keytouched=timeout
           If X < 45 Then Gosub Keyorder Else Gosub Program
        End If

        If Touch2 = 0 Then
           Waitms 30
           Set Ledout
           Touch = 2
           X = 0
           Do
             Waitms 50
             Incr X
             If X = 45 Then Gosub Beepprogram
             If X > 60 Then Exit Do
           Loop Until Touch2 = 1
           keytouched=timeout
           If X < 45 Then Gosub Keyorder Else Gosub Program
        End If

        If Touch3 = 0 Then
           Waitms 30
           Set Ledout
           Touch = 3
           X = 0
           Do
             Waitms 50
             Incr X
             If X = 45 Then Gosub Beepprogram
             If X > 60 Then Exit Do
           Loop Until Touch3 = 1
           keytouched=timeout
           If X < 45 Then Gosub Keyorder Else Gosub Program
        End If

        If Touch4 = 0 Then
           Waitms 30
           Set Ledout
           Touch = 4
           X = 0
           Do
             Waitms 50
             Incr X
             If X = 45 Then Gosub Beepprogram
             If X > 60 Then Exit Do
           Loop Until Touch4 = 1
           Keytouched = Timeout
           If X < 45 Then Gosub Keyorder Else Gosub Program
        End If

        If Keytouched = 0 And Sensoren = 0 And Sensor = 0 And Led2 = 1 And Led3 = 1 Then
           If Led1 = 1 Then
              Id = Touchid1 : Cmd = 182 : Direct = Tooutput
              Set Tempen
              Tempon = T1
              Reset Led1
              Gosub Tx
           Else
               Set Tempen
               Tempon = 0
           End If
        End If

        If Keytouched > 0 Then
           Reset Tempen
           Tempon = 0
        End If
        Waitms 200
        Reset Ledout
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
Keys:
     'Reset Led1
     'Reset Led2
     'Reset Led3
     'Reset Led4
     Set Ledout
     Keycheck = 1
     Waitms 150
     Do
       If Touch1 = 0 Then
              Gosub Beep
              While Touch1 = 0
                            Incr T
                            Waitms 1
                            If T >= 5000 Then
                               T = 0
                               Gosub Beep
                               Rnumber = 0
                               Rnumber_e = Rnumber
                               Waitms 10
                               Set Buzz
                               Wait 1
                               Wait 1
                               Reset Buzz
                               Reset Ledout
                               Return
                               Exit While
                            End If
              Wend
              If T < 5000 Then
                            T = 0
                            Reset Ledout
                            Return
              End If
       End If
       ''''''''''''''''''''''''''^^^
       Gosub _read
       If Okread = 1 Then
               Gosub Beep
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
                                     Set Buzz
                                     Wait 1
                                     Reset Buzz
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
                                    Set Buzz
                                    Wait 5
                                    Reset Buzz
                                 Else                       'agar kamtar az 100 remote bod
                                    Rnumber_e = Rnumber     'meghdare rnumber ra dar eeprom zakhore mikonad
                                    Ra = Address
                                    Eevar(rnumber) = Ra
                                    Waitms 10
                                 End If
                              End If
               End If
               Exit Do
       End If
     Loop
     Okread = 0
     Reset Ledout
Return
'========================================================================= CHECK
Check:
      Okread = 1
      If Keycheck = 0 Then                                  'agar keycheck=1 bashad yani be ledeha farman nade
         For I = 1 To Rnumber
             Ra = Eevar(i)
             If Ra = Address Then                           'code
                Gosub Command
                Gosub Beep
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
                    Id = Touchid4

        End Select
        Gosub Keyorder

        Gosub Tx
        Waitms 200
Return

Beep:
     If Beepen = 0 Then Return
     Set Buzz
     Waitms 80
     Reset Buzz
     Waitms 30
Return

Beeperror:
     If Beepen = 0 Then Return
     Set Buzz
     Waitms 300
     Reset Buzz
     Waitms 30
     Return

Beepprogram:

Return



Remotelearn:
     For I = 1 To 8
         Toggle Led2
         Waitms 500
     Next
     Set Led2
     Wait 1
     Reset Led2

     Do
       Gosub _read
       If Okread = 1 Then
               Gosub Beep
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
                                     Set Buzz
                                     Wait 1
                                     Reset Buzz
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
                                    Set Buzz
                                    Wait 5
                                    Reset Buzz
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
         Select Case Touch
                Case 1
                     Toggle Led1
                     Id = Touchid1
                     If Led1 = 0 Then Cmd = 182 Else Cmd = 181
                Case 2
                     Toggle Led2
                     Id = Touchid2
                     If Led2 = 0 Then Cmd = 182 Else Cmd = 181

                Case 3
                     Toggle Led3
                     Id = Touchid3
                     If Led3 = 0 Then Cmd = 182 Else Cmd = 181
                Case 4
                     Toggle Alloffon
                     If Alloffon = 1 Then Cmd = 182 Else Cmd = 181
         End Select

         If Touch < 4 Then
            Gosub Tx
         Else
            For I = 1 To 4
                If I = 1 Then
                   Id = Touchid1
                   If Alloffon = 1 Then Reset Led1 Else Set Led1
                   Gosub Tx
                End If
                If I = 2 Then
                   Id = Touchid2
                   If Alloffon = 1 Then Reset Led2 Else Set Led2
                   Gosub Tx
                End If
                If I = 3 Then
                   Id = Touchid3
                   If Alloffon = 1 Then Reset Led3 Else Set Led3
                   Gosub Tx
                End If
                If I = 4 Then
                   If Alloffon = 1 Then Reset Led4 Else Set Led4
                End If
                Waitms 250
            Next
         End If


Return
Program:

        Select Case Touch
               Case 1
                    Gosub Remotelearn
               Case 2
                    Toggle Beepen
               Case 3
                    Toggle Sensoren
               Case 4
                    Gosub Remoteclear
        End Select

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
        If 20ms = 50 Then
           Incr Secc
           20ms = 0
           Toggle Ledout
           If Secc > T1 And Secc < T2 Then Toggle Buzz
           If Secc > T2 Or Secc < T1 Then Reset Buzz
           If Secc = 70 Then Reset Keytouched
        End If
        Timer0 = 39
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