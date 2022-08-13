$regfile = "m32def.dat"
$crystal=11059200
$baud = 9600

Const Usecom2 = 1




Configs:



Simrst Alias Portd.6 : Config Portd.6 = Output
Led Alias Portb.0 : Config Portb.0 = Output
Led2 Alias Porta.2 : Config Porta.2 = Output
Pg Alias Porta.1 : Config Porta.1 = Output

Key Alias Pina.0 : Config Porta.0 = Input

#if Usecom2 = 1
Open "comd.5:9600,8,n,1" For Output As #2
#endif
Enable Interrupts
Enable Urxc
On Urxc Getline

Config Timer0 = Timer , Prescale = 1024
Enable Timer0
On Timer0 T0rutin
Start Timer0

Defines:

Declare Sub Sendsms
Declare Sub Getline
Declare Sub Clearbuf

Dim Number As String * 13
Dim Msg As String * 60
Dim Test As Byte
Dim Rxin As Byte
Dim Strin As String * 60
Dim I As Byte

Startup:


Reset Simrst
Waitms 100
Set Simrst
For I = 1 To 40
    Toggle Led
    Waitms 250

Next
 Set Led2
 Wait 1
 Reset Led2
       Print "ATE0"
       'do
         'Print #2 , "wait until ready"
         'Waitms 100
         'Getline
       'Loop Until Lcase(strin) = "sms ready"
       Print "AT&F"

       Do
         'Waitms 100
         Strin = ""
         Print "ATE0"
         Getline
         Print #2 , "ATE0"
       Loop Until Lcase(strin) = "ok"

   Do

      Strin = ""
      Print "AT"
      Getline
      Print #2 , "AT"
   Loop Until Lcase(strin) = "ok"

   Wait 1
   'Clearbuf
   Do

      Strin = ""
      Print "AT+cpin?"
      Getline
      Print #2 , "AT+cpin"
   Loop Until Lcase(strin) <> ""



   do
      Strin = ""

      Print "AT+CMGF=1"
      Getline
      Print #2 , "AT+CMGF"
   Loop Until Lcase(strin) = "ok"
   Print "AT+CMGF=?"

   do
      Strin = ""

      Print "At+Cusd=1"
      Getline
      Print #2 , "AT+cusd"
   Loop Until Lcase(strin) = "ok"
   Print "At+Cusd=?"


   Do
      Strin = ""

      Print "AT+CSMP=17,167,0,0"
      Getline
      Print #2 , "AT+csmp"
   Loop Until Lcase(strin) = "ok"


   Do
      Strin = ""

      Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
      Getline
      Print #2 , "AT+cscs"
   Loop Until Lcase(strin) = "ok"



   Number = "+989155609631" : Msg = "system is online"
   Sendsms



Print #2 , "config is finished"
Main:

     Do
       Getline

        If Key = 0 Then
           Waitms 20
           Set Led
           Reset Led2
           'For I = 1 To 10
               Print "AT"
               Toggle Led : Toggle Led2                     ': Waitms 500

           'Next
           Print #2 , "AT was sent"
           If Key = 0 Then
              Number = "+989155609631" : Msg = "system is online"
              Sendsms
           End If
           Do
           Loop Until Key = 1
        End If

     Loop

T0rutin:

        Incr Test

        If Test = 20 Then
           'Toggle led
           Test = 0
        End If



Return

Sub Getline
        Rxin = 0
        Strin = ""
        Do
        Inputbin Rxin
            Select Case Rxin

               Case 0

               Case 10
                     If Strin <> "" Then Exit Do
               Case 13

               Case Else
               Strin = Strin + Chr(rxin)
            End Select
        Loop
        Print #2 , Strin
End Sub

End

Sub Clearbuf

    Do
      Inputbin Rxin

    Loop Until Rxin = 0

End Sub




sub sendsms

   Print "AT+CMGS=" ; Chr(34);number; Chr(34)
   Print #2 , "AT+CMGS=" ; Chr(34) ; Number ; Chr(34)
   Getline
   Wait 1
   Print Msg ; Chr(26)
   Print #2 , Msg ; Chr(26)
   Getline
   Waitms 250

End Sub