'*******************************************************************************
'
'                           ILI9325 LCD Test 8 bit
'
'                            resolution 240x320
'
'*******************************************************************************
$regfile = "m128def.dat"
$crystal = 8000000
$hwstack = 512
$swstack = 512
$framesize = 512

'--------------------------- Pin Configuration ---------------------------------
Data_disp Alias Porta : Config Data_disp = Output           'Data Port
Rs_disp Alias Portf.4 : Config Rs_disp = Output             'Command/Data pin
Wr_disp Alias Portf.5 : Config Wr_disp = Output             'Write pin

Cs_disp Alias Portf.7 : Config Cs_disp = Output             'Chip Select
Cs_disp = 0

Res_disp Alias Portf.6 : Config Res_disp = Output           'Reset pin
Res_disp = 1

'-------------------------------- Library --------------------------------------
Const Portrait = 0                                          '0=Landscape, 1=Portrait

Config Submode = New : $include "ILI9325 library.inc"       'Include library

'---------------------------- Fonts and Pictures -------------------------------
' You need to include Fonts and Pictures below the "End"
'-------------------------------------------------------------------------------
'
' For load Pictures from SPI-ROM you must configure SPI:

Config Spi = Hard , Interrupt = Off , Data Order = Msb , Master = Yes , Polarity = High , Phase = 1 , Clockrate = 4 , Noss = 1
Spsr.0 = 1 : Spcr.0 = 0 : Spcr.1 = 0                        'F_spi = F_osc / 2
Ss_spi_rom Alias Portb.6 : Config Ss_spi_rom = Output : Ss_spi_rom = 1       'Chip Select pin
Spiinit





'================================ Test Program =================================

Dim Count As Word , Text As String * 16 , N As Word , M As Word , B As Byte

Display_init                                                ' Initialize Display

Do

Lcd_clear White
Lcd_clear White
Restore Font12x16
Lcd_text "Controller ILI9325" , 45 , 25 , Darkred , White   '****** Text
Restore Font25x32
Lcd_text "240x320 LCD" , 23 , 50 , Darkgreen , White
Restore Font36x56 : Digit_font = 1
For Count = 20 To 24
   Text = Str(count)
   Lcd_text Text , 120 , 110 , Blue , White
   Wait 1
Next Count
Digit_font = 0

Restore Font25x32
Lcd_text "Negative  " , 60 , 180 , Black , White            '****** Negative
Lcd_negative 1
Restore Font36x56 : Digit_font = 1
For Count = 25 To 27
   Text = Str(count)
   Lcd_text Text , 120 , 110 , Blue , White
   Wait 1
Next Count
Digit_font = 0


Restore Font25x32
Lcd_text " Normal   " , 60 , 180 , Black , White
Lcd_negative 0
Restore Font36x56 : Digit_font = 1
For Count = 28 To 30
   Text = Str(count)
   Lcd_text Text , 120 , 110 , Blue , White
   Wait 1
Next Count
Digit_font = 0


Lcd_clear White
Restore Color8x8                                            '****** Color Font Text
Lcd_text_color "Color Font text 'Color8x8'" , 55 , 65 , Black , White
Restore Color16x16
Lcd_text_color "Font 'Color16x16' " , 25 , 100 , Darkgreen , White
Wait 2



Lcd_clear White
Restore Font25x32
Lcd_text "Clear Screen" , 11 , 80 , Black , White           '****** Clear Screen
Lcd_text "    B&W" , 11 , 120 , Black , White
Wait 2
Lcd_clear Black : Waitms 500
Lcd_clear White : Waitms 500
Lcd_clear Black : Waitms 500
Lcd_clear White
Lcd_text "Clear Screen" , 11 , 80 , Brown , White
Lcd_text "with color" , 35 , 120 , Blue , White
Wait 2
Lcd_clear Red : Waitms 500
Lcd_clear Green : Waitms 500
Lcd_clear Blue : Waitms 500



Lcd_clear Black
Lcd_text "Pixels" , 70 , 10 , White , Black                 '****** Set Pixel
Waitms 500
For Count = 10 To 310 Step 32
   For N = 50 To 230 Step 32
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 26 To 310 Step 16
   For N = 66 To 230 Step 16
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 18 To 310 Step 8
   For N = 58 To 230 Step 8
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 14 To 310 Step 4
   For N = 54 To 230 Step 4
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Wait 2



Lcd_clear White                                             '****** Line
Lcd_text "Line" , 110 , 10 , Blue , White
For Count = 1 To 4
   For N = 100 To 220 Step 4
      Lcd_line 160 , 220 , N , 80 , Black
      Lcd_line 160 , 220 , N , 80 , White
   Next N
   For N = 219 To 101 Step - 4
      Lcd_line 160 , 220 , N , 80 , Black
      Lcd_line 160 , 220 , N , 80 , White
   Next N
Next Count


Lcd_clear White
Lcd_text "Circle" , 80 , 10 , Black , White                 '******* Circle
Lcd_circle 100 , 100 , 40 , Blue
Lcd_circle 100 , 100 , 39 , Blue
Lcd_circle 160 , 100 , 40 , Black
Lcd_circle 160 , 100 , 39 , Black
Lcd_circle 220 , 100 , 40 , Red
Lcd_circle 220 , 100 , 39 , Red
Lcd_circle 130 , 160 , 40 , Darkyellow
Lcd_circle 130 , 160 , 39 , Darkyellow
Lcd_circle 190 , 160 , 40 , Green1
Lcd_circle 190 , 160 , 39 , Green1
Wait 2


Lcd_clear Cyan
Lcd_text "Fill Circle" , 20 , 10 , Brown , Cyan             '******* Fill Circle
Lcd_fill_circle 100 , 100 , 40 , Blue
Lcd_fill_circle 220 , 100 , 40 , Red
Lcd_fill_circle 160 , 160 , 40 , Darkgreen
Wait 2



Lcd_clear Blue
Lcd_text "Filled Box" , 40 , 100 , Yellow , Blue            '****** Filled Box
Lcd_fill_box 10 , 10 , 80 , 80 , White
Lcd_fill_box 240 , 10 , 310 , 80 , Red
Lcd_fill_box 10 , 160 , 80 , 230 , Yellow
Lcd_fill_box 240 , 160 , 310 , 230 , Cyan
Wait 2



Lcd_clear Gold
Lcd_text "Box" , 125 , 10 , Darkblue , Gold                 '****** Box
Lcd_box 60 , 70 , 140 , 140 , Darkblue
Lcd_box 120 , 100 , 200 , 180 , Black
Lcd_box 180 , 70 , 260 , 140 , Violet
Lcd_box 60 , 160 , 100 , 200 , Brown
Lcd_box 65 , 165 , 95 , 195 , Red
Lcd_box 220 , 160 , 260 , 200 , Brown
Lcd_box 225 , 165 , 255 , 195 , Red
Lcd_box 50 , 60 , 270 , 210 , Blue
Wait 2



Lcd_clear White
Restore Font12x16
Lcd_text "  256 colors Picture" , 40 , 20 , Darkblue , White       '****** BGC Picture
Restore Animals
Lcd_pic_bgc 90 , 60
Wait 2


Lcd_clear White
Restore Font12x16
Lcd_text "65536 colors Picture" , 40 , 20 , Darkblue , White       '****** 16-bit Picture
Restore Coffee
Lcd_pic_sram 80 , 65 , 160 , 120
Wait 1


Lcd_clear White
Restore Font12x16
Lcd_text "65536 colors Picture" , 40 , 20 , Darkblue , White
Lcd_text "from external SPI-ROM" , 32 , 44 , Darkblue , White
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 0
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 153600
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 307200
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 460800
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 614400
Wait 1
Lcd_pic_spi 0 , 0 , 320 , 240 , 768000
Wait 1


Loop

End                                                         'end program
'-------------------------------------------------------------------------------
$include "color8x8.font"
$include "color16x16.font"
$include "Font12x16.font"
'$include "Font25x32.font"
$include "Font36x56.font"
$include "Font25x32_new.font"
$inc Coffee , Nosize , "Coffee.bin"
Animals:
$bgf "Animals.bgc"