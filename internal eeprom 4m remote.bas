
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 115200

Configs:
'-------------------------------------------------------------------------------
Config Pinb.0 = Input                                       'RF INPUT
Config Pinc.1 = Output                                      'Buzzer B.2
Config Pind.2 = Output                                      'relay 1
Config Pind.3 = Output                                      'relay 2
Config Pind.4 = Output                                      'relay3
Config Pind.5 = Output                                      'relay4
Config Pinc.0 = Output                                      'led1 learning led
'Config Pinc.0 = Input                                       'key1
Config Scl = Portc.5                                        'at24cxx pin6
Config Sda = Portc.4                                        'at24cxx pin5
'--------------------------------- Alias  --------------------------------------
_in Alias Pinb.0                                            'RF input
Buzz Alias Portc.1                                          'B.1
Rel1 Alias Portd.2                                          'relay1
Rel2 Alias Portd.3                                          'relay2
Rel3 Alias Portd.4                                          'relay3
Rel4 Alias Portd.5                                          'relay4
Led1 Alias Portc.0                                          'learning led
'Key1 Alias Pinc.0                                           'learn key
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
Dim Eevar(20) As Eram Long

Maxconfig:
Rxtx Alias Portd.7 : Config Portd.7 = Output
Enable Interrupts

Enable Urxc
On Urxc rx

En Alias Portd.6 : Config Portd.6 = Output
Wantid_led Alias Portc.2 : Config Portc.2 = Output
Isrequest_led Alias Portc.3 : Config Portc.3 = Output
Dim Maxin As Byte

Dim Din(5) As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte

Dim Newaddress As Eram Byte :if newaddress=255 then newaddress=0

Dim direct As Byte
Dim Endbit As Byte : Endbit = 220

Dim Inok As Boolean
Dim Isrequest As Boolean
Dim Wantid As Boolean
Dim Enable_remote As Boolean
Dim Learnnew As Boolean
Dim Clearall As Boolean

Dim Findorder As Byte

Dim Remoteid(40) As Eram Byte
Dim Codeid(40) As Eram Byte
Dim Setid(40) As Eram Byte
Dim Skey(40) As Eram Byte



Dim Raw As Byte

Dim Cmdid(40) As Eram Byte
Dim Cmdcode As Byte

Dim Ercounter As Eram Byte : If Ercounter = 255 Then Ercounter = 0
Dim Rcounter As Byte : Rcounter = Ercounter

Dim Keylearnd As Byte
Dim wic As Byte
Dim Test As Word



Consts:

Const Allid = 99
Const Nonid = 0
Const Mytyp = 104 : : Typ = Mytyp

Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

Const Learndone = 184
Const Cleardone = 185
Const Keywasset = 186
Const Sendkey = 150

Subs:

Declare Sub checkanswer
Declare Sub Do_learn
Declare Sub Clear_remotes
Declare Sub Tx
Declare Sub Getid
Declare Sub Order
Declare Sub Beep
Declare Sub Errorbeep

Startup:
'-------------------------- read rnumber index from eeprom
Rnumber = Rnumber_e
If Rnumber > 20 Then
   Rnumber = 0
   Rnumber_e = Rnumber
   Waitms 10
End If


'------------------- startup
Waitms 500
Set Led1
Set Rxtx
call beep
call beep
Reset Led1
Waitms 500
Reset Rxtx


Reset En
Reset Clearall

Main:
'Start Watchdog
'************************************************************************ main
Do
  'Reset Watchdog

  Reset En
  Incr Test
  If Test = 100 Then
     Test = 0
     Gosub _read
  End If
  'If Learnnew = 1 Then
   '  Call Do_learn
    ' Reset Learnnew
  'End If

  'If Clearall = 1 Then

   ' call beep
    'Waitms 100
    'Call Clear_remotes
    'Reset Clearall
  'End If

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


'========================================================================= CHECK
Check:
      Okread = 1
      If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
         For I = 1 To Rnumber

             Ra = Eevar(i)
             If Ra = Address Then
                Raw = I                                     'code
                Gosub Command
                call beep
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
                   ' Cmd = 163

               Case 8
                    Toggle Rel4
                   ' Cmd = 164

        End Select
        'Direct = Tooutput
        'Call Tx
        If Wantid = 1 Then
           Incr Rcounter
           Ercounter = Rcounter

           Remoteid(rcounter) = Raw
           Codeid(rcounter) = Code
           Setid(rcounter) = Wic

           Reset Wantid

           Reset Isrequest
           Reset Isrequest_led
        End If

        If Isrequest = 1 Then
           Toggle Isrequest_led
           For I = 1 To 40

               If Remoteid(i) = Raw Then
                  If Codeid(i) = Code Then
                                    Id = Setid(i)
                                    If Skey(i) = 180 Then Skey(i) = 181 Else Skey(i) = 180
                                    Cmd = Skey(i)
                                    Direct = Tooutput
                                    Call Tx
                                    Exit For
                  End If
               End If

           Next
        End If
        Reset Wantid_led


        Waitms 200
Return
'-------------------------------------------------------------------------- BEEP


Rx:

      Incr I
      Inputbin Maxin


      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then I = 1

      Din(i) = Maxin

      If Inok = 1 Then

        Reset Inok
        Wic = Din(4)
        Id = Wic
        I = 0
        If Din(2) = 104 Then Call Checkanswer


      End If


Return


Sub Errorbeep
    Set Buzz
    Waitms 700
    Reset Buzz
End Sub

Sub Beep
    Set Buzz
    Waitms 80
    Reset Buzz
    Waitms 30
End Sub


Sub Clear_remotes
 '(
If Clearall = 1 Then
     Reset Rel1
     Reset Rel2
     Reset Rel3
     Reset Rel4
     For I = 1 To 50

         Remoteid(i) = 0

         Codeid(i) = 0
     Next I
     Rnumber = 0
     Rnumber_e = Rnumber
     Set Led1
     Call Beep
     Call Beep
     Call Errorbeep
     Wait 1
     Reset Led1
     Reset Clearall
End If
')
End Sub

Sub Do_learn:
    Do
           Gosub _read

           If Okread = 1 Then
              Call Beep                                     'repeat check
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
                    If Rnumber > 20 Then                    'agar bishtar az 100 remote learn shavad
                       Rnumber = 20
                       Set Buzz
                       Wait 5
                       Reset Buzz
                    Else                                    'agar kamtar az 100 remote bod
                       Rnumber_e = Rnumber                  'meghdare rnumber ra dar eeprom zakhore mikonad
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


End Sub



Sub Checkanswer
                   Toggle Rxtx
            Reset Inok
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
                  Wic = Din(4)
                  Cmdcode = 180
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

                Case 158
                     Ercounter = 0
                     For I = 1 To 40
                         Remoteid(i) = 0
                         Codeid(i) = 0
                         Setid(i) = 0
                     Next

                Case 161

                  Set Learnnew
                  Reset Clearall
                  Call Do_learn

                Case 162
                  If Id <> 72 Then Return
                  Reset Learnnew
                            Set Led1
                            Reset Rel1
                            Reset Rel2
                            Reset Rel3
                            Reset Rel4
                            For I = 1 To 50

                                Remoteid(i) = 0

                                Codeid(i) = 0
                            Next I
                            Rnumber = 0
                            Rnumber_e = Rnumber

                            Call Beep
                            Call Beep
                            Call Errorbeep
                            Wait 1
                            Reset Led1
                            Reset Clearall
                  'Set Clearall
                  'Call Clear_remotes
                Case 163
                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Cmdcode = 163
                  Set Wantid
                  Reset Isrequest_led
                  Set Wantid_led
                Case 164
                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Set Wantid
                  Reset Isrequest_led
                  Set Wantid_led
                  Cmdcode = 164
            End Select

End Sub

Sub Order



End Sub

Sub Tx:
    Toggle Rxtx
    If Direct = Tomaster Then
       Endbit = 230
    Elseif Direct = Tooutput Then
       Endbit = 210
    End If
    Set En
    Waitms 10
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset En



End Sub
End