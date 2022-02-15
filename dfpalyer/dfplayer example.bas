
$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600
'-------------
'Config Lcdpin = Pin , Rs = Porta.1 , E = Porta.2 , Db4 = Porta.3 , Db5 = Porta.4 , Db6 = Porta.5 , Db7 = Porta.6
'Config Lcd = 16 * 2
'Cursor Off
'Cls

'------------
led alias portc.5:config portc.5=OUTPUT
Config Pind.6 = Input :volume_up Alias Pind.5
Config Pind.5 = Input :volume_down Alias Pind.6
Config Pind.4 = Input : _next Alias Pind.3
Config Pind.3 = Input : Previous   Alias Pind.4
'***********************************************************************************
'printbin &7E:&FF:&06:&03:&00:&00;&01:&FF:&E6:&EF
'7E FF 06 09 00 00 04 FF DD EF
wait 5
Printbin  126 ; 255 ; 6 ;9 ;0 ; 0;1; 239
wait 1

do
'Printbin  126 ; 255 ; 6 ;3 ;0 ; 1;2; 239
'wait 1
  wait 1
Printbin  126 ; 255 ; 6 ; 4; 0 ; 0 ;0; 239
  wait 1
Printbin  126 ; 255 ; 6 ; 1; 0 ; 0 ;0; 239
  wait 1
  toggle led
loop

Do
'home
'cursor off
'lcd "df_player"
'--------
if volume_up=0 then
Printbin  126 ; 255 ; 6 ; 04; 0 ; 0 ;0; 239
'home l
'lcd "volume++       "
end if
'-------------
if volume_down=0 then
Printbin  126 ; 255 ; 6 ; 5 ;0 ; 0 ;0; 239
waitms 50
'home l
'lcd "volume----                 "
end if
'-------------
if _next=0 then
Printbin  126 ; 255 ; 6 ;1 ;0 ; 0 ;0; 239
waitms 50
'home l
'lcd "next           "
end if
'-------------
if Previous =0 then
Printbin  126 ; 255 ; 6 ;2 ;0 ; 0 ;0; 239
waitms 50
'home l
'lcd "Previous               "
end if
'-------------
waitms 100
Loop
End