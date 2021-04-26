
$regfile = "m32def.dat"
$crystal = 11059200
$hwstack = 100
$swstack = 150
$framesize = 150
$baud = 9600

$include "LCD_ST7920_declare.inc"

Dim Buff As String * 20
 Dim I As Byte

Do

   Lcds_init 1
   Lcds_cls 1                                               'Init LCD in Text-Mode       1
   Lcds 1 , 1 , "GLCD-ST7920"
   Lcds 2 , 1 , "Display 4x16"
   Lcds 3 , 1 , "8-BIT BUS"
   Lcds 4 , 1 , "TEXT Mode"
   Wait 5
   Lcds_cls 1

  Lcds_init 2                                               'Init LCD in Grafic-Mode      2
  Lcds_cls 2
Call Lcds_text( "Bascom AVR" , 1 , 1 , 2)                   'Call Lcds_text( "String" , x , y , font)
Call Lcds_text( "LCD ST7920" , 1 , 9 , 2)
Call Lcds_text( "Grafic 128 x 64" , 1 , 18 , 2)
Call Lcds_text( "Graphic Mode" , 1 , 27 , 2)

Wait 5
   Lcds_cls 2
  Buff = ""
 Buff = Farsi( "-»Â ‰«„ Œœ«-")
Call Lcds_text(buff , 33 , 1 , 1)
 Buff = ""
 Buff = Farsi( "”·«„")
Call Lcds_text(buff , 56 , 9 , 1)
 Buff = ""
 Buff = Farsi( "›«—”Ì ‰ÊÌ”Ì")
Call Lcds_text(buff , 30 , 17 , 1)
 Buff = ""
 Buff = Farsi( "ò«„Å«Ì·— »”ò«„")
Call Lcds_text(buff , 22 , 25 , 1)
 Buff = ""
 Buff = Farsi( "«⁄œ«œ ›«—”Ì")
Call Lcds_text(buff , 30 , 33 , 1)

Call Lcds_text( "0123456789" , 33 , 41 , 1)
   Wait 3
   Lcds_cls 2
   Call Lcds_box(54 , 22 , 74 , 42 , 0 , Black)
   Wait 2
   Call Lcds_box(54 , 22 , 74 , 42 , 1 , Black)
   Wait 2

   Lcds_cls 2
   Call Lcds_circle(64 , 32 , 20 , Black)
   Wait 2
   Call Lcds_fill_circle(64 , 32 , 20 , Black)
   Wait 2
    Lcds_cls 2
   Call Lcds_line(10 , 22 , 118 , 22 , 1 , Black)
   Call Lcds_line(10 , 42 , 118 , 42 , 1 , Black)
   Wait 2
   Lcds_cls 2
  ' Restore Pic                                              'first restore Pic
   Restore Pic
   Call Lcds_show_bgf(1 , 15)                               'write BGF to Buffer
   Restore Pic1
   Call Lcds_show_bgf(45 , 15)                              'write BGF to Buffer
   Restore Pic2
   Call Lcds_show_bgf(88 , 15)                              'write BGF to Buffer
   Wait 2
   Lcds_cls 2

'(
For I = 0 To 110
 Buff = ""
 Buff = Str(i)
 Buff = Format(buff , "000")
Call Lcds_text(buff , 1 , 1 , 2)
Waitms 250
Next I
')
Loop


End

$include "LCD_ST7920_sub.inc"

'include used fonts
$include "FONT/font6x8.font"                                ' œ«—«Ì ›Ê‰  ›«—”Ì
$include "FONT/font8x8.font"                                ' œ«—«Ì ›Ê‰  ›«—”Ì
$include "Font/Digital20x32.font"
 '$include "FONT/font12x16dig.font"                         '›ﬁÿ ›Ê‰  «—ﬁ«„ œ«—œ
$include "FONT/font12x16dig_f.font"                         '›ﬁÿ ›Ê‰  «—ﬁ«„ ›«—”Ì œ«—œ
$include "FONT/font16x16.font"
$include "FONT/digit_notifi_12x16.font "                    '»·Ê ÊÀ Ê ¬‰ ‰

'include used BGF
$inc Pic , Nosize , "BGF\abc.bgf"                           '32x32 pixel
$inc Pic1 , Nosize , "BGF\time.bgf"                         '32x32 Pixel
$inc Pic2 , Nosize , "BGF\music.bgf"                        '32x32 Pixel

End