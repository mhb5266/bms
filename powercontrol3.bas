$regfile = "m16def.dat"
$crystal = 1000000

Configs:
Config Lcdpin = Pin ; Db7 = Portb.5 ; Db6 = Portb.4 ; Db5 = Portb.3 ; Db4 = Portb.2 ; Enable = Portb.1 ; Rs = Portb.0
Cursor Off
Cls
Config Adc = Free , Prescaler = Auto
Initlcd
Config Timer1 = Timer , Prescale = 256

'Enable Interrupts
'Enable Ovf1
'On Ovf1 T1isr
'Enable Int0
'On Int0 Intisr
'config int0=FALLING
'
'trig alias pind.2:config portd.2=INPUT

Pg Alias Portd.7 : Config Portd.7 = Output
En Alias Portb.1 : Config Portb.1 = Output
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

Key1 Alias Pinc.6 : Config Portc.6 = Input
Key2 Alias Pinc.5 : Config Portc.5 = Input
Key3 Alias Pinc.4 : Config Portc.4 = Input
Key4 Alias Pinc.7 : Config Portc.7 = Input

Buz Alias Portd.6 : Config Portd.6 = Output

Defines:

Dim In1ok As Bit : Dim In2ok As Bit : Dim Ingok As Bit
Dim B As Byte
Dim X As Byte
Dim I As Word
Dim Adcin As Dword
Dim Vin As Single
Dim In1 As Word
Dim In2 As Word
Dim Ing As Word

Dim Min1(5) As Single
Dim Min2(5) As Single
Dim Ming(5) As Single

Dim Backup As Single
Dim Volt As String * 5
Dim V(3) As String * 5

Dim Ts As Byte : Ts = 3
Dim Tg As Byte : Tg = 10

Dim Times As Byte
Dim Etimes As Eram Byte

Declare Sub Calvolt
Declare Sub Startgen
Declare Sub Readvolt
Declare Sub Showvolt
Declare Sub Readkeys
Declare Sub Keyorder
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
Initlcd
 Wait 5

    Cls
    Lcd " Em  Electronic "
    Wait 3
    Cls : Waitms 500

 Cls
 Lcd "ENTER start time" : Lowerline : Lcd Ts
 I = 0
 Do
   Readkeys
   If Touch > 0 Then I = 0
   If Touch = 3 Then Incr Ts
   If Touch = 1 Then Decr Ts
   Waitms 100
   Home
   Lcd "ENTER start time" : Lowerline : Lcd Ts ; "   "
   If Ts > 9 Then Ts = 1
   If Ts = 0 Then Ts = 9
   If Touch = 2 Then Exit Do
   Incr I
   If I = 50 Then Exit Do
 Loop
 Wait 1
 Cls
 Lcd "start time= " : Lcd Ts : Lcd " s   "
 Wait 1

  Cls
 Lcd "ENTER TEST TIME" : Lowerline : Lcd Tg ; "   "
 I = 0
 Do
   Readkeys
   If Touch > 0 Then I = 0
   If Touch = 3 Then Incr Tg
   If Touch = 1 Then Decr Tg
   Waitms 100
   Home
   Lcd "ENTER Test time" : Lowerline : Lcd Tg ; "   "
   If Tg > 30 Then Ts = 1
   If Tg = 0 Then Ts = 30
   If Touch = 2 Then Exit Do
   Incr I
   If I = 50 Then Exit Do
 Loop
 Wait 1
 Cls
 Lcd "Test time= " : Lcd Tg : Lcd " s  "
 Wait 1

'Times = Etimes : Wait 20
'If Times > 10 Or Times = 0 Then
 '  Etimes = 2
 '  Times = Etimes
'End If

Start Adc

Timer1 = 64910
Start Timer1

Set Buz
Waitms 500
Reset Buz
Reset Sw
Cls

Do
  Touch = 0
  Readkeys
  If Touch = 0 Then Exit Do
  If Touch > 0 Then
     Home
     Lcd "Touch Error"
     Lowerline
     Lcd "Pls Dont touch"
  End If
Loop

Order = "auto"

Main:

   Do
     For I = 1 To 50
          Waitms 20
          Readkeys
          If Touch > 0 Then
             Keyorder
          End If
     Next
     Readvolt
     Showvolt
     Findorder
   Loop


Sub Findorder
    'Readkeys
    Select Case Order
           Case "stop"
                 Set Led1 : Reset Led2 : Reset Led3 : Reset Led4
                 Resetall

           Case "auto"
                 Reset Led1 : Set Led2 : Reset Led3 : Reset Led4
                 Cls
                 Lcd "Auto Mode"
                 Wait 2
                 Cls
                 'Reset L1k1
                 'Wait 1
                 'Reset L2k2
                 'Wait 1
                 'Reset L1g
                 'Wait 1
                 'Reset L2g
                 'Wait 1
                 'Reset Sw
                 'Reset Startt
                      For B = 0 To 10
                        Readvolt
                        Wait 1
                        Cls
                        Lcd "V1= " ; In1 ; " v Test"
                        Wait 1
                        If In1ok = 1 Then Incr X
                      Next
                      If X > 9 Then
                         Reset L1g
                         Wait 1
                         Set L1k1
                         Wait 1
                      End If
                      For B = 0 To 10
                        Readvolt
                        Wait 1
                        Cls
                        Lcd "V2= " ; In2 ; " v Test"
                        Wait 1
                        If In2ok = 1 Then Incr X
                      Next
                      If X > 9 Then
                         Reset L2g
                         Wait 1
                         Set L2k2
                         Wait 1
                      End If
                 Do
                   If Order = "gen " Then Exit Do
                   Readvolt
                   Showvolt
                   If In1ok = 1 Then
                      If L1k1 = 0 Then
                         Set L1k1
                         Wait 2
                      End If
                   Else
                       Reset L1k1
                       Wait 1
                   End If
                   If In2ok = 1 Then
                      If L2k2 = 0 Then
                         Set L2k2
                         Wait 2
                      End If
                   Else
                       Reset L2k2
                       Wait 1
                   End If
                   If In1ok = 1 And In2ok = 1 Then
                      Reset Sw : Reset Startt
                   End If
                   If In1ok = 0 Or In2ok = 0 Then
                      Wait 1
                      Startgen

                      If Ingok = 1 And Gen = 1 Then
                         Order = "Gen "
                         'Lcd Order : Lowerline : Lcd Gen : Wait 2 : Cls
                         Exit Do
                      End If
                   End If

                   If In1ok = 0 And In2ok = 0 And Ingok = 0 Then
                      Wait 1 : Home : Lcd "Power Is off"
                      Reset L1k1
                      Wait 1
                      Reset L2k2
                      Wait 1
                      Reset L1g
                      Wait 1
                      Reset L2g
                      Wait 1
                   End If
                   For I = 1 To 50
                       Waitms 20
                       Readkeys
                       If Touch > 0 Then Exit Do
                   Next

                 Loop

           Case "run "
                 Reset Led1 : Reset Led2 : Set Led3 : Reset Led4
                 Reset L1k1
                 Wait 2
                 Reset L2k2
                 Wait 2
                 Reset L1g
                 Wait 2
                 Reset L2g
                 Wait 2
                 Startgen
                 Do
                   Readvolt
                   Showvolt
                   If Ingok = 1 Then
                      Reset L1k1
                      Wait 1
                      Set L1g
                      Wait 1
                      Reset L2k2
                      Wait 1
                      Set L2g
                      Wait 1
                   End If
                   If Ingok = 0 Then
                      Reset L1g
                      Wait 1
                      Reset L2g
                      Wait 1
                      Exit Do
                   End If
                   For I = 1 To 50
                       Waitms 20
                       Readkeys
                       If Touch > 0 Then
                          Reset L1k1
                          Wait 1
                          Reset L2k2
                          Wait 1
                          Reset L1g
                          Wait 1
                          Reset L2g
                          Wait 1
                          Exit Do
                       End If
                   Next
                 Loop
                 Keyorder

           Case "test"
                 Reset Led1 : Reset Led2 : Reset Led3 : Set Led4
                 Reset L1k1
                 Wait 2
                 Reset L2k2
                 Wait 2
                 Reset L1g
                 Wait 2
                 Reset L2g
                 Wait 2
                 Startgen
                 Do
                   Readvolt
                   Showvolt
                   For I = 1 To 50
                       Readkeys
                       If Touch > 0 Then
                          Exit Do
                       End If
                   Next
                 Loop
                 Keyorder
           Case "gomenu"




           Case "Gen "
                 Do
                   Readvolt
                   Showvolt
                   If In1ok = 0 And Ingok = 1 Then
                      Reset L1k1
                      Wait 1
                      Set L1g
                      Wait 1
                   Elseif L1k1 = 0 And In1ok = 1 Then
                      X = 0
                      Cls
                      Initlcd
                      Wait 2
                      For B = 0 To 10

                        Readvolt
                        Wait 1

                        Cls
                        Lcd "V1= " ; In1 ; " v Test"
                        Lowerline
                        Lcd "VG= " ; Ing ; " v   "

                        Wait 1
                        If In1ok = 1 Then Incr X

                      Next
                      If X > 9 Then
                         Reset L1g
                         Wait 3
                         Set L1k1
                         Wait 3
                      End If
                   End If
                   If In2ok = 0 And Ingok = 1 Then
                      Reset L2k2
                      Wait 1
                      Set L2g
                      Wait 1
                   Elseif L2k2 = 0 And In2ok = 1 Then
                      X = 0
                      Cls
                      Initlcd
                      Wait 2
                      For B = 0 To 10

                        Readvolt
                        Wait 1

                        Cls
                        Lcd "V2= " ; In2 ; " v Test"
                        Lowerline
                        Lcd "VG= " ; Ing ; " v   "

                        Wait 1
                        If In2ok = 1 Then Incr X

                      Next
                      If X > 9 Then
                         Reset L2g
                         Wait 3
                         Set L2k2
                         Wait 3
                      End If
                   End If
                   If In1ok = 0 Or In2ok = 0 Then
                      If Ingok = 0 Then
                         Reset L1k1
                         Wait 1
                         Reset L2k2
                         Wait 1
                         Reset L1g
                         Wait 1
                         Reset L2g
                         Wait 1
                         Reset Startt
                         Reset Sw
                         Initlcd
                         Startgen
                      End If
                   End If
                   If In1ok = 1 And In2ok = 1 Then
                      X = 0
                      Initlcd
                      For B = 1 To 10

                        Readvolt
                        Wait 1

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
                         Reset L1g
                         Reset L2g
                         Order = "auto"
                         Wait 1
                            Cls : Lcd "Generator = OFF"
                            Wait 2
                            Exit Do
                      End If
                   End If
                   For I = 1 To 50
                       Waitms 20
                       Readkeys
                       If Touch > 0 Then Exit Do
                   Next
                 Loop


    End Select
    'Order = ""
End Sub


Sub Resetall
    Initlcd
    Reset Sw
    Reset Startt
    Reset L1k1
    Reset L2k2
    Reset L1g
    Reset L2g
    Wait 1 : Cls : Lcd " Outputs are Off " : Wait 3
    Order = "stopp"
    Cls
    Lcd " Press Any Key  "
    Do
      Readkeys
      If Touch > 0 Then Exit Do
    Loop
    Keyorder
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
    Touch = 0
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
           Adcin = Getadc(0)
           Calvolt
           V(1) = Volt
           Min1(i) = Vin

           Adcin = Getadc(2)
           Calvolt
           V(2) = Volt
           Min2(i) = Vin

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
      Vin = Vin / 0.0033
      Vin = Vin * 0.633
      Vin = Vin / 132
      Vin = Vin * 1.14
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
      'Cursor Off
      Timer1 = 64910
      Start Timer1
Return



Sub Startgen

    Readvolt
'(
    If Ingok = 1 Then
       Wait 3
       Cls : Lcd "Generator Is ON"
       Order = "rungen"
       Wait 1
       Cls
       Return
    End If
')
    I = 0
    Wait 1 : Cls : Lcd " Generator Run  " : Lowerline : Lcd Order : Wait 2
    Do
      Touch = 0
      Readkeys
      If Touch = 0 Then Exit Do
    Loop
    I = 0
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
      Cls : Lcd "Start ->ON "
      Lowerline
      'Lcd Times
      If Ts > 10 Then Ts = 3
      Times = Ts
      Do
      Cls
      Lcd Times
      Decr Times
      Wait 1
      If Times = 0 Then Exit Do
      Loop

      For B = 0 To 20
          Waitms 50
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
      Next
      Reset Startt
      Cls : Lcd "Start ->OFF" : Lowerline : Lcd "Test Voltage" : Wait 1


      X = 0
      If Tg > 30 Then Tg = 30
      Times = Tg
      Do
        Cls
        Lcd Times
        Decr Times
        Wait 1
          Readkeys
          If Touch > 0 Then
             Cls : Lcd "Stop Running"
                Exit Do
          End If
        If Times = 0 Then Exit Do
      Loop

      For B = 0 To 10
          'Order = "run"
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
      If I = 3 Then
         Cls : Lcd "Generator ERROR" : Wait 3
         If In1ok = 0 And In2ok = 0 Then
            Cls : Lcd "Press any Key"
            I = 0
            Reset Sw
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
      If Touch > 0 Then
         Keyorder
      End If
    Loop
    If Touch > 0 Then
       Keyorder
    End If
    Wait 1
    Cls
End Sub

Sub Keyorder
             Select Case Touch
                 Case 1
                      Order = "stop"
                 Case 2
                      Order = "auto"
                 Case 3
                      Order = "run "
                 Case 4
                      Order = "test"
             End Select
             Touch = 0
             Findorder

End Sub


Sub Showvolt
    Initlcd
    Waitms 50

    If Order = "auto" Or Order = "Gen " Then
         Home
         If In1ok = 1 And In2ok = 1 Then
            Lcd "V1= " ; In1 ; " v  " ; Order
            Lowerline
            Lcd "V2= " ; In2 ; " v      "
         End If
         If In1ok = 0 And In2ok = 1 Then
            Lcd "V2= " ; In2 ; " v  " ; Order
            Lowerline
            Lcd "VG= " ; Ing ; " v  ->V1"
         End If
         If In1ok = 1 And In2ok = 0 Then
            Lcd "V1= " ; In1 ; " v  " ; Order
            Lowerline
            Lcd "VG= " ; Ing ; " v  ->V2"
         End If
         If In1ok = 0 And In2ok = 0 And Ingok = 1 Then
            Lcd "Gen=ON  Line=OFF"
            Lowerline
            Lcd "VG= " ; Ing ; " v      "
         End If
         'Lcd V(3) ; " G "
    End If
    If Order = "test" Then

         Cls
         Lcd "Test Mode"
         Lowerline
         Lcd "VG= " ; Ing ; " v       "

    End If

    If Order = "run " Then
         Cls
         Lcd "Run Mode"
         Lowerline
         Lcd "VG= " ; Ing ; " v       "
    End If

End Sub
End