
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
'Config Com1 = Dummy , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 7 , Clockpol = 0
'open "com1:"for binary as #1

Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2
Cursor Off


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

Dim Maxin As Byte


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
Dim I As Byte
Dim Buf As Byte

Dim D As Byte

Relay1 = 0
Relay2 = 0
Relay3 = 0
Rii = 1
Sens1 = 1
Sens2 = 1
S = 2
Body = 0


'(
  Cls
  Locate 1 , 3                                              'Clear display
  Lcd "Initializing"
  Locate 2 , 6
  Lcd "Modem..."
  Set Pwr
  Wait 2
  Reset Pwr


  Cls

  Do
    Lcd "."
    Incr Gps
    If Gps > 15 Then Exit Do
    Waitms 500
  Loop
  Cls
')



 Wait 5
Print "AT+IPR=9600"
Wait 2
'Print "ate0"
Dail
Wait 2
  Cls
  Do

    'Printbin 65 ; 84
     Print "AT"
     Print "AT"
     Incr D
    Inmsg = ""
    Wait 1
    Lcd "get command"
    Waitms 500
    Lowerline
    Do
       Gps = Inkey()
       Inmsg = Inmsg + Chr(gps)


       Lcd Gps
         Loop Until Ischarwaiting() = 0
    Lcd "  " ; Inmsg
    Wait 2
    Cls
    Waitms 500
  Loop
  Do
         Print "At"

         Wait 1
         Inmsg = ""
         Do

         Gps = Inkey()
         If Gps > 0 Then                                    '++++++++++++++++++++++++++++++++++++++++++
         'Lcd Gps
         Inmsg = Inmsg + Chr(gps)
         Lcd Inmsg ; " "



                                                      ' build string
         Loop Until Ischarwaiting() = 0
         Wait 2
         Cls
         End If
  Loop


Main:
Maxin = "  "
Do
                                                    ' THIRD Command Text Mode
    Print "AT+CMGF=1"
    Wait 1
    Do
      Maxin = Inkey()
      Inmsg = Chr(maxin)
      Lcd Inmsg
      Buf = Ischarwaiting()
    Loop Until Buf = 0
    Home
    Maxin = "         "
    Wait 1
    Cls
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
Print "Atd" ; 09376921503 ; ";"
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