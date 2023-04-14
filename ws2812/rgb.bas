
    'PROGRAMM:RAINBOW_EXPL_Shift
    'DESCRIPTION: Knight-Rider effect
    $regfile = "m8adef.dat"
    $crystal = 11059200
    $hwstack = 40
    $swstack = 16
    $framesize = 32
    '----[IMPLEMENT RAINBOW]--------------------------------------------------------
    $lib "Rainbow.lib"
    $external Ws2812b


Declare Sub Select_rainbow(byval Channel As Byte)
Declare Sub Setcolor(byval Lednr As Word , Color() As Byte)
Declare Sub Send()

    Declare Sub Fill(color() As Byte) : $external Use_fill
    Declare Sub Fill_colors(color() As Byte) : $external Use_fill       ' new v1.2
    Declare Sub Fill_stripe(color() As Byte) : $external Use_fill_stripe       ' new v1.2
    Declare Sub Clear_stripe() : $external Use_clear_stripe
    Declare Sub Clear_colors() : $external Use_clear_colors
    Declare Sub Swap_color(byval Lednr1 As Word , Byval Lednr2 As Word) : $external Use_swap_color
    Declare Sub Rotate_left(byval Left_index As Word , Byval Width As Word) : $external Use_rotate_left
    Declare Sub Rotate_right(byval Left_index As Word , Byval Width As Word) : $external Use_rotate_right
    Declare Sub Shift_right(byval Left_index As Word , Byval Width As Word) : $external Use_shift_right
    Declare Sub Shift_left(byval Left_index As Word , Byval Width As Word) : $external Use_shift_left
    Declare Sub And_color(byval Lednr As Word , Color() As Byte) : $external Use_and_color
    Declare Sub Or_color(byval Lednr As Word , Color() As Byte) : $external Use_or_color
    Declare Sub Add_color(byval Lednr As Word , Color() As Byte) : $external Use_add_color
    Declare Sub Sub_color(byval Lednr As Word , Color() As Byte) : $external Use_sub_color
    Declare Sub Change_pin(byval Port As Byte , Byval Pin As Byte) : $external Use_change_pin
  ' Declare Sub Settablecolor(byval Lednr As Word , Byval Index As Byte) : $external Use_settablecolor
  '  Declare Function GetColor (byval LedNr As Word)as Byte:$external USE_GetColor
  ' Declare Function Lookup_color(byval Index As Byte) As Byte : $external Use_lookup_color       'new v1.2



'#CHANNEL0
Const Rainbow0_len = 8
Const Rainbow0_port = Portc
Const Rainbow0_pin = Pc5
Dim Color(3) As Byte                                        'gloabal Color-variables
 R Alias Color(_base)
 G Alias Color(_base + 1)
 B Alias Color(_base + 2)
'_______________________________________________________________________________
'----[MAIN]---------------------------------------------------------------------
Dim N As Word
dim i as byte
Dim Num As Word
Dim Index As Byte
Call Select_rainbow(0)                                      'select Rainbow
Wait 2

R = 0 : G = 0 : B = 0

Do

   call clear_colors()
   call send
   wait 1
   for i=7 to 5 step -1
      r=0 :g=50:b=0
      call setcolor(i,r)
      call send
     waitus 100
   next
   wait 3

   call clear_colors()
   call send
   wait 1
   for i=4 to 3 step -1
      r=50 :g=50:b=0
      call setcolor(i,r)
      call send
      waitus 100
   next
   wait 3

   call clear_colors()
   call send
   wait 1
   for i=2 to 0 step -1
      r=50 :g=0:b=0
      call setcolor(i,r)
      call send
      waitus 100
   next
   wait 3
'(

R = 50 : G = 0 : B = 0
Call Setcolor(0 , R)
Call Send()

R = 53 : G = 0 : B = 55
Call Setcolor(1 , R)
Call Send()
R = 55 : G = 20 : B = 0

Call Setcolor(2 , R)
Call Send()

R = 0 : G = 40 : B = 35
Call Setcolor(3 , R)
Call Send()

R = 5 : G = 45 : B = 0
Call Setcolor(4 , R)
Call Send()

R = 0 : G = 50 : B = 23
Call Setcolor(5 , R)
Call Send()

R = 51 : G = 63 : B = 9
Call Setcolor(6 , R)
Call Send()

R = 0 : G = 55 : B = 55
Call Setcolor(7 , R)
Call Send()
')
'(
For N = 0 To 15
Call Rotate_left(0 , 8)
Call Send()
Waitms 200
Next N
Call Clear_colors()
R = 0 : G = 0 : B = 0
For N = 0 To 3
R = Lookup(n , Colors)
Call Setcolor(n , R)
Call Send()
Next N


For N = 0 To 47
Call Rotate_left(0 , 8)
Call Send()
Waitms 100
Next N

Call Clear_colors()
R = 0 : G = 0 : B = 0
For N = 0 To 3

B = Lookup(n , Colors)
Call Setcolor(n , R)
Call Send()
Next N

For N = 0 To 45
Call Rotate_left(0 , 8)
Call Send()
Waitms 100
Next N
Call Clear_colors()

R = 10 : G = 10 : B = 10
For N = 0 To 3
Call Setcolor(n , R)
Call Send()
Next N
R = 20 : G = 0 : B = 0
For N = 4 To 7
Call Setcolor(n , R)
Call Send()
Next N

For N = 0 To 40
Call Rotate_right(0 , 8)
Call Send()
Waitms 100
Next N
Call Clear_colors()

R = 10 : G = 10 : B = 10
For N = 0 To 6 Step 2
Call Setcolor(n , R)
Call Send()
Next N
R = 20 : G = 0 : B = 0
For N = 1 To 7 Step 2
Call Setcolor(n , R)
Call Send()
Next N

For N = 0 To 20
Call Rotate_right(0 , 8)
Call Send()
Waitms 300
Next N
Call Clear_colors()
 ')
Loop
End

Colors:
Data 100 , 70 , 40 , 10