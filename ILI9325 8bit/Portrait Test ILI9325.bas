'*******************************************************************************
'
'                         ILI9325 LCD Portrait Test
'
'                            resolution 240x320
'
'*******************************************************************************
$regfile = "usb1286.dat"
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
Const Portrait = 1                                          '0=Landscape, 1=Portrait

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

Restore Font12x16
Lcd_text "Controller ILI9325" , 10 , 40 , Darkred , White   '****** Text
Restore Font25x32
Lcd_text "240x320" , 30 , 80 , Darkgreen , White
Restore Font36x56 : Digit_font = 1
For Count = 20 To 24
   Text = Str(count)
   Lcd_text Text , 90 , 160 , Blue , White
   Wait 1
Next Count
Digit_font = 0


Restore Font25x32
Lcd_text "Negative" , 20 , 260 , Black , White              '****** Negative
Lcd_negative 1
Restore Font36x56 : Digit_font = 1
For Count = 25 To 27
   Text = Str(count)
   Lcd_text Text , 90 , 160 , Blue , White
   Wait 1
Next Count
Digit_font = 0

Restore Font25x32
Lcd_text " Normal " , 20 , 260 , Black , White
Lcd_negative 0
Restore Font36x56 : Digit_font = 1
For Count = 28 To 30
   Text = Str(count)
   Lcd_text Text , 90 , 160 , Blue , White
   Wait 1
Next Count
Digit_font = 0


Lcd_clear White
Restore Color8x8                                            '****** Color Font Text
Lcd_text_color "Color Font text 'Color8x8'" , 16 , 65 , Black , White
Restore Color16x16
Lcd_text_color "'Color16x16'" , 18 , 100 , Darkgreen , White
Wait 2


Lcd_clear White
Restore Font25x32
Lcd_text "Clear" , 60 , 80 , Black , White                  '****** Clear Screen
Lcd_text "Screen" , 42 , 120 , Black , White
Lcd_text "B&W" , 80 , 170 , Black , White
Wait 2
Lcd_clear Black : Waitms 500
Lcd_clear White : Waitms 500
Lcd_clear Black : Waitms 500
Lcd_clear White
Lcd_text "Clear" , 60 , 80 , Darkred , White
Lcd_text "Screen" , 42 , 120 , Darkred , White
Lcd_text "Color" , 50 , 170 , Blue , White
Wait 2
Lcd_clear Red : Waitms 500
Lcd_clear Green : Waitms 500
Lcd_clear Blue : Waitms 500


Lcd_clear Black
Lcd_text "Pixels" , 50 , 10 , White , Black                 '****** Set Pixel
Waitms 500
For Count = 10 To 230 Step 32
   For N = 50 To 310 Step 32
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 26 To 230 Step 16
   For N = 66 To 310 Step 16
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 18 To 230 Step 8
   For N = 58 To 310 Step 8
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Waitms 500
For Count = 14 To 230 Step 4
   For N = 54 To 310 Step 4
      Lcd_set_pixel Count , N , White
   Next N
Next Count
Wait 2



Lcd_clear White                                             '****** Line
Lcd_text "Line" , 80 , 10 , Blue , White
For Count = 1 To 4
   For N = 60 To 180 Step 4
      Lcd_line 120 , 300 , N , 110 , Black
      Lcd_line 120 , 300 , N , 110 , White
   Next N
   For N = 179 To 61 Step - 4
      Lcd_line 120 , 300 , N , 110 , Black
      Lcd_line 120 , 300 , N , 110 , White
   Next N
Next Count



Lcd_clear White
Lcd_text "Circle" , 50 , 10 , Black , White                 '******* Circle
Lcd_circle 60 , 160 , 40 , Blue
Lcd_circle 60 , 160 , 39 , Blue

Lcd_circle 120 , 160 , 40 , Black
Lcd_circle 120 , 160 , 39 , Black

Lcd_circle 180 , 160 , 40 , Red
Lcd_circle 180 , 160 , 39 , Red

Lcd_circle 90 , 220 , 40 , Darkyellow
Lcd_circle 90 , 220 , 39 , Darkyellow

Lcd_circle 150 , 220 , 40 , Green1
Lcd_circle 150 , 220 , 39 , Green1
Wait 2


Lcd_clear Cyan
Restore Font25x32
Lcd_text "Filled" , 50 , 10 , Brown , Cyan                  '******* Fill Circle
Lcd_text "Circle" , 50 , 50 , Brown , Cyan
Lcd_fill_circle 60 , 160 , 40 , Blue
Lcd_fill_circle 180 , 160 , 40 , Red
Lcd_fill_circle 120 , 220 , 40 , Darkgreen
Wait 2



Lcd_clear Blue
Lcd_text "Filled" , 45 , 125 , Yellow , Blue                '****** Filled Box
Lcd_text "Box" , 75 , 175 , Yellow , Blue
Lcd_fill_box 10 , 10 , 80 , 80 , White
Lcd_fill_box 160 , 10 , 230 , 80 , Red
Lcd_fill_box 10 , 240 , 80 , 310 , Yellow
Lcd_fill_box 160 , 240 , 230 , 310 , Cyan
Wait 2



Lcd_clear Gold
Lcd_text "Box" , 80 , 10 , Darkblue , Gold                  '****** Box
Lcd_box 20 , 70 , 100 , 140 , Darkblue
Lcd_box 60 , 100 , 200 , 180 , Black
Lcd_box 140 , 70 , 230 , 140 , Violet
Lcd_box 20 , 160 , 100 , 200 , Brown
Lcd_box 25 , 165 , 90 , 195 , Red
Lcd_box 180 , 160 , 230 , 200 , Brown
Lcd_box 185 , 165 , 220 , 195 , Red
Lcd_box 5 , 60 , 235 , 240 , Blue
Wait 2


Lcd_clear White
Restore Font12x16
Lcd_text "Picture" , 90 , 20 , Darkblue , White             '****** BGC Picture
Lcd_text "256 colors" , 70 , 50 , Darkblue , White
Restore Animals
Lcd_pic_bgc 60 , 90
Wait 2


Lcd_clear White
Restore Font12x16
Lcd_text "Picture" , 90 , 20 , Darkblue , White             '****** 16-bit Picture
Lcd_text "65536 colors" , 55 , 50 , Darkblue , White
Restore Coffee
Lcd_pic_sram 40 , 100 , 160 , 120
Wait 1



Lcd_clear White
Restore Font12x16
Lcd_text "Picture" , 90 , 20 , Darkblue , White
Lcd_text "65536 colors" , 55 , 50 , Darkblue , White
Lcd_text "from SPI-ROM" , 55 , 80 , Darkblue , White
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 0
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 153600
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 307200
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 460800
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 614400
Wait 1
Lcd_pic_spi 0 , 0 , 240 , 320 , 768000
Wait 1

Loop

End                                                         'end program
'-------------------------------------------------------------------------------
$include "color8x8.font"
$include "color16x16.font"
$include "Font12x16.font"
$include "Font25x32.font"
$include "Font36x56.font"
$inc Coffee , Nosize , "Coffee.bin"
Animals:
$bgf "Animals.bgc"