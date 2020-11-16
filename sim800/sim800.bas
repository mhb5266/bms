
$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600

Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2

$hwstack = 64
$swstack = 64
$framesize = 64

Config Debounce = 200                                       'Set 150ms as Debounce delay

Config Porta.0 = Output
Config Porta.1 = Output
Config Porta.2 = Output
Config Portd.6 = Output
Config Pind.2 = Input
Config Pind.7 = Input
Config Pinc.0 = Input


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



Relay1 Alias Porta.0
Relay2 Alias Porta.1
Relay3 Alias Porta.2
Pwr Alias Portd.6
Ri Alias Pind.2
Sens1 Alias Pind.7
Sens2 Alias Pinc.0


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
Ri = 1
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



Wait 5                                                      ' give some time for gsm modem




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


Do
M:

'********************************** SENSORHAA****************************
    If Alarm = 1 Then
       If Sens1 = 0 Then
       If Sens1 = 1 Then
       Cls
       Num = Pass_stored
       Lcd "===> SENSED 1 <==="
       Msg = "Amotion In Sensor 1"
       If Sms = 1 Then Send_sms
       If Sms = 0 Then Dail
       Goto P
       End If
       End If



        If Sens2 = 0 Then
        If Sens2 = 1 Then
        Cls
        Num = Pass_stored
        Lcd "===> SENSED 2 <==="
        Msg = "Amotion In Sensor 2"
        If Sms = 1 Then Send_sms
        If Sms = 0 Then Dail
        Goto P
        End If
        End If

    End If
'*********************************Message Sense*******************************************


       If Ri = 0 Then S = 0
         If S < 3 Then
         Incr S
         Print "AT"
         Wait 2
         Print "AT+CMGR=1"                                  ' get the message
         Getline
         If Inmsg <> "OK" Then
           Num = Inmsg
           Getline
           Gps = Split(num , Ar(1) , ",")
           Num = Ar(2)
           Gps = Len(num)
           Gps = Gps - 2
           Num = Mid(num , 2 , Gps)

           Inmsg = Lcase(inmsg)


           If Inmsg = P1 Then                               'password is 333
             Cls
             Locate 1 , 1
             Lcd "===> Password <==="
             Locate 2 , 1
             Lcd "===> Accepted <==="
             Pass_stored = Num
             Number = Pass_stored
             Num2 = Num
             Msg = "Password Accepted"
             Body = 1
             If Sms = 1 Then Send_sms
            If Sms = 0 Then Dail
           Elseif Num = Pass_stored Then
             Body = 1
            Cls
            Lcd "Control msg Rciv"
'**********************************************************************************
             If Inmsg = "1 -on" Then                        '1-on
              Relay1 = 1
              Status1 = 1
              Rly1 = "On"
              Num = Pass_stored
              Msg = "LIGHT Switched On"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "1 -off" Then                   '1-off

              Relay1 = 0
              Status1 = 0
              Rly1 = "Off"
              Num = Pass_stored
              Msg = "LIGHT Switched Off"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "2 -ON" Then
              Relay2 = 1
              Status2 = 1
              Rly2 = " ON"
              Num = Pass_stored
              Msg = "FAN Switched On"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "2 -OFF" Then
              Relay2 = 0
              Status2 = 0
              Rly2 = "OFF"
              Num = Pass_stored
              Msg = "FAN Switched Off"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail
             Elseif Inmsg = "3 -ON" Then
              Relay3 = 1
              Status3 = 1
              Rly3 = "ON"
              Num = Pass_stored
              Msg = "AC Switched On"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "3 -OFF" Then
              Relay3 = 0
              Status3 = 0
              Rly3 = "OFF"
              Num = Pass_stored
              Msg = "AC Switched Off"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = " STATUS" Then
              Cls
              Lcd "Status Checked"
              Num = Pass_stored
              Msg = "1 Is:" + Rly1 + "- -" + "2 Is :" + Rly2 + "- -" + "3 Is :" + Rly3 + "- -" + "Securt Is :" + Alrm
              Send_sms

             Elseif Inmsg = "PASS" Then
             Msg = "SECURITY Password Is =>(" + P1 + ")"
             Send_sms


             Elseif Inmsg = "LISTEN -ON" Then
              Num = Pass_stored
              Listen = 1
              Cls
              Lcd "Listen On"
              Msg = "LISTEN Mod On"
              Send_sms
             Elseif Inmsg = "LISTEN -OFF" Then
              Listen = 0
              Cls
              Lcd "LISTEN Off"
              Msg = "LISTEN Mod Off"
              Send_sms
             Elseif Inmsg = "NEW -PASS" Then
             Chenge_pass


             Elseif Inmsg = "ALL -OFF" Then
              Relay1 = 0
              Status1 = 0
              Relay2 = 0
              Status2 = 0
              Relay3 = 0
              Status3 = 0
              Num = Pass_stored
              Msg = "ALL Channel Switched Off"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "ALARM -ON" Then
              Num = Pass_stored
              Alarm = 1
              Cls : Lcd "SECQRITY On"
              Msg = "SECQRITY System Swiched On"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "ALARM -OFF"then
              Num = Pass_stored
              Alarm = 0
              Cls : Lcd "SECQRITY Off"
              Msg = "SECQRITY System Swiched Off"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail


             Elseif Inmsg = "DAIL"then
              Num = Pass_stored
              Sms = 0
              Cls : Lcd "===> DAIL Mod <==="
              Msg = "DAIL Mod"
              Dail
             Elseif Inmsg = "SMS"then
              Num = Pass_stored
              Sms = 1
              Cls : Lcd "===> SMS Mod <==="
              Msg = "SMS Mod"
             If Sms = 1 Then Send_sms
             If Sms = 0 Then Dail

             Elseif Inmsg = "EXIT"then
              Cls : Lcd "=> Delet Number <="
              Msg = "THIS Number Romoved From Sysyem!"
              If Sms = 1 Then Send_sms
              If Sms = 0 Then Dail
              Body = 0
              Pass_stored = "0"
              Num = "1"
              Number = "2"

             Elseif Inmsg = "Sharj"then

             Num = Pass_stored
             Mony
             Cls
             Lcd "Sharj Rial"
             Msg = Sharj + "Rial"
             Send_sms
             If Sharj < "1000"then
             Dail
             End If

             Wait 3
'***********************************************************************************
             Else
              Num = Pass_stored
              Cls
              Lcd "ERROR Msg"
             End If
           Else
             Cls
             Locate 1 , 3
             Lcd "ERROR Pass"
             Wait 1
             Cls


         End If
         P:

           Wait 1
           Print "AT+CMGD= 0,4"
           Wait 1
           Cls
           Cursor Off
           Locate 1 , 4
           Lcd "{SYSTEM}"
           Locate 2 , 4
           Lcd "{ONLINE}"
           Locate 1 , 15 : Lcd Chr(1)
           Locate 1 , 16 : Lcd Chr(2)
           If Alarm = 1 Then
           Locate 1 , 14 : Lcd Chr(3)
           End If
           If Body = 0 Then
           Locate 1 , 13 : Lcd Chr(4)
           End If
           If Sms = 1 Then
           Locate 1 , 1 : Lcd "S"
           Else
           Locate 1 , 1 : Lcd "D"
           Locate 2 , 1 : Lcd Chr(135)
           Locate 2 , 13 : Lcd Sharj
           End If


     End If

 End If


Loop


End

'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
'    SEND SMS
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Sub Send_sms

     Wait 1
     Print "AT+CMGS=" ; Chr(34) ; Num ; Chr(34)             'send sms
     Waitms 200
     Print Msg ; Chr(26)
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