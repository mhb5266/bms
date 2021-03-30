
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2

$hwstack = 64
$swstack = 64
$framesize = 64

Config Debounce = 200                                       'Set 150ms as Debounce delay

Relay1 Alias Porta.0 : Config Porta.0 = Output
Relay2 Alias Porta.1 : Config Porta.1 = Output
Relay3 Alias Porta.2 : Config Porta.2 = Output
Pwr Alias Portd.6 : Config Portd.6 = Output
Rii Alias Pind.2 : Config Pind.2 = Input
Sens1 Alias Pind.7 : Config Pind.7 = Input
Sens2 Alias Pinc.0 : Config Pinc.0 = Input


Declare Sub Getline
Declare Sub Send_sms
Declare Sub Sms_check
Declare Sub Dail
Declare Sub Chenge_pass
Declare Sub Mony


Deflcdchar 1 , 31 , 21 , 14 , 4 , 4 , 4 , 4 , 4
Deflcdchar 2 , 1 , 1 , 1 , 5 , 5 , 5 , 21 , 21
Deflcdchar 3 , 32 , 14 , 10 , 21 , 21 , 17 , 31 , 32
Deflcdchar 4 , 32 , 17 , 25 , 21 , 19 , 17 , 32 , 32












'####################################
Dim Listen As Eram Byte
Dim Alarm As Eram Byte
Dim Status1 As Eram Byte
Dim Status2 As Eram Byte
Dim Status3 As Eram Byte
Dim Number As Eram String * 13
Dim Sms As Eram Byte
Dim Pass As Eram String * 4
Dim Pass2 As Eram String * 3

Dim Maxin As String * 10


'------------ Variables and constants for GSM --------------------------------- ------
Dim Num As String * 80
Dim Num2 As String * 80
Dim Msg As String * 160
Dim Inmsg As String * 160
Dim Gstmp As Byte
Dim Ar(10) As String * 20
Dim Count As Byte
Dim Gps As Byte
Dim Pass_stored As String * 13
Dim Sharj As String * 160
Dim S As Byte
Dim X As Byte
Dim Rly1 As String * 3
Dim Rly2 As String * 3
Dim Rly3 As String * 3
Dim Rly4 As String * 3
Dim Alrm As String * 3
Dim P1 As String * 4
Dim P2 As String * 3
Dim Body As Bit




Relay1 = 0
Relay2 = 0
Relay3 = 0
Rii = 1
Sens1 = 1
Sens2 = 1
S = 2
Body = 0

If Sms = 1 Then
Sms = 1
Else
Sms = 0
End If
If Alarm = 1 Then
Alrm = "on"
Else
Alrm = "Off"
End If
Cursor Off
P2 = Pass2

If P2 = "OK" Then
Cls : Lcd "HAVE OLD PASS"
Wait 2
Else
Pass = "1111"
Cls : Lcd "Default Pass Is:" : Locate 2 , 7 : Lcd "1111"
Wait 2
End If

P1 = Pass

Pass_stored = Number
Gps = Status1
If Gps = 1 Then
  Relay1 = 1
  Rly1 = "on"
Else
  Relay1 = 0
  Rly1 = "off"
End If
Gps = Status2
If Gps = 1 Then
  Relay2 = 1
  Rly2 = "on"
Else
  Relay2 = 0
  Rly2 = "Off"
End If
Gps = Status3
If Gps = 1 Then
  Relay3 = 1
  Rly3 = "on"
Else
  Relay3 = 0
  Rly3 = "off"
End If


  Cls
  Locate 1 , 3                                              'Clear display
  Lcd "Initializing"
  Locate 2 , 6
  Lcd "Modem..."
  Set Pwr
  Wait 2
  Reset Pwr



'Wait 5                                                      ' give some time for gsm modem




Print "AT"
Wait 2
Print "AT+CMGD=0,4"
Wait 2
Print "AT+CREG?"
Wait 2
Print "ATE0"
Wait 2
Print "AT+CNMI =1,1,0,0,0"                                  'new message indication off
Wait 2                                                      ' THIRD Command Text Mode
Print "AT+CMGF=1"
Wait 1
Print "AT"
Wait 1

Cls


Main:
Maxin = "no"
Do
                                                    ' THIRD Command Text Mode
Print "AT+CMGF=1"
Wait 1
Waitms 100
Input Maxin
Cls
Lcd Maxin
Wait 2

Loop

Do

  M:


    P:



Loop


End

Sub Send_sms

     Wait 1
     Print "AT+CMGS=" ; Chr(34) ; 09376921503 ; Chr(34)     'send sms
     Waitms 200
     Print "hi" ; Chr(26)
     Wait 5
     Print "AT"
     Wait 1


End Sub
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'    Read gsm modem AND WAITING FOR SMS
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Sub Getline
 Inmsg = ""
 Do
  Gps = Inkey()
  If Gps > 0 Then                                           '++++++++++++++++++++++++++++++++++++++++++
    Select Case Gps
    Case 13 : If Inmsg <> "" Then Exit Do                   ' if we have received something'+++++++++++++++++
    Case 10 : If Inmsg <> "" Then Exit Do                   ' if we have received something '++++++++++++++++++++
    Case Else
      Inmsg = Inmsg + Chr(gps)                              ' build string
    End Select
  End If
 Loop

End Sub
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Sub Dail
Print "Atd" ; Num ; ";"
Wait 10
Print "Ath"
End Sub
'***************************************************************************************
Sub Chenge_pass
Print "AT+CMGD=0,4"
Wait 1
Msg = "Please Send New Pass -4 Raghami Or Send Cancel"
Send_sms
Cls : Lcd "Wait For New pass"
Do
         Wait 2
         Print "AT+CMGR=1"                                  ' get the message
         Getline
         If Inmsg <> "OK" Then                              '+++++++++++++++++++++++++
           Num = Inmsg
           Getline
           Gps = Split(num , Ar(1) , ",")
           Num = Ar(2)
           Gps = Len(num)
           Gps = Gps - 2
           Num = Mid(num , 2 , Gps)
           If Num <> Num2 Then Goto M                       ' for More Security  '+++++++++++++++++++++
           Inmsg = Lcase(inmsg)
           If Inmsg = "Cancel" Then Goto P
           Pass = Inmsg
           P1 = Pass
           Pass2 = "OK"
           Cls : Lcd "Pass Recived"
           Msg = "SUCCESFULL Chenged Password"
           Send_sms
           Goto P
           End If
Loop
End Sub
'***********************************************
Sub Mony
Print "ATD*140*1#"
Getline
Getline
Sharj = Left(inmsg , 77)
Sharj = Right(sharj , 6)
Sharj = Ltrim(sharj)
End Sub