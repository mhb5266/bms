
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 115200

Configs:
'-------------------------------------------------------------------------------
Config Pinb.0 = Input                                       'RF INPUT
Config Pinc.5 = Output                                      'Buzzer B.2
Config Pind.2 = Output                                      'relay 1
Config Pind.3 = Output                                      'relay 2
Config Pind.4 = Output                                      'relay3
Config Pind.5 = Output                                      'relay4
Config Pinc.4 = Output                                      'led1 learning led
Config Pinc.0 = Input                                       'key1
Config Scl = Portb.2                                        'at24cxx pin6
Config Sda = Portb.1                                        'at24cxx pin5
'--------------------------------- Alias  --------------------------------------
_in Alias Pinb.0                                            'RF input
Buzz Alias Portc.5                                          'B.1
Rel1 Alias Portd.2                                          'relay1
Rel2 Alias Portd.3                                          'relay2
Rel3 Alias Portd.4                                          'relay3
Rel4 Alias Portd.5                                          'relay4
Led1 Alias Portc.4                                          'learning led
Key1 Alias Pinc.0                                           'learn key
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Const Eewrite = 160                                         'eeprom write address
Const Eeread = 161                                          'eeprom read address
'--------------------------------- Timer ---------------------------------------
Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0
'Config Watchdog = 2048
'--------------------------------- Variable ------------------------------------
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
Dim Eaddress As Word                                        'eeprom address variable
Dim E_read As Byte
Dim E_write As Byte
Dim Eevar(100) As Eram Long

Maxconfig:
Enable Interrupts

Enable Urxc
On Urxc rx

En Alias Portd.6 : Config Portd.6 = Output
Wantid_led Alias Portc.2 : Config Portc.2 = Output
Isrequest_led Alias Portc.3 : Config Portc.3 = Output
Dim Maxin As Byte

Dim Din(5) As Byte
Dim Typ As Byte : Typ = 104
Dim Cmd As Byte
Dim Id As Byte

Dim Startbit As Byte
Dim Endbit As Byte : Endbit = 220

Dim Inok As Boolean
Dim Isrequest As Boolean
Dim Wantid As Boolean
Dim Enable_remote As Boolean
Dim Learnnew As Boolean
Dim Clearall As Boolean


Dim Remoteid(10) As Long
Dim Codeid(10) As Byte
Dim Codeids(10) As Byte

Dim Code1(10) As Byte
Dim Code2(10) As Byte
Dim Code4(10) As Byte
Dim Code8(10) As Byte

Dim Code1s(10) As Byte
Dim Code2s(10) As Byte
Dim Code4s(10) As Byte
Dim Code8s(10) As Byte


Dim Remotecounter As Byte
Dim Keylearnd As Byte
Dim Wantidcode As Byte
Dim Raw As Byte
Rxtx Alias Portd.7 : Config Portd.7 = Output

Const Allid = 99
Const Nonid = 0


Const Tomaster = 242
Const Toslave = 232



Declare Sub Findorder
Declare Sub Do_learn
Declare Sub Clear_remotes
Declare Sub Tx
Declare Sub Getid

Startup:
'-------------------------- read rnumber index from eeprom
Rnumber = Rnumber_e
If Rnumber > 100 Then
Rnumber = 0
Rnumber_e = Rnumber
Waitms 10
End If
'------------------- startup
Waitms 500
Set Led1
Set Rxtx
Gosub Beep
Gosub Beep
Reset Led1
Waitms 500
Reset Rxtx


Reset En

Main:
'Start Watchdog
'************************************************************************ main
Do
  'Reset Watchdog


  Gosub _read

  If Learnnew = 1 Then
     Call Do_learn
     Reset Learnnew
  End If

  If Clearall = 1 Then

    Gosub Beep
    Waitms 100
    Call Clear_remotes
    Reset Clearall
  End If

Loop
'*******************************************************************************
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

            I = 0
         End If
      End If
Return
'================================================================ keys  learning
Sub Clear_remotes
     Reset Rel1
     Reset Rel2
     Reset Rel3
     Reset Rel4
     Set Led1
     Keycheck = 1
     Waitms 150
     Do
            'If Key1 = 0 Then
            If Clearall = 1 Then
               Gosub Beep
               'While Key1 = 0
               While Clearall = 1
                     Incr T
                     Waitms 1
                     If T >= 5000 Then
                        T = 0
                        Gosub Beep
                        Rnumber = 0
                        Rnumber_e = Rnumber
                        Waitms 10
                        Set Buzz
                        Waitms 750
                        Reset Buzz
                        Reset Led1
                        Reset Clearall
                        Remotecounter = 0
                        For I = 1 To 10
                            Remoteid(i) = 0
                        Next I
                        Return
                        Exit While
                     End If
               Wend
               If T < 5000 Then
                  T = 0
                  Reset Led1
                  Exit Do
               End If
            End If
     Loop
End Sub
Sub Do_learn:
    Do
           Gosub _read

           If Okread = 1 Then
              Gosub Beep                                        'repeat check
              If Rnumber = 0 Then                               ' agar avalin remote as ke learn mishavad
                 Incr Rnumber
                 Rnumber_e = Rnumber
                 Waitms 10
                 Ra = Address
                 Eevar(rnumber) = Ra
                 Waitms 10
                 Exit Do
              Else                                          'address avalin khane baraye zakhire address remote
                 For I = 1 To Rnumber
                     Ra = Eevar(i)
                     If Ra = Address Then                       'agar address remote tekrari bod yani ghablan learn shode
                        Set Buzz
                        Wait 1
                        Reset Buzz
                        Error = 1
                        Exit For
                     Else
                        Error = 0
                     End If
                 Next
                 If Error = 0 Then                              ' agar tekrari nabod
                    Incr Rnumber                                'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                    If Rnumber > 100 Then                       'agar bishtar az 100 remote learn shavad
                       Rnumber = 100
                       Set Buzz
                       Wait 5
                       Reset Buzz
                    Else                                    'agar kamtar az 100 remote bod
                       Rnumber_e = Rnumber                      'meghdare rnumber ra dar eeprom zakhore mikonad
                       Ra = Address
                       Eevar(rnumber) = Ra
                       Waitms 10
                    End If
                 End If
              End If


              Exit Do
           End If
         Okread = 0
         Reset Led1

    Loop
    Incr Rnumber
    Remoteid(rnumber) = Address

End Sub
Return
'========================================================================= CHECK
Check:
      Okread = 1
      If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
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
'-------------------------------- Relay command
Command:

        Select Case Code
               Case 1
                    Toggle Rel1

               Case 2
                    Toggle Rel2

               Case 4
                    Toggle Rel3

               Case 8
                    Toggle Rel4

        End Select

        If Wantid = 1 Then
           Remoteid(wantidcode) = Address
           Codeid(wantidcode) = Code
           Reset Wantid
           Reset Wantid_led
        End If

        If Isrequest = 1 Then
           For I = 1 To 10
               If Remoteid(i) = Address Then
                  If Codeid(i) = Code Then
                                    id=i
                                    If Codeids(i) = 180 Then Codeids(i) = 181 Else Codeids(i) = 180
                                    Cmd = Codeids(i)
                                    Startbit = Toslave
                                    Call Tx
                                    Exit For
                  End If
               End If
           Next
        End If



        Waitms 200
Return
'-------------------------------------------------------------------------- BEEP
Beep:
Set Buzz
Waitms 80
Reset Buzz
Waitms 30
Return

Sub Getid


End Sub

Sub Findorder

    If Din(2) = Typ Then
            Select Case Din(3)


                Case 150
                  Set Isrequest
                  Reset Learnnew
                  Reset Clearall
                  Set Isrequest_led
                  Reset Wantid_led
                Case 151
                  Reset Learnnew
                  Reset Clearall
                  Wantidcode = Din(4)
                  Select Case Wantidcode
                         Case 1
                              Set Rel1
                         Case 2
                              Set Rel2
                         Case 3
                              Set Rel3
                         Case 4
                              Set Rel4
                  End Select
                  Set Wantid
                  Reset Isrequest_led
                  Set Wantid_led
                  'Call Getid
                Case 156
                  Reset Learnnew
                  Reset Clearall
                  Set Enable_remote
                Case 157
                  Reset Learnnew
                  Reset Clearall
                  Reset Enable_remote
                Case 161
                  Set Learnnew
                  Reset Clearall
                Case 162
                  Reset Learnnew
                  Set Clearall

            End Select


    End If
    Start Timer1
End Sub


Sub Tx:
    If Startbit = Tomaster Then
       Endbit = 220
    Elseif Startbit = Toslave Then
       Endbit = 210
    End If
    Set En
    Waitms 10
    Printbin Startbit ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En



End Sub

Rx:
      Stop Timer1
      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 230 Then Set Inok
      If Maxin = 252 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then
        Toggle Rxtx
        Wantidcode = Din(4)
        If Din(2) = Typ Then Call Findorder
        I = 0
        Reset Inok
      End If


Return


End