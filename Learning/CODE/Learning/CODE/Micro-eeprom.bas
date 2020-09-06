'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 4000000
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
Gosub Beep
Gosub Beep
Reset Led1
Waitms 500
Enable Interrupts

Main:
'Start Watchdog
'************************************************************************ main
Do
'Reset Watchdog
Gosub _read
If Key1 = 0 Then
'Reset Watchdog
'Stop Watchdog
Gosub Beep
Waitms 100
Gosub Keys
'Start Watchdog
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
If Timer1 >= 3500 And Timer1 <= 8800 Then
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
If S(i) >= 120 And S(i) <= 350 Then
S(i) = 0
Else
If S(i) >= 400 And S(i) <= 850 Then
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
Reset Rel1
Reset Rel2
Reset Rel3
Reset Rel4
Set Led1
Keycheck = 1
Waitms 150
Do
If Key1 = 0 Then
Gosub Beep
While Key1 = 0
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
If Ra = Address Then                                        'agar address remote tekrari bod yani ghablan learn shode
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
Incr Rnumber                                                'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
If Rnumber > 100 Then                                       'agar bishtar az 100 remote learn shavad
Rnumber = 100
Set Buzz
Wait 5
Reset Buzz
Else                                                        'agar kamtar az 100 remote bod
Rnumber_e = Rnumber                                         'meghdare rnumber ra dar eeprom zakhore mikonad
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
Reset Led1
Return
'========================================================================= CHECK
Check:
Okread = 1
If Keycheck = 0 Then                                        'agar keycheck=1 bashad yani be releha farman nade
For I = 1 To Rnumber
Ra = Eevar(i)
If Ra = Address Then                                        'code
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
Select Case Code:
Case 1:
Toggle Rel1
Waitms 100
Case 2:
Toggle Rel2
Waitms 100
Case 4:
Toggle Rel3
Waitms 100
Case 8:
Toggle Rel4
Waitms 100
Case Else
End Select
Return
'-------------------------------------------------------------------------- BEEP
Beep:
Set Buzz
Waitms 80
Reset Buzz
Waitms 30
Return




