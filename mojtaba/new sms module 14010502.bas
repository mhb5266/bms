$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Configs:


        Simrst Alias Portd.6 : Config Portd.6 = Output
        Enable Interrupts
        Enable Urxc
        On Urxc Rxin
        Open "comd.5:9600,8,n,1" For Output As #2
        Open "comd.4:9600,8,n,1" For Input As #3


        Pc Alias Porta.1 : Config Porta.1 = Output
        Micro Alias Portb.0 : Config Portb.0 = Output


Defsubs:


        Declare Sub Rxin
        Declare Sub Readsms

Defines:


        Dim Answer As String * 120
        Dim Rx As Byte
        Dim A As Byte
        Dim Timeout As Word




Startup:

        Reset Simrst
        Waitms 100
        Set Simrst

        For A = 0 To 50
            Toggle Pc
            Waitms 250
        Next
        Reset Pc
        Answer = ""
        Do
          If Answer = "OK" Then Exit Do
          Print "ATE0"
          Wait 2
        Loop
'(

   Print "AT"
                                                      ' Waitms 100
   Print "AT+cpin?"
                                                      ' get pin status
   Print "AT+CMGF=1"
   'Wait 1
   Print #2 , "cmgf="
   Print "AT+CMGF?"
   'Wait 1                                                   ' set SMS text mode
   Print "At+Cusd=1"
   'Wait 1
   Print "At+Cusd?"
   'Wait 1
   Print "AT+CSMP=17,167,0,0"
   'Wait 1
   Print "AT+CSMP?"
   'Wait 1
   Print "AT+CNMI=2,1,0,0,0"
   'Wait 1
   Print "AT+CNMI?"

   Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)

   Print "AT+CSCS?"
   'Wait 1

')


   do
      answer=""
      Print#2 , "ATE0"
      Print "ATE0"


   Loop Until Answer = "OK"



   do
      answer=""
      Print#2 , "AT&F"
      Print "AT&F"


   Loop Until Answer = "OK"


   do
      answer=""
      Print#2 , "ATE0"
      Print "ATE0"


   Loop Until Answer = "OK"


   'Do
      answer=""
      Print#2 , "AT"
      Print "AT"


   'Loop Until Answer = "OK"


   'Do
      Answer = ""
      Print#2 , "AT+cpin?"
      Print "AT+cpin?"


   'Loop Until Lcase(answer) <> ""



   do
      answer=""
      Print#2 , "AT+CMGF=1"
      Print "AT+CMGF=1"


   Loop Until Answer = "OK"


   Do
      Answer = ""
      Print#2 , "At+Cusd=1"
      Print "At+Cusd=1"


   Loop Until Answer = "OK"




   do
      answer=""
      Print#2 , "AT+CSMP=17,167,0,0"
      Print "AT+CSMP=17,167,0,0"


   Loop Until Answer = "OK"



   do
      answer=""
      Print#2 , "AT+CNMI=2,1,0,0,0"
      Print "AT+CNMI=2,1,0,0,0"


   Loop Until Answer = "OK"



   do
      Answer = ""
      Print#2 , "AT+CSCS=GSM"
      Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)


   Loop Until Answer = "OK"






Main:

 Do
   A = Instr(answer , "+CMTI")
   If A > 0 Then Readsms
 Loop

End


Sub Rxin
        Rx = 0
        Answer = ""
        Timeout = 0
        Do
        Incr Timeout
        Waitms 1
        If Timeout > 5000 Then Exit Do
        Inputbin Rx
            Select Case Rx

               Case 0

               Case 10
                     If Answer <> "" Then Exit Do
               Case 13

               Case Else
               Answer = Answer + Chr(rx)
            End Select
        Loop
        Print #2 , Answer
End Sub

Sub Readsms

    Print "AT+CMGR=1"
    Do
    Loop Until Answer <> ""
    Print #2 , Answer



End Sub