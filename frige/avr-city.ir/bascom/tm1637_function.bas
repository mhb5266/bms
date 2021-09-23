Sub Tm1637_init()
Config Clk = Output
Config Dio = Output
local b as byte
b= brightness and &h07
if b > 0 then
b = b or &h08
endif
b =b + &h80
call Disp_1_2_3_4_dot(28,28,28,28,0)
_start
Call Wrbyte(b) : _ack
_stop

End Sub
'----------------------------------------------------------------------
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
_start
Call Wrbyte(&H40) : _ack                                    'Automatic address adding
_stop
_start
Call Wrbyte(&Hc0) : _ack
Call Wrbyte(d1) : _ack
Call Wrbyte(d2) : _ack
Call Wrbyte(d3) : _ack
Call Wrbyte(d4) : _ack
_stop
End Sub
'----------------------------------------------------------------------
Sub Disp(byval addr As Byte , Byval Dataa As Byte )
if addr>= 1 or addr <=4 then
addr=addr - 1
Dataa = Lookup(dataa , Table_7s )
_start
Call Wrbyte(&H44) : _ack       ' fixed address
_stop
_start
Call Wrbyte(&Hc0 or addr) : _ack
Call Wrbyte(dataa) : _ack
_stop
end if
End Sub
'-----------------------------------------------------------------------
Sub Tm1637_num(byval N As Word)
local D1 As Byte , d2 as byte , d3 as byte , d4 as byte
Local B As Word
B = N / 1000 : D1 = B Mod 10
B = N / 100 : D2 = B Mod 10
B = N / 10 : D3 = B Mod 10
D4 = N Mod 10
call Disp_1_2_3_4_dot(d1,d2,d3,d4,0)
End Sub
'--------------------------------------------------------------------
Sub Tm1637_scroll(byval S As String)
   Local S_length As Byte
   Local S_character As String * 4
   Local S_stringloop As Byte
    S_length = Len(s) - 3
   For S_stringloop = 1 To S_length
     S_character = Mid(s , S_stringloop , 4)
      Call Tm1637_print(s_character)
      Waitms delay_scroll
      Next
End Sub
'--------------------------------------------------------------------------
Sub Tm1637_print(byval S As String)
Local H As Byte
local d1 as byte ,d2 as byte,d3 as byte,d4 as byte
   Local S_character As String * 1
   Local S_stringloop As Byte


   For S_stringloop = 1 To 4
      S_character = Mid(s , S_stringloop , 1)
         Select Case S_character
         Case "0" : H = 0
         Case "1" : H = 1
         Case "2" : H = 2
         Case "3" : H = 3
         Case "4" : H = 4
         Case "5" : H = 5
         Case "6" : H = 6
         Case "7" : H = 7
         Case "8" : H = 8
         Case "9" : H = 9
         Case "A" : H = 10
         Case "a" : H = 34
         Case "B" : H = 11
         Case "b" : H = 11
         Case "C" : H = 12
         Case "c" : H = 36
         Case "D" : H = 13
         Case "d" : H = 13
         Case "E" : H = 14
         Case "F" : H = 15
         Case "G" : H = 16
         Case "H" : H = 17
         Case "I" : H = 18
         Case "J" : H = 19
         Case "L" : H = 20
         Case "U" : H = 27
         Case "S" : H = 5
         Case "y" : H = 37
         Case "Y" : H = 37
         Case "n" : H = 21
         Case "O" : H = 0
         Case "o" : H = 22
         Case "p" : H = 23
         Case "q" : H = 35
         Case "r" : H = 24
         Case "t" : H = 26
         Case "u" : H = 25
         Case "e" : H = 33
         Case " " : H = 28
         Case "-" : H = 29
         Case "_" : H = 30
         Case "]" : H = 31
         Case "[" : H = 32
         Case "*" : H = 38
         Case "l" : H = 39
         Case "h" : H = 40
         case "i" : H = 41
         Case Else : H = 28
      End Select
      select case S_stringloop
      case 1 :   D1 = h
      case 2 :   D2 = h
      case 3 :   D3 = h
      case 4 :   D4 = h
      end select

     Next S_stringloop
  call Disp_1_2_3_4_dot(d1,d2,d3,d4,0)
End Sub
'----------------------------------------------------------

Sub _start()
   Set Clk
   Set Dio
   Waitus 2
   Reset Dio
End Sub



Sub _ack()

    Reset Clk
   Reset Dio
   Set Clk
   Waitus 2
   Reset Clk
End Sub


Sub _stop()
   Reset Clk
   Waitus 2
   Reset Dio
   Waitus 2
   Set Clk
   Waitus 2
   Set Dio
End Sub

Sub Wrbyte(byval _data As Byte)
Local I As Byte                                             'Write byte variable passed by the call (Bajt)
   For I = 0 To 7                                           'send bit, LSB first
      Reset Clk
       Dio = _data.i
      Waitus 3
      Set Clk
      Waitus 3
   Next I
End Sub

sub displight(byval light as byte)
    select case light
         case 1
              light=&H88
         case 2
              light=&H89
         case 3
              light=&H8A
         case 4
              light=&H8B
         case 5
             light=&H8C
         case 6
             light=&H8D
         case 7
              light=&H8E
         case 8
              light=&H8F
         case 0
              light=&H80
    end select
    _start
    Call Wrbyte(light) : _ack
    _stop
end sub
'____________________________________________________________

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