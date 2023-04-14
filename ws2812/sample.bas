$Regfile = "m8def.dat"
$Crystal = 11059200
$hwstack = 40
$swstack = 16
$framesize = 32

Config RAINBOW = 1 , rgb = 4 , RB0_LEN = 8 , RB0_PORT = PORTc , rb0_pin = 5
'                      ^-- using rgbW leds #### MUST BE FIRST PARAMETER when defined ###
'                                                   ^ connected to pin 0
'                                       ^------------ connected to portB
'                         ^-------------------------- 8 leds on stripe
'              ^------------------------------------- 1 channel


'Global Color-variables
Dim Color(4) as Byte
R alias Color(_base) : G alias Color(_base + 1) : B alias Color(_base + 2) : W alias color(_base + 3)

'CONST
const numLeds = 8

'----[MAIN]---------------------------------------------------------------------
Dim n as Byte

RB_SelectChannel 0                                         ' select first channel
R = 50 : G = 0 : B = 100 : w = 10                           ' define a color
RB_SetColor 0 , color(_base)                               ' update led on the left
RB_SetColor numleds - 1 , color(_base)                     ' update led on the right
RB_Send
waitms 2000

Do
  For n = 1 to Numleds / 2 - 1
    rb_Shiftright 0 , Numleds / 2                         'shift to the right
    rb_Shiftleft Numleds / 2 , Numleds / 2               'shift to the left all leds except the last one
    Waitms 1000
    RB_Send
  Next
  For n = 1 to Numleds/2 - 1
    rb_Shiftleft 0 , Numleds / 2                         'shift to the left all leds except the last one
    rb_Shiftright Numleds / 2 , Numleds / 2               'shift to the right
    Waitms 1000
    RB_Send
  Next
  waitms 500                   'wait a bit
Loop