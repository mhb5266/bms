
$regfile = "m16def.dat"
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

config_fridge:

const maxtmp=31
const mintmp=-2


motor alias portc.2:config portc.2=OUTPUT
fan alias portc.4:config portc.4=OUTPUT

Config_temp:

Config 1wire = Portc.0


Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6




Dim Readsens As Integer


Dim Tmpread As Boolean
Dim Tmp1 As Integer


declare sub temp
declare sub  conversion
declare sub fridge


config_tm1637:

Config Porta.0 = Output                                     ' for TM1637 clock
Config Porta.1 = Output                                     ' for TM1637 data

Tm1637_clk Alias Porta.0
Tm1637_dout Alias Porta.1
Tm1637_din Alias Pina.1

Declare Sub Tm1637_disp(byval Bdispdata As Word)            'The display can only show numbers
Declare Sub Tm1637_wrbyte(byval Bdata As Byte)
Declare Sub Tm1637_on()
Declare Sub Tm1637_off()
Declare Sub Tm1637_start()
Declare Sub Tm1637_stop()
Declare Sub Tm1637_ack()






dim i as word
led alias portd.6:config portd.6=OUTPUT
'========================================================================
'
'     Start main
'
'========================================================================


Tm1637_on

main:

Do
temp
'incr i
'toggle led
Tm1637_disp tmp1
Wait 1
'Tm1637_off

fridge

Loop
End

t1rutin:
stop timer1
     toggle led

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
       set motor
       set fan
    end if

    if tmp1<mintmp then
       reset motor
       reset fan
    end if

end sub