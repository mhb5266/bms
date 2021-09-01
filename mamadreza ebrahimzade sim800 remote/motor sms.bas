$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600
Config Pinc.5 = Output
Config Pinc.4 = Input
Config Pinc.3 = Output
Config Pinc.2 = Output

Dim A As Bit
Dim R As Byte : R = 0
Dim X As Byte : X = 0
Dim B As Byte
Dim G As Byte
Dim P As Bit : P = 0
Dim Sms As String * 250 : Sms = ""

Wait 3
Set Portc.5
Waitms 60
Reset Portc.5

Wait 5
Hom:
   Print "AT+CMGD=0,4"
   Waitms 500
   Do
      If Pinc.4 = 0 Then Exit Do
   Loop

   Waitms 100
   Do
     Print "AT+CMGR=1"
     Sms = ""
     G = 0
     A = 0
     Do
        B = Inkey()
        Select Case B

           Case 0:
           Case 13:
              Incr G
              If Sms <> "" Then
                 A = 1
                 Exit Do
              End If
           Case 10:
              If Sms <> "" Then
                 A = 1
                 Exit Do
              End If
           Case Else
              If G = 3 Then
                 Sms = Sms + Chr(b)
              End If
        End Select
     Loop


     If A = 1 Then
        If Sms = "ON" Then
           Waitms 200
           R = 1
           Waitms 500
           Exit Do
        End If
        If Sms = "OFF" Then
           Waitms 200
           R = 2
           Waitms 500
           Exit Do
        End If
     End If
   Loop
If R = 1 Then
Set Portc.3

Set Portc.2
R = 0
P = 1
Waitms 50
'----------------
Print "AT"
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; "093**********" ; Chr(34)
Waitms 500
Print "POWER ON" ; Chr(26)
Waitms 600
'----------------
End If
If R = 2 Then
Reset Portc.3
Reset Portc.2
R = 0
P = 0
Waitms 50
'----------------
Print "AT"
Waitms 500
Print "AT+CMGF=1"
Waitms 500
Print "AT+CMGS=" ; Chr(34) ; "093**********" ; Chr(34)
Waitms 500
Print "POWER OFF" ; Chr(26)
Waitms 600

'----------------
End If
Gosub Sss
Goto Hom
End
Sss:
Sho:
Print "AT+CMGR=1"
Sms = ""
Incr X
Do
B = Inkey()
Select Case B
Case 0:
Case 13:
If Sms <> "" Then Exit Do
Case 10:
If Sms <> "" Then Exit Do
Case Else
Sms = Sms + Chr(b)
End Select
Loop
If X = 1 Then Goto Sho
If X = 2 Then Goto Sho
If X = 3 Then Goto Sho
X = 0
Waitms 100
Return