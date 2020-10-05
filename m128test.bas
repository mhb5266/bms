
$regfile = "m128def.dat"



$crystal = 11059200
$baud = 115200
$lib "glcdKS108.lbx"

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



Dim I As Byte

Startup:
Set Backlight
Cls

Do

  Toggle Txled
  Toggle Rxled
  Wait 1
  Incr I
  Lcdat 1 , 1 , I
  Wait 1
Loop


End

$include "font8x8.font"