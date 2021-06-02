

$regfile = "m128def.dat"
$crystal = 11059200

$hwstack = 64
$swstack = 100
$framesize = 100

$baud = 9600

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

configport:

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


configmax:

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
Dim Findorder As String * 20
Dim Remoteid As Byte
Dim Remotekeyid As Byte

Dim Fstatus As  Byte
Dim Lstatus As  Byte
Dim Pstatus As  Byte
Dim Wstatus As  Byte
dim pustatus as   byte

Dim efdays As Eram Byte
Dim eldays As Eram Byte
Dim epdays As Eram Byte
Dim ewdays As Eram Byte
dim epudays as  eram  byte

Dim fdays As  Byte
Dim ldays As  Byte
Dim pdays As Byte
Dim wdays As  Byte
dim pudays as    byte

Dim Days As Byte

Dim eftime(4) As Eram Byte
Dim eltime(4) As Eram Byte
Dim eptime(4) As Eram Byte
Dim ewtime(4) As Eram Byte
dim eputime(4) as eram byte

Dim ftime(4) As  Byte
Dim ltime(4) As  Byte
Dim ptime(4) As  Byte
Dim wtime(4) As  Byte
dim putime(4) as  byte


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
const idpump=56

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
dim changetime as Boolean
dim lsec as byte
Dim Pumps As Bit
Dim Mutes As Bit
Dim Sensors As Bit

Dim Backmenu As Boolean

Dim Pass(4) As Byte
Dim Reerror As Byte


Dim Touch As Byte
Dim Nextday As Boolean
Dim Count As Byte




Dim I As Byte
Dim J As Byte

Order_consts:

Const Allid = 99



Const Tomaster = 252
Const Tooutput = 232
Const Toinput = 242

Const Dark = 161
Const Minlight = 162
Const Midlight = 163
Const Maxlight = 164

Consts:


Const Main_menu_counter = 8

configSub:
   declare sub pump_menu
   declare sub selectmenu
   declare sub selectsenario
   declare sub beeppro
   declare sub readtouch
   declare sub checkkey
   declare sub shoewtime
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
   Declare Sub beeperror
   Declare Sub Temp

   Declare Sub Show
   Declare Sub Main_menu
   Declare Sub Input_menu
   Declare Sub Tx

   Declare Sub Checkanswer


















Declare Sub Order


Startup:

Eday = Day
Set Backlight

Cls
Call Beep
Showpic 0 , 0 , Logo
Waitms 700
Cls
Waitms 500



Main:

   do
      waitms 100
      read_dt
      mtosh
      if _sec<>lsec then
         shoewtime
         temp
         ifcheck
      end if
      lsec=_sec
      readtouch
      if touch>10 and touch<15 then
        selectmenu
      end if
      if touch>20 and touch<25 then
         selectsenario
      end if
   loop

Gosub Main



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


pumpicon:
$bgf "pump.bgf"

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

   if sh_month=1 and sh_day=2 and _hour=0 and _min=0 and changetime=0 then
      set changetime
      incr _hour
      settime
   end if

   if sh_month=6 and sh_day=31 and _hour=0 and _min=0 and changetime=0 then
      set changetime
      decr _hour
      settime
   end if

   if _hour=1 and _min=1 then reset changetime



end sub
sub shoewtime


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


  if jstatus= 0 then
      setfont font16x16en
      lcdat 3,1,sens1;"  "
  end if

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

  if jstatus= 1 then
      showpic 96,32,smalljacuzi
      setfont font16x16en
      lcdat 3,1,sens2;"  "
  end if
      '(
   If Readsens < 0 Then Readsens = Readsens * -1
   Sahih2 = 0
   If Readsens > 9 Then
   Sahih2 = Readsens / 10
   Ashar2 = Readsens Mod 10
   End If
        ')


End Sub

sub ifcheck
   if jstatus=1 then
      if sens2=alarmtemp then
         beeperror
      end if
   end if

   if ftime(1)=_hour and ftime(2)=_min and fstatus=3 then
      findorder="setfountain"
      order
   end if
   if ftime(3)=_hour and ftime(4)=_min and fstatus=3 then
      findorder="resetfountain"
      order
   end if


   if ltime(1)=_hour and ltime(2)=_min and lstatus=3 then
      findorder="setlight"
      order
   end if
   if ltime(3)=_hour and ltime(4)=_min and lstatus=3 then
      findorder="resetlight"
      order
   end if


   if putime(1)=_hour and putime(2)=_min and pustatus=3 then
      findorder="setpump"
      order
   end if
   if putime(3)=_hour and putime(4)=_min and pustatus=3 then
      findorder="resetpump"
      order
   end if


   if ptime(1)=_hour and ptime(2)=_min and pstatus=3 then
      findorder="setplant"
      order
   end if
   if ptime(3)=_hour and ptime(4)=_min and pstatus=3 then
      findorder="resetplant"
      order
   end if


   if wtime(1)=_hour and wtime(2)=_min and wstatus=3 then
      findorder="setwater"
      order
   end if
   if wtime(3)=_hour and wtime(4)=_min and wstatus=3 then
      findorder="resetwater"
      order
   end if

end sub

Sub Setting_menu

   cls
   set backmenu
   do
      If Backmenu = 1 Then
         Reset Backmenu
         If Count < 1 Or Count > 4 Then Count = 1
         Select Case Count

            Case 1
               Showpic 0 , 0 , exiticon
            Case 2
               Showpic 0 , 0 ,  night
            Case 3
               Showpic 0 , 0 , party
            Case 4
               Showpic 0 , 0 , rutin
            Case 5


         End Select
      End If
      readtouch
      if touch=11 then
         select case count

            case 1
               Findorder = "savesenario#1"
               Order
               Showpic 0 , 0 , exiticon,1
               waitms 500
               Showpic 0 , 0 , exiticon
            case 2
               Findorder = "savesenario#2"
               Order
               Showpic 0 , 0 , night,1
               waitms 500
               Showpic 0 , 0 , night
            Case 3
               Findorder = "savesenario#3"
               Order
               Showpic 0 , 0 , party,1
               waitms 500
               Showpic 0 , 0 , party
            case 4
               Findorder = "savesenario#4"
               Order
               Showpic 0 , 0 , rutin,1
               waitms 500
               Showpic 0 , 0 , rutin

         end select
      end if
      if touch=12 or touch=13 then
         if touch=12 then incr count else decr count
         if count<1 then count=4
         if count>4 then count=1
         cls
         Select Case Count
            Case 1
               Showpic 0 , 0 , exiticon
            Case 2
               Showpic 0 , 0 ,  night
            Case 3
               Showpic 0 , 0 , party
            Case 4
               Showpic 0 , 0 , rutin
            Case 5


         End Select
      end if
      if touch=14 then
         cls
         exit do
      end if
   loop

End Sub

Sub Pwlsetting
    Selection = 1
    Cls
    Status = 1

        Select Case Id
               Case Idlight
                    showpic 0,0,slight
               Case Idplant
                    showpic 0,0,splant
               Case Idwater
                    showpic 0,0,swatersystem
               Case Idfountain
                    showpic 0,0,sfountain
        End Select

    Do
      '(
        Select Case Id
               Case Idlight
                    Lcdat 1 , 1 , Farsi( " —Ê‘‰«ÌÌ ‰„«    ") , 1
               Case Idplant
                    Lcdat 1 , 1 , Farsi( " —‘œ êÌ«Â       ") , 1
               Case Idwater
                    Lcdat 1 , 1 , Farsi( " ¬»Ì«—Ì         " ) , 1
               Case Idfountain
                    Lcdat 1 , 1 , Farsi( " ¬»‰„«          " ) , 1
        End Select
        ')




        If Status < 1 Then Status = 3 : If Status > 3 Then Status = 1

        If Onhour > 59 Then Onhour = 0
        If Onmin > 59 Then Onmin = 0


        If Offhour > 59 Then Offhour = 0
        If Offmin > 59 Then Offmin = 0

        '-----------------------------
        If Selection = 1 And Blink_ = 0 Then
           S1 = "     "
        Else
           If Status = 1 Then S1 = "ON  "
           If Status = 2 Then S1 = "OFF "
           If Status = 3 Then S1 = "AUTO"
        End If

        Setfont Font16x16en
        Lcdat 5 , 1 , S1
        Setfont Font8x8
        S1 = "     "
        If Status = 3 and id<>idlight Then

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

                 Lcdat 7 , 1 , S1

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


                 Lcdat 8 , 1 , S1




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

        If Touch = 11 or touch=21 Then
           Incr Selection
           If Status < 3 Then
              If Selection > 1 Then Selection = 1
              set backmenu
              cls
              exit do
           End If
           if status=3 and id=idlight then
              set backmenu
              cls
              exit do
           end if
           Touch = 0
        End If

        If Touch = 14 or touch=24 Then
           Cls
           Setfont Font8x8
           Set Backmenu
           touch=0
           Return
        End If

        Incr Timer_1
        If Timer_1 > 5 Then
         Timer_1 = 0
         Toggle Blink_
        End If

        '-----------------------------------
        If Touch = 12 or touch=22 Then

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

        End If
        '------------------------------------
        If Touch = 13 or touch=23 Then
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
        End If

        '--------------------------------------

        If Status < 1 Then Status = 3 : If Status > 3 Then Status = 1


        if touch=12 or touch=13 or touch=22 or touch=23 then
            Cls
            set blink_
            Select Case Id
               Case Idlight
                    showpic 0,0,slight
               Case Idplant
                    showpic 0,0,splant
               Case Idwater
                    showpic 0,0,swatersystem
               Case Idfountain
                    showpic 0,0,sfountain
            End Select
            if selection=1 and status<3 then
               if status=1 then
                  cmd=180:direct=tooutput:typ=relaymodule:tx
                  waitms 20
                  cmd=182:direct=tooutput:typ=relaymodule:tx
                  waitms 20
               end if
               if status=2 then
                  cmd=180:direct=tooutput:typ=relaymodule:tx
                  waitms 20
                  cmd=181:direct=tooutput:typ=relaymodule:tx
                  waitms 20
               end if
            end if
            touch=0
        endif



        Waitms 50


        If Selection > 12 Then
           Cls
           Exit Do
        End If
    Loop
End Sub

Sub Jacuzi_menu

    Id = Idjacuzi
    Findorder = "setjacuzi"
    Selection = 1
    Cls
    showpic 0,0,smalljacuzi


    Do







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
        Lcdat 5 , 1 , S1

        Lcdat 7 , 1 , S2


        Call Readtouch

        If Touch = 11 or touch=21 Then
           Incr Selection
           If Selection > 2 Then
               Selection = 1
               set backmenu
               cls
               exit do
            end if
           Touch = 0
        End If

        If Touch = 14 or touch=24 Then
           Cls
           Set Backmenu
           Setfont Font8x8
           touch=0
           Exit Do
        End If

        Incr Timer_1
        If Timer_1 > 5 Then
         Timer_1 = 0
         Toggle Blink_
        End If

        '-----------------------------------
        If Touch = 12 or touch=22 Then

              If Selection = 1 Then Incr Status
              If Selection = 2 Then Incr Alarmtemp
        End If
        '------------------------------------
        If Touch = 13 or touch=23 Then
           If Selection = 1 Then Decr Status
           If Selection = 2 Then Decr Alarmtemp
        End If

        '--------------------------------------
        If Status > 2 Then Status = 1
        If Status < 1 Then Status = 2

        if touch=12 or touch=13 or Touch = 22 or touch=23 then
            set blink_
            if status=1 then
                  cmd=180:direct=tooutput:typ=relaymodule:tx
                  waitms 20
                  cmd=182:direct=tooutput:typ=relaymodule:tx
                  waitms 20
            end if
            if status=2 then
                  cmd=180:direct=tooutput:typ=relaymodule:tx
                  waitms 20
                  cmd=181:direct=tooutput:typ=relaymodule:tx
                  waitms 20
            end if
            Touch = 0
        end if



        If Alarmtemp > 40 Then Alarmtemp = 25
        If Alarmtemp < 25 Then Alarmtemp = 40


        Waitms 50

    Loop
    If Status = 1 Then Jstatus = 1 else jstatus=0
End Sub

Sub Plant_menu

    Id = Idplant
    for i=1 to 4
      ptime(i)=eptime(i)
      waitms 20
    next
    Days = pdays
    waitms 10
    Status = pstatus
    waitms 10
    Onhour = ptime(1)
    Onmin = ptime(2)
    Offhour = ptime(3)
    Offmin = ptime(4)
    Call Pwlsetting

    epdays = Days
    pdays = Days
    waitms 10
    pstatus = Status
    waitms 10
    ptime(1) = Onhour
    ptime(2)= Onmin
    ptime(3) = Offhour
    ptime(4) = Offmin
    for i=1 to 4
      eptime(i)=ptime(i)
      waitms 20
    next

End Sub

Sub Watersystem_menu

    Id = Idwater
    for i=1 to 4
      wtime(i)=ewtime(i)
      waitms 20
    next
    Days = wdays
    waitms 10
    Status = wstatus
    waitms 10
    Onhour = wtime(1)
    Onmin = wtime(2)
    Offhour = wtime(3)
    Offmin = wtime(4)
    Call Pwlsetting

    ewdays = Days
    wdays = Days
    waitms 10
    wstatus = Status
    waitms 10
    wtime(1) = Onhour
    wtime(2)= Onmin
    wtime(3) = Offhour
    wtime(4) = Offmin
    for i=1 to 4
      ewtime(i)=wtime(i)
      waitms 20
    next

End Sub

Sub Fountain_menu


    Id = Idfountain
    for i=1 to 4
      ftime(i)=eftime(i)
      waitms 20
    next
    Days = fdays
    waitms 10
    Status = fstatus
    waitms 10
    Onhour = ftime(1)
    Onmin = ftime(2)
    Offhour = ftime(3)
    Offmin = ftime(4)
    Call Pwlsetting

    efdays = Days
    fdays = Days
    waitms 10
    fstatus = Status
    waitms 10
    ftime(1) = Onhour
    ftime(2)= Onmin
    ftime(3) = Offhour
    ftime(4) = Offmin
    for i=1 to 4
      eftime(i)=ftime(i)
      waitms 20
    next

End Sub

Sub pump_menu

    Id = Idpump
    for i=1 to 4
      putime(i)=eputime(i)
      waitms 20
    next
    Days = pudays
    waitms 10
    Status = pustatus
    waitms 10
    Onhour = putime(1)
    Onmin = putime(2)
    Offhour = putime(3)
    Offmin = putime(4)
    Call Pwlsetting

    epudays = Days
    pudays = Days
    waitms 10
    pustatus = Status
    waitms 10
    putime(1) = Onhour
    putime(2)= Onmin
    putime(3) = Offhour
    putime(4) = Offmin
    for i=1 to 4
      eputime(i)=putime(i)
      waitms 20
    next

End Sub

Sub Light_menu

    Id = Idlight

    Days = eldays
    Status = Lstatus
    Onhour = eltime(1)
    Onmin = eltime(2)
    Offhour = eltime(3)
    Offmin = eltime(4)

    Call Pwlsetting

    eldays = Days
    Lstatus = Status
    eltime(1) = Onhour
    eltime(2)= Onmin
    eltime(3) = Offhour
    eltime(4) = Offmin

   for i=1 to 4
      ltime(i)=eltime(i)
      waitms 20
   next

End Sub

Sub Checkanswer

End Sub


Sub Order

   Select Case Findorder
      Case "savesenario#1"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 200 : Id = 1
      Case "savesenario#2"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 200 : Id = 2
      Case "savesenario#3"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 200 : Id = 3
      Case "savesenario#4"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 200 : Id = 4
      Case "setsenario#1"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 201 : Id = 1
      Case "setsenario#2"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 201 : Id = 2
      Case "setsenario#3"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 201 : Id = 3
      Case "setsenario#4"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 201 : Id = 4

      case "setfountain"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 182 : Id = idfountain
      case "resetfountain"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 181 : Id = idfountain

      case "setlight"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 182 : Id = idlight
      case "resetlight"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 181 : Id = idlight

      case "setpump"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 182 : Id = idpump
      case "resetpump"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 181 : Id = idpump

      case "setwater"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 182 : Id = idwater
      case "resetwater"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 181 : Id = idwater

      case "setplant"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 182 : Id = idplant
      case "resetplant"
         Direct = Tooutput : Typ = Relaymodule : Cmd = 181 : Id = idplant



   End Select

    Call Tx


End Sub

Sub Readtouch
   touch=0
   If Touch1 = 1 Or Touch2 = 1 Or Touch3 = 1 Or Touch4 = 1 Then
      checkkey
   end if
end sub

Sub Checkkey
    Beep
   If Touch1 = 1 Then
      j=0
      do
         incr j
         If J = 11 Then
            Beeppro
            Exit Do
         end if
         waitms 50
      loop until touch1=0
      if j<5 then
         touch=11
      elseif j>10 then
         touch=21
      end if
   end if

   if touch2=1 then
      j=0
      do
         incr j
         if j=11 then
            beeppro
            exit do
         end if
         waitms 50
      Loop Until Touch2 = 0
      if j<5 then
         touch=12
      elseif j>10 then
         touch=22
      end if
   end if
   if touch3=1 then
      j=0
      do
         incr j
         if j=11 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch3=0
      if j<5 then
         touch=13
      elseif j>10 then
         touch=23
      end if
   end if

   if touch4=1 then
      j=0
      do
         incr j
         if j=11 then
            beeppro
            exit do
         end if
         waitms 50
      loop until touch4=0
      if j<5 then
         touch=14
      elseif j>10 then
         touch=24
      end if
   end if
end sub

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




sub selectsenario
   cls
   waitms 200
   if touch=21 then
      showpic 0,0,exiticon
      do
         readtouch
         if touch=11 or touch=21 then
            Showpic 0 , 0 , exiticon , 1
            Findorder = "setsenario#1"
            beeppro
            Order
            waitms 500
            cls
            return
         end if
         if touch=12 or  touch=13 or touch=14 or touch=22 or touch=23 or touch=24  then
            beeppro
            cls
            exit do
         end if
      loop
   end if
   If Touch = 22 Then
      showpic 0,0,night
      do
         readtouch
         if touch=12 or touch=22 then
            Showpic 0 , 0 , night , 1
            Findorder = "setsenario#2"
            beeppro
            Order
            waitms 500
            cls
            return
         end if
         if touch=11 or  touch=21 or touch=14 or touch=22 or touch=23 or touch=24  then
            beeperror
            cls
            exit do
         end if
      loop
   end if
   If Touch = 23 Then
      showpic 0,0,party
      do
         readtouch
         if touch=13 or touch=23 then
            Showpic 0 , 0 , party , 1
            Findorder = "setsenario#3"
            beeppro
            Order
            waitms 500
            cls
            return
         end if
         if touch=12 or  touch=11 or touch=14 or touch=22 or touch=21 or touch=24  then
             beeppro
            cls
            exit do
         end if
      loop
   end if
   If Touch = 24 Then
      showpic 0,0,rutin
      do
         readtouch
         if touch=14 or touch=24 then
            Showpic 0 , 0 , rutin , 1
            Findorder = "setsenario#4"
            beeppro
            Order
            waitms 500
            cls
            return
         end if
         if touch=12 or  touch=13 or touch=11 or touch=22 or touch=23 or touch=21   then
            beeppro
            cls
            exit do
         end if
      loop
   end if


end sub

Sub Selectmenu
   cls
   set backmenu
   count=1
   do
      If Backmenu = 1 Then
         Reset Backmenu
         If Count < 1 Or Count > 8 Then Count = 1
         Select Case Count

            Case 1
               Showpic 32 , 0 , Jaccuziicon
            Case 2
               Showpic 32 , 0 , Planticon
            Case 3
               Showpic 32 , 0 , Watersystemicon
            Case 4
               Showpic 32 , 0 , Lighticon
            Case 5
               Showpic 32 , 0 , Fountainicon
            Case 6
               Showpic 32 , 0 , pumpicon
            Case 7
               Showpic 32 , 0 , Setclockicon
            Case 8
               Showpic 32 , 0 , Settingicon

         End Select
      End If
      readtouch
      if touch=11 then
         select case count

            case 1
               jacuzi_menu
            case 2
               plant_menu
            Case 3
               watersystem_menu
            case 4
               light_menu
            case 5
               fountain_menu
            case 6
               pump_menu
            case 7
               clock_menu
            case 8
               Setting_menu
         end select
      end if
      if touch=12 or touch=13 then
         if touch=12 then incr count else decr count
         if count<1 then count=8
         if count>8 then count=1
         cls
         Select Case Count
            Case 1
               Showpic 32 , 0 , Jaccuziicon
            Case 2
               Showpic 32 , 0 , Planticon
            Case 3
               Showpic 32 , 0 , Watersystemicon
            Case 4
               Showpic 32 , 0 , Lighticon
            Case 5
               Showpic 32 , 0 , Fountainicon
            Case 6
               Showpic 32 , 0 , pumpicon
            Case 7
               Showpic 32 , 0 , Setclockicon
            Case 8
               Showpic 32 , 0 , Settingicon

         End Select
      end if
      if touch=14 then
         cls
         exit do
      end if
   loop
end sub


Sub Clock_menu
 Call Beep
 Selection = 1
 Cls
 setfont font8x8
 Do



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

    If Touch = 11 or touch=21 Then
       Incr Selection
       Touch = 0
    End If

    If Touch = 14 or touch=24 Then
       Cls
       Touch = 0
       Set Backmenu
       Return
    End If

    Incr Timer_1
    If Timer_1 > 5 Then
     Timer_1 = 0
     Toggle Blink_
    End If

    if touch=12 or touch=13 or touch=22 or touch=23 then set blink_

    '-----------------------------------
    If Touch = 12 or touch=22 Then
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
    If Touch = 13 or touch=23 Then
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




Sub beeperror

    Set Buz
    Waitms 700
    Reset Buz

End Sub

