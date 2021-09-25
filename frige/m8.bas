
$regfile = "m8def.dat"
$crystal = 1000000
$hwstack = 100
$swstack = 100
$framesize = 100


config_timer:
             Config Timer1 = Timer , Prescale = 1024
             enable interrupts
             enable timer1
             on ovf1 t1rutin
             timer1=64535:start timer1
             dim onn as word
             dim offf as word

config_fridge:

const maxtmp=-10
const mintmp=-17


buzz alias portd.7:config portd.7=output
'stb alias portb.5:config portb.5=OUTPUT:reset stb
'csel alias portc.1:config portc.1=OUTPUT:reset csel

motor alias portd.6:config portd.6=OUTPUT
fan alias portd.5:config portd.5=OUTPUT
out1 alias portb.1:config portb.1=OUTPUT
out2 alias portb.2 :config portb.2=OUTPUT
'buzz alias portb.0:config portb.0=output
stb alias portb.5:config portb.5=OUTPUT:reset stb
csel alias portc.1:config portc.1=OUTPUT:reset csel
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


Dim Readsens As Integer


Dim Tmpread As Boolean
Dim Tmp1 As Integer


declare sub temp
declare sub  conversion
declare sub fridge


config_tm1637:

Config Portb.3= Output                                     ' for TM1637 clock
Config Portb.4 = Output                                     ' for TM1637 data

Tm1637_clk Alias Portb.3
Tm1637_dout Alias Portb.4
Tm1637_din Alias Pinb.4

Declare Sub Tm1637_disp(byval Bdispdata As integer)            'The display can only show numbers
Declare Sub Tm1637_wrbyte(byval Bdata As Byte)
Declare Sub Tm1637_on()
Declare Sub Tm1637_off()
Declare Sub Tm1637_start()
Declare Sub Tm1637_stop()
Declare Sub Tm1637_ack()
Declare Sub Disp_1_2_3_4_dot(byval Dig1 As Byte , Byval Dig2 As Byte , Byval Dig3 As Byte , Byval Dig4 As Byte , Byval Dot As Byte)






dim i as word
'led alias portd.6:config portd.6=OUTPUT
'========================================================================
'
'     Start main
'
'========================================================================

for i=1 to 4
   'toggle buzz
   waitms 250
next

Tm1637_on

main:

Do

'incr i
'toggle led
waitms 50
if tmp1<-17 then set downside:reset upside
if tmp1>-10 then set upside:reset downside

'Tm1637_off

'fridge

Loop
End

t1rutin:
stop timer1


   temp
      Tm1637_disp tmp1

   if tmp1>maxtmp then
       set motor
       set fan
       set out1
       set out2
    end if

    if tmp1<mintmp then
       reset motor
       reset fan
       set out1
       set out2
    end if

    if tmp1>-16 and upside=0 and downside=1 then
      reset out1
    end if
    if tmp1>-13 and upside=0 and downside=1 then
      reset out2
    end if

timer1=64535
start timer1

return

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



Sub Tm1637_disp(byval Bdispdata As integer)
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

   For Bcounter = 2 To 6
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
         case "-" : Tm1637_wrbyte &B01000000                    '-    29
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


      Tmp1 = Readsens

      Gosub Conversion
      Sens1 = Temperature

   end if

end sub


sub Conversion
   Readsens = Readsens * 10 : Readsens = Readsens \ 16
   tmp1=readsens
   tmp1=tmp1/10
   Temperature = Str(readsens) : Temperature = Format(temperature , "0.0")
end sub

sub fridge

    if tmp1>maxtmp then
       reset motor
       reset fan
       reset out1
       reset out2
    end if

    if tmp1<mintmp then
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
Tm1637_ack                                    'Automatic address adding
Tm1637_stop
Tm1637_start
Call Wrbyte(&Hc0) : Tm1637_ack
Call Wrbyte(d1) : Tm1637_ack
Call Wrbyte(d2) : Tm1637_ack
Call Wrbyte(d3) : Tm1637_ack
Call Wrbyte(d4) : Tm1637_ack
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