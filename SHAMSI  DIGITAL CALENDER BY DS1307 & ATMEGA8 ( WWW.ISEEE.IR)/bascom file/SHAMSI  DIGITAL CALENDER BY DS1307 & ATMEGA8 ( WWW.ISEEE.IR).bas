

$regfile = "m128def.dat"

$crystal = 8000000

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************               CONFIG            ****************
'******************************                                 ****************
'*******************************************************************************

Declare Function M_kabise(byref Sal As Word)as Byte
Declare Function Sh_kabise(byref Sal As Word)as Byte
'-----------------------------------------------------
Config Lcdpin = Pin , Db4 = Portb.2 , Db5 = Portb.3 , _
Db6 = Portb.4 , Db7 = Portb.5 , E = Portb.0 , Rs = Portb.1
Cursor Off
'-----------------------------------------------------

Config Sda = Portd.7
Config Scl = Portd.6
'****************************
Const Ds1307w = &HD0
Const Ds1307r = &HD1

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************                DIM              ****************
'******************************                                 ****************
'*******************************************************************************

Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim _year As Word
Dim Weekday As Byte
'--------------
Dim M_day As Word
Dim Sh_day As Word
Dim M_year As Word
Dim Sh_year As Word
Dim M_month As Word
Dim Sh_month As Word
Dim Kabise As Byte
Dim Kole_roz_m As Word
Dim Kole_roz_sh As Word
'-------------

'********************************

Dim Conter1 As Word
Dim Conter2 As Word
Dim Conter3 As Word
Dim Conter4 As Word
Dim Day_of_month(12) As Byte
Day_of_month(1) = 31
Day_of_month(2) = 28
Day_of_month(3) = 31
Day_of_month(4) = 30
Day_of_month(5) = 31
Day_of_month(6) = 30
Day_of_month(7) = 31
Day_of_month(8) = 31
Day_of_month(9) = 30
Day_of_month(10) = 31
Day_of_month(11) = 30
Day_of_month(12) = 31

'----------------------

Dim Temp1 As Integer
Dim Temp2 As Integer
Dim Temp3 As Word
Dim Temp4 As Word
Dim Temp5 As Byte

'----------------------- keys
Key_menu Alias Pind.0
Config Key_menu = Input
Portd.0 = 1

Key_incr Alias Pind.1
Config Key_incr = Input
Portd.1 = 1

Key_decr Alias Pind.2
Config Key_decr = Input
Portd.2 = 1
'-----------------------------------
Dim Menu As Byte
Dim Timer_1 As Word
Dim S1 As String * 15
Dim S As String * 10
S1 = "  WWW.ISEEE.IR"
Dim Blink_flag As Bit
Dim Selection As Byte
'------------------------------------



'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************                MAIN             ****************
'******************************                                 ****************
'*******************************************************************************

Cls
Locate 1 , 1 : Lcd S1
Wait 1
Cls
Do
  Gosub Read_date_time
  Gosub M_to_sh

  Locate 1 , 1
  Lcd "TIME: " ; _hour ; ":" ; _min ; ":" ; _sec ; "   "
  Locate 2 , 1
  Lcd "DATE: " ; Sh_year ; "/" ; Sh_month ; "/" ; Sh_day ; "   "


  '---------------------------- WAIT AND READ KEY

  For Conter1 = 1 To 40000

     If Key_menu = 0 Then

        Waitms 100

        If Key_menu = 0 Then
           Cls
           Locate 1 , 1
           Lcd "     MENU "
           Wait 1
           Gosub Menuu
        End If

        Waitus 10

     End If

  Next

'------------------------------
Loop

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************                MENU             ****************
'******************************                                 ****************
'*******************************************************************************

Menuu:

Selection = 1
Cls
Do

Incr Timer_1
If Timer_1 > 5 Then
 Timer_1 = 0
 Toggle Blink_flag
End If

S1 = "TIME: "
'-----------------------------
If Selection = 1 And Blink_flag = 0 Then

 S1 = S1 + "  "
Else

 S = Str(_hour)
 S = Format(s , "00")
 S1 = S1 + S

End If
S1 = S1 + ":"
'------------------------------
If Selection = 2 And Blink_flag = 0 Then

 S1 = S1 + "  "
Else

 S = Str(_min)
 S = Format(s , "00")
 S1 = S1 + S

End If
S1 = S1 + ":"
'------------------------------
If Selection = 3 And Blink_flag = 0 Then

 S1 = S1 + "  "
Else

 S = Str(_sec)
 S = Format(s , "00")
 S1 = S1 + S

End If


Locate 1 , 1
Lcd S1


S1 = "DATE: "
'--------------------------------
If Selection = 4 And Blink_flag = 0 Then

 S1 = S1 + "    "
Else

 S = Str(sh_year)
 S = Format(s , "0000")
 S1 = S1 + S

End If
S1 = S1 + "/"
'---------------------------------
If Selection = 5 And Blink_flag = 0 Then

 S1 = S1 + "  "
Else

 S = Str(sh_month)
 S = Format(s , "00")
 S1 = S1 + S

End If
S1 = S1 + "/"
'----------------------------------
If Selection = 6 And Blink_flag = 0 Then

 S1 = S1 + "  "
Else

 S = Str(sh_day)
 S = Format(s , "00")
 S1 = S1 + S

End If

Locate 2 , 1
Lcd S1




If Key_menu = 0 Then
   Waitms 100
   If Key_menu = 0 Then Incr Selection
End If


'-----------------------------------
If Key_incr = 0 Then
   Waitms 100
   If Key_incr = 0 Then

      If Selection = 1 Then Incr _hour
      If Selection = 2 Then Incr _min
      If Selection = 3 Then Incr _sec
      If Selection = 4 Then Incr Sh_year
      If Selection = 5 Then Incr Sh_month
      If Selection = 6 Then Incr Sh_day

   End If

End If
'------------------------------------
If Key_decr = 0 Then
   Waitms 100
   If Key_decr = 0 Then

     If Selection = 1 Then Decr _hour
     If Selection = 2 Then Decr _min
     If Selection = 3 Then Decr _sec
     If Selection = 4 Then Decr Sh_year
     If Selection = 5 Then Decr Sh_month
     If Selection = 6 Then Decr Sh_day

   End If

End If

'--------------------------------------
If _hour > 100 Then _hour = 23
If _min > 100 Then _min = 59
If _sec > 100 Then _sec = 59

If _hour > 23 Then _hour = 0
If _min > 59 Then _min = 0
If _sec > 59 Then _sec = 0
If Sh_year > 1470 Then Sh_year = 1390
If Sh_month > 12 Then Sh_month = 1
If Sh_day > 31 Then Sh_day = 1


If Sh_year < 1390 Then Sh_year = 1470
If Sh_month < 1 Then Sh_month = 12
If Sh_day < 1 Then Sh_day = 31
'---------------------------------------


Waitms 40

If Selection > 6 Then Exit Do

Loop

Cls
Locate 1 , 1
Lcd " SAVEING"
Wait 1
Gosub Sh_to_m
Gosub Setdate
Gosub Settime

Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************       READ DATE AND TIME        ****************
'******************************                                 ****************
'*******************************************************************************

Read_date_time:
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 0                                                ' start address in 1307
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307r                                          ' send address
  I2crbyte _sec , Ack
  I2crbyte _min , Ack                                       ' MINUTES
  I2crbyte _hour , Ack                                      ' Hours
  I2crbyte Weekday , Ack                                    ' Day of Week
  I2crbyte M_day , Ack                                      ' Day of Month
  I2crbyte M_month , Ack                                    ' Month of Year
  I2crbyte _year , Nack                                     ' Year
  I2cstop
  _sec = Makedec(_sec) : _min = Makedec(_min) : _hour = Makedec(_hour)
  M_day = Makedec(m_day) : M_month = Makedec(m_month) : _year = Makedec(_year)
  M_year = 2000 + _year

Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************              SET DATE           ****************
'******************************                                 ****************
'*******************************************************************************

Setdate:

  _year = M_year - 2000
  M_day = Makebcd(m_day) : M_month = Makebcd(m_month) : _year = Makebcd(_year)
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 4                                                ' starting address in 1307
  I2cwbyte M_day                                            ' Send Data to SECONDS
  I2cwbyte M_month                                          ' MINUTES
  I2cwbyte _year                                            ' Hours
  I2cstop
Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************             SET TIME            ****************
'******************************                                 ****************
'*******************************************************************************

Settime:
  _sec = Makebcd(_sec) : _min = Makebcd(_min) : _hour = Makebcd(_hour)
  I2cstart                                                  ' Generate start code
  I2cwbyte Ds1307w                                          ' send address
  I2cwbyte 0                                                ' starting address in 1307
  I2cwbyte _sec                                             ' Send Data to SECONDS
  I2cwbyte _min                                             ' MINUTES
  I2cwbyte _hour                                            ' Hours
  I2cstop
Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************         MILADI TO SHAMSI        ****************
'******************************                                 ****************
'*******************************************************************************


M_to_sh:

'----------------
If M_kabise(m_year) = 0 Then
   Day_of_month(2) = 28
Else
   Day_of_month(2) = 29
End If
'----------------

Conter2 = M_month - 1
Kole_roz_m = 0

For Conter1 = 1 To Conter2
   Kole_roz_m = Kole_roz_m + Day_of_month(conter1)
Next
Kole_roz_m = Kole_roz_m + M_day

'**********************************

If Kole_roz_m > 79 Then

   Sh_year = M_year - 621
   Kole_roz_sh = Kole_roz_m - 79

Else

   Sh_year = M_year - 622

   Temp4 = M_year - 1
   Temp5 = M_kabise(temp4)

   If Temp5 = 0 Then
      Kole_roz_sh = Kole_roz_m + 286
   Else
      Kole_roz_sh = Kole_roz_m + 287
   End If

End If

'**********************************

Sh_month = 1

'****************
While Kole_roz_sh > 30

   If Sh_month < 7 Then
         Kole_roz_sh = Kole_roz_sh - 31
   Else
         Kole_roz_sh = Kole_roz_sh - 30
   End If

   Incr Sh_month

Wend
'***************
'---------------
If Kole_roz_sh = 0 Then

   Decr Sh_month
   If Sh_month < 7 Then
      Sh_day = 31
   Else
      Sh_day = 30
   End If
Else
   Sh_day = Kole_roz_sh
End If
'---------------
Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************        SHAMSI TO MILADI         ****************
'******************************                                 ****************
'*******************************************************************************

Sh_to_m:

'------------------
Kole_roz_sh = 0
'------------------

If Sh_month > 6 Then

 Kole_roz_sh = 186
 Temp4 = Sh_month - 7
 Temp4 = Temp4 * 30
 Kole_roz_sh = Kole_roz_sh + Temp4

Else

 Temp4 = Sh_month - 1
 Temp4 = Temp4 * 31
 Kole_roz_sh = Kole_roz_sh + Temp4

End If
Kole_roz_sh = Kole_roz_sh + Sh_day

'****************************
If Kole_roz_sh > 286 Then

   M_year = Sh_year + 622
   Kole_roz_m = Kole_roz_sh - 286

Else

   M_year = Sh_year + 621
   Kole_roz_m = Kole_roz_sh + 79

End If
'**************************

If M_kabise(m_year) = 0 Then
   Day_of_month(2) = 28
Else
   Day_of_month(2) = 29
End If


'----------------



For M_month = 1 To 12

   If Kole_roz_m < 31 Then Exit For
   Kole_roz_m = Kole_roz_m - Day_of_month(m_month)

Next


If Kole_roz_m > Day_of_month(m_month) Then

    Kole_roz_m = Kole_roz_m - Day_of_month(conter1)
    Incr M_month

End If

M_day = Kole_roz_m

Return

'*******************************************************************************
'******************************                                 ****************
'WWW.ISEEE.IR *****************          END OF PROGRAM         ****************
'******************************                                 ****************
'*******************************************************************************

End

'============================================================
'============================================================

Function M_kabise(byref Sal As Word)as Byte

   Local T1 As Integer
   Local T2 As Integer
   Local T3 As Integer
   Local B As Byte
   '=========================
   T1 = Sal Mod 4
   T2 = Sal Mod 100
   T3 = Sal Mod 400
   B = 0
   '=========================
   '------
   If T1 = 0 And T2 <> 0 Then
      B = 1
   End If
   '------
   If T2 = 0 And T3 = 0 Then
      B = 1
   End If
   '------
   M_kabise = B

End Function

'============================================================
'============================================================

Function Sh_kabise(byref Sal As Word)as Byte

   Local T1 As Integer
   Local B As Byte
   '==================
   T1 = Sal Mod 33
   B = 0
   '==================
   '------
   If T1 = 1 Or T1 = 5 Or T1 = 9 Or T1 = 13 Or T1 = 17 Or T1 = 22 Or _
   T1 = 26 Or T1 = 30 Then

      B = 1

   End If
   '------
   Sh_kabise = B

End Function


'WWW.ISEEE.IR
'YEAR 2012