
$regfile = "m8def.dat"
$crystal = 8000000
$hwstack = 100
$swstack = 100
$framesize = 100


config_timer:
             Config Timer1 = Timer , Prescale = 1024
             enable interrupts
             enable timer1
             on ovf1 t1rutin
             timer1=57535:start timer1
             dim onn as word
             dim offf as word

config_fridge:

const maxtmp=-10
const mintmp=-17


led alias portd.7:config portd.7=output
'stb alias portb.5:config portb.5=OUTPUT:reset stb
'csel alias portc.1:config portc.1=OUTPUT:reset csel

motor alias portd.6:config portd.6=OUTPUT
fan alias portd.5:config portd.5=OUTPUT
out1 alias portb.1:config portb.1=OUTPUT
out2 alias portb.2 :config portb.2=OUTPUT
'buzz alias portb.0:config portb.0=output
stb alias portC.5:config portC.5=OUTPUT:reset stb
csel alias portc.1:config portc.1=OUTPUT:reset csel

dim ads as word :ads=192

Config_temp:

Config 1wire = Portb.0


Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6

dim upside as bit
dim downside as bit

dim seg(8) as byte
dim grid(8) as byte
dim j as byte


Dim Readsens As Integer


Dim Tmpread As Boolean
Dim Tmp As Integer


declare sub temp
declare sub  conversion
declare sub fridge

const num=8
dim segment as byte
dim light as byte


config_tm1637:
'(
Config Portb.3= Output                                     ' for TM1637 clock
Config Portb.4 = Output                                     ' for TM1637 data
Tm1637_clk Alias Portb.3
Tm1637_dout Alias Portb.4
Tm1637_din Alias Pinb.4
')


Config Portc.3= Output                                     ' for TM1637 clock
Config Portc.4 = Output                                     ' for TM1637 data
clk Alias Portc.3
dout Alias Portc.4
din Alias Pinc.4

Declare Sub convert(byval Bdispdata As integer)            'The display can only show numbers
Declare Sub wrbyte(byval Bdata As Byte)
declare sub disp

Declare Sub dispon()
Declare Sub Tm1637_off()
Declare Sub _start()
Declare Sub _stop()
Declare Sub _ack()
Declare Sub Disp_1_2_3_4_dot(byval Dig1 As Byte , Byval Dig2 As Byte , Byval Dig3 As Byte , Byval Dig4 As Byte , Byval Dot As Byte)






dim i as word
'led alias portd.6:config portd.6=OUTPUT
'========================================================================
'
'     Start main
'
'========================================================================
stop timer1
'(
  set stb :set clk:waitus 2: reset stb
  wrbyte &H40
  set stb :set clk:waitus 2: reset stb
  wrbyte &HC0
  for i=1 to 16
      wrbyte &H01
      waitus 2
  next
  segment=&H88
  for i= 1 to 8
      incr segment
      toggle led
      wait 1
      set stb :set clk:waitus 2: reset stb
      wrbyte segment
  next
  for i=1 to 8
      waitms 200
      toggle led
  next
')
'start timer1

  set stb :set clk:waitus 2: reset stb
  wrbyte &H44
  set stb :set clk:waitus 2: reset stb
  wrbyte &HC0
  wrbyte &H06
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HC2
  wrbyte &H02
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HC4
  wrbyte &H00
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HC6
  wrbyte &H06
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HC8
  wrbyte &H07
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HCA
  wrbyte &H05
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HCC
  wrbyte &H06
  waitus 2

  set stb :set clk:waitus 2: reset stb
  wrbyte &HCE
  wrbyte &H00
  waitus 2
  set stb :set clk:waitus 2: reset stb
  wrbyte &H8F
  for i=1 to 8
      toggle led
      waitms 200
  next
  wait 1

main:



Do
'incr tmp
temp
tmp=tmp*-1
tmp=tmp+20
convert tmp
waitms 500
'incr i
'toggle led
'waitms 50
'if tmp<-17 then set downside:reset upside
'if tmp>-10 then set upside:reset downside

      'disp num
      'dispon
'wait 1
'toggle led
'Tm1637_off

'fridge

Loop
End

t1rutin:
stop timer1

   toggle led

   '(
   temp
      disp num
      dispon
   if tmp>maxtmp then
       set motor
       set fan
       set out1
       set out2
    end if

    if tmp<mintmp then
       reset motor
       reset fan
       set out1
       set out2
    end if

    if tmp>-16 and upside=0 and downside=1 then
      reset out1
    end if
    if tmp>-13 and upside=0 and downside=1 then
      reset out2
    end if

    ')

timer1=57535

start timer1

return

'=========================================================================
'
'     Subroutines
'
'========================================================================
'(
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
')


Sub Tm1637_off()
   '_start
   wrbyte &H80                                       'Turn display off
   '_ack
   '_stop
End Sub



Sub dispon()
   '_start
  set clk :set stb:waitus 2: reset stb
   wrbyte &H8F
   waitus 2                                       'Turn display on and set PWM for brightness to 25%
   '_ack
   '_stop
End Sub


'(
Sub _start()
   set stb
   waitus 2
   Set Tm1637_clk
   Set Tm1637_dout
   Waitus 2
   Reset Tm1637_dout
   reset stb
End Sub


Sub _stop()
   set stb
   waitus 2
   Reset Tm1637_clk
   Waitus 2
   Reset Tm1637_dout
   Waitus 2
   Set Tm1637_clk
   Set Tm1637_dout
   reset stb
End Sub

')



Sub convert (byval Bdispdata As integer)
    Local Bcounter As Byte
   Local Strdisp As String * 3

   'Strdisp = Str(bdispdata)
   'Strdisp = Format(strdisp , "   5")
   if tmp<0 then
      'tmp=tmp*10
      strdisp="-"
      strdisp=strdisp+str(abs(tmp))
   elseif tmp>0 then
       strdisp=str(tmp)
   end if
   'strdisp="123"
   strdisp=format(strdisp,"   ")
   bcounter=len(strdisp)
   incr bcounter
   For i = 1 To bcounter
      Select Case Asc(strdisp ,bcounter-i)
                              '.gfedcba
         Case "0" : segment= &B00111111
         Case "1" : segment= &B00110000
         Case "2" : segment= &B01011011
         Case "3" : segment= &B01111001
         Case "4" : segment= &B01110100
         Case "5" : segment= &B01101101
         Case "6" : segment= &B01101111
         Case "7" : segment= &B00111100
         Case "8" : segment= &B01111111
         Case "9" : segment= &B01111101
         case "-" : segment= &B01000000                    '-    29
         Case Else : segment= &B00000000
      End Select
      seg(i)=segment

   Next
   disp

End Sub

sub disp
         for i=0 to 7
           grid(1).i=seg(i+1).0
           grid(2).i=seg(i+1).1
           grid(3).i=seg(i+1).2
           grid(4).i=seg(i+1).3
           grid(5).i=seg(i+1).4
           grid(6).i=seg(i+1).5
           grid(7).i=seg(i+1).6
           grid(8).i=seg(i+1).7
         next
   set stb :set clk:waitus 2: reset stb
   wrbyte &H44
   set stb :set clk:waitus 2: reset stb
   wrbyte &HC0
   wrbyte grid(1)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HC2
   wrbyte grid(2)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HC4
   wrbyte grid(3)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HC6
   wrbyte grid(4)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HC8
   wrbyte grid(5)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HCA
   wrbyte grid(6)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HCC
   wrbyte grid(7)
   set stb :set clk:waitus 2: reset stb
   wrbyte &HCE
   wrbyte grid(8)
   set stb :set clk:waitus 2: reset stb
   wrbyte &H88

end sub

Sub wrbyte(byval Bdata As Byte)
   Local Bbitcounter As Byte
   For Bbitcounter = 0 To 7                                 'LSB first
      Reset clk
      dout = Bdata.bbitcounter
      Waitus 2
      Set clk
      Waitus 2
   Next
End Sub


sub temp
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   if err=0 then
      1wwrite &HBE
      Readsens = 1wread(2)


      tmp = Readsens

      Gosub Conversion
      Sens1 = Temperature

   end if

end sub


sub Conversion
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   tmp=readsens
   tmp=tmp/10
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub

sub fridge

    if tmp>maxtmp then
       reset motor
       reset fan
       reset out1
       reset out2
    end if

    if tmp<mintmp then
       set motor
       set fan
       set out1
       set out2
    end if

end sub

'(

Sub Disp_1_2_3_4_dot(byval Dig1 As Byte , Byval Dig2 As Byte , Byval Dig3 As Byte , Byval Dig4 As Byte , Byval Dot As Byte)
local D1 As Byte , d2 as byte , d3 as byte , d4 as byte
D1 = Lookup(dig1 , Table_7s )
D2 = Lookup(dig2 , Table_7s )
D3 = Lookup(dig3 , Table_7s )
Select Case Dot
Case 0 : D2 = D2 And &B01111111                     'OFF :
Case 1 : D2 = D2 Or &B10000000                      'ON  :
End Select
D4 = Lookup(dig4 , Table_7s)
Tm1637_start
Call Wrbyte(&H40)
_ack                                    'Automatic address adding
Tm1637_stop
Tm1637_start
Call Wrbyte(&Hc0) : _ack
Call Wrbyte(d1) : _ack
Call Wrbyte(d2) : _ack
Call Wrbyte(d3) : _ack
Call Wrbyte(d4) : _ack
Tm1637_stop
End Sub



Table_7s:
'      XGFEDCBA
Data &B00111111                                             '0
Data &B00000110                                             '1
Data &B01011011                                             '2
Data &B01001111                                             '3
Data &B01100110                                             '4
Data &B01101101                                             '5
Data &B01111101                                             '6
Data &B00000111                                             '7
Data &B01111111                                             '8
Data &B01101111                                             '9
Data &B01110111                                             'A    10
Data &B01111100                                             'b    11
Data &B00111001                                             'C    12
Data &B01011110                                             'D    13
Data &B01111001                                             'E    14
Data &B01110001                                             'F    15
Data &B00111101                                             'G    16
Data &B01110110                                             'H    17
Data &B00110000                                             'I    18
Data &B00001110                                             'J    19
Data &B00111000                                             'L    20
Data &B01010100                                             'n    21
Data &B01011100                                             'o    22
Data &B01110011                                             'P    23
Data &B01010000                                             'r    24
Data &B00011100                                             'u    25
Data &B01111000                                             't    26
Data &B00111110                                             'U    27
Data &B00000000                                             'off  28
Data &B01000000                                             '-    29
Data &B00001000                                             '_    30
Data &B00001111                                             ']    31
Data &B00111001                                             '[    32
Data &B01111011                                             'e    33
Data &B01011111                                             'a    34
Data &B01100111                                             'q    35
Data &B01011000                                             'c    36
Data &B01101110                                             'y    37
Data &B01100011                                             '*    38
Data &B00110000                                             'l    39
Data &B01110100                                             'h    39
DATA &B00010000                                             'i    41

   ')