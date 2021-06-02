

$regfile = "m128def.dat"
$crystal = 11059200

$hwstack = 64
$swstack = 100
$framesize = 100

$baud = 115200

$include "FONT/farsi_func.bas"
$lib "glcdKS108.lib"

configtemp:

   Config 1wire = Portc.1


   Dim Ds18b20_id_1(9) As Byte
   Dim Ds18b20_id_2(8) As Byte
   Dim Action As Byte
   Ds18b20_id_1(1) = 1wsearchfirst()
   Ds18b20_id_2(1) = 1wsearchnext()
   Dim Temperature As String * 6
   Dim Sens1 As String * 6
   Dim Sens2 As String * 6


   Dim Refreshtemp As Byte

   Dim Readsens As Integer
   Dim Dift As Integer

   Dim P As Byte
   Dim Tempok As Bit

   Dim Tmpread As Boolean
   Dim Tmp1 As Integer
   Dim Tmp2 As Integer

   Dim St1(10) As Integer
   Dim St2(10) As Integer

   Dim Alarmtemp As Byte

   Dim Sahih1 As Integer
   Dim Sahih2 As Integer

   Dim Ashar1 As Integer
   Dim Ashar2 As Integer

configlcd:
'-----------------------------------------------------
   Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 1 , Ce2 = 0 , Cd = 6 , Rd = 5 , Reset = 2 , Enable = 4
   Setfont Font8x8
   Initlcd

configports:

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

configclock:

   Config Sda = Portd.1
   Config Scl = Portd.0

   Const Ds1307w = &HD0
   Const Ds1307r = &HD1
   Dim Eday As Eram Byte
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
   Dim Showtemp As Byte
   Dim Menu As Byte
   Dim Test As Byte
   Dim Timer_1 As Word


   Dim S1 As String * 16
   Dim S2 As String * 16
   Dim S3 As String * 16
   Dim S4 As String * 16
   Dim S As String * 10

   S1 = "  WWW.ISEEE.IR"
   Dim Blink_ As Bit
   Dim Selection As Byte
   Dim A As Byte
   Dim Backtime As Boolean

   Dim Sunseth As Byte
   Dim Sunsetm As Byte

   Dim Sunriseh As Byte
   Dim Sunrisem As Byte
   Dim U As Byte
   Dim D As Byte

configsubs:
   declare sub selectmenu
   declare sub selectsenario
   declare sub beeppro
   declare sub keytouched
   declare sub checkkey
   declare sub showtime
   declare sub conversion
   declare sub read_dt
   declare sub setdate
   declare sub settime
   declare sub mtosh
   declare sub shtom
   Declare Sub Configmenu
   Declare Sub Poweroff

   Declare Sub Ifcheck
   'Declare Function Farsi(byval S As String * 20) As String * 20

   Declare Sub Clock_menu
   Declare Sub Jacuzi_menu
   Declare Sub Light_menu
   Declare Sub Watersystem_menu
   Declare Sub Fountain_menu
   Declare Sub Plant_menu
   Declare Sub Remote_menu
   Declare Sub Setting_menu
   Declare Sub Pwlsetting

   Declare Sub Setkeyid
   Declare Sub Set_id_modules
   Declare Sub Module_config

   Declare Sub Sync_io

   Declare Function M_kabise(byref Sal As Word)as Byte

   Declare Function Sh_kabise(byref Sal As Word) As Byte

   Declare Sub Beep
   Declare Sub Errorbeep
   Declare Sub Temp
   'Declare Sub Readtouch
   Declare Sub Show
   Declare Sub Main_menu
   Declare Sub Input_menu
   Declare Sub Tx
   Declare Sub findOrder
   Declare Sub Checkanswer

Defines:

   dim count as byte
   dim lsec as byte
   dim order as string*20
   dim touch as Byte
   dim backmenu as Boolean
   Dim Inputcounter As Byte

   Dim Sycnum As Eram Byte
   Dim Configmode As Byte
   Dim Ok1 As Boolean
   Dim Ok2 As Boolean
   Dim Ok3 As Boolean
   Dim Ok4 As Boolean

   Dim I As Byte
   Dim J As Byte


configmax:


  'Enable Interrupts
  'Enable Urxc
  'On Urxc Rx



   Dim Senario As Byte
   Dim Maxin As Byte
   Dim Id As Byte
   Dim Typ As Byte
   Dim Cmd As Byte
   Dim Startbit As Byte : Startbit = 252
   Dim Endbit As Byte : Endbit = 220
  'Dim Findorder As Byte
   Dim Remoteid As Byte
   Dim Remotekeyid As Byte

   Dim Fstatus as Byte
   Dim Lstatus As  Byte
   Dim Pstatus As  Byte
   Dim Wstatus As  Byte
   dim jstatus as byte


   Dim Fdays As Eram Byte
   Dim Ldays As Eram Byte
   Dim Pdays As Eram Byte
   Dim Wdays As Eram Byte
   Dim Days As Byte

   Dim Ftime(4) As Eram Byte
   Dim Ltime(4) As Eram Byte
   Dim Ptime(4) As Eram Byte
   Dim Wtime(4) As Eram Byte

   Dim Onhour As Byte
   Dim Onmin As Byte
   Dim Offhour As Byte
   Dim Offmin As Byte

   Dim Status As Byte


   Dim Setlight As Byte

   Dim Din(5) As Byte

   Dim Inok As Boolean
   Dim Learnok As Boolean

   Dim Learndone As Boolean
   Dim Cleardone As Byte
   Dim Setremotedone As Boolean

   Dim Direct As Byte



   Dim X As Word
   Dim W As Word
   Dim Z As Word

Consts:

   Const Keyin = 101
   Const Steps = 102
      'Const Senario = 103
   Const Remote = 104
   Const Relaymodule = 110
   Const Pwmmodule = 111
   Const Outstep = 112

   Const Idjacuzi = 51
   Const Idwater = 52
   Const Idlight = 53
   Const Idplant = 54
   Const Idfountain = 55
   Const Main_menu_counter = 8
   Const Tooutput = 232 : Direct = Tooutput
   const toinput=242



Startup:

   Set Backlight
'lcdat 1,1,"hi"
'wait 5
   Cls
   Call Beep



Main:

   do
      waitms 100
      read_dt
      mtosh
      if _sec<>lsec then
         showtime
         temp
      end if
      lsec=_sec
      keytouched
      if touch>10 and touch<15 then
        selectmenu
      end if
      if touch>20 and touch<25 then
         selectsenario
      end if
   loop

   Gosub Main


   End





sub selectsenario

end sub

sub selectmenu
   cls
   set backmenu
   do
      If Backmenu = 1 Then
         Reset Backmenu
         If Count < 1 Or Count > 8 Then Count = 1
         Select Case Count
            Case 1
               Showpic 32 , 0 , Settingicon
            Case 2
               Showpic 32 , 0 , Jaccuziicon
            Case 3
               Showpic 32 , 0 , Planticon
            Case 4
               Showpic 32 , 0 , Watersystemicon
            Case 5
               Showpic 32 , 0 , Lighticon
            Case 6
               Showpic 32 , 0 , Fountainicon
            Case 7
               Showpic 32 , 0 , Setclockicon
            Case 8
               Showpic 32 , 0 , Configicon

         End Select
      End If
      keytouched
      if touch=11 then
         select case count
            case 1

            case 2
               jaccizimenu
         end select
      end if
      if touch=12 or touch=13 then
         if touch=12 then incr count else decr count
         if count<1 then count=8
         if count>8 then count=1
         cls
         Select Case Count
            Case 1
               Showpic 32 , 0 , Settingicon
            Case 2
               Showpic 32 , 0 , Jaccuziicon
            Case 3
               Showpic 32 , 0 , Planticon
            Case 4
               Showpic 32 , 0 , Watersystemicon
            Case 5
               Showpic 32 , 0 , Lighticon
            Case 6
               Showpic 32 , 0 , Fountainicon
            Case 7
               Showpic 32 , 0 , Setclockicon
            Case 8
               Showpic 32 , 0 , Configicon

         End Select
      end if
      if touch=14 then
         cls
         exit do
      end if
   loop
end sub

sub Conversion:
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub

sub keytouched
   touch=0
   if touch1=1 or touch2=1 or touch3=1 or touch4=1 then
      beep
      checkkey
   end if
end sub

sub checkkey
   if touch1=1 then
      j=0
      do
         incr j
         if j=21 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch1=1
      if j<3 then
         touch=11
      elseif j>20 then
         touch=21
      end if
   end if

   if touch2=1 then
      j=0
      do
         incr j
         if j=21 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch2=1
      if j<3 then
         touch=12
      elseif j>20 then
         touch=22
      end if
   end if
   if touch3=1 then
      j=0
      do
         incr j
         if j=21 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch3=1
      if j<3 then
         touch=13
      elseif j>20 then
         touch=23
      end if
   end if

   if touch4=1 then
      j=0
      do
         incr j
         if j=21 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch4=1
      if j<3 then
         touch=14
      elseif j>20 then
         touch=24
      end if
   end if
end sub

sub Read_dt:
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

end sub

sub showtime


   Setfont Font8x8



   If _hour > 9 Then
      Lcdat 1 , 1 , _hour
   Else
      Lcdat 1 , 1 , "0" ; _hour
   End If
   A = _sec Mod 2
   If A = 1 Then Lcdat 1 , 16 , " " Else Lcdat 1 , 16 , ":"
   If _min > 9 Then
      Lcdat 1 , 24 , _min ; " "
   Else
      Lcdat 1 , 24 , "0" ; _min ; " "
   End If



   Lcdat 1 , 48 , Sh_year ; "/"
   If Sh_month < 10 Then
      Lcdat 1 , 88 , "0" ; Sh_month ; "/"
   Else
      Lcdat 1 , 88 , Sh_month ; "/"
   End If
   If Sh_day < 10 Then
      Lcdat 1 , 112 , "0" ; Sh_day
   Else
      Lcdat 1 , 112 , Sh_day
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

end sub

sub Setdate:
   _year = M_year - 2000
   M_day = Makebcd(m_day) : M_month = Makebcd(m_month) : _year = Makebcd(_year)
   I2cstart                                                  ' Generate start code
   I2cwbyte Ds1307w                                          ' send address
   I2cwbyte 4                                                ' starting address in 1307
   I2cwbyte M_day                                            ' Send Data to SECONDS
   I2cwbyte M_month                                          ' MINUTES
   I2cwbyte _year                                            ' Hours
   I2cstop
end sub


sub Settime:
   _sec = 0
   _sec = Makebcd(_sec) : _min = Makebcd(_min) : _hour = Makebcd(_hour)
   I2cstart                                                  ' Generate start code
   I2cwbyte Ds1307w                                          ' send address
   I2cwbyte 0                                                ' starting address in 1307
   I2cwbyte _sec                                             ' Send Data to SECONDS
   I2cwbyte _min                                             ' MINUTES
   I2cwbyte _hour                                            ' Hours
   I2cstop
end sub


sub Mtosh:

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
end sub

sub Shtom

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

end sub


Sub Tx
    If Direct = Toinput Then
       Endbit = 220
    Elseif Direct = Tooutput Then
       Endbit = 210
    End If
    Set Em
    Waitms 10
    Set Txled
    Printbin Direct ; Typ ; Cmd ; Id ; Endbit
    Waitms 50
    Reset Em
    Reset Txled
    Enable Urxc


End Sub


Sub Temp
   Incr P
   If P > 12 Then P = 1
   'reset watchdog
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   1wwrite &HBE
   Readsens = 1wread(2)


   Tmp1 = Readsens

   Gosub Conversion
   Sens1 = Temperature

   setfont font16x16en
   lcdat 3,1,sens1;"  "


  '(

   If Readsens < 0 Then Readsens = Readsens * -1
   Sahih1 = 0
   If Readsens > 9 Then
   Sahih1 = Readsens / 10
   Ashar1 = Readsens Mod 10
   End If
    ')

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Readsens = 1wread(2)
   Tmp2 = Readsens

   Gosub Conversion
   Sens2 = Temperature
      '(
   If Readsens < 0 Then Readsens = Readsens * -1
   Sahih2 = 0
   If Readsens > 9 Then
   Sahih2 = Readsens / 10
   Ashar2 = Readsens Mod 10
   End If
        ')


End Sub


Sub Pwlsetting
    Selection = 1
    Cls
    Status = 1

    Do

        Select Case Id
               Case Idlight
                    Lcdat 1 , 1 , Farsi( " ÑæÔäÇíí äãÇ    ") , 1
               Case Idplant
                    Lcdat 1 , 1 , Farsi( " ÑÔÏ íÇå       ") , 1
               Case Idwater
                    Lcdat 1 , 1 , Farsi( " ÂÈíÇÑí         " ) , 1
               Case Idfountain
                    Lcdat 1 , 1 , Farsi( " ÂÈäãÇ          " ) , 1
        End Select


        Incr Timer_1
        If Timer_1 > 5 Then
         Timer_1 = 0
         Toggle Blink_
        End If


        If Status < 1 Then Status = 3 : If Status > 3 Then Status = 1

        If Onhour > 59 Then Onhour = 0
        If Onmin > 59 Then Onmin = 0


        If Offhour > 59 Then Offhour = 0
        If Offmin > 59 Then Offmin = 0

        '-----------------------------
        If Selection = 1 And Blink_ = 0 Then
           S1 = "     "
        Else
           If Status = 1 Then S1 = " ON  "
           If Status = 2 Then S1 = " OFF "
           If Status = 3 Then S1 = " AUTO"
        End If

        Setfont Font16x16en
        Lcdat 3 , 1 , S1
        Setfont Font8x8
        S1 = "     "
        If Status = 3 Then

                  S1 = "ON :"


                 '-----------------------------
                 If Selection = 2 And Blink_ = 0 Then

                  S1 = S1 + "  "
                 Else

                  S = Str(onhour)
                  S = Format(s , "00")
                  S1 = S1 + S

                 End If
                 S1 = S1 + ":"
                 '------------------------------
                 If Selection = 3 And Blink_ = 0 Then

                  S1 = S1 + "  "
                 Else

                  S = Str(onmin)
                  S = Format(s , "00")
                  S1 = S1 + S

                 End If

                 Lcdat 6 , 1 , S1

                 S1 = "OFF:"
                 '------------------------------
                 If Selection = 4 And Blink_ = 0 Then

                  S1 = S1 + "  "
                 Else

                  S = Str(offhour)
                  S = Format(s , "00")
                  S1 = S1 + S

                 End If
                 S1 = S1 + ":"
                 '------------------------------
                 If Selection = 5 And Blink_ = 0 Then

                  S1 = S1 + "  "
                 Else

                  S = Str(offmin)
                  S = Format(s , "00")
                  S1 = S1 + S

                 End If


                 Lcdat 7 , 1 , S1




                S1 = ""
                '--------------------------------
                If Selection = 6 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.0 = 1 Then S1 = S1 + "*Sat" Else S1 = S1 + " Sat"


                End If

                Lcdat 2 , 88 , S1

                '---------------------------------
                S1 = ""
                If Selection = 7 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.1 = 1 Then S1 = S1 + "*Sun" Else S1 = S1 + " Sun"


                End If

                Lcdat 3 , 88 , S1
                '----------------------------------

                S1 = ""
                If Selection = 8 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.2 = 1 Then S1 = S1 + "*Mon" Else S1 = S1 + " Mon"


                End If

                Lcdat 4 , 88 , S1
                '----------------------------------
                S1 = ""
                If Selection = 9 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.3 = 1 Then S1 = S1 + "*Tue" Else S1 = S1 + " Tue"


                End If

                Lcdat 5 , 88 , S1
                '----------------------------------

                S1 = ""
                If Selection = 10 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.4 = 1 Then S1 = S1 + "*Wed" Else S1 = S1 + " Wed"


                End If

                Lcdat 6 , 88 , S1
                '----------------------------------
                S1 = ""
                If Selection = 11 And Blink_ = 0 Then

                 S1 = S1 + "     "
                Else

                 If Days.5 = 1 Then S1 = S1 + "*Thu" Else S1 = S1 + " Thu"


                End If

                Lcdat 7 , 88 , S1
                '----------------------------------

                S1 = ""
                If Selection = 12 And Blink_ = 0 Then

                 S1 = S1 + "    "
                Else

                 If Days.6 = 1 Then S1 = S1 + "*Fri" Else S1 = S1 + " Fri"


                End If

                Lcdat 8 , 88 , S1
                '----------------------------------
        End If

        Call Readtouch

        If Touch = 1 Then
           Incr Selection
           If Status < 3 Then
              If Selection > 1 Then Selection = 1
              Return
           End If
           Touch = 0
        End If

        If Touch = 4 Then
           Cls
           Setfont Font8x8
           Set Backmenu
           Return
        End If

        '-----------------------------------
        If Touch = 2 Then

              If Selection = 1 Then Incr Status
              If Selection = 2 Then Incr Onhour
              If Selection = 3 Then Incr Onmin
              If Selection = 4 Then Incr Offhour
              If Selection = 5 Then Incr Offmin
              If Selection = 6 Then Toggle Days.0
              If Selection = 7 Then Toggle Days.1
              If Selection = 8 Then Toggle Days.2
              If Selection = 9 Then Toggle Days.3
              If Selection = 10 Then Toggle Days.4
              If Selection = 11 Then Toggle Days.5
              If Selection = 12 Then Toggle Days.6

              Touch = 0
              Cls
        End If
        '------------------------------------
        If Touch = 3 Then
              If Selection = 1 Then Decr Status
              If Selection = 2 Then Decr Onhour
              If Selection = 3 Then Decr Onmin
              If Selection = 4 Then Decr Offhour
              If Selection = 5 Then Decr Offmin
              If Selection = 6 Then Toggle Days.0
              If Selection = 7 Then Toggle Days.1
              If Selection = 8 Then Toggle Days.2
              If Selection = 9 Then Toggle Days.3
              If Selection = 10 Then Toggle Days.4
              If Selection = 11 Then Toggle Days.5
              If Selection = 12 Then Toggle Days.6
             Touch = 0
             Cls
        End If

        '--------------------------------------



        Waitms 50


        If Selection > 12 Then
           Cls
           Exit Do
        End If
    Loop
End Sub

Sub Jacuzi_menu

    Id = Idjacuzi

    Selection = 1
    Cls
    Lcdat 1 , 1 , Farsi( " Ì˜æÒí          ") , 1


    Do


        Incr Timer_1
        If Timer_1 > 5 Then
         Timer_1 = 0
         Toggle Blink_
        End If




        S1 = ""
        '-----------------------------
        If Selection = 1 And Blink_ = 0 Then
           S1 = S1 + "      "
        Else
           If Status = 1 Then S1 = S1 + " ON  "
           If Status = 2 Then S1 = S1 + " OFF "
        End If
        S2 = ""
        If Selection = 2 And Blink_ = 0 Then
           S2 = S2 + "   "
        Else
           S2 = " " + Str(alarmtemp) + "!"
        End If
        Setfont Font16x16en
        Lcdat 3 , 1 , S1

        Lcdat 5 , 1 , S2


        Call Readtouch

        If Touch = 1 Then
           Incr Selection
           If Selection > 2 Then Selection = 1
           Touch = 0
        End If

        If Touch = 4 Then
           Cls
           Set Backmenu
           Setfont Font8x8
           Exit Do
        End If

        '-----------------------------------
        If Touch = 2 Then

              If Selection = 1 Then Incr Status
              If Selection = 2 Then Incr Alarmtemp
              Touch = 0
        End If
        '------------------------------------
        If Touch = 3 Then
           If Selection = 1 Then Decr Status
           If Selection = 2 Then Decr Alarmtemp
             Touch = 0
        End If

        '--------------------------------------

        If Status > 2 Then Status = 1
        If Status < 1 Then Status = 2

        If Alarmtemp > 40 Then Alarmtemp = 25
        If Alarmtemp < 25 Then Alarmtemp = 40


        Waitms 50

    Loop
       Direct = Tooutput
       Typ = Relaymodule
    If Status = 1 Then
       Cmd = 180
       Jstatus = 1
    End If
    If Status = 2 Then
       Cmd = 181
       Jstatus = 0
    End If
       Call Tx
End Sub

Sub Plant_menu

    Id = Idplant

    Days = Pdays
    Status = Pstatus
    Onhour = Ptime(1)
    Onmin = Ptime(2)
    Offhour = Ptime(3)
    Offmin = Ptime(4)

    Call Pwlsetting

    Pdays = Days
    Pstatus = Status
    Ptime(1)= Onhour
    Ptime(2) = Onmin
    Ptime(3)= Offhour
    Ptime(4) = Offmin

    If Status = 1 Then
       Cmd = 180
       Id = Idplant
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
    If Status = 2 Then
       Cmd = 181
       Id = Idplant
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If


End Sub

Sub Watersystem_menu

    Id = Idwater

    Days = Wdays
    Status = Wstatus
    Onhour = Wtime(1)
    Onmin = Wtime(2)
    Offhour = Wtime(3)
    Offmin = Wtime(4)

    Call Pwlsetting

    Wdays = Days
    Wstatus = Status
    Wtime(1)  = Onhour
    Wtime(2)  = Onmin
    Wtime(3)  = Offhour
    Wtime(4)  = Offmin

    If Status = 1 Then
       Cmd = 180
       Id = Idwater
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
    If Status = 2 Then
       Cmd = 181
       Id = Idwater
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If

End Sub

Sub Fountain_menu

    Id = Idfountain

    Days = Fdays
    Status = Fstatus
    Onhour = Ftime(1)
    Onmin = Ftime(1)
    Offhour = Ftime(1)
    Offmin = Ftime(1)

    Call Pwlsetting

    Fdays = Days
    Fstatus = Status
    Ftime(1)  = Onhour
    Ftime(1)  = Onmin
    Ftime(1)  = Offhour
    Ftime(1)  = Offmin
    If Status = 1 Then
       Cmd = 180
       Id = Idfountain
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
    If Status = 2 Then
       Cmd = 181
       Id = Idfountain
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
End Sub

Sub Light_menu

    Id = Idlight

    Days = Ldays
    Status = Lstatus
    Onhour = Ltime(1)
    Onmin = Ltime(1)
    Offhour = Ltime(1)
    Offmin = Ltime(1)

    Call Pwlsetting

    Ldays = Days
    Lstatus = Status
    Ltime(1)   = Onhour
    Ltime(1)   = Onmin
    Ltime(1)   = Offhour
    Ltime(1)   = Offmin
    If Status = 1 Then
       Cmd = 180
       Id = Idlight
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
    If Status = 2 Then
       Cmd = 181
       Id = Idlight
       Typ = Relaymodule
       Direct = Tooutput
       Call Tx
    End If
End Sub


Sub Clock_menu
   Call Beep
   Selection = 1
   Cls
   Do

      Incr Timer_1
      If Timer_1 > 5 Then
         Timer_1 = 0
         Toggle Blink_
      End If

      S1 = "TIME: "
    '-----------------------------
      If Selection = 1 And Blink_ = 0 Then

         S1 = S1 + "  "
      Else

         S = Str(_hour)
         S = Format(s , "00")
         S1 = S1 + S

      End If
      S1 = S1 + ":"
    '------------------------------
      If Selection = 2 And Blink_ = 0 Then

         S1 = S1 + "  "
      Else

         S = Str(_min)
         S = Format(s , "00")
         S1 = S1 + S

      End If
      S1 = S1 + ":"
    '------------------------------
      If Selection = 3 And Blink_ = 0 Then

         S1 = S1 + "  "
      Else

         S = Str(_sec)
         S = Format(s , "00")
         S1 = S1 + S

      End If


      Lcdat 1 , 1 , S1


      S1 = "DATE: "
    '--------------------------------
      If Selection = 4 And Blink_ = 0 Then

         S1 = S1 + "    "
      Else

         S = Str(sh_year)
         S = Format(s , "0000")
         S1 = S1 + S

      End If
      S1 = S1 + "/"
    '---------------------------------
      If Selection = 5 And Blink_ = 0 Then

         S1 = S1 + "  "
      Else

         S = Str(sh_month)
         S = Format(s , "00")
         S1 = S1 + S

      End If
      S1 = S1 + "/"
    '----------------------------------
      If Selection = 6 And Blink_ = 0 Then

         S1 = S1 + "  "
      Else

         S = Str(sh_day)
         S = Format(s , "00")
         S1 = S1 + S

      End If

      If Selection = 7 And Blink_ = 0 Then
         S2 = "    "
         Eday = Day
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





   ' Call Readtouch

      If Touch = 1 Then
         Incr Selection
         Touch = 0
      End If

      If Touch = 4 Then
         Cls
         Touch = 0
         Set Backmenu
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
   Set Backmenu
   Wait 1
   Cls
   shtom
   Gosub Setdate
   Gosub Settime

End Sub


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


Sub Beep
     'reset watchdog
   Set Buz
   Waitms 80
   Reset Buz
   Waitms 30
End Sub

Sub Beeppro
     'reset watchdog
   Set Buz
   Waitms 100
   Reset Buz
   Waitms 50
   Set Buz
   Waitms 200
   Reset Buz
   Waitms 50
End Sub


Sub Errorbeep

   Set Buz
   Waitms 700
   Reset Buz

End Sub



Spump:
   $bgf "spump.bgf"

Sdissensor:
   $bgf "sdissensor.bgf"

Sensensor:
   $bgf "sensensor.bgf"

Smute:
   $bgf "smute.bgf"

Sunmute:
   $bgf "sunmute.bgf"

Configicon:
   $bgf "configicon.bgf"


Sfountain:
   $bgf "sfountain.bgf"


Slight:
   $bgf "slight.bgf"

Swatersystem:
   $bgf "swatersystem.bgf"

Splant:
   $bgf "splant.bgf"

Sparty:
   $bgf "sparty.bgf"

Snight:
   $bgf "snight.bgf"

Srutin:
   $bgf "srutin.bgf"

Smalljacuzi:
   $bgf "small jacuzi.bgf"

Sexiticon:
   $bgf "sexiticon.bgf"

Exiticon:
   $bgf "exiticon.bgf"

Fountainicon:
   $bgf "fountain.bgf"

Tempicon:
   $bgf "tempicon.bgf"

Cancelicon:
   $bgf "cancel.bgf"

Perviousicon:

   $bgf "pervious.bgf"

Nexticon:
   $bgf "next.bgf"

Menuicon:
   $bgf "menu.bgf"

Tv:
   $bgf "tv.bgf"

Party:
   $bgf "party.bgf"

Rutin:
   $bgf "rutin.bgf"

Night:
   $bgf "night.bgf"

Logo:
   $bgf "logo.bgf"
Settingicon:
   $bgf "settingicon.bgf"

            '$bgf "emtech1.bgf"
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

Kelidha:
   $bgf "kelidha.bgf"


Includes:
   $include "FONT/farsi_map.bas"
   $include "FONT/font8x8.font"
   $include "FONT/font12x16dig_f.font"
   $include "FONT/digit_notifi_12x16.font "
   '$include "font8x8.font"

   $include "font32x32.font"

   $include "font16x16en.font"