'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 115200


Config_rxtx:

Enable Interrupts
Enable Urxc
On Urxc Rx

Rxtx Alias Portd.7 : Config Portd.7 = Output
Wantid_led Alias Portc.3 : Config Portc.3 = Output
Isrequest_led Alias Portc.2 : Config Portc.2 = Output
En Alias Portd.6 : Config Portd.6 = Output
Dim Maxin As Byte

Dim Inok As Boolean

Dim Id As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Din(5) As Byte
Dim Wic As Byte
Dim Direct As Byte
Dim Endbit As Byte
Dim Cmdcode As Byte

Dim Numcounter As Byte
Dim Idcounter As Byte
Dim Eidcounter As Eram Byte
Idcounter = Eidcounter
If Idcounter = 255 Then Idcounter = 50
Eidcounter = Idcounter
Dim Remoteid(40) As Eram Byte
Dim Codeid(40) As Eram Byte
Dim Setid(40) As Eram Byte

Dim Raw As Byte
Dim H As Byte
Dim X As Byte
Dim W As Byte
Dim Test As Byte

Dim Isrequest As Boolean
Dim Wantid As Boolean
Dim Clearall As Boolean
Dim Learnnew As Boolean
Dim Enable_remote As Boolean

'Dim Eevar(10) As Eram Byte


Const Tomaster = 252
Const Toinput = 242
Const Tooutput = 232
Const Mytyp = 104

Declare Sub Tx
Declare Sub Checkanswer
Declare Sub Do_learn
Declare Sub Clear_remotes
Declare Sub Beep
Declare Sub Errorbeep
Declare Sub Order

Config_remote:

'-------------------------------------------------------------------------------
Config Pinb.0 = Input                                       'RF INPUT
Config Pinc.1 = Output                                      'Buzzer B.1
Config Pind.2 = Output                                      'relay 1
Config Pind.3 = Output                                      'relay 2
Config Pind.4 = Output                                      'relay3
Config Pind.5 = Output                                      'relay4
Config Pinc.0 = Output                                      'led1 learning led
Config Pinb.1 = Input                                       'key1
Config Scl = Portc.5                                        'at24cxx pin6
Config Sda = Portc.4                                        'at24cxx pin5
'--------------------------------- Alias  --------------------------------------
_in Alias Pinb.0                                            'RF input
Buzz Alias Portc.0                                          'B.1
Rel1 Alias Portd.2                                          'relay1
Rel2 Alias Portd.3                                          'relay2
Rel3 Alias Portd.4                                          'relay3
Rel4 Alias Portd.5                                          'relay4
Led1 Alias Portc.1                                          'learning led
Key1 Alias Pinb.1                                           'learn key
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
Dim M As String * 8
Dim M1 As String * 2
Dim M2 As String * 2
Dim M3 As String * 2
'-------------------------- read rnumber index from eeprom
Gosub Rnumber_er
If Rnumber > 100 Then
Rnumber = 0
Gosub Rnumber_ew
End If
'------------------- startup
Waitms 500
Set Led1
Call Beep
call beep
Reset Led1
Waitms 500

For I = 0 To 40
    If Remoteid(i) > 0 And Remoteid(i) <> 255 Then Incr Numcounter
Next


Main:
'Start Watchdog
'************************************************************************ main
Do

  Gosub _read
  If Key1 = 0 Then

    Call Beep
    Waitms 100
    Gosub Keys

  End If

Loop
'*****************************************
'-------------------------------------read
_read:
      Okread = 0
      If _in = 1 Then
         Do
           If _in = 0 Then Exit Do
         Loop
         Timer1 = 0
         Start Timer1
         While _in = 0

         Wend
         Stop Timer1
         If Timer1 >= 9722 And Timer1 <= 23611 Then
            Do
              If _in = 1 Then
                 Timer1 = 0
                 Start Timer1
                 While _in = 1

                 Wend
                 Stop Timer1
                 Incr I
                 S(i) = Timer1
              End If

              If I = 24 Then Exit Do
            Loop
            For I = 1 To 24
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

'========================================================================= keys  learning
Keys:
     Reset Rel1
     Reset Rel2
     Reset Rel3
     Reset Rel4
     Set Led1
     Keycheck = 1                                                'hengame learn kardan be releha farman nade
     Waitms 150
     Do
       If Key1 = 0 Then                                     ' agar kelid feshorde bemanad
          Call Beep
          While Key1 = 0
                Incr T
                Waitms 1
                If T >= 5000 Then
                   T = 0
                   Call Beep
                   Rnumber = 0
                   Gosub Rnumber_ew
                   Set Buzz
                   Wait 1
                   Wait 1
                   Reset Buzz
                   Reset Led1
                   Return
                   Exit While
                End If
          Wend
          If T < 5000 Then
                    T = 0
                    Reset Led1
                    Return
          End If
       End If
     Loop
Return


'================================================================ CHECK   code chek ok
Check:
      Okread = 1
      If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
         Eaddress = 10
         For I = 1 To Rnumber
             Gosub Ra_r
             If Ra = Address Then
                Raw = I                                     'code
                Gosub Command
                Call Beep
                Exit For
             End If
             Eaddress = Eaddress + 1
         Next
      End If
      Keycheck = 0
Return
'-------------------------------- Relay command
Command:

        'If Code = 1 Then Toggle Rel1
        'If Code = 2 Then Toggle Rel2
        'If Code = 3 Then Toggle Rel3
        'If Code = 4 Then Toggle Rel4

        Toggle Rel1

        If Wantid = 1 Then

           For I = 0 To Numcounter
               If Remoteid(i) = Raw Then
                  Exit For
               Else
                   If Codeid(i) = Code Then
                      Exit For
                   Else
                       Incr Idcounter
                       Incr Numcounter
                       Remoteid(numcounter) = Raw
                       Codeid(numcounter) = Code
                       Setid(numcounter) = Idcounter
                       For Test = 1 To 4
                           Toggle Wantid_led
                           Wait 1
                       Next
                   End If
               End If

           Next

        End If

        If Isrequest = 1 Then
           'Reset Wantid
           'Reset Wantid_led
           For H = 0 To Numcounter
               If Remoteid(h) = Raw Then
                  If Codeid(h) = Code Then
                     Id = Setid(h)
                     'If Codes(h) = 180 Then Codes(h) = 181 Else Codes(h) = 180
                     Cmd = 180
                     Typ = Mytyp
                     Direct = Tooutput
                     Call Tx
                     Exit For
                  End If
               End If
           Next H
        End If


Return
'---------------------- for write a byte to eeprom
Eew:
I2cstart
I2cwbyte Eewrite
I2cwbyte Eaddress                                           'A
I2cwbyte E_write
I2cstop
Waitms 10
Return
'''''''''''''''''''''' for read a byte to eeprom
Eer:
I2cstart
I2cwbyte Eewrite
I2cwbyte Eaddress                                           'A
I2cstart
I2cwbyte Eeread
I2crbyte E_read , Nack
I2cstop
Return

'--------------------------------- rnumber_er >eeprom read remote number learn
Rnumber_er:
Eaddress = 1
Gosub Eer
Rnumber = E_read
Return
'----------------------- rnumber_ew
Rnumber_ew:
Eaddress = 1
E_write = Rnumber
Gosub Eew
Return
'----------------------ra_w   write address code to eeprom
Ra_w:
M = ""
M = Hex(ra)
M1 = Mid(m , 3 , 2)
M2 = Mid(m , 5 , 2)
M3 = Mid(m , 7 , 2)
Gosub Decode
E_write = Hexval(m1)
Gosub Eew
Incr Eaddress
E_write = Hexval(m2)
Gosub Eew
Incr Eaddress
E_write = Hexval(m3)
Gosub Eew
Return
'----------------------ra_r  read address code from eeprom
Ra_r:
Gosub Eer
M1 = Hex(e_read)
Incr Eaddress
Gosub Eer
M2 = Hex(e_read)
Incr Eaddress
Gosub Eer
M3 = Hex(e_read)
M = ""
M = M + M1
M = M + M2
M = M + M3
Ra = Hexval(m)
Return
'------------------------------------------------------decode eeprom address
Decode:
       Select Case Rnumber
              Case 1
              Eaddress = 10
              Case 2
              Eaddress = 13
              Case 3
              Eaddress = 16
              Case 4
              Eaddress = 19
              Case 5
              Eaddress = 22
              Case 6
              Eaddress = 25
              Case 7
              Eaddress = 28
              Case 8
              Eaddress = 31
              Case 9
              Eaddress = 34
              Case 10
              Eaddress = 37
              Case 11
              Eaddress = 40
              Case 12
              Eaddress = 43
              Case 13
              Eaddress = 46
              Case 14
              Eaddress = 49
              Case 15
              Eaddress = 52
              Case 16
              Eaddress = 55
              Case 17
              Eaddress = 58
              Case 18
              Eaddress = 61
              Case 19
              Eaddress = 64
              Case 20
              Eaddress = 67
              Case 21
              Eaddress = 70
              Case 22
              Eaddress = 73
              Case 23
              Eaddress = 76
              Case 24
              Eaddress = 79
              Case 25
              Eaddress = 82
              Case 26
              Eaddress = 85
              Case 27
              Eaddress = 88
              Case 28
              Eaddress = 91
              Case 29
              Eaddress = 94
              Case 30
              Eaddress = 97
              Case 40
              Eaddress = 100
              Case 41
              Eaddress = 103
              Case 42
              Eaddress = 106
              Case 43
              Eaddress = 109
              Case 44
              Eaddress = 112
              Case 45
              Eaddress = 115
              Case 46
              Eaddress = 118
              Case 47
              Eaddress = 121
              Case 48
              Eaddress = 124
              Case 49
              Eaddress = 127
              Case 50
              Eaddress = 130
              Case 51
              Eaddress = 133
              Case 52
              Eaddress = 136
              Case 53
              Eaddress = 139
              Case 54
              Eaddress = 142
              Case 55
              Eaddress = 145
              Case 56
              Eaddress = 148
              Case 57
              Eaddress = 151
              Case 58
              Eaddress = 154
              Case 59
              Eaddress = 157
              Case 60
              Eaddress = 160
              Case 70
              Eaddress = 163
              Case 71
              Eaddress = 166
              Case 72
              Eaddress = 169
              Case 73
              Eaddress = 172
              Case 74
              Eaddress = 175
              Case 75
              Eaddress = 178
              Case 76
              Eaddress = 181
              Case 77
              Eaddress = 184
              Case 78
              Eaddress = 187
              Case 79
              Eaddress = 190
              Case 80
              Eaddress = 193
              Case 81
              Eaddress = 196
              Case 82
              Eaddress = 199
              Case 83
              Eaddress = 202
              Case 84
              Eaddress = 205
              Case 85
              Eaddress = 208
              Case 86
              Eaddress = 211
              Case 87
              Eaddress = 214
              Case 88
              Eaddress = 217
              Case 89
              Eaddress = 220
              Case 90
              Eaddress = 223
              Case 91
              Eaddress = 226
              Case 92
              Eaddress = 229
              Case 93
              Eaddress = 232
              Case 94
              Eaddress = 235
              Case 95
              Eaddress = 238
              Case 96
              Eaddress = 241
              Case 97
              Eaddress = 244
              Case 98
              Eaddress = 247
              Case 99
              Eaddress = 250
              Case 100
              Eaddress = 253
              Case Else
       End Select
Return
'-------------------------------------------------------------------------------



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



End



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
                  Reset Wantid

                Case 151

                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Cmdcode = 180
                  Set Wantid
                  Reset Isrequest
                  Reset Isrequest_led
                  'Set Wantid_led


                Case 156

                  Reset Learnnew
                  Reset Clearall
                  Set Enable_remote

                Case 157

                  Reset Learnnew
                  Reset Clearall
                  Reset Enable_remote

                Case 158
                     'Ercounter = 0
                     For I = 1 To 40
                         Remoteid(i) = 0
                         Codeid(i) = 0
                         Setid(i) = 0
                         Eidcounter = 0
                     Next

                Case 161

                  'Set Learnnew
                  'Reset Clearall
                   Call Do_learn

                Case 162
                  If Id <> 72 Then Return
                  Reset Learnnew
                            Set Led1
                            Reset Rel1
                            Reset Rel2
                            Reset Rel3
                            Reset Rel4
                                  Rnumber = 0
                                  Gosub Rnumber_ew

                            Call Beep
                            Call Beep
                            Call Errorbeep
                            Wait 1
                            Reset Led1
                            Reset Clearall

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

Sub Do_learn
    Do
        Gosub _read
        If Okread = 1 Then
           Call Beep

           If Rnumber = 0 Then                                  ' agar avalin remote as ke learn mishavad
              Incr Rnumber
              Gosub Rnumber_ew
              Ra = Address
              Gosub Ra_w
              Exit Do
           Else
               Eaddress = 10                                    'address avalin khane baraye zakhire address remote
               For I = 1 To Rnumber
                   Gosub Ra_r
                   If Ra = Address Then                         'agar address remote tekrari bod yani ghablan learn shode
                      Set Buzz
                      Wait 1
                      Reset Buzz
                      Error = 1
                      Exit For
                   Else
                       Error = 0
                   End If
                   Eaddress = Eaddress + 1
               Next
               If Error = 0 Then                                ' agar tekrari nabod
                  Incr Rnumber                                  'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                  If Rnumber > 100 Then                         'agar bishtar az 100 remote learn shavad
                     Rnumber = 100
                     Set Buzz
                     Wait 5
                     Reset Buzz
                  Else                                          'agar kamtar az 100 remote bod
                     Gosub Rnumber_ew                           'meghdare rnumber ra dar eeprom zakhore mikonad
                     Ra = Address
                     Gosub Ra_w
                  End If
               End If
           End If
           Exit Do
        End If
    Loop
    Okread = 0
    Reset Led1
Return
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