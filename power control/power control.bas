$regfile = "m16def.dat"
$crystal = 1000000

configs:
Config Lcdpin = Pin ; Db7 = Portb.5 ; Db6 = Portb.4 ; Db5 = Portb.3 ; Db4 = Portb.2 ; Enable = Portb.1 ; Rs = Portb.0
Cursor Off
Config Adc = Free , Prescaler = Auto

Config Timer1 = Timer , Prescale = 256

Enable Interrupts
Enable Ovf1
On Ovf1 T1isr
'Enable Int0
'On Int0 Intisr
'config int0=FALLING
'
'trig alias pind.2:config portd.2=INPUT

Pg Alias Portd.7 : Config Portd.7 = Output

Startt Alias Portd.5 : Config Portd.5 = Output
L1k1 Alias Portd.0 : Config Portd.0 = Output
L2k2 Alias Portd.2 : Config Portd.2 = Output
L1g Alias Portd.1 : Config Portd.1 = Output
L2g Alias Portd.3 : Config Portd.3 = Output
Sw Alias Portd.4 : Config Portd.4 = Output


Led1 Alias Portc.3 : Config Portc.3 = Output
Led2 Alias Portc.2 : Config Portc.0 = Output
Led3 Alias Portc.1 : Config Portc.1 = Output
Led4 Alias Portc.0 : Config Portc.2 = Output

key1 Alias Pinc.6 : Config Portc.6 = Input
key2 Alias Pinc.5 : Config Portc.5 = Input
Key3 Alias Pinc.4 : Config Portc.4 = Input
Key4 Alias Pinc.7 : Config Portc.7 = Input

buz Alias Portd.6 : Config Portd.6 = Output

Defines:

Dim In1ok As Bit : Dim In2ok As Bit : Dim Ingok As Bit
Dim B As Byte
Dim X As Byte
Dim I As Word
dim adcin as dword
Dim Vin As Single
Dim In1 As Word
Dim In2 As Word
Dim Ing As Word

Dim Min1(5) As Single
dim min2(5) as single
dim ming(5) as single

dim backup as  single
dim volt as string*5
dim v(3) as string*5

Dim Times As Byte
Dim Etimes As Eram Byte

Declare Sub Calvolt
Declare Sub Startgen
Declare Sub Readvolt
Declare Sub Showvolt
Declare Sub Readkeys
Declare Sub Beep
Declare Sub Errorbeep
Declare Sub Lbeep
Declare Sub Findorder
Declare Sub Resetall



Dim Order As String * 10
Dim Turn As Byte
Dim Move As Byte
Dim T As Byte
Dim Beeptime As Byte
Dim T20ms As Byte

Dim Touch As Byte
Dim Gen As Byte


Startup:
Times = Etimes : Wait 20
If Times > 10 Or Times = 0 Then
   Etimes = 2
   Times = Etimes
End If
   Cls
    Lcd " Em  Electronic "
    Wait 3
    cls:waitms 500
Start Adc

Timer1 = 64910
start timer1

Set Buz
Beeptime = 10
Reset Sw

Do
  Touch = 0
  Readkeys
  If Touch = 0 Then Exit Do
Loop

Main:

   Do

     Readkeys
     If Order = "" Then Order = "auto"
     Findorder

     If Touch > 0 Then
        'Home : Lcd Touch
          Select Case Touch

                 Case 1
                      'Set Led1 : Reset Led2 : Reset Led3 : Reset Led4
                      Order = "stop"
                 Case 2
                     ' Reset Led1 : Set Led2 : Reset Led3 : Reset Led4
                      Order = "auto"
                 Case 3
                      Order = "run "
                     ' Reset Led1 : Reset Led2 : Set Led3 : Reset Led4
                 Case 4
                      Order = "test"
                     ' Reset Led1 : Reset Led2 : Reset Led3 : Set Led4
                 Case 11

                 Case 22

                 Case 33
                      Order = "starttime"
                 Case 44
                      Order = "gomenu"
          End Select
          Findorder

          Touch = 0
     End If
     Cls
   loop


Sub Findorder
    'Readkeys
    Select Case Order
           Case "stop"
                 Set Led1 : Reset Led2 : Reset Led3 : Reset Led4
                 Resetall

           Case "auto"
                 Reset Led1 : Set Led2 : Reset Led3 : Reset Led4
                 Do
                   Readvolt
                   Showvolt
                   If In1ok = 1 Then Set L1k1 Else Reset L1k1
                   Wait 1
                   If In2ok = 1 Then Set L2k2 Else Reset L2k2
                   Wait 1
                   If In1ok = 1 And In2ok = 1 Then
                      Reset Sw : Reset Startt
                   End If
                   If In1ok = 0 Or In2ok = 0 Then
                      Startgen

                      If Ingok = 1 And Gen = 1 Then
                         Order = "rungen"
                         'Lcd Order : Lowerline : Lcd Gen : Wait 2 : Cls
                         Exit Do
                      End If
                   End If



                   Readkeys
                   If Touch > 0 Then Exit Do
                 Loop
           Case "run "
                 Reset Led1 : Reset Led2 : Set Led3 : Reset Led4
                 Startgen
                 Order = "runn"
           Case "test"
                 Reset Led1 : Reset Led2 : Reset Led3 : Set Led4
                 Startgen
                 Order = "testt"
           Case "gomenu"

           Case "starttime"
                 Do
                   Home
                   Lcd "Start Time= " ; Times ; " s   "
                   If Key1 = 0 Then Decr Times
                   If Key2 = 0 Then Incr Times
                   If Key1 = 0 Or Key2 = 0 Or Key3 = 0 Or Key4 = 0 Then
                      Set Buz
                      Do
                        Waitms 50
                        If Key1 = 1 Or Key2 = 1 Or Key3 = 1 Or Key4 = 1 Then Exit Do
                      Loop
                   End If
                   Reset Buz
                   If Key4 = 0 Then
                      Etimes = Times : Waitms 50 : Exit Do
                   End If
                   If Times = 0 Then Times = 10
                   If Times = 11 Then Times = 1
                   Waitms 50
                 Loop

           Case "rungen"
                 Do
                   Readvolt
                   Showvolt
                   If In1ok = 0 And Ingok = 1 Then
                      Reset L1k1
                      Set L1g
                      Wait 1
                   Else
                      X = 0
                      For B = 0 To 10
                        Readvolt
                        Cls
                        Lcd "V1= " ; In1 ; " v Test"
                        Lowerline
                        Lcd "Vg= " ; Ing ; " v   "
                        Wait 1
                        If In1ok = 1 Then Incr X
                      Next
                      If X > 9 Then Reset L1g
                   End If
                   If In2ok = 0 And Ingok = 1 Then
                      Reset L2k2
                      Set L2g
                      wait 1
                   Else
                      X = 0
                      For B = 0 To 10
                        Readvolt
                        Cls
                        Lcd "V2= " ; In2 ; " v Test"
                        Lowerline
                        Lcd "Vg= " ; Ing ; " v   "
                        Wait 1
                        If In2ok = 1 Then Incr X
                      Next
                      If X > 9 Then Reset L2g
                   End If
                   If In1ok = 1 And In2ok = 1 Then
                      X = 0
                      For B = 1 To 10
                        Readvolt
                        Cls
                        Lcd "V1= " ; In1 ; " v Test"
                        Lowerline
                        Lcd "V2= " ; In2 ; " v   "
                        Wait 1
                        If In1ok = 1 And In2ok = 1 Then Incr X
                      Next
                      If In1ok = 1 And In2ok = 1 And X > 9 Then

                         Reset Sw
                         Reset Startt
                         Order = "auto"
                         Cls : Lcd "Generator = OFF" : Wait 3 : Cls
                         Exit Do
                      End If
                   End If
                   Readkeys
                   If Touch > 0 Then Exit Do
                 Loop


    End Select
    'Order = ""
End Sub


Sub Resetall
    Reset Sw
    Reset Startt
    Reset L1k1
    Reset L2k2
    Reset L1g
    Reset L2g
    Cls : Lcd " Outputs are Off " : Wait 3
    Order = "stopp"
End Sub


'(
Sub Readkeys

    If Key1 = 0 Then
       Set Buz
       I = 0
       Do
         Incr I
         Waitms 20
         If I = 20 Then Exit Do
       Loop Until Key1 = 1
       If I < 10 Then
          Beep
          Touch = 1
       End If
       If I >= 19 Then
          Lbeep
          Touch = 11
       End If
    End If

    If Key2 = 0 Then
       Set Buz
       I = 0
       Do
         Incr I
         Waitms 20
         If I = 20 Then Exit Do
       Loop Until Key2 = 1
       If I < 10 Then
          Beep
          Touch = 2
       End If
       If I >= 19 Then
          Lbeep
          Touch = 22
       End If
    End If

    If Key3 = 0 Then
       Set Buz
       I = 0
       Do
         Incr I
         Waitms 20
         If I = 20 Then Exit Do
       Loop Until Key3 = 1
       If I < 10 Then
          Beep
          Touch = 3
       End If
       If I >= 19 Then
          Lbeep
          Touch = 33
       End If
    End If

    If Key4 = 0 Then
       Set Buz
       I = 0
       Do
         Incr I
         Waitms 20
         If I = 20 Then Exit Do
       Loop Until Key4 = 1
       If I < 10 Then
          Beep
          Touch = 4
       End If
       If I >= 19 Then
          Lbeep
          Touch = 44
       End If
    End If


End Sub
')


Sub Readkeys

    If Key1 = 0 Then
       Set Buz
       Waitms 25
       Touch = 1
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key1 = 0
       Reset Buz
    End If

    If Key2 = 0 Then
       Set Buz
       Waitms 25
       Touch = 2
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key2 = 0
       Reset Buz
    End If

    If Key3 = 0 Then
       Set Buz
       Waitms 25
       Touch = 3
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key3 = 0
       Reset Buz
       Cls : Lcd "1 -> run mode" : Lowerline : Lcd "2 -> menu "
       Wait 1
       Do
       Loop Until Key1 = 0 Or Key2 = 0 Or Key3 = 0 Or Key4 = 0
       Cls
       Do
         If Key1 = 0 Then
            Order = "run" : Home : Lcd "run mode *" : Lowerline : Lcd "menu      "
         End If
         If Key2 = 0 Then
            Order = "starttime" : Home : Lcd "run mode  " : Lowerline : Lcd "menu     *"
         End If
         Waitms 100
         If Key1 = 0 Or Key2 = 0 Or Key3 = 0 Or Key4 = 0 Then
            Set Buz
         Else
             Reset Buz
         End If
         If Key3 = 0 Then
            Cls
            Do
            Loop Until Key3 = 0
            Reset Buz
            Exit Do



         End If
       Loop
       Findorder
    End If

    If Key4 = 0 Then
       Set Buz
       Waitms 25
       Touch = 4
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key4 = 0
       Reset Buz


    End If


End Sub
Sub Beep
    Set Buz
    Beeptime = 2

End Sub

Sub Lbeep
    Set Buz
    Beeptime = 10

End Sub


Sub Errorbeep
    Set Buz
    Beeptime = 8
End Sub
Sub Readvolt
           adcin=getadc(0)
           calvolt
           v(1)=volt
           min1(i)=vin

           Adcin = Getadc(2)
           calvolt
           v(2)=volt
           min2(i)=vin

           Adcin = Getadc(1)
           Calvolt
           V(3) = Volt
           Ming(i) = Vin


           In1 = Val(v(1)):
           In2 = Val(v(2))
           Ing = Val(v(3))


           If In1 > 170 And In1 < 250 Then In1ok = 1 Else In1ok = 0
           If In2 > 170 And In2 < 250 Then In2ok = 1 Else In2ok = 0
           If Ing > 170 And Ing < 250 Then Ingok = 1 Else Ingok = 0

           If In1ok = 1 And In2ok = 1 And Ingok = 0 Then
              'In1 = In1 - 9
              'In2 = In2 - 9
           End If
           If In1ok = 0 And In2ok = 1 And Ingok = 1 Then
              'Ing = Ing - 9
              'In2 = In2 - 9
           End If
           If In1ok = 1 And In2ok = 0 And Ingok = 1 Then
              'In1 = In1 - 9
              'Ing = Ing - 9
           End If
           If In1ok = 1 And In2ok = 0 And Ingok = 0 Then
              'In1 = In1 - 22
           End If
           If In1ok = 0 And In2ok = 1 And Ingok = 0 Then
              'In2 = In2 - 22
           End If
           If In1ok = 0 And In2ok = 0 And Ingok = 1 Then
              'Ing = Ing - 22
           End If
           Waitms 200

End Sub

Sub Calvolt
      Vin = Adcin
      vin=vin/0.0033
      vin=vin*0.633
      vin=vin/132
      vin=vin*1.14
      Volt = Fusing(vin , "##.#")
End Sub

T1isr:
      Stop Timer1

           'Touch = 0
           'Readkeys
           'If Touch > 0 Then Findorder
           Incr T20ms
           If Beeptime > 0 Then
              Decr Beeptime
              If Beeptime = 0 Then
                 Reset Buz
              End If
           End If
           If T20ms = 50 Then

           End If

      Timer1 = 64910
      Start Timer1
Return


Sub Startgen

    Readvolt
    If Ingok = 1 Then
       Cls : Lcd "Generator Is ON"
       Wait 3
       Cls
       Return
    End If
    I = 0
    Cls : Lcd " Generator Run  " : Lowerline : Lcd Order
    Do
      Touch = 0
      Readkeys
      If Touch = 0 Then Exit Do
    Loop
    Do
      Incr I
      Reset Sw
      Cls : Lcd "switch= OFF"
      For B = 0 To 20
          Waitms 50
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
      Next
      Set Sw
      Cls : Lcd "switch= ON "
      For B = 0 To 80
          Waitms 50
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
      Next
      Set Startt
      Cls : Lcd "start= ON "
      Lowerline
      'Lcd Times
      Wait Times
      X = Times
      X = Times * 20
      For B = 0 To 20
          Waitms 50
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
      Next
      Reset Startt
      Cls : Lcd "start= OFF" : Lowerline : Lcd "Test Voltage"
      For B = 0 To 100
          Waitms 50
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
      Next
      X = 0
      For B = 0 To 10
          Order = "run"
          Readvolt
          If Ingok = 1 Then Incr X
          Showvolt
          Waitms 500
      Next
      If Ingok = 1 And X > 9 Then
         Cls : Lcd "It Is OK"
         Gen = 1
         Exit Do
      End If
      If I = 4 Then
         Cls : Lcd "Generator ERROR"
         If In1ok = 0 And In2ok = 0 Then
            Cls : Lcd "Press any Key"
            Do
              Touch = 0
              Readkeys
              If Touch > 0 Then Exit Do
            Loop
         End If
         Order = "auto"
         Gen = 2
         Exit Do
      End If
    Loop
    Wait 1
    Cls
End Sub



Sub Showvolt
    Cursor Off
    If Order = "auto" Or Order = "rungen" Then
         Home
         If In1ok = 1 And In2ok = 1 Then
            Lcd "V1= " ; In1 ; " v       "
            Lowerline
            Lcd "V2= " ; In2 ; " v      "
         End If
         If In1ok = 0 And In2ok = 1 Then
            Lcd "V2= " ; In2 ; " v       "
            Lowerline
            Lcd "VG= " ; Ing ; " v      "
         End If
         If In1ok = 1 And In2ok = 0 Then
            Lcd "V1= " ; In1 ; " v       "
            Lowerline
            Lcd "VG= " ; Ing ; " v      "
         End If
         If In1ok = 0 And In2ok = 0 And Ingok = 1 Then
            Lcd "Gen=ON  Line=OFF"
            Lowerline
            Lcd "VG= " ; Ing ; " v      "
         End If
         'Lcd V(3) ; " G "
    End If
    If Order = "run" Then

         Cls
         Lcd "Voltage Test"
         Lowerline
         Lcd "VG= " ; Ing ; " v       "

    End If

End Sub
End