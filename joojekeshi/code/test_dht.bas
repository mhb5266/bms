'######################## DHT-22 Humidity & Temperature Sensor####################
' DHT-22
'
'  |-----o-- Vcc
'  |     |
'  |     -
'  |     10k
'  |     -
'  |     |
'  |-----o-- Data ~~~ PC0 (µC)
'  |
'  |-------- NC
'  |
'  |-------- GND
'
'  Timings: Bit = 0 ~ 28 µs / Bit = 1 ~ 70 µs
'  Min_time = 28 µs < TCNT0 Value (ticks) < 70 µs  (in ticks)
'  every time > Min_time >>> Bit = 1
'  every time < Min_time >>> Bit = 0
'
'  Min_time ~ 20 (ticks) for 3.6864 MHz
'
' ~ ticks for Bit = 0: 26 µs * $crystal (in MHz) / Prescale
' ~ ticks for Bit = 1: 70 µs * $crystal (in MHz) / Prescale
'
'######################## DHT-22 Humidity & Temperature Sensor####################

$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600
$hwstack = 64
$swstack = 64
$framesize = 64
'#####################################
Config pinb.1 = Input
Config Timer0 = Timer , Prescale = 8
'#####################################

$include "FONT/farsi_func.bas"
$lib "glcd-Nokia5110.lib"
'1.RST
'2.CE-------CS1
'3.DC  -----A0
'4.DIN -----Si
'5.CLK -----SCLK
'6.VCC------3.3V
'7.BL ------3.3V
'8.GND
'Config Graphlcd = 128x64sed , Rst = Portc.1 , Cs1 = Portc.0 , _
'A0 = Portc.2 , Si = Portc.3 , Sclk = Portc.4
Config Graphlcd = 128x64sed , Rst = Portc.7 , Cs1 = Portc.6 , _
A0 = Portc.5 , Si = Portc.4 , Sclk = Portc.3
' Rst & Cs1 is optional
Const Contrast_lcd = 72
'Contrast 0 to 127, if not defined - 72
'Const Negative_lcd = 1       'Inverting screen
'Const Rotate_lcd = 1          'Rotate screen to 180∞
Initlcd
Cls
Setfont Font8x8
'#####################################
Const Min_time = 20                                         'this has to be changed according to your frequency settings in $crystal
Dim Count As Byte
Dim Signaltime(43) As Byte
Dim Humidityw As Word
Dim Temperaturew As Word
Dim Humsens_chksum As Byte
Dim Humiditys As String * 16
Dim Temperatures As String * 16
'#####################################
Declare Sub Read_timings
Declare Sub Humtemp_values
Declare Function Compare_chksum(byval Hsens_humidity As Word , Byval Hsens_temperature As Word , Byval Hsens_chksum As Byte) As Byte
'##################################### Main loop
Cls
Lcdat 1 , 1 , "HI"
Wait 2
Cls
Do
  Wait 1
  Cls
  Call Humtemp_values
  If Compare_chksum(humidityw , Temperaturew , Humsens_chksum) = 1 Then
   Humiditys = Str(humidityw)
   Temperatures = Str(temperaturew)
   'Print "Humidity: " ; Format(humiditys , "0.0") ; " %"
   Lcdat 1 , 1 , "Humidity: " ; Format(humiditys , "0.0") ; " %"
   'Print "Temperature: " ; Format(temperatures , "0.0") ; " deg"
  Else
   'Print "Read Error"
   Lcdat 2 , 1 , "Read Error"
  End If
Loop
End
'#############################################################  Read timings
' measure time (in ticks) for signal = high (Start / Stop  TIMER0)
' 1st two measurements do not contain sensor values
Sub Read_timings
   Wait 3
   Count = 1
   Config Pinb.1 = Output : Portb.1 = 0                     ' request data
   Waitms 20                                                ' wait 20 ms
   Config pinb.1 = Input                                    ' wait for data, receive data
   While Count < 43                                         'collect 42 timings / signals
      Bitwait pinb.1 , Set                                  'signal goes high > start timer
      Start Timer0
      Bitwait Pinb.1 , Reset                                'signal goes low  > stop timer
      Stop Timer0
      Signaltime(count) = Tcnt0                             'store number of ticks per signal in Signaltime byte
      Tcnt0 = 0
      Incr Count
  Wend

End Sub
'############################################################# Humidity and temperature values
'  transform timings into bits (40 timings > 40 Bits)
'  every time (in ticks) > Min_time >>> Bit = 1
'  every time (in ticks) < Min_time >>> Bit = 0
'  first word contains humidity
'  second word contains temperature
'  last byte contains checksum
Sub Humtemp_values
   Local X As Byte
   Humidityw = 0
   Temperaturew = 0
   Humsens_chksum = 0
   Call Read_timings
   For Count = 3 To 42                                      ' skip first two
      Select Case Count
         Case 3 To 18
            X = 18 - Count
            If Signaltime(count) > Min_time Then Toggle Humidityw.x
         Case 19 To 34
            X = 34 - Count
            If Signaltime(count) > Min_time Then Toggle Temperaturew.x
         Case 34 To 42
            X = 42 - Count
            If Signaltime(count) > Min_time Then Toggle Humsens_chksum.x
      End Select
  Next
End Sub
'############################################################# Calculate Checksum and compare with trasnmitted value

Function Compare_chksum(byval Hsens_humidity As Word , Byval Hsens_temperature As Word , Byval Hsens_chksum As Byte) As Byte
   Local Chksum As Byte
   Chksum = Low(hsens_humidity ) + High(hsens_humidity )
   Chksum = Chksum + Low(hsens_temperature)
   Chksum = Chksum + High(hsens_temperature)
   If Chksum = Hsens_chksum Then
      Compare_chksum = 1
   Else
      Compare_chksum = 0
   End If
End Function



Pic:
'$bgf "image/graph.bgf"
$include "FONT/farsi_map.bas"
 ' $include "FONT/font5x5.font"
 ' $include "FONT/font5x12.font"
 ' $include "FONT/font6x8.font"                              ' œ«—«Ì ›Ê‰  ›«—”Ì
 ' $include "FONT/font6x10.font"
 ' $include "FONT/font7x11TT.font"
 ' $include "FONT/font7x12.font"
  $include "FONT/font8x8.font"                              ' œ«—«Ì ›Ê‰  ›«—”Ì
 ' $include "FONT/font8x12.font"
 ' $include "FONT/font8x13TT.font"
 ' $include "FONT/font8x14TT.font"
 ' $include "FONT/font10x16TT.font"
 ' $include "FONT/my12_16.font"
 ' $include "FONT/font12x16dig.font"                         '›ﬁÿ ›Ê‰  «—ﬁ«„ œ«—œ
 ' $include "FONT/font16x16.font"
