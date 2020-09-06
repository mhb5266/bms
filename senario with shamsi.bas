
$regfile = "m128def.dat"



$crystal = 11059200
$baud = 115200
$lib "glcdKS108.lbx"


Tempconfig:

 Config 1wire = Portc.1
Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6
Dim Dahom As Word
Dim Sahih As Word
Dim Buffer_digital As Integer

Lcdconfig:
'-----------------------------------------------------
Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 1 , Ce2 = 0 , Cd = 6 , Rd = 5 , Reset = 2 , Enable = 4
Setfont Font8x8

Portconfig:

Config Portf = Output
Config Porta = Output
 Touch1 Alias Pine.5 : Config Porte.5 = Input
Touch2 Alias Pine.6 : Config Porte.6 = Input
Touch3 Alias Pine.7 : Config Porte.7 = Input
Touch4 Alias Pinb.0 : Config Portb.0 = Input

Backlight Alias Porta.3 : Config Porta.3 = Output
Txled Alias Portg.2 : Config Portg.2 = Output
Rxled Alias Portc.4 : Config Portc.4 = Output

Buz Alias Portc.0 : Config Portc.0 = Output
Em Alias Portg.0 : Config Portg.0 = Output

Clockconfig:

Config Sda = Portd.1
Config Scl = Portd.0

Const Ds1307w = &HD0
Const Ds1307r = &HD1

Dim Day As Byte
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim _year As Word
Dim Weekday As Byte
Dim M_day As Word
Dim Sh_day As Word
Dim M_year As Word
Dim Sh_year As Word
Dim M_month As Word
Dim Sh_month As Word
Dim Kabise As Byte
Dim Kole_roz_m As Word
Dim Kole_roz_sh As Word
Dim Conter1 As Word
Dim Conter2 As Word
Dim Conter3 As Word
Dim Conter4 As Word
Dim Day_of_month(12) As Byte
Day_of_month(1) = 31
Day_of_month(2) = 28
Day_of_month(3) = 31
Day_of_month(4) = 30
Day_of_month(5) = 31
Day_of_month(6) = 30
Day_of_month(7) = 31
Day_of_month(8) = 31
Day_of_month(9) = 30
Day_of_month(10) = 31
Day_of_month(11) = 30
Day_of_month(12) = 31

Dim Temp1 As Integer
Dim Temp2 As Integer
Dim Temp3 As Word
Dim Temp4 As Word
Dim Temp5 As Byte

Dim Menu As Byte
Dim Timer_1 As Word

Dim S2 As String * 5
Dim S1 As String * 15
Dim S As String * 10

S1 = "  WWW.ISEEE.IR"
Dim Blink_flag As Bit
Dim Selection As Byte
Dim A As Byte

Maxconfig:

Enable Interrupts
Enable Urxc
On Urxc Rx

Dim Maxin As Byte
Dim Id As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Startbit As Byte : Startbit = 252
Dim Endbit As Byte : Endbit = 220
Dim Findorder As Byte
Dim Remoteid As Byte
Dim Remotekeyid As Byte

Dim Din(5) As Byte

Dim Inok As Boolean
Dim Learnok As Boolean


Const Keyin = 101
Const Steps = 102
Const Senario = 103
Const Remote = 104
Const Outlogic = 110
Const Outpwm = 111
Const Outstep = 112

Defines:

Dim Touch As Byte
Dim Nextday As Boolean
Dim Count As Byte


Dim I As Byte
Dim J As Byte


Consts:

Const Allid = 99
Const Readallinput = 1
Const Read1input = 2
Const Learnkey = 3
Const Enablebuz = 4
Const Disablebuz = 5
Const Enablesensor = 6
Const Disablesensor = 7
Const Enableinput = 8
Const Disableinput = 9
Const Readsteps = 10
Const Learnsteps = 11
Const Enablestep = 12
Const Disablestep = 13
Const Readsenario = 14
Const Readremote = 15
Const Outputblank = 16
Const Resetoutput = 17
Const Resetalloutput = 18
Const Setoutput = 19
Const Clearid = 20
Const Learnremote = 21
Const Clearremote = 22
Const Setremoteid = 23

Const Main_menu_counter = 7

Subs:

Declare Sub Clock_menu
Declare Sub Remote_menu

Declare Function M_kabise(byref Sal As Word)as Byte
Declare Function Sh_kabise(byref Sal As Word)as Byte

Declare Sub Beep
Declare Sub Errorbeep
Declare Sub Temp
Declare Sub Readtouch
Declare Sub Show
Declare Sub Main_menu
Declare Sub Input_menu
Declare Sub Tx
Declare Sub Order
Declare Sub Checkanswer



Startup:


Set Backlight
'Lcdat 1 , 1 , "hi"
'Waitms 500
'Cls
Call Beep




Main:


     Do
       Gosub Read_date_time
       Gosub M_to_sh
       Call Temp
       Call Show

       Touch = 0
       Call Readtouch
       If Touch = 1 Then Call Main_menu



     Loop

Gosub Main


Sub Main_menu:
     Touch = 0
     Do
     Loop Until Touch1 = 0
     Waitms 100
     Cls
     Count = 1
     Do
            Disable Urxc
            If Touch = 2 Then
                   touch = 0
                   incr count
                   If Count > Main_menu_counter Then Count = 1
                   cls
            endif
            if touch = 3 then
                   Touch = 0
                   decr count
                   If Count = 0 Then Count = Main_menu_counter
                   Cls
            endif
            if touch = 4 then
                   Touch = 0
                   cls
                   return
            endif
            Select Case Count
                   case 1
                        Showpic 50 , 20 , Setclockicon
                   case 2
                        Showpic 50 , 20 , Remoteicon
                   case 3
                        Showpic 50 , 20 , Planticon
                   case 4
                        Showpic 50 , 20 , Watersystemicon
                   Case 5
                        Showpic 50 , 20 , Lighticon
                   case 6
                        Showpic 50 , 20 , Jaccuziicon
                   Case 7
                        'Showpic 50 , 20 , Settingicon
                        Lcdat 1 , 1 , "Setting"
            End Select
            if touch = 1 then
                   Touch = 0
                   Cls
                   Select Case Count
                          Case 1
                               Call Clock_menu
                          Case 2

                               Call Remote_menu
                          Case 3

                          Case 4

                          Case 5

                          Case 6

                          Case 7
                               Call Input_menu


                   End Select
            End If
            Call Readtouch
     Loop
End Sub


Sub Remote_menu:
    Count = 1
    Cls
    Do
        Call Readtouch
        If Touch = 4 Then
           Cls
           Return
        End If

        If Touch = 1 Then

           Select Case Count
                  Case 1
                       Findorder = Clearremote
                       Call Order
                  Case 2
                       Findorder = Learnremote
                       Call Order
                  Case 3
                        Remotekeyid = 1
                        Cls
                        Do
                          Lcdat 1 , 1 , "out " ; Remotekeyid
                          Call Readtouch
                          If Touch = 1 Then
                             Cls
                             Id = Remotekeyid
                             Findorder = Setoutput
                             Call Order
                             Cls
                             Lcdat 1 , 1 , "out " ; Remotekeyid
                             Waitms 20
                             Findorder = Setremoteid
                             Call Order
                          End If

                          If Touch = 2 Then
                             Incr Remotekeyid
                          End If

                          If Touch = 3 Then
                             Decr Remotekeyid
                          End If

                          If Touch = 4 Then
                             Findorder = Resetalloutput
                             Call Order
                             Findorder = Readallinput
                             Call Order
                             Findorder = Readremote
                             Call Order
                             Return
                          End If
                        Loop
           End Select

        End If

        If Touch = 2 Then
           Incr Count
           If Count > 3 Then Count = 1
           Cls
        End If

        If Touch = 3 Then
           Decr Count
           If Count = 0 Then Count = 3
           Cls
        End If

        Select Case Count
               Case 1
                    Lcdat 1 , 1 , "Clear Remotes"
               Case 2
                    Lcdat 1 , 1 , "Learn New"
               Case 3
                    Lcdat 1 , 1 , "Config Remotes"
        End Select
    Loop
End Sub

Sub Input_menu:
    Cls
    Id = 0
    Do
      Call Readtouch
      If Touch = 1 Then
         Incr Id
         Findorder = Setoutput
         Call Order
         Lcdat Id , 1 , "out" ; Id
         Waitms 20
         Findorder = Learnkey
         Call Order
      End If

      If Touch = 2 Then


      End If

      If Touch = 3 Then

      End If

      If Touch = 4 Then
         Findorder = Resetalloutput
         Call Order
         Findorder = Readallinput
         Call Order
         Findorder = Readremote
         Call Order
         Cls
         Return
      End If


    Loop

End Sub


Rx:
      'J = 0
      'Do

      Incr J
      Incr I
      Inputbin Maxin

      If I = 5 And Maxin = 220 Then Set Inok
      If Maxin = 242 Then I = 1

      Din(i) = Maxin
      If I = 5 Then I = 0
      If Inok = 1 Then
         I = 0
         Checkanswer
         Reset Inok
      End If

Return

Sub Checkanswer:
    Select Case Din(2)

           Case Keyin


                If Din(4) = Id Then
                   Lcdat Id , 1 ,"input " ;id;" connect"
                End If
                If Din(3) = 151 Then
                   If Din(4) = Id Then
                      Learnok = 1
                   End If
                End If
                If Din(3) = 180 Then Set Portc.din(4)
                If Din(3) = 181 Then Reset Portc.din(4)
                If Din(3) = 182 Then
                   Set Portc.id
                   Wait 2
                   Reset Portc.id
                End If
           Case Remote
                Select Case Din(3)
                       Case 180
                            Cls
                            Lcdat 1 , 1 , "Key " ; Remotekeyid ; " is set"
                            Wait 1
                            Cls
                       Case 181
                            Cls
                            Lcdat 1 , 1 , "Key " ; Remotekeyid ; " is set"
                            Wait 1
                            Cls
                       Case 184
                            Cls
                            Lcdat 1 , 1 , "learn Is Done"
                            Lcdat 2 , 1 , Din(4)
                            Incr Remoteid
                            Wait 1
                            Cls
                       Case 185
                            Cls
                            Lcdat 1 , 1 , "Clear is Done"
                            Wait 1
                            Cls
                End Select


           Case Senario

           Case Steps

           Case Outlogic

           Case Outpwm

    End Select
    'Call Sendqc
    'Call Setout


End Sub

Sub Order

    Select Case Findorder



           Case Readallinput

                Typ = 101 : Cmd = 150 : Id = 99

           Case Read1input

                Typ = 101 : Cmd = 150 : Id = Id

           Case Learnkey

                Typ = 101 : Cmd = 151 : Id = Id

           Case Enablebuz

                Typ = 101 : Cmd = 152 : Id = 99

           Case Disablebuz

                Typ = 101 : Cmd = 153 : Id = 99

           Case Enablesensor

                Typ = 101 : Cmd = 154 : Id = 99

           Case Disablesensor

                Typ = 101 : Cmd = 155 : Id = 99

           Case Enableinput

                Typ = 101 : Cmd = 156 : Id = 99

           Case Disableinput

                Typ = 101 : Cmd = 157 : Id = 99

           Case Readsteps

                Typ = 102 : Cmd = 150 : Id = 99

           Case Learnsteps

                Typ = 102 : Cmd = 151 : Id = Id

           Case Enablestep

                Typ = 102 : Cmd = 156 : Id = 99

           Case Disablestep

                Typ = 110 : Cmd = 157 : Id = 99

           Case Readsenario

                Typ = 103 : Cmd = 150 : Id = 99

           Case Readremote

                Typ = 104 : Cmd = 150 : Id = 99

           Case Outputblank

                Typ = 110 : Cmd = 183 : Id = Id

           Case Resetoutput

                Typ = 110 : Cmd = 181 : Id = Id

           Case Resetalloutput

                Typ = 110 : Cmd = 181 : Id = 99

           Case Setoutput

                Typ = 110 : Cmd = 180 : Id = Id

           Case Clearid

                Typ = 101 : Cmd = 167 : Id = Id

           Case Clearremote

                Typ = 104 : Cmd = 162 : Id = Allid

           Case Learnremote

                Typ = 104 : Cmd = 161 : Id = Allid

           Case Setremoteid

                Typ = 104 : Cmd = 151 : Id = Remotekeyid

    End Select

    Call Tx


End Sub

Sub Tx:
    Set Em
    Waitms 10
    Set Txled
    Printbin Startbit ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset Em
    Reset Txled
    Enable Urxc


End Sub

Sub Show:


       Lcdat 4 , 1 , Sens1
       Lcdat 4 , 90 , Sens2


       If _hour > 9 Then
          Lcdat 1 , 1 , _hour
       Else
          Lcdat 1 , 1 , "0" ; _hour
       End If
       A = _sec Mod 2
       If A = 1 Then Lcdat 1 , 16 , " " Else Lcdat 1 , 16 , ":"
       If _min > 9 Then
          Lcdat 1 , 24 , _min
       Else
          Lcdat 1 , 24 , "0" ; _min
       End If

        Select Case Day
           Case 1
                S2 = "Sat"
           Case 2
                S2 = "Sun"
           Case 3
                S2 = "Mon"
           Case 4
                S2 = "Tue"
           Case 5
                S2 = "Wed"
           Case 6
                S2 = "Thu"
           Case 7
                S2 = "Fri"

        End Select

       Lcdat 1 , 96 , S2

       Lcdat 2 , 1 , Sh_year ; "/"
       If Sh_month < 10 Then
          Lcdat 2 , 40 , "0" ; Sh_month ; "/"
       Else
           Lcdat 2 , 40 , Sh_month ; "/"
       End If
       If Sh_day < 10 Then
          Lcdat 2 , 64 , "0" ; Sh_day
       Else
           Lcdat 2 , 64 , Sh_day
       End If


End Sub

Sub Temp:

   'reset watchdog
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Sens1 = Temperature


   Dahom = Buffer_digital
   Do
   Dahom = Dahom - 10
   Loop Until Dahom < 10
   Sahih = Buffer_digital - Dahom
   Sahih = Sahih / 10




   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Sens2 = Temperature
End Sub

Conversion:
   Buffer_digital = Buffer_digital * 10 : Buffer_digital = Buffer_digital \ 16
   Temperature = Str(buffer_digital) : Temperature = Format(temperature , "0.0")
Return

Sub Clock_menu:
 Call Beep
 Selection = 1
 Cls
 Do

    Incr Timer_1
    If Timer_1 > 5 Then
     Timer_1 = 0
     Toggle Blink_flag
    End If

    S1 = "TIME: "
    '-----------------------------
    If Selection = 1 And Blink_flag = 0 Then

     S1 = S1 + "  "
    Else

     S = Str(_hour)
     S = Format(s , "00")
     S1 = S1 + S

    End If
    S1 = S1 + ":"
    '------------------------------
    If Selection = 2 And Blink_flag = 0 Then

     S1 = S1 + "  "
    Else

     S = Str(_min)
     S = Format(s , "00")
     S1 = S1 + S

    End If
    S1 = S1 + ":"
    '------------------------------
    If Selection = 3 And Blink_flag = 0 Then

     S1 = S1 + "  "
    Else

     S = Str(_sec)
     S = Format(s , "00")
     S1 = S1 + S

    End If


    Lcdat 1 , 1 , S1


    S1 = "DATE: "
    '--------------------------------
    If Selection = 4 And Blink_flag = 0 Then

     S1 = S1 + "    "
    Else

     S = Str(sh_year)
     S = Format(s , "0000")
     S1 = S1 + S

    End If
    S1 = S1 + "/"
    '---------------------------------
    If Selection = 5 And Blink_flag = 0 Then

     S1 = S1 + "  "
    Else

     S = Str(sh_month)
     S = Format(s , "00")
     S1 = S1 + S

    End If
    S1 = S1 + "/"
    '----------------------------------
    If Selection = 6 And Blink_flag = 0 Then

     S1 = S1 + "  "
    Else

     S = Str(sh_day)
     S = Format(s , "00")
     S1 = S1 + S

    End If

    If Selection = 7 And Blink_flag = 0 Then
       S2 = "   "
    Else
        Select Case Day
           Case 1
                S2 = "Sat"
           Case 2
                S2 = "Sun"
           Case 3
                S2 = "Mon"
           Case 4
                S2 = "Tue"
           Case 5
                S2 = "Wed"
           Case 6
                S2 = "Thu"
           Case 7
                S2 = "Fri"

        End Select

    End If

    Lcdat 2 , 1 , S1
    Lcdat 3 , 1 , S2





    Call Readtouch

    If Touch = 1 Then
       Incr Selection
       Touch = 0
    End If

    If Touch = 4 Then
       Cls
       Touch = 0
       Return
    End If
    '-----------------------------------
    If Touch = 2 Then
          If Selection = 1 Then Incr _hour
          If Selection = 2 Then Incr _min
          If Selection = 3 Then Incr _sec
          If Selection = 4 Then Incr Sh_year
          If Selection = 5 Then Incr Sh_month
          If Selection = 6 Then Incr Sh_day
          If Selection = 7 Then Incr Day
          Touch = 0
    End If
    '------------------------------------
    If Touch = 3 Then
         If Selection = 1 Then Decr _hour
         If Selection = 2 Then Decr _min
         If Selection = 3 Then Decr _sec
         If Selection = 4 Then Decr Sh_year
         If Selection = 5 Then Decr Sh_month
         If Selection = 6 Then Decr Sh_day
         If Selection = 7 Then Decr Day
         Touch = 0
    End If

    '--------------------------------------
    If _hour > 100 Then _hour = 23
    If _min > 100 Then _min = 59
    If _sec > 100 Then _sec = 59

    If _hour > 23 Then _hour = 0
    If _min > 59 Then _min = 0
    If _sec > 59 Then _sec = 0
    If Sh_year > 1470 Then Sh_year = 1390
    If Sh_month > 12 Then Sh_month = 1
    If Sh_day > 31 Then Sh_day = 1



    If Sh_year < 1390 Then Sh_year = 1470
    If Sh_month < 1 Then Sh_month = 12
    If Sh_day < 1 Then Sh_day = 31

    If Day < 1 Then Day = 7
    If Day > 7 Then Day = 1
    '---------------------------------------


    Waitms 40

    If Selection > 7 Then Exit Do

 Loop

 Cls
 Lcdat 1 , 1 , " SAVEING"
 Wait 1
 Cls
 Gosub Sh_to_m
 Gosub Setdate
 Gosub Settime

End Sub

Read_date_time:
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 0                                                ' start address in 1307
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307r                                          ' send address
  I2crbyte _sec , Ack
  I2crbyte _min , Ack                                       ' MINUTES
  I2crbyte _hour , Ack                                      ' Hours
  I2crbyte Weekday , Ack                                    ' Day of Week
  I2crbyte M_day , Ack                                      ' Day of Month
  I2crbyte M_month , Ack                                    ' Month of Year
  I2crbyte _year , Nack                                     ' Year
  I2cstop
  _sec = Makedec(_sec) : _min = Makedec(_min) : _hour = Makedec(_hour)
  M_day = Makedec(m_day) : M_month = Makedec(m_month) : _year = Makedec(_year)
  M_year = 2000 + _year

  If _sec = 1 Then
     Reset Nextday
     'Cls
  End If
  If _hour = 0 And _min = 0 And _sec = 0 And Nextday = 0 Then
      Cls
      Set Nextday
      Incr Day
      If Day > 7 Then Day = 1
      Select Case Day
           Case 1
                S2 = "Sat"
           Case 2
                S2 = "Sun"
           Case 3
                S2 = "Mon"
           Case 4
                S2 = "Tue"
           Case 5
                S2 = "Wed"
           Case 6
                S2 = "Thu"
           Case 7
                S2 = "Fri"

      End Select
  End If

Return


Setdate:

  _year = M_year - 2000
  M_day = Makebcd(m_day) : M_month = Makebcd(m_month) : _year = Makebcd(_year)
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 4                                                ' starting address in 1307
  I2cwbyte M_day                                            ' Send Data to SECONDS
  I2cwbyte M_month                                          ' MINUTES
  I2cwbyte _year                                            ' Hours
  I2cstop
Return


Settime:
  _sec = Makebcd(_sec) : _min = Makebcd(_min) : _hour = Makebcd(_hour)
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 0                                                ' starting address in 1307
  I2cwbyte _sec                                             ' Send Data to SECONDS
  I2cwbyte _min                                             ' MINUTES
  I2cwbyte _hour                                            ' Hours
  I2cstop
Return


M_to_sh:

'----------------
If M_kabise(m_year) = 0 Then
   Day_of_month(2) = 28
Else
   Day_of_month(2) = 29
End If
'----------------

Conter2 = M_month - 1
Kole_roz_m = 0

For Conter1 = 1 To Conter2
   Kole_roz_m = Kole_roz_m + Day_of_month(conter1)
Next
Kole_roz_m = Kole_roz_m + M_day

'**********************************

If Kole_roz_m > 79 Then

   Sh_year = M_year - 621
   Kole_roz_sh = Kole_roz_m - 79

Else

   Sh_year = M_year - 622

   Temp4 = M_year - 1
   Temp5 = M_kabise(temp4)

   If Temp5 = 0 Then
      Kole_roz_sh = Kole_roz_m + 286
   Else
      Kole_roz_sh = Kole_roz_m + 287
   End If

End If

'**********************************

Sh_month = 1

'****************
While Kole_roz_sh > 30

   If Sh_month < 7 Then
         Kole_roz_sh = Kole_roz_sh - 31
   Else
         Kole_roz_sh = Kole_roz_sh - 30
   End If

   Incr Sh_month

Wend
'***************
'---------------
If Kole_roz_sh = 0 Then

   Decr Sh_month
   If Sh_month < 7 Then
      Sh_day = 31
   Else
      Sh_day = 30
   End If
Else
   Sh_day = Kole_roz_sh
End If
'---------------
Return

Sh_to_m:

'------------------
Kole_roz_sh = 0
'------------------

If Sh_month > 6 Then

 Kole_roz_sh = 186
 Temp4 = Sh_month - 7
 Temp4 = Temp4 * 30
 Kole_roz_sh = Kole_roz_sh + Temp4

Else

 Temp4 = Sh_month - 1
 Temp4 = Temp4 * 31
 Kole_roz_sh = Kole_roz_sh + Temp4

End If
Kole_roz_sh = Kole_roz_sh + Sh_day

'****************************
If Kole_roz_sh > 286 Then

   M_year = Sh_year + 622
   Kole_roz_m = Kole_roz_sh - 286

Else

   M_year = Sh_year + 621
   Kole_roz_m = Kole_roz_sh + 79

End If
'**************************

If M_kabise(m_year) = 0 Then
   Day_of_month(2) = 28
Else
   Day_of_month(2) = 29
End If


'----------------



For M_month = 1 To 12

   If Kole_roz_m < 31 Then Exit For
   Kole_roz_m = Kole_roz_m - Day_of_month(m_month)

Next


If Kole_roz_m > Day_of_month(m_month) Then

    Kole_roz_m = Kole_roz_m - Day_of_month(conter1)
    Incr M_month

End If

M_day = Kole_roz_m

Return



Function M_kabise(byref Sal As Word)as Byte

   Local T1 As Integer
   Local T2 As Integer
   Local T3 As Integer
   Local B As Byte
   '=========================
   T1 = Sal Mod 4
   T2 = Sal Mod 100
   T3 = Sal Mod 400
   B = 0
   '=========================
   '------
   If T1 = 0 And T2 <> 0 Then
      B = 1
   End If
   '------
   If T2 = 0 And T3 = 0 Then
      B = 1
   End If
   '------
   M_kabise = B

End Function


Function Sh_kabise(byref Sal As Word)as Byte

   Local T1 As Integer
   Local B As Byte
   '==================
   T1 = Sal Mod 33
   B = 0
   '==================
   '------
   If T1 = 1 Or T1 = 5 Or T1 = 9 Or T1 = 13 Or T1 = 17 Or T1 = 22 Or _
   T1 = 26 Or T1 = 30 Then

      B = 1

   End If
   '------
   Sh_kabise = B

End Function

Sub Beep:
     'reset watchdog
     Set Buz
     Waitms 80
     Reset Buz
     Waitms 30
End Sub
Return

Sub Errorbeep

    Set Buz
    Waitms 700
    Reset Buz

End Sub



Sub Readtouch

Touch = 0
'do
  reset watchdog
    if touch1 = 1 then
       do

       Loop Until Touch1 = 0
       Touch = 1
    endif
    if touch2 = 1 then
       Do
       Loop Until Touch2 = 0
       Touch = 2
    endif
    if touch3 = 1 then
       Do
       Loop Until Touch3 = 0
       touch = 3
    endif
    if touch4 = 1 then
       Do
       Loop Until Touch4 = 0
       touch = 4
    endif

 If Touch > 0 Then Call Beep
'loop until touch > 0
End Sub

Includes:

$include "font32x32.font"
$include "font16x16.font"
$include "font8x8.font"
Setclockicon:
$bgf "clock.bgf"
Remoteicon:
$bgf "remote.bgf"
Planticon:
$bgf "plant.bgf"
Lighticon:
$bgf "light.bgf"
Jaccuziicon:
$bgf "jaccuzi.bgf"
Watersystemicon:
$bgf "watersystem.bgf"
Kelidhaicon:
$bgf "kelidha.bgf"
Settingicon:
$bgf "settingicon2.bgf"

End
