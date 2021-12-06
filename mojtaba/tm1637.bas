
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
config lcdpin=pin;db7=porta.4;db6=portb.4;db5=portb.3;db4=portb.2;rs=portb.0;en=portb.1
config lcd=16*2
'cursor off
'cls:lcd "hi" :wait 2:cls

Tm1637_clk Alias Portc.3: config portc.3 =output
Tm1637_dout Alias Portc.2 :config portc.2=output
Tm1637_din Alias Pinc.2
Declare Sub disp(byval Bdispdata As integer)            'The display can only show numbers)
Declare Sub dispstr()
Declare Sub wrbyte(byval Bdata As Byte)
Declare Sub dispon()
Declare Sub Tm1637_off()
Declare Sub _start()
Declare Sub _stop()
Declare Sub _ack()
declare sub disptime

dim _secc as byte
dim _min as  byte,_hour as byte,_sec as byte
dim i as byte :i=80
dim stri as string*4
dim strsc as string*1
dim smin as string*2
dim shour as string*2
dispon
main:
do
  incr _sec
  if _sec>59 then
     _sec=0
     incr _min
       if _min>59 then
          _min=0
          incr _hour
          if _hour>23 then
             _hour=0
          end if
       end if
  end if
  _secc=_sec mod 2
  waitms 50
  shour=str(_hour):smin=str(_min)
  shour=format(shour,"00"): smin=format(smin,"00")
  stri=shour
  stri=stri+smin
  dispstr
  'incr i
loop


Sub _ack()

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
   _start
   wrbyte &H80                                       'Turn display off
   _ack
   _stop
End Sub



Sub dispon()
   _start
   wrbyte &H8A                                       'Turn display on and set PWM for brightness to 25%
   _ack
   _stop
End Sub



Sub _start()

   Set Tm1637_clk
   Set Tm1637_dout
   Waitus 2
   Reset Tm1637_dout
End Sub


Sub _stop()

   Reset Tm1637_clk
   Waitus 2
   Reset Tm1637_dout
   Waitus 2
   Set Tm1637_clk
   Waitus 2
   Set Tm1637_dout
End Sub





Sub disp(byval Bdispdata As integer)
   Local Bcounter As Byte
   Local Strdisp As String * 5

   Strdisp = Str(bdispdata)
   Strdisp = Format(strdisp , "     ")
   home ; lcd _sec
   _start
   wrbyte &H40                                       'autoincrement adress mode
   _ack
   _stop
   _start
   wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
   _ack

   For Bcounter = 2 To 6
      Select Case Asc(strdisp , Bcounter)
         Case "0" : wrbyte &B00111111
         Case "1" : wrbyte &B00000110
         Case "2" : wrbyte &B01011011
         Case "3" : wrbyte &B01001111
         Case "4" : wrbyte &B01100110
         Case "5" : wrbyte &B01101101
         Case "6" : wrbyte &B01111101
         Case "7" : wrbyte &B00000111
         Case "8" : wrbyte &B01111111
         Case "9" : wrbyte &B01101111
         case "-" : wrbyte &B01000000
         case "c" : wrbyte &B01111001
         case ":" : wrbyte &B11111111
         Case Else : wrbyte &B00000000
      End Select
      _ack
   Next
   _stop
End Sub


Sub dispstr()
   Local Bcounter As Byte
   Local Strdisp As String * 4

   strdisp=stri
   Strdisp = Format(strdisp , "    ")
   home ; lcd _sec
   _start
   wrbyte &H40                                       'autoincrement adress mode
   _ack
   _stop
   _start
   wrbyte &HC0                                       'startaddress first digit (HexC0) = MSB display
   _ack

   For Bcounter = 1 To 4
      strin =mid (strdisp,bcounter,1)
      'cls
      'lcd strdisp;"   "; bcounter
      'lowerline:lcd strin
      'wait 1
      if _secc=0 then
      select case strin
         Case "0" : wrbyte &B00111111
         Case "1" : wrbyte &B00000110
         Case "2" : wrbyte &B01011011
         Case "3" : wrbyte &B01001111
         Case "4" : wrbyte &B01100110
         Case "5" : wrbyte &B01101101
         Case "6" : wrbyte &B01111101
         Case "7" : wrbyte &B00000111
         Case "8" : wrbyte &B01111111
         Case "9" : wrbyte &B01101111
         case "-" : wrbyte &B01000000
         case "c" : wrbyte &B01111001
         Case Else : wrbyte &B00000000
      End Select
      _ack

      else
      select case strin
         Case "0" : wrbyte &B10111111
         Case "1" : wrbyte &B10000110
         Case "2" : wrbyte &B11011011
         Case "3" : wrbyte &B11001111
         Case "4" : wrbyte &B11100110
         Case "5" : wrbyte &B11101101
         Case "6" : wrbyte &B11111101
         Case "7" : wrbyte &B10000111
         Case "8" : wrbyte &B11111111
         Case "9" : wrbyte &B11101111
         case "-" : wrbyte &B11000000
         case "c" : wrbyte &B11111001
         Case Else : wrbyte &B10000000
      End Select
      _ack
      end if

   Next
   _stop
End Sub



Sub wrbyte(byval Bdata As Byte)
   Local Bbitcounter As Byte

   For Bbitcounter = 0 To 7                                 'LSB first
      Reset Tm1637_clk
      Tm1637_dout = Bdata.bbitcounter
      Waitus 3
      Set Tm1637_clk
      Waitus 3
   Next
End Sub



end