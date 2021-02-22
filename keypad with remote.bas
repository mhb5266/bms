'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 9600
'-------------------------------------------------------------------------------
Configs:
         _in Alias Pinb.0 : Config Pinb.0 = Input
        Buzz Alias Portc.5 : Config Pinc.5 = Output
        Led1 Alias Portd.2 : Config Pind.2 = Output
        led2 Alias Portd.3 : Config Pind.3 = Output
        led3 Alias Portd.4 : Config Pind.4 = Output
        led4 Alias Portd.5 : Config Pind.5 = Output
        ledout Alias Portc.4 : Config Pinc.4 = Output
        Touch1 Alias Pinc.0 : Config Pinc.0 = Input
        Touch2 Alias Pinc.0 : Config Pinc.0 = Input
        Touch3 Alias Pinc.0 : Config Pinc.0 = Input
        Touch4 Alias Pinc.0 : Config Pinc.0 = Input

        Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0


Defines:


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
        Dim Ra As Long                                              'fp address
        Dim Rnumber As Byte                                         'remote know
        Dim Rnumber_e As Eram Byte
        Dim Okread As Bit
        Dim Error As Bit
        Dim Keycheck As Bit
        Dim T As Word                                               'check for pushing lean key time
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
        Set ledout
        Gosub Beep
        Gosub Beep
        Reset ledout
        Waitms 500
        Enable Interrupts

Main:

     Do

     Gosub _read

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
           Touch = 1
           Set Led1
           X = 0
           Do
             Waitms 50
             Incr X
             If X = 75 Then Gosub Beepprogram
             If X = 100 Then Exit Do
           Loop Until Touch1 = 1
           If X > 0 And X < 25 Then
              Gosub Keyorder
              Gosub Beep
           End If
           If X > 75 And X < 101 Then Gosub Remoteclear
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
Keys:
     Reset led1
     Reset led2
     Reset led3
     Reset led4
     Set ledout
     Keycheck = 1
     Waitms 150
     Do
       If touch1 = 0 Then
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
                               Reset ledout
                               Return
                               Exit While
                            End If
              Wend
              If T < 5000 Then
                            T = 0
                            Reset ledout
                            Return
              End If
       End If
       ''''''''''''''''''''''''''^^^
       Gosub _read
       If Okread = 1 Then
               Gosub Beep
               ''''''''''''''''''''''repeat check
               If Rnumber = 0 Then                                         ' agar avalin remote as ke learn mishavad
                              Incr Rnumber
                              Rnumber_e = Rnumber
                              Waitms 10
                              Ra = Address
                              Eevar(rnumber) = Ra
                              Waitms 10
                              Exit Do
                              Else                                                     'address avalin khane baraye zakhire address remote
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
                              If Error = 0 Then                                           ' agar tekrari nabod
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
      If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be ledeha farman nade
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
               Case 1
                    Toggle led1
                    Waitms 200
               Case 2
                    Toggle led2
                    Waitms 200
               Case 4
                    Toggle led3
                    Waitms 200
               Case 8
                    Toggle Led4
                    Waitms 200
               Case Else
        End Select
Return

Beep:
     If Beepen = 0 Then Return
     Set Buzz
     Waitms 80
     Reset Buzz
     Waitms 30
Return

Beeperror:
     Set Buzz
     Waitms 300
     Reset Buzz
     Waitms 30
     Return

Beepprogram:


Return

Remotelearn:

     Do
       Gosub _read
       If Okread = 1 Then
               Gosub Beep
               ''''''''''''''''''''''repeat check
               If Rnumber = 0 Then                                         ' agar avalin remote as ke learn mishavad
                              Incr Rnumber
                              Rnumber_e = Rnumber
                              Waitms 10
                              Ra = Address
                              Eevar(rnumber) = Ra
                              Waitms 10
                              Exit Do
                              Else                                                     'address avalin khane baraye zakhire address remote
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
                              If Error = 0 Then                                           ' agar tekrari nabod
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
Return

Remoteclear:

       Rnumber = 0
       Rnumber_e = Rnumber

Return

Keyorder:

Return

Tx:


Return

Rx:


Return


End