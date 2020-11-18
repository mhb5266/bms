
$regfile = "m2560def.dat"
$crystal = 12000000
$hwstack = 100
$swstack = 100
$framesize = 100

Config Portf.0 = Output                                     ' for TM1637 clock
Config Portf.1 = Output                                     ' for TM1637 data

Tm1637_clk Alias Portf.0
Tm1637_dout Alias Portf.1
Tm1637_din Alias Pinf.1

Declare Sub Tm1637_disp(byval Bdispdata As Word)            'The display can only show numbers
Declare Sub Tm1637_wrbyte(byval Bdata As Byte)
Declare Sub Tm1637_on()
Declare Sub Tm1637_off()
Declare Sub Tm1637_start()
Declare Sub Tm1637_stop()
Declare Sub Tm1637_ack()
'========================================================================
'
'     Start main
'
'========================================================================

Tm1637_on
Tm1637_disp 45
Wait 2
Tm1637_off

Do
Loop
End

'=========================================================================
'
'     Subroutines
'
'========================================================================

Sub Tm1637_ack()
   Reset Tm1637_clk
   Waitus 5
   Reset Tm1637_dout
   Bitwait Tm1637_din , Reset
   Set Tm1637_clk
   Waitus 2
   Reset Tm1637_clk
   Set Tm1637_dout
End Sub



Sub Tm1637_off()
   Tm1637_start
   Tm1637_wrbyte &H80                                       'Turn display off
   Tm1637_ack
   Tm1637_stop
End Sub



Sub Tm1637_on()
   Tm1637_start
   Tm1637_wrbyte &H8A                                       'Turn display on and set PWM for brightness to 25%
   Tm1637_ack
   Tm1637_stop
End Sub



Sub Tm1637_start()
   Set Tm1637_clk
   Set Tm1637_dout
   Waitus 2
   Reset Tm1637_dout
End Sub


Sub Tm1637_stop()
   Reset Tm1637_clk
   Waitus 2
   Reset Tm1637_dout
   Waitus 2
   Set Tm1637_clk
   Waitus 2
   Set Tm1637_dout
End Sub



Sub Tm1637_disp(byval Bdispdata As Word)
   Local Bcounter As Byte
   Local Strdisp As String * 5

   Strdisp = Str(bdispdata)
   Strdisp = Format(strdisp , "     ")

   Tm1637_start
   Tm1637_wrbyte &H40                                       'autoincrement adress mode
   Tm1637_ack
   Tm1637_stop
   Tm1637_start
   Tm1637_wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
   Tm1637_ack

   For Bcounter = 2 To 5
      Select Case Asc(strdisp , Bcounter)
         Case "0" : Tm1637_wrbyte &B00111111
         Case "1" : Tm1637_wrbyte &B00000110
         Case "2" : Tm1637_wrbyte &B01011011
         Case "3" : Tm1637_wrbyte &B01001111
         Case "4" : Tm1637_wrbyte &B01100110
         Case "5" : Tm1637_wrbyte &B01101101
         Case "6" : Tm1637_wrbyte &B01111101
         Case "7" : Tm1637_wrbyte &B00000111
         Case "8" : Tm1637_wrbyte &B01111111
         Case "9" : Tm1637_wrbyte &B01101111
         Case Else : Tm1637_wrbyte &B00000000
      End Select
      Tm1637_ack
   Next
   Tm1637_stop
End Sub



Sub Tm1637_wrbyte(byval Bdata As Byte)
   Local Bbitcounter As Byte

   For Bbitcounter = 0 To 7                                 'LSB first
      Reset Tm1637_clk
      Tm1637_dout = Bdata.bbitcounter
      Waitus 3
      Set Tm1637_clk
      Waitus 3
   Next
End Sub