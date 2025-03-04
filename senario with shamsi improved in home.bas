

$regfile = "m128def.dat"
$crystal = 11059200

$hwstack = 64
$swstack = 100
$framesize = 100

$baud = 115200

$include "FONT/farsi_func.bas"
$lib "glcdKS108.lib"

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

Lcdconfig:
'-----------------------------------------------------
Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 1 , Ce2 = 0 , Cd = 6 , Rd = 5 , Reset = 2 , Enable = 4
Setfont Font8x8
Initlcd

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


Maxconfig:

Enable Interrupts
'Enable Urxc
'On Urxc Rx



Dim Senario As Byte
Dim Maxin As Byte
Dim Id As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Startbit As Byte : Startbit = 252
Dim Endbit As Byte : Endbit = 220
Dim Findorder As Byte
Dim Remoteid As Byte
Dim Remotekeyid As Byte

Dim Fstatus As Eram Byte
Dim Lstatus As Eram Byte
Dim Pstatus As Eram Byte
Dim Wstatus As Eram Byte

Dim Fdays As Eram Byte
Dim Ldays As Eram Byte
Dim Pdays As Eram Byte
Dim Wdays As Eram Byte
Dim Days As Byte

Dim Fonhour As Eram Byte
Dim Fonmin As Eram Byte
Dim Foffhour As Eram Byte
Dim Foffmin As Eram Byte

Dim Lonhour As Eram Byte
Dim Lonmin As Eram Byte
Dim Loffhour As Eram Byte
Dim Loffmin As Eram Byte

Dim Ponhour As Eram Byte
Dim Ponmin As Eram Byte
Dim Poffhour As Eram Byte
Dim Poffmin As Eram Byte

Dim Wonhour As Eram Byte
Dim Wonmin As Eram Byte
Dim Woffhour As Eram Byte
Dim Woffmin As Eram Byte

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

Dim X As Word
Dim W As Word
Dim Z As Word


Plant_def:

          Dim Plant_status As Byte
          Dim Plant_start_hour As Byte
          Dim Plant_start_min As Byte
          Dim Plant_stop_hour As Byte
          Dim Plant_stop_min As Byte
          Dim Plant_days(7) As Byte

Defines:

Dim Jstatus As Boolean


Dim Pumps As Bit
Dim Mutes As Bit
Dim Sensors As Bit

Dim Backmenu As Boolean

Dim Pass(4) As Byte
Dim Reerror As Byte

Dim Poosh As Word
Dim Touch As Byte
Dim Nextday As Boolean
Dim Count As Byte

Dim Inputcounter As Byte
Dim Relaymodulecounter As Eram Byte : If Relaymodulecounter = 255 Then Relaymodulecounter = 0
Dim Pwmmodulecounter As Eram Byte : If Pwmmodulecounter = 255 Then Pwmmodulecounter = 0
Dim Einputcounter As Eram Byte : If Einputcounter = 255 Then Einputcounter = 0
Inputcounter = Einputcounter

Dim Sycnum As Eram Byte
Dim Configmode As Byte
Dim Ok1 As Boolean
Dim Ok2 As Boolean
Dim Ok3 As Boolean
Dim Ok4 As Boolean

Dim I As Byte
Dim J As Byte

Order_consts:

Const Allid = 99
Const Alltyp = 115
Const Readallinput = 1
Const Read1input = 2
Const Setidkey = 3
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
Const Setidremote = 23
Const Sycrelaymoduleid = 24
Const Sycpwmmoduleid = 25
Const Setidformodules = 26
Const Clearall = 27
Const Pwmlight = 28
Const Pwmblink = 29
Const Readyoutput = 30


Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

Const Dark = 161
Const Minlight = 162
Const Midlight = 163
Const Maxlight = 164

Consts:


Const Main_menu_counter = 8

Subs:


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
Declare Sub Readtouch
Declare Sub Show
Declare Sub Main_menu
Declare Sub Input_menu
Declare Sub Tx
Declare Sub Order
Declare Sub Checkanswer

Startup:

Eday = Day
Set Backlight

Cls
Call Beep
Showpic 32 , 0 , Logo
Waitms 500
Cls
Findorder = Readremote
Call Order
Findorder = Readallinput
Call Order


Main:

     Do
       Gosub Read_date_time
       Gosub M_to_sh


       If Refreshtemp <> _sec Then
          Call Temp
'(
          If _sec = 5 Or _sec = 20 Or _sec = 35 Or _sec = 50 Then
            Cls
            Select Case Senario
               Case 0
                  Showpic 0 , 17 , Srutin , 0
                  Showpic 31 , 17 , Snight , 0
                  Showpic 63 , 17 , Sparty , 0
                  Showpic 95 , 17 , Sexiticon , 0
               Case 1
                  Showpic 0 , 17 , Srutin , 1
                  Showpic 31 , 17 , Snight , 0
                  Showpic 63 , 17 , Sparty , 0
                  Showpic 95 , 17 , Sexiticon , 0
               Case 2
                  Showpic 0 , 17 , Srutin , 0
                  Showpic 31 , 17 , Snight , 1
                  Showpic 63 , 17 , Sparty , 0
                  Showpic 95 , 17 , Sexiticon , 0
               Case 3
                  Showpic 0 , 17 , Srutin , 0
                  Showpic 31 , 17 , Snight , 0
                  Showpic 63 , 17 , Sparty , 1
                  Showpic 95 , 17 , Sexiticon , 0
               Case 4
                  Showpic 0 , 17 , Srutin , 0
                  Showpic 31 , 17 , Snight , 0
                  Showpic 63 , 17 , Sparty , 0
                  Showpic 95 , 17 , Sexiticon , 1
            End Select
          End If

          If _sec = 0 Or _sec = 15 Or _sec = 30 Or _sec = 45 Then
             Cls
             Setfont Font16x16en
             If Jstatus = 0 Then
                Lcdat 3 , 1 , Sens1 ; "! "
                Showpic 0 , 33 , Tempicon

             Else
                Lcdat 3 , 1 , Sens2 ; "! "
                Showpic 0 , 33 , Smalljacuzi
             End If
             If Pumps = 1 Then
                Showpic 31 , 33 , Spump , 1
             Else
                Showpic 31 , 33 , Spump , 0
             End If
             If Mutes = 1 Then
                Showpic 63 , 33 , Smute , 0
             Else
                Showpic 63 , 33 , Sunmute , 0
             End If
             If Sensors = 1 Then
                Showpic 95 , 33 , Sensensor , 0
             Else
                Showpic 95 , 33 , Sdissensor , 0
             End If
             Setfont Font8x8

          End If

          If _sec = 10 Or _sec = 25 Or _sec = 40 Or _sec = 55 Then
            Cls
            If Lstatus = 1 Then
               Showpic 0 , 17 , Slight , 1
            Else
               Showpic 0 , 17 , Slight , 0
            End If
            If Pstatus = 1 Then
               Showpic 31 , 17 , Splant , 1
            Else
               Showpic 31 , 17 , Splant , 0
            End If
            If Wstatus = 1 Then
               Showpic 63 , 17 , Swatersystem , 1
            Else
               Showpic 63 , 17 , Swatersystem , 0
            End If
            If Fstatus = 1 Then
               Showpic 95 , 17 , Sfountain , 1
            Else
               Showpic 95 , 17 , Sfountain , 0
            End If
          End If
          ')
         Refreshtemp = _sec
       End If
       Call Show
       If Touch1 = 1 Or Touch2 = 1 Or Touch3 = 1 Or Touch4 = 1 Then
          Waitms 50
          If Touch1 = 1 Or Touch2 = 1 Or Touch3 = 1 Or Touch4 = 1 Then
             Poosh = 0
             Call Beep
             Gosub Choose_senario
          End If
       End If
       Call Readtouch

       'If Touch > 0 Then Call Main_menu


     Loop

Gosub Main

Choose_senario:

Do
Waitms 50
Incr Poosh
If Poosh > 600 Then
   Cls
   Return
End If

       If Touch1 = 1 Then
       Call Beep
          Poosh = 0
          Do
            Waitms 50
            Incr Poosh
            If Poosh > 40 Then
               Exit Do
            End If
          Loop Until Touch1 = 0
          If Poosh > 40 Then
             Poosh = 0
             Cls
             Call Main_menu
          Elseif Poosh < 20 Then

                 If Poosh < 20 And Ok1 = 1 Then
                    Cls
                    Showpic 0 , 0 , Rutin , 1
                    Setlight = Minlight
                    Findorder = Pwmlight
                    Senario = 1
                    Call Order
                    Wait 2
                    Cls
                    Exit Do
                 End If
                 If Poosh < 20 And Ok1 = 0 Then
                    Set Ok1
                    Reset Ok2
                    Reset Ok3
                    Reset Ok4
                    Cls
                    Showpic 0 , 0 , Rutin
                 End If
          End If
          Poosh = 0
       End If

       If Touch2 = 1 And Ok2 = 0 Then
       Call Beep
                 Poosh = 0
                 Set Ok2
                 Reset Ok1
                 Reset Ok3
                 Reset Ok4
                 Cls
                 Showpic 0 , 0 , Night
                 Do
                 Loop Until Touch2 = 0

       Elseif Touch2 = 1 And Ok2 = 1 Then
                 Call Beep
                 Poosh = 0
                 Do
                    Cls
                    Showpic 0 , 0 , Night , 1
                    Setlight = Maxlight
                    Findorder = Pwmlight
                    Senario = 2
                    Call Order
                    Wait 2
                    Cls
                    Exit Do
                 Loop Until Touch2 = 0
       End If

       If Touch3 = 1 And Ok3 = 0 Then
       Call Beep
       Poosh = 0
                 Set Ok3
                 Reset Ok1
                 Reset Ok2
                 Reset Ok4
                 Cls
                 Showpic 0 , 0 , Party
                 Do
                 Loop Until Touch3 = 0


       Elseif Touch3 = 1 And Ok3 = 1 Then
       Call Beep
       Poosh = 0
                 Do
                    Cls
                    Showpic 0 , 0 , Party , 1
                    Setlight = Midlight
                    Findorder = Pwmlight
                    Senario = 3
                    Call Order
                    Wait 2
                    Cls
                    Exit Do
                 Loop Until Touch3 = 0
       End If

       If Touch4 = 1 Then
       Call Beep
          Poosh = 0
          Do
            Waitms 50
            Incr Poosh
            If Poosh > 40 Then
               Exit Do
            End If
          Loop Until Touch4 = 0
          If Poosh > 40 Then
             Poosh = 0
             Cls
             Return
          Elseif Poosh < 20 Then

                 If Poosh < 20 And Ok4 = 1 Then
                    Cls
                    Showpic 0 , 0 , Exiticon , 1
                    Setlight = Minlight
                    Findorder = Pwmlight
                    Senario = 4
                    Call Order
                    Wait 2
                    Cls
                    Exit Do
                 End If
                 If Poosh < 20 And Ok4 = 0 Then
                                  Reset Ok1
                                  Reset Ok2
                                  Reset Ok3
                                  Set Ok4
                                  Cls
                                  Showpic 0 , 0 , Exiticon
                 End If
          End If
          Poosh = 0
       End If
Loop
Return

Rx:

      Incr J
      Incr I
      Inputbin Maxin

      If I = 5 And Maxin = 230 Then Set Inok
      If Maxin = 252 Then I = 1

      Din(i) = Maxin
      If Inok = 1 And Din(1) = 252 Then
         I = 0
         Typ = Din(2) : Cmd = Din(3) : Id = Din(4)
         Checkanswer
         Reset Inok
         Cls
      End If

Return


Conversion:
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
Return


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
  _sec = 0
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



End

Includes:
$include "FONT/farsi_map.bas"
$include "FONT/font8x8.font"
$include "FONT/font12x16dig_f.font"
$include "FONT/digit_notifi_12x16.font "


$include "font32x32.font"

$include "font16x16en.font"

'$include "font8x8.font"


Sub Main_menu

     Touch = 0
     Do
        Call Readtouch
     Loop Until Touch = 0
     Waitms 100
     Cls
     Count = 1
     Showpic 32 , 0 , Settingicon

     Do
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
            If Touch = 2 Then
                   Incr Count
                   If Count > Main_menu_counter Then Count = 1
                   Cls
            End If
            If Touch = 3 Then
                   Decr Count
                   If Count = 0 Then Count = Main_menu_counter
                   Cls
            End If
            If Touch = 4 Then
                   Findorder = Readallinput
                   Call Order
                   Findorder = Readremote
                   Call Order
                   Findorder = Readyoutput
                   Call Order
                   Touch = 0
                   Cls
                   Gosub Main
            End If
            If Touch = 2 Or Touch = 3 Then
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
                        Touch = 0
            End If
            If Touch = 1 Then
                   Touch = 0
                   Cls
                   Select Case Count
                          Case 1
                               Call Setting_menu
                          Case 2
                               Call Jacuzi_menu
                          Case 3
                               Call Plant_menu
                          Case 4
                               Call Watersystem_menu
                          Case 5
                               Call Light_menu
                          Case 6
                               Call Fountain_menu
                          Case 7
                               Call Clock_menu
                          Case 8
                               Call Configmenu


                   End Select
            End If
            Call Readtouch
     Loop
End Sub


Sub Ifcheck

    If Sh_month = 6 And Sh_day = 31 Then
       If _hour = 0 And _min = 0 And Backtime = 0 Then
              Set Backtime
              If Backtime = 1 Then
                 _hour = 23
                 _min = 0
                 Sh_day = 30
                  Gosub Sh_to_m
                  Gosub Setdate
                  Gosub Settime

              End If
       End If
    Else
        If _hour = 0 And _min = 0 Then
           Incr Day
           Eday = Day
        End If
    End If

    If Sh_month = 1 And Sh_day = 2 Then
       If _hour = 0 And _min = 0 And Backtime = 0 Then
              Set Backtime
              If Backtime = 1 Then
                 _hour = 1
                 _min = 0
                  Gosub Sh_to_m
                  Gosub Setdate
                  Gosub Settime
              End If
       End If
    Else
        If _hour = 0 And _min = 0 Then
           Incr Day
           Eday = Day
        End If
    End If



    If _hour = 1 And _min = 1 And Backtime = 1 Then
       Reset Backtime
       Incr Day
       Eday = Day
    End If


    If Ponhour = _hour And Ponmin = _min Then
       Days = Pdays
       If Days.day = 1 Then
          Cmd = 182
          Id = Idplant
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If

    If Lonhour = _hour And Lonmin = _min Then
       Days = Ldays
       If Days.day = 1 Then
          Cmd = 182
          Id = Idlight
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If

    If Wonhour = _hour And Wonmin = _min Then
       Days = Wdays
       If Days.day = 1 Then
          Cmd = 182
          Id = Idwater
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If

    If Poffhour = _hour And Poffmin = _min Then
       Days = Pdays
       If Days.day = 1 Then
          Cmd = 181
          Id = Idplant
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If
    If Loffhour = _hour And Loffmin = _min Then
       Days = Ldays
       If Days.day = 1 Then
          Cmd = 181
          Id = Idlight
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If

    If Woffhour = _hour And Woffmin = _min Then
       Days = Wdays
       If Days.day = 1 Then
          Cmd = 181
          Id = Idwater
          Typ = Relaymodule
          Direct = Tooutput
          Call Tx
       End If
    End If

    If _hour = 1 And _min = 1 Then

       Select Case Sh_day
              Case 1 To 10
                   U = 0
              Case 11 To 20
                   U = 1
              Case Is > 20
                   U = 2
       End Select
       D = U + 3

       Select Case Sh_month
              Case 1
                   Sunriseh = Lookup(u , 1h)
                   Sunrisem = Lookup(d , 1m)
                   Sunseth = Lookup(u , 1h)
                   Sunsetm = Lookup(d , 1m)
              Case 2
                   Sunriseh = Lookup(u , 2h)
                   Sunrisem = Lookup(d , 2m)
                   Sunseth = Lookup(u , 2h)
                   Sunsetm = Lookup(d , 2m)
              Case 3
                   Sunriseh = Lookup(u , 3h)
                   Sunrisem = Lookup(d , 3m)
                   Sunseth = Lookup(u , 3h)
                   Sunsetm = Lookup(d , 3m)
              Case 4
                   Sunriseh = Lookup(u , 4h)
                   Sunrisem = Lookup(d , 4m)
                   Sunseth = Lookup(u , 4h)
                   Sunsetm = Lookup(d , 4m)
              Case 5
                   Sunriseh = Lookup(u , 5h)
                   Sunrisem = Lookup(d , 5m)
                   Sunseth = Lookup(u , 5h)
                   Sunsetm = Lookup(d , 5m)
              Case 6
                   Sunriseh = Lookup(u , 6h)
                   Sunrisem = Lookup(d , 6m)
                   Sunseth = Lookup(u , 6h)
                   Sunsetm = Lookup(d , 6m)
              Case 7
                   Sunriseh = Lookup(u , 7h)
                   Sunrisem = Lookup(d , 7m)
                   Sunseth = Lookup(u , 7h)
                   Sunsetm = Lookup(d , 7m)
              Case 8
                   Sunriseh = Lookup(u , 8h)
                   Sunrisem = Lookup(d , 8m)
                   Sunseth = Lookup(u , 8h)
                   Sunsetm = Lookup(d , 8m)
              Case 9
                   Sunriseh = Lookup(u , 9h)
                   Sunrisem = Lookup(d , 9m)
                   Sunseth = Lookup(u , 9h)
                   Sunsetm = Lookup(d , 9m)
              Case 10
                   Sunriseh = Lookup(u , 10h)
                   Sunrisem = Lookup(d , 10m)
                   Sunseth = Lookup(u , 10h)
                   Sunsetm = Lookup(d , 10m)
              Case 11
                   Sunriseh = Lookup(u , 11h)
                   Sunrisem = Lookup(d , 11m)
                   Sunseth = Lookup(u , 11h)
                   Sunsetm = Lookup(d , 11m)
              Case 12
                   Sunriseh = Lookup(u , 12h)
                   Sunrisem = Lookup(d , 12m)
                   Sunseth = Lookup(u , 12h)
                   Sunsetm = Lookup(d , 12m)
       End Select
    End If


    If Sunriseh = _hour And Sunrisem = _min And _sec = 0 Then
       Id = Idlight
       Cmd = 181
       Typ = Relaymodule
       Call Tx

    End If

    If Sunseth = _hour And Sunsetm = _min And _sec = 0 Then
       Id = Idlight
       Cmd = 182
       Typ = Relaymodule
       Call Tx
    End If

End Sub

Sub Setting_menu

   If Pumps = 1 Then
      Showpic 0 , 17 , Spump , 1
   Else
      Showpic 0 , 17 , Spump , 0
   End If

   If Mutes = 1 Then
      Showpic 31 , 17 , Smute , 1
   Else
      Showpic 31 , 17 , Sunmute , 0
   End If

   If Sensors = 1 Then
      Showpic 63 , 17 , Sensensor , 0
   Else
      Showpic 63 , 17 , Sdissensor , 0
   End If

   Showpic 95 , 17 , Sexiticon , 0

   Do
      Call Readtouch
      If Touch = 1 Then
         Toggle Pumps
         If Pumps = 1 Then
            Showpic 0 , 17 , Spump , 1
         Else
            Showpic 0 , 17 , Spump , 0
         End If
      End If
      If Touch = 2 Then
         Toggle Mutes
         If Mutes = 1 Then
            Showpic 31 , 17 , Smute , 0
         Else
            Showpic 31 , 17 , Sunmute , 0
         End If
      End If
      If Touch = 3 Then
         Toggle Sensors
         If Sensors = 1 Then
            Showpic 63 , 17 , Sensensor , 0
         Else
            Showpic 63 , 17 , Sdissensor , 0
         End If
      End If

      If Touch = 4 Then
         Showpic 95 , 17 , Sexiticon , 1
         Waitms 500
         Cls
         Return
      End If
   Loop

End Sub

Sub Configmenu
    Touch = 0
    Count = 1
    Cls
    Setfont Font8x8
    Do
      For I = 1 To 4
       Do
               Select Case I
                Case 1
                     If Blink_ = 1 Then
                        Lcdat 4 , 48 , "*"
                     Else
                        Lcdat 4 , 48 , " "
                     End If
                Case 2
                     If Blink_ = 1 Then
                        Lcdat 4 , 48 , "**"
                     Else
                        Lcdat 4 , 48 , "* "
                     End If
                Case 3
                     If Blink_ = 1 Then
                        Lcdat 4 , 48 , "***"
                     Else
                        Lcdat 4 , 48 , "** "
                     End If
                Case 4
                     If Blink_ = 1 Then
                        Lcdat 4 , 48 , "****"
                     Else
                        Lcdat 4 , 48 , "*** "
                     End If
               End Select
                   Incr Timer_1
                   If Timer_1 > 5 Then
                    Timer_1 = 0
                    Toggle Blink_
                   End If
                   Waitms 50
        Call Readtouch
        If Touch > 0 Then Exit Do
       Loop
       Pass(i) = Touch
       Do
         Call Readtouch
       Loop Until Touch = 0
      Next
      Lcdat 4 , 48 , "****"
      If Pass(1) = 1 And Pass(2) = 4 And Pass(3) = 2 And Pass(4) = 3 Then
         Call Beep
         Waitms 50
         Call Beep
         Reerror = 0
         Cls
         Exit Do
      Else
          Call Errorbeep
          Incr Reerror
          If Reerror > 2 Then
             Cls
             Lcdat 4 , 1 , " Wrong Password "
             Do
               Wait 1
               Incr Reerror
             Loop Until Reerror > 14
             Reerror = 0
          End If
          Cls
      End If
    Loop
    Do


        If Count > 4 Or Count < 1 Then Count = 1
        Select Case Count
               Case 1

                    Lcdat 3 , 1 , "Config Remotes  "

               Case 2

                    Lcdat 3 , 1 , "Clear All       "

               Case 3

                    Lcdat 3 , 1 , "Set Key ID      "

               Case 4

                    Lcdat 3 , 1 , "Set Module ID   "

        End Select

        Call Readtouch
        If Touch = 4 Then
           Cls
           Set Backmenu
           Return
        End If

        If Touch = 2 Then
           Incr Count
           Cls
        End If
        If Touch = 3 Then
           Decr Count
           Cls
        End If
        Lcdat 1 , 1 , "Setting Menu    " , 1
        If Count = 0 Then Count = 4
        If Count > 4 Then Count = 1
        If Touch = 1 Then
           Select Case Count
                  Case 1
                       Call Remote_menu

                  Case 2
                       Lcdat 3 , 1 , "all IDs Cleared"
                       Relaymodulecounter = 0
                       Pwmmodulecounter = 0
                       Einputcounter = 0
                       Inputcounter = 0
                       'Typ = 101
                       'Direct = Toinput
                       'Findorder = Clearall
                       'Call Order
                       'Typ = 104
                       'Findorder = Clearremote
                       'Call Order
                       Direct = Tooutput
                       Typ = 110
                       Findorder = Clearall
                       Call Order
                       Direct = Tooutput
                       Typ = 111
                       Findorder = Clearall
                       Call Order

                  Case 3
                       Call Setkeyid

                  Case 4
                       Call Set_id_modules

           End Select
        End If
    Loop
End Sub

Sub Setkeyid

    'Incr Inputcounter

    Do


        Call Readtouch

      If Touch = 4 Then
         Einputcounter = Inputcounter
         Return
      End If

      If Touch = 2 Then
         Incr Inputcounter
         Einputcounter = Inputcounter
      End If

      If Touch = 3 Then
         Decr Inputcounter
         Einputcounter = Inputcounter
      End If
      If Inputcounter > 50 Then Inputcounter = 1
      If Inputcounter < 1 Then Inputcounter = 1
      Inputcounter = Einputcounter
      Lcdat 1 , 1 , "Set Key IDs     " , 1
      If Inputcounter = 0 Then Inputcounter = 1
      Lcdat 3 , 1 , "Learn Key #" ; Inputcounter ; "  "

      If Touch = 1 Then
         Lcdat 3 , 1 , "Press All Key   "
         Touch = 0
         If Inputcounter = 0 Then Inputcounter = 1
         Einputcounter = Inputcounter
         Id = Inputcounter
         Do
           Findorder = Readallinput
           Call Order
           If Inputcounter > 50 Then Inputcounter = 1
           Id = Inputcounter
           Findorder = Setidkey
           Call Order
           Wait 3
           Lcdat 3 , 1 , "Key number " ; Inputcounter ; "  "
           If Touch4 = 1 Then
              Waitms 50
              If Touch4 = 1 Then Exit Do
           End If
         Loop
         Cls
      End If
    Loop

End Sub

Sub Set_id_modules
                 Findorder = Readremote
                 Call Order
                 Findorder = Readallinput
                 Call Order


                 Lcdat 5 , 1 , Farsi( "����� ����")
                 Lcdat 7 , 1 , Farsi( "����� � �����")
    Do
      Call Readtouch
      If Touch = 4 Then
         Cls
         Exit Do
      End If
      If Touch = 1 Then
                 Cls
                 Lcdat 5 , 1 , Farsi( "����� ����")
                 Lcdat 7 , 1 , Farsi( "�� ������ ����")
                 Findorder = Setidformodules
                 Typ = Relaymodule
                 Call Order
                 Findorder = Setidformodules
                 Typ = Pwmmodule
                 Call Order
      End If
    Loop

End Sub

Sub Module_config
        Cls
        Count = 1
Do
        Call Readtouch
        If Touch = 4 Then
           Cls
           Set Backmenu
           Return
        End If

        If Touch = 2 Then
           Incr Count
           Sycnum = Count
           Cls
        End If
        If Touch = 3 Then
           Decr Count
           Sycnum = Count
           Cls
        End If
        Count = Sycnum
        If Configmode = Relaymodule Then Lcdat 1 , 1 , "Relay Cng Menu  " , 1
        If Configmode = Pwmmodule Then Lcdat 1 , 1 , "PWM Cng Menu    " , 1
        Lcdat 5 , 1 , "Syc I/O " ; Count ; "  "
        If Touch = 1 Then
               Lcdat 6 , 1 , "press a key"
              If Configmode = Relaymodule Then
                 Findorder = Readremote
                 Call Order
                 Findorder = Readallinput
                 Call Order
                 Typ = Relaymodule
                 Cmd = 180
                 Findorder = Sycrelaymoduleid
                 Id = Count
                 Call Order
              Elseif Configmode = Pwmmodule Then
                 Findorder = Readremote
                 Call Order
                 Findorder = Readallinput
                 Call Order
                 Typ = Pwmmodule
                 Cmd = 183
                 Findorder = Pwmblink
                 Id = Count
                 Call Order
                 Cmd = 160
                 Findorder = Sycpwmmoduleid
                 Id = Count
                 Call Order
              End If


        End If
        Touch = 0
Loop
End Sub


Sub Sync_io
Cls

End Sub

Sub Remote_menu
    Count = 1
    Cls
    Do
        Call Readtouch
        If Touch = 4 Then
           Findorder = Readremote
           Call Order
           Set Backmenu
           Cls
           Return
        End If

        If Touch = 1 Then
           Select Case Count
                  Case 1
                       Direct = Toinput
                       Typ = 104
                       Findorder = Clearremote
                       Call Order
                       Findorder = Clearall
                       Call Order
                       Typ = 101
                       Direct = Toinput
                       Findorder = Clearall
                       Call Order
                  Case 2
                       Findorder = Learnremote
                       Call Order
                  Case 3
                       'Findorder = Setidremote
                       'Lcdat 5 , 1 , "Press Remote    "
                       'Call Order
           End Select

        End If
        Lcdat 1 , 1 , Farsi( "      ���� �����") , 1

        If Touch = 2 Then
           Incr Count
           If Count > 2 Then Count = 1
           Cls
        End If

        If Touch = 3 Then
           Decr Count
           If Count = 0 Then Count = 2
           Cls
        End If

        Select Case Count
               Case 1
                    Lcdat 3 , 1 , Farsi( "  �ǘ ���� �����")
               Case 2
                    Lcdat 3 , 1 , Farsi( "    ������ �����" )
               'Case 3
                    'Lcdat 3 , 1 , "Config Remotes  "
        End Select
    Loop
End Sub

Sub Pwlsetting
    Selection = 1
    Cls
    Status = 1

    Do

        Select Case Id
               Case Idlight
                    Lcdat 1 , 1 , Farsi( " ������� ���    ") , 1
               Case Idplant
                    Lcdat 1 , 1 , Farsi( " ��� ����       ") , 1
               Case Idwater
                    Lcdat 1 , 1 , Farsi( " ������         " ) , 1
               Case Idfountain
                    Lcdat 1 , 1 , Farsi( " �����          " ) , 1
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
    Lcdat 1 , 1 , Farsi( " ̘���          ") , 1


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
    Onhour = Ponhour
    Onmin = Ponmin
    Offhour = Poffhour
    Offmin = Poffmin

    Call Pwlsetting

    Pdays = Days
    Pstatus = Status
    Ponhour = Onhour
    Ponmin = Onmin
    Poffhour = Offhour
    Poffmin = Offmin

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
    Onhour = Wonhour
    Onmin = Wonmin
    Offhour = Woffhour
    Offmin = Woffmin

    Call Pwlsetting

    Wdays = Days
    Wstatus = Status
    Wonhour = Onhour
    Wonmin = Onmin
    Woffhour = Offhour
    Woffmin = Offmin

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
    Onhour = Fonhour
    Onmin = Fonmin
    Offhour = Foffhour
    Offmin = Foffmin

    Call Pwlsetting

    Fdays = Days
    Fstatus = Status
    Fonhour = Onhour
    Fonmin = Onmin
    Foffhour = Offhour
    Foffmin = Offmin
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
    Onhour = Lonhour
    Onmin = Lonmin
    Offhour = Loffhour
    Offmin = Loffmin

    Call Pwlsetting

    Ldays = Days
    Lstatus = Status
    Lonhour = Onhour
    Lonmin = Onmin
    Loffhour = Offhour
    Loffmin = Offmin
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

Sub Checkanswer
    'Disable Urxc
    Select Case Typ

           Case Keyin

                If Cmd = 151 Then
                         Id = Einputcounter
                         Remotekeyid = Id
                         Findorder = Setidkey
                         Call Order
                End If

                If Cmd = 156 Then
                   Incr Inputcounter
                   Einputcounter = Inputcounter
                End If

                'If Din(4) = Id Then
                   'Lcdat Id , 1 ,"input " ;id;" connect"
                'End If
                'If Din(3) = 151 Then
                   'If Din(4) = Id Then
                      'Learnok = 1
                   'End If
                'End If
                'If Din(3) = 180 Then Set Portc.din(4)
                'If Din(3) = 181 Then Reset Portc.din(4)
                'If Din(3) = 182 Then
                   'Set Portc.id
                   'Wait 2
                   'Reset Portc.id
                'End If
           Case Remote
                Select Case Din(3)
                       Case 180

                       Case 181

                       Case 184
                            Set Learndone

                       Case 185
                            Set Cleardone

                       Case 186
                            Set Setremotedone

                End Select


           Case Senario

           Case Steps

           Case Relaymodule
                If Cmd = 165 Then
                   Relaymodulecounter = Id
                   Lcdat 5 , 1 , Id
                   Wait 2
                   Cls
                End If

           Case Pwmmodule
                If Cmd = 165 Then
                   Pwmmodulecounter = Id
                   Lcdat 5 , 1 , Id
                   Wait 2
                   Cls
                End If

                If Cmd = 190 Then
                   Call Poweroff
                End If

    End Select
    Return
End Sub


Sub Order

    Select Case Findorder



           Case Readallinput

                Direct = Toinput : Typ = 101 : Cmd = 150 : Id = Allid

           Case Read1input

                Direct = Toinput : Typ = 101 : Cmd = 150

           Case Setidkey

                Direct = Toinput : Typ = 101 : Cmd = 151 : Id = Id

           Case Enablebuz

                Direct = Toinput : Typ = 101 : Cmd = 152 : Id = Allid

           Case Disablebuz

                Direct = Toinput : Typ = 101 : Cmd = 153 : Id = Allid

           Case Enablesensor

                Direct = Toinput : Typ = 101 : Cmd = 154 : Id = Allid

           Case Disablesensor

                Direct = Toinput : Typ = 101 : Cmd = 155 : Id = Allid

           Case Enableinput

                Direct = Toinput : Typ = 101 : Cmd = 156 : Id = Allid

           Case Disableinput

                Direct = Toinput : Typ = 101 : Cmd = 157 : Id = Allid

           Case Readremote

                Direct = Toinput : Typ = 104 : Cmd = 150 : Id = Allid

           Case Outputblank

                Direct = Tooutput : Typ = 110 : Cmd = 183 : Id = Id

           Case Resetoutput

                Direct = Tooutput : Typ = 110 : Cmd = 181 : Id = Id

           Case Resetalloutput

                Direct = Tooutput : Typ = 110 : Cmd = 181 : Id = Allid

           Case Setoutput

                Direct = Tooutput : Typ = 110 : Cmd = 180 : Id = Id

           Case Clearid

                Typ = 101 : Cmd = 159 : Id = Id

           Case Clearremote

                Direct = Toinput : Typ = 104 : Cmd = 162 : Id = Allid

           Case Learnremote

                Direct = Toinput : Typ = 104 : Cmd = 161 : Id = Allid

           Case Setidremote

                Direct = Toinput : Typ = 104 : Cmd = 151

           Case Sycrelaymoduleid

                Direct = Tooutput : Typ = 110 : Cmd = 160

           Case Sycpwmmoduleid
                Direct = Tooutput : Typ = 111 : Cmd = 160

           Case Setidformodules
                Direct = Tooutput : Cmd = 151

           Case Clearall
                 Cmd = 158

           Case Pwmlight

                Direct = Tooutput : Typ = Pwmmodule : Cmd = Setlight : Id = Allid

           Case Pwmblink

                Direct = Tooutput : Typ = Pwmmodule : Cmd = 183

           Case Readyoutput
                Direct = Tooutput : Typ = Pwmmodule : Cmd = 150

    End Select

    Call Tx


End Sub



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

Sub Poweroff


End Sub

Sub Show

       Call Ifcheck

 '

 '(
       If Jstatus = 0 Then
          Lcdat 3 , 1 , Sens1 ; "! " , 1
          Showpic 0 , 33 , Tempicon , 1

       Else
          Lcdat 3 , 1 , Sens2 ; "! " , 1
          Showpic 0 , 33 , Smalljacuzi , 1
       End If
')
       'Dift = St1(2) - St1(1)

'       If Dift < 30 And Dift > -30  Then





        'If P = 10 Then



 '
'(
         If Jstatus = 0 Then
            If Tmp1 < 0 Then
                 Lcdat 3 , 0 , "-"
                 If Tmp1 > -100 And Tmp1 < 0 Then
                     Setfont Font 32x32
                     Lcdat 3 , 9 , Sahih1
                     Setfont Font16x16en
                     Lcdat 5 , 41 , Ashar1 ; "  "
                     Lcdat 3 , 41 , " ! "
                 Else
                     Setfont Font32x32
                     Lcdat 3 , 9 , Sahih1
                     Setfont Font16x16en
                     Lcdat 5 , 73 , Ashar1 ; "  "
                     Lcdat 3 , 73 , " ! "
                 End If
            Else
                 If Tmp1 < 100 Then
                     Setfont Font32x32
                     Lcdat 3 , 1 , Sahih1
                     Setfont Font16x16en
                     Lcdat 5 , 33 , Ashar1 ; "  "
                     Lcdat 3 , 33 , " ! "
                 Else
                     Setfont Font32x32
                     Lcdat 3 , 1 , Sahih1
                     Setfont Font16x16en
                     Lcdat 5 , 64 , Ashar1 ; "  "
                     Lcdat 3 , 64 , " ! "
                 End If
            End If
         Else
                     Setfont Font 32x32
                     Lcdat 3 , 0 , Sahih2 , 1
                     Lcdat 7 , 0 , "  " , 1
                     Setfont Font16x16en
                     Lcdat 3 , 64 , "!" , 1
                     Lcdat 4 , 64 , " " , 1
                     Lcdat 7 , 0 , "      " , 1
                     Showpic 90 , 32 , Smalljacuzi , 1
         End If
       'End If

')


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


       'Lcdat 1 , 96 , S2

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

       '(
       X = Sh_year
       X = X - 1396

       If X > 3 Then
          W = X Mod 4
          If W = 0 Then W = X / 4
       Else
           W = 0
       End If

       X = X + W
       If X > 7 Then X = X Mod 7
       X = X + 4

       If X > 7 Then X = X - 7

       Z = 0
       If Sh_month > 1 Then
          Z = Sh_month - 1
          If Z > 6 Then
             Z = Z - 6
             Z = Z * 30
             Z = Z + 186
             Z = Z + Sh_day
          Else
              Z = Z * 31
              Z = Z + Sh_day
          End If
       Else
           Z = Sh_day
       End If
       Z = Z Mod 7
       Z = Z + X
       If Z > 7 Then Z = Z - 7

       Day = Z - 1

')
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




         If Readsens < 0 Then Readsens = Readsens * -1
         Sahih1 = 0
         If Readsens > 9 Then
            Sahih1 = Readsens / 10
            Ashar1 = Readsens Mod 10
         End If


   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Readsens = 1wread(2)
   Tmp2 = Readsens

      Gosub Conversion
      Sens2 = Temperature

         If Readsens < 0 Then Readsens = Readsens * -1
         Sahih2 = 0
         If Readsens > 9 Then
            Sahih2 = Readsens / 10
            Ashar2 = Readsens Mod 10
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





    Call Readtouch

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
 Gosub Sh_to_m
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

Sub Errorbeep

    Set Buz
    Waitms 700
    Reset Buz

End Sub

Sub Readtouch

Touch = 0
'do
  'reset watchdog
    If Touch1 = 1 Then
       Do
       Waitms 30
       Loop Until Touch1 = 0
       Touch = 1
    End If

    If Touch2 = 1 Then

       Do
       Waitms 30
       Loop Until Touch2 = 0
       Touch = 2
    End If

    If Touch3 = 1 Then

       Do
       Waitms 30
       Loop Until Touch3 = 0
       Touch = 3
    End If

    If Touch4 = 1 Then
       Do
       Waitms 30
       Loop Until Touch4 = 0
       Touch = 4
    End If

 If Touch > 0 Then Call Beep
'loop until touch > 0
End Sub

1h:
Data 6 , 6 , 6 , 18 , 18 , 19
1m:
Data 29 , 14 , 0 , 46 , 55 , 3

2h:
Data 5 , 5 , 5 , 19 , 19 , 19
2m:
Data 46 , 35 , 26 , 13 , 21 , 30

3h:
Data 5 , 5 , 5 , 19 , 19 , 19
3m:
Data 18 , 14 , 13 , 38 , 45 , 49

4h:
Data 5 , 5 , 5 , 19 , 19 , 19
4m:
Data 16 , 20 , 26 , 52 , 51 , 48

5h:
Data 5 , 5 , 5 , 19 , 19 , 19,
10,48
5m:
Data 34 , 42 , 50 , 41 , 31 , 20

6h:
Data 5 , 6 , 6 , 19 , 18 , 18
6m:
Data 59 , 7 , 14 , 6 , 52 , 37

7h:
Data 5 , 5 , 5 , 17 , 17 , 16
7m:
Data 23 , 31 , 40 , 20 , 6 , 52

8h:
Data 5 , 5 , 6 , 16 , 16 , 16
8m:
Data 49 , 59 , 9 , 40 , 30 , 22

9h:
Data 6 , 6 , 6 , 16 , 16 , 16
9m:
Data 19 , 29 , 36 , 17 , 15 , 17

10h:
Data 6 , 6 , 6 , 16 , 16 , 16
10m:
Data 41 , 44 , 43 , 22 , 29 , 38

11h:
Data 6 , 6 , 6 , 16 , 16 , 17
11m:
Data 38 , 31 , 21 , 49 , 59 , 10

12h:
Data 6 , 5 , 5 , 17 , 17 , 17
12m:
Data 9 , 56 , 42 , 20 , 29 , 38