$regfile = "m128def.dat"
$crystal = 11059200
$hwstack = 64
$swstack = 100
$framesize = 100
$baud = 115200
$lib "glcdKS108.lib"
$include "FONT/farsi_map.bas"
Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 1 , Ce2 = 0 , Cd = 6 , Rd = 5 , Reset = 2 , Enable = 4
Backlight Alias Porta.3 : Config Porta.3 = Output
Set Backlight


Ant Alias Chr(33)
Ant1 Alias Chr(38)
Ant2 Alias Chr(34)
Ant3 Alias Chr(40)
Ant4 Alias Chr(35)
Bluetooth Alias Chr(36)
C_bt Alias Chr(41)
No_ant Alias Chr(42)

Initlcd
Do
Setfont Font8x8
Cls
Dim N As Byte
Lcdat 1 , 1 , "test" , 0
Lcdat 2 , 1 , "”·«„" , 0
Lcdat 3 , 1 , "€€€ €" , 0
Lcdat 4 , 1 , "ÂÂÂ Â" , 0
Lcdat 5 , 1 , Farsi( "1234" ) ; "1234" , 0
Lcdat 6 , 1 , Farsi( "€€€ €" ) , 0
Lcdat 7 , 1 , Farsi( "”·«„" ) , 0
Wait 2
Cls
Setfont Digit_notifi_12x16
 Lcdat 1 , 1 , Ant ; Ant2 ; Ant4 ; C_bt ; Bluetooth , 0
Setfont Fontdig12x16_f

  For N = 0 To 150
  Lcdat 3 , 7 , N ; "  " , 0
  Waitms 100
 Next
Loop
End
$include "FONT/farsi_map.bas"
$include "FONT/font8x8.font"
   $include "FONT/font12x16dig_f.font"
    $include "FONT/digit_notifi_12x16.font "                'ant  bluetooth