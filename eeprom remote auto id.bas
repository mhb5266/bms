
$regfile = "M8def.dat"
$crystal = 11059200
$baud = 115200


Config_rxtx:

Enable Interrupts
Enable Urxc
On Urxc Rx

En Alias Portd.2 : Config Portd.2 = Output
Dim Maxin As Byte

Dim Inok As Boolean

Dim F As Byte



Dim Newlearn As Bit
Dim Remoteid(10) As Eram Byte



Dim Id As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Din(5) As Byte
Dim Wic As Byte
Dim Direct As Byte
Dim Endbit As Byte
Dim Cmdcode As Byte

Dim Enum As Eram Byte
Dim Num As Byte
Num = Enum
If Num > 100 Then Num = 2



'(
Eidcounter = Idcounter
Dim Remoteid(40) As Eram Byte
Dim Codeid(40) As Eram Byte
Dim Setid(40) As Eram Byte
Dim Gotid As Boolean
Dim Hasid As Boolean
')
Dim Raw As Byte
Dim H As Byte
Dim X As Byte
Dim W As Byte
Dim Test As Byte

Dim Isrequest As Boolean

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
Declare Sub Clearids

Config_remote:

_in Alias Pind.3 : Config Portd.3 = Input
Key1 Alias Pind.6 : Config Portd.6 = Input

Rel1 Alias Portd.7 : Config Portd.7 = Output
Led Alias Portb.0 : Config Portb.0 = Output
Buzz Alias Portb.1 : Config Portb.1 = Output
Rxtx Alias Portb.2 : Config Portb.2 = Output


'-------------------------------------------------------------------------------
'(
Config Pinb.0 = Input                                       'RF INPUT
Config Pinc.1 = Output                                      'Buzzer B.1
Config Pind.2 = Output                                      'relay 1
Config Pind.3 = Output                                      'relay 2
Config Pind.4 = Output                                      'relay3
Config Pind.5 = Output                                      'relay4
Config Pinc.0 = Output                                      'buzz learning led
')                                     'key1
Config Scl = Portc.5                                        'at24cxx pin6
Config Sda = Portc.4                                        'at24cxx pin5
'--------------------------------- Alias  --------------------------------------
'_in Alias Pinb.0                                            'RF input
'Buzz Alias Portc.0                                          'B.1
'Rel1 Alias Portd.2                                          'relay1
'buzz Alias Portc.1                                          'learning led
'Key1 Alias Pinb.1                                           'learn key
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
Set Buzz
Call Beep
Call Beep
Reset Buzz
Waitms 500




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

     Set Buzz
     Keycheck = 1                                           'hengame learn kardan be releha farman nade
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
                   Reset Buzz
                   Return
                   Exit While
                End If
          Wend
          If T < 5000 Then
                    T = 0
                    Reset Buzz
                    Return
          End If
       End If
     Loop
Return


'================================================================ CHECK   code chek ok
Check:
      Okread = 1
      If Keycheck = 0 Then                                  'agar keycheck=1 bashad yani be releha farman nade
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

        If Newlearn = 1 Then

           If Code = 15 Then
              Remoteid(1) = Raw
              Waitms 10
           Elseif Code = 8 Then
              Remoteid(num) = Raw
              Waitms 10
              Incr Num
              Enum = Num
           End If
           Reset Newlearn

           For I = 1 To 8
               Toggle Led
               Waitms 250
           Next I

        End If

        For I = 1 To 10
            If Remoteid(i) = Raw Then
               Select Case I
                      Case 1
                           Id = Lookup(code , Remote16)
                      Case 2
                           Id = Lookup(code , 1remote4)
                      Case 3
                           Id = Lookup(code , 2remote4)
                      Case 4
                           Id = Lookup(code , 3remote4)
                      Case 5
                           Id = Lookup(code , 4remote4)
                      Case 6
                           Id = Lookup(code , 5remote4)
                      Case Else
               End Select
               Cmd = 180
               Typ = Mytyp
               Direct = Tooutput
               Call Tx
               Exit For
            End If
        Next
'(
        If Num = 0 Or Num > 40 Then Num = 1
        Reset Hasid
        For I = 1 To 40
            If Remoteid(i) = Raw And Codeid(i) = Code Then
               If Setid(i) < 100 Or Setid(i) > 55 Then Set Hasid
               If Hasid = 1 Then
                       'If Isrequest = 1 Then
                          For H = 1 To 40
                              If Remoteid(h) = Raw Then
                                    Id = Setid(i)
                                    Cmd = 180
                                    Typ = Mytyp
                                    Direct = Tooutput
                                    Call Tx
                                    Exit For

                              End If
                          Next H
                       'End If
                       Exit For
               End If
            End If
        Next


        If Hasid = 0 Then
           Incr Idcounter
           Incr Num
           Enum = Num
           Eidcounter = Idcounter
           Remoteid(num) = Raw
           Codeid(num) = Code
           Setid(num) = Idcounter
           For X = 1 To 4
               Toggle Buzz
               Waitms 250
           Next
        End If
')



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

      Incr F
      Inputbin Maxin


      If F = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then F = 1

      Din(f) = Maxin

      If Inok = 1 Then

        Reset Inok
        Wic = Din(4)
        Id = Wic
        F = 0
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
     Set buzz
     Call Beep
     Call Beep
     Call Errorbeep
     Wait 1
     Reset buzz
     Reset Clearall
End If
')
End Sub


Sub Checkanswer
                   Toggle Rxtx
            Reset Inok
            Select Case Din(3)


                Case 150
                     Set Led
                     Set Isrequest

                Case 151

                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Cmdcode = 180

                  Reset Isrequest
                  Reset Led
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
                     Call Clearids
                Case 161

                  'Set Learnnew
                  'Reset Clearall
                   Call Do_learn

                Case 162
                     Call Clearids

                Case 163
                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Cmdcode = 163

                  Reset Led
                  'Set Wantid_led
                Case 164
                  Reset Learnnew
                  Reset Clearall
                  Wic = Din(4)
                  Reset Led
                  'Set Wantid_led
                  Cmdcode = 164
            End Select

End Sub

Sub Do_learn
    Do
        Gosub _read
        If Okread = 1 Then
           Call Beep

           If Rnumber = 0 Then                              ' agar avalin remote as ke learn mishavad
              Incr Rnumber
              Gosub Rnumber_ew
              Ra = Address
              Gosub Ra_w
              Set Newlearn
              Exit Do
           Else
               Eaddress = 10                                'address avalin khane baraye zakhire address remote
               For I = 1 To Rnumber
                   Gosub Ra_r
                   If Ra = Address Then                     'agar address remote tekrari bod yani ghablan learn shode
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
               If Error = 0 Then                            ' agar tekrari nabod
                  Incr Rnumber                              'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                  If Rnumber > 100 Then                     'agar bishtar az 100 remote learn shavad
                     Rnumber = 100
                     Set Buzz
                     Wait 5
                     Reset Buzz
                  Else                                      'agar kamtar az 100 remote bod
                     Gosub Rnumber_ew                       'meghdare rnumber ra dar eeprom zakhore mikonad
                     Ra = Address
                     Gosub Ra_w
                     Set Newlearn
                  End If
               End If
           End If
           Exit Do
        End If
    Loop
    Okread = 0
    Reset Buzz
Return
End Sub


Sub Clearids:
             For I = 1 To 10
                 Remoteid(i) = 0
                 Waitms 10

             Next
             Num = 2
             Enum = 2
             Waitms 5
                                  Rnumber = 0
                                  Gosub Rnumber_ew

                            Call Beep
                            Call Beep
                            Call Errorbeep
                            Wait 1
                            Reset Buzz
                            Reset Clearall
                            Din(1) = 0
                            Din(2) = 0
                            Din(3) = 0
                            Din(4) = 0
                            Din(5) = 0

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



Remote16:
Data 60 , 61 , 62 , 63 , 64 , 65 , 66 , 67 , 68 , 69 , 70 , 71 , 72 , 73 , 74 , 75 , 96

1remote4:
Data 0 , 76 , 77 , 0 , 78 , 0 , 0 , 0 , 79

2remote4:
Data 0 , 80 , 81 , 0 , 82 , 0 , 0 , 0 , 83

3remote4:
Data 0 , 84 , 85 , 0 , 86 , 0 , 0 , 0 , 87

4remote4:
Data 0 , 88 , 89 , 0 , 90 , 0 , 0 , 0 , 91

5remote4:
Data 0 , 92 , 93 , 0 , 94 , 0 , 0 , 0 , 95