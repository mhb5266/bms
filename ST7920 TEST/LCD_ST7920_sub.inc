$nocompile

'*******************************************************************************
'*  Init LCD for ST7920  Controller Serial-Mode                   24.02.15/rt  *
'*******************************************************************************
Sub Lcds_init(byval D_type As Byte)                         '1=Text / 2=Grafic

   Waitms 50
   Mybyte = &H30 : Lcds_command Mybyte
   Mybyte = &B01 : Lcds_command Mybyte : Waitms 2
   Mybyte = &H06 : Lcds_command Mybyte
   Mybyte = &H0C : Lcds_command Mybyte


   Select Case D_type
      Case 1
         Lcds_command &H30                                    'Set Text-Mode
         Waitms 1
      Case 2
         Lcds_command &B00110110                      'Set Graphic-Mode
   End Select
End Sub


'*******************************************************************************
'*  Clear Screen Command  1 = Text-Mode   2 = Grafic-Mode                      *
'*******************************************************************************
Sub Lcds_cls(byval D_type As Byte)
   Select Case D_type
      Case 1                                                'Clear in Text-Mode
         Lcds_command 1
                  waitms 2
          Lcds_command 2
      Case 2                                                'Clear in Grafic-Mode
   For Lcdx = &H80 To &B10001111
      For Lcdy = &H80 To &B10011111
         Lcds_command Lcdy
         Lcds_command Lcdx
         Lcds_data 0
         Lcds_data 0
      Next
   Next
   End Select
End Sub




'*******************************************************************************
'*  Anzeige Wert/String Zeile Y1 Position X1                                   *
'*******************************************************************************
Sub Lcds(byval Y1 As Byte , Byval X1 As Byte , Byval Text1 As String * 20)

 local t as byte
IF X1>0 THEN  DECR X1
 select case Y1
        case 1:    X1=X1 OR  &H80
        case 2:    X1=X1 OR  &H90
        case 3:    X1=X1 OR  &H88
        case 4:    X1=X1 OR  &H98
        case else:    X1=X1 OR  &H80
end select

   Lcds_command x1         'Set Cursor-Position

   For T = 1 To Len(text1)
      Lcds_data    Mid(text1 , T , 1)
   Next     t

End Sub

Sub Lcds_command(byval Ir As Byte)
   E = 0
   Rs = 0
   E = 1
   nop
   Outport = Ir
   nop
   E = 0
   Waitus 80
End Sub


Sub Lcds_data(byval Dr_en As Byte)
   E = 0
   Rs = 1
   E = 1
   nop
   Outport = Dr_en
   nop
   E = 0
   Waitus 80
End Sub

 Function Lcdget()as Byte
   E = 0
   Rs = 1
   Rw = 1
   E = 1
   'Ddrc = 0
   CONFIG outport =input
   Outport = 0
   nop
   Lcdget = Getport
   nop
   E = 0
   Rw = 0
   Waitus 80
  'Ddrc = &HFF
   CONFIG outport =output
End Function

'*******************************************************************************
' All Grafic-Routines (c) by Heiko Kipnik
'
'*******************************************************************************
' Show BASCOM Graphic Files (BGF)
' use the Graphic converter in Uncompressed Mode
' The Sub do not support RLE compression
' Set Xs=Start Xpoint  Ys=Start Ypoint
'*******************************************************************************
Sub Lcds_show_bgf(byval Xs As Byte , Byval Ys As Byte)
   Local Xz As Byte , Yz As Byte , Col As Byte
   Local Bnr As Byte , Xdum As Byte , Xend As Byte , Yend As Byte
   Read Yend                                                'Read Height
   Read Xend                                                'Read Width

   Yend = Yend + Ys                                         'Set end point
   Xend = Xend + Xs                                         'Set end point

   Decr Xend
   Decr Yend

   For Yz = Ys To Yend                                      'Ystart to Yend
     For Xz = Xs To Xend Step 8                             'Step 8 Pixel for one Byte
       Read Col                                             'Read BGF file 1Byte = 8 Pixel
       Xdum = Xz                                            'X Start Point
      For Bnr = 7 To 0 Step -1                              'MSB first Set 8Bit
       If Col.bnr = 0 Then                                  'Read pixel
        Call Lcds_set_pixel(xdum , Yz , White)              'Set Pixel
       Else
        Call Lcds_set_pixel(xdum , Yz , Black)               'Clear Pixel
       End If
       Incr Xdum                                            'Incr X pointer
      Next
     Next
   Next
End Sub

'*******************************************************************************
' Draw Box Xs-Ys to Xe-Ye fill=1 Fill -- Fill=0 no fill
' Color=1 Black Pixel  Color=0 White Pixel
'*******************************************************************************
Sub Lcds_box(byval Xs As Byte , Byval Ys As Byte , Byval Xe As Byte , Byval Ye As Byte , Byval Fill As Byte , Byval Color As Byte)
    Local Xza As Byte , Yza As Byte

  If Fill = 1 Then
   For Yza = Ys To Ye
    For Xza = Xs To Xe
      Call Lcds_set_pixel(xza , Yza , Color)
    Next
   Next
  Else
   Call Lcds_line(xs , Ys , Xe , Ys , 1 , Color)
   Call Lcds_line(xs , Ye , Xe , Ye , 1 , Color)

   Call Lcds_line(xs , Ys , Xs , Ye , 1 , Color)
   Call Lcds_line(xe , Ys , Xe , Ye , 1 , Color)
  End If
End Sub

'*******************************************************************************
' Set or Clear a Pixel to X-Y Position  Colo=1 Set Pixel  Colo=0 Clear Pixel
' and write Data to Display-Array
'*******************************************************************************
Sub Lcds_set_pixel(byval X As Byte , Byval Y As Byte , Byval color As Byte )
   ' (0,0)-(127,63)
   Xadrs = X \ 16
   Xpos = X Mod 16

   Yadrs = Y \ 32
   Yadrs = Yadrs * 8
   Xadrs = Xadrs + Yadrs

   Yadrs = Y Mod 32


   Xadrs = Xadrs + &H80
   Yadrs = Yadrs + &H80
   Lcds_command Yadrs
   Lcds_command Xadrs


   Byteh = Lcdget()
   Byteh = Lcdget()
   Bytel = Lcdget()

   If Xpos < 8 Then
      Xpos = 7 - Xpos
      Xpos = 2 ^ Xpos
      if color=black then
      Byteh = Byteh Or Xpos
      else
       Xpos=not Xpos
       Byteh = Byteh and Xpos
      end if
      Else
      Xpos = 15 - Xpos
      Xpos = 2 ^ Xpos
      if color=black then
       Bytel = Bytel Or Xpos
      else
       Xpos=not Xpos
         Bytel = Bytel and  Xpos
      end if
   End If


   Lcds_command Yadrs
   Lcds_command Xadrs


   Lcds_data Byteh
   Lcds_data Bytel
End Sub

'*******************************************************************************
'LCD_Text  String -- X -- Y Start -- Font
'*******************************************************************************
Sub Lcds_text(byval S As String , Xoffset As Byte , Yoffset As Byte , Fontset As Byte)
   Local Tempstring As String * 1 , Temp As Word
   Local Pixels As Byte , Count As Byte , Carcount As Byte
   Local Row As Byte , Block As Byte , Byteseach As Byte , Blocksize As Byte
   Local Colums As Byte , Columcount As Byte , Rowcount As Byte , Stringsize As Byte
   Local Xpos As Byte , Ypos As Byte , Pixel As Byte , Pixelcount As Byte
   Local Offset As Word

   Stringsize = Len(s) - 1                                  'Size of the text string -1 because we must start with 0
  Select Case Fontset
      Case 1 :
         Block = Lookup(0 , font6x8)                          'Add or remove here fontset's that you need or not,
         Byteseach = Lookup(1 ,font6x8 )
         Blocksize = Lookup(2 ,font6x8 )
         Pixel = Lookup(3 ,font6x8 )
      Case 2 :
         Block = Lookup(0 , font8x8)
         Byteseach = Lookup(1 ,font8x8 )
         Blocksize = Lookup(2 ,font8x8 )
         Pixel = Lookup(3 ,font8x8 )
      Case 3 :
         Block = Lookup(0 , Digital20x32)
         Byteseach = Lookup(1 , Digital20x32)
         Blocksize = Lookup(2 , Digital20x32)
         Pixel = Lookup(3 , Digital20x32)
      Case 4 :
         Block = Lookup(0 , font12x16dig_f)                          'Add or remove here fontset's that you need or not,
         Byteseach = Lookup(1 ,font12x16dig_f )
         Blocksize = Lookup(2 ,font12x16dig_f )
         Pixel = Lookup(3 ,font12x16dig_f )
      Case 5:
         Block = Lookup(0 , font16x16)
         Byteseach = Lookup(1 ,font16x16 )
         Blocksize = Lookup(2 ,font16x16 )
         Pixel = Lookup(3 ,font16x16 )
      Case 6:
         Block = Lookup(0 , digit_notifi_12x16)
         Byteseach = Lookup(1 , digit_notifi_12x16)
         Blocksize = Lookup(2 , digit_notifi_12x16)
         Pixel = Lookup(3 , digit_notifi_12x16)
   End Select
   Colums = Blocksize / Block                               'Calculate the numbers of colums
   Row = Block * 8                                          'Row is always 8 pixels high = 1 byte, so working with row in steps of 8.
   Row = Row - 1                                            'Want to start with row=0 instead of 1
   Colums = Colums - 1                                      'Same for the colums
   For Carcount = 0 To Stringsize                           'Loop for the numbers of caracters that must be displayed
      Temp = Carcount + 1                                   'Cut the text string in seperate caracters
      Tempstring = Mid(s , Temp , 1)
      Offset = Asc(tempstring) - 32                         'Font files start with caracter 32
      Offset = Offset * Blocksize
      Offset = Offset + 4
      Temp = Carcount * Byteseach
      Temp = Temp + Xoffset
      For Rowcount = 0 To Row Step 8                        'Loop for numbers of rows
         Xpos = Temp
         For Columcount = 0 To Colums                       'Loop for numbers of Colums
            Select Case Fontset
               Case 1 : Pixels = Lookup(offset , font6x8)
               Case 2 : Pixels = Lookup(offset , font8x8)
               Case 3 : Pixels = Lookup(offset , Digital20x32)
               Case 4 : Pixels = Lookup(offset , font12x16dig_f)
               Case 5 : Pixels = Lookup(offset , font16x16)
               Case 6 : Pixels = Lookup(offset ,digit_notifi_12x16 )
            End Select
            Ypos = Rowcount + Yoffset
            For Pixelcount = 0 To 7                         'Loop for 8 pixels to be set or not
               Pixel = Pixels.0                             'Set the pixel (or not)
               If Pixel = 0 Then

                  Call Lcds_set_pixel(xpos , Ypos , White)
               Else
                  Call Lcds_set_pixel(xpos , Ypos , Black)
               End If
               Shift Pixels , Right                         'Shift the byte 1 bit to the right so the next pixel comes availible
               Incr Ypos                                    'Each pixel on his own spot
            Next Pixelcount

            Incr Offset
            Incr Xpos                                       'Do some calculation to get the caracter on the correct Xposition
         Next Columcount
      Next Rowcount
   Next Carcount
End Sub



'*******************************************************************************
' Draw Fill Circle  X-Y Center - Radius - Color=1 set Pixel  Color=0 clear pixel
'*******************************************************************************
Sub Lcds_fill_circle(byval X As Byte , Byval Y As Byte , Byval Radius As Byte , Byval Color1 As Byte)
   Local Xy_radius As Integer , Zahly As Integer , Zahlx As Integer , Y1 As Integer , X1 As Integer
   Local Y11 As Integer , X11 As Integer , Xy As Integer , X2 As Byte , Y2 As Byte
   Xy_radius = Radius * Radius
   Y1 = -radius
   X1 = -radius

   For Zahly = Y1 To Radius
      Y11 = Zahly * Zahly
      For Zahlx = X1 To Radius
         X11 = Zahlx * Zahlx
         Xy = X11 + Y11
         If Xy <= Xy_radius Then
            X2 = X + Zahlx
            Y2 = Y + Zahly
            Call Lcds_set_pixel(x2 , Y2 , Color1)
         End If
      Next
   Next

End Sub
'*******************************************************************************
' Draw Circle  X-Y Center - Radius - Color=1 set Pixel  Color=0 clear pixel
'*******************************************************************************
Sub Lcds_circle(byval X As Byte , Byval Y As Byte , Byval Radius As Byte , Byval Color As Byte)
   Local X0 As Byte , Y0 As Byte , Error As Integer
   Local Xp As Byte , Yp As Byte , Xe As Byte , Ye As Byte

   Error = -radius
   Xp = Radius
   Yp = 0

   While Xp >= Yp
      X0 = X + Xp : Y0 = Y + Yp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X - Xp : Y0 = Y + Yp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X + Xp : Y0 = Y - Yp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X - Xp : Y0 = Y - Yp
      Call Lcds_set_pixel(x0 , Y0 , Color)

      X0 = X + Yp : Y0 = Y + Xp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X - Yp : Y0 = Y + Xp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X + Yp : Y0 = Y - Xp
      Call Lcds_set_pixel(x0 , Y0 , Color)
      X0 = X - Yp : Y0 = Y - Xp
      Call Lcds_set_pixel(x0 , Y0 , Color)

      Error = Error + Yp
      Incr Yp
      Error = Error + Yp

      If Error >= 0 Then
         Decr Xp
         Error = Error - Xp
         Error = Error - Xp
      End If

   Wend

End Sub
'*******************************************************************************
' Draw line X - Y Start to X - Y End - Pen Width - Color=1 set Pixel  Color=0 clear pixel
'*******************************************************************************
Sub Lcds_line(byval X1 As Byte , Byval Y1 As Byte , Byval X2 As Byte , Byval Y2 As Byte , Byval Pen_width As Byte , Byval Color As Byte)
   Local Y As Word , X As Word , X_diff As Single , Y_diff As Single , Pos As Word
   Local X_factor As Single , X_pos As Word , Y_pos As Word , Base As Word , Pen_count As Byte
   Local Xpoint As Byte , Ypoint As Byte
   Y_diff = Y2 - Y1
   X_diff = X2 - X1
   Pos = 0

   X_factor = Abs(y_diff)
   Y = X_factor
   X_factor = Abs(x_diff)
   X = X_factor

   If Y > X Then
      X_factor = X_diff / Y_diff
      If Y1 > Y2 Then
         Swap Y1 , Y2
         Base = X2
      Else
         Base = X1
      End If
      For Y = Y1 To Y2
         X_diff = Pos * X_factor
         X_pos = X_diff
         X_pos = X_pos + Base
         Xpoint = X_pos
         Ypoint = Y
         Call Lcds_set_pixel(xpoint , Ypoint , Color)
         For Pen_count = 1 To Pen_width
            Call Lcds_set_pixel(xpoint , Ypoint , Color)
            Incr Xpoint
         Next Pen_count
         Incr Pos
      Next Y
   Else
      X_factor = Y_diff / X_diff
      If X1 > X2 Then
         Swap X1 , X2
         Base = Y2
      Else
         Base = Y1
      End If
      For X = X1 To X2
         Y_diff = Pos * X_factor
         Y_pos = Y_diff
         Y_pos = Y_pos + Base
         Xpoint = X
         Ypoint = Y_pos
         Call Lcds_set_pixel(xpoint , Ypoint , Color)
         For Pen_count = 1 To Pen_width
            Call Lcds_set_pixel(xpoint , Ypoint , Color)
            Incr Ypoint
         Next Pen_count
         Incr Pos
      Next X
   End If

End Sub

'*******************************************************************************
Function Farsi(byval S As String * 20) As String * 20

       Local Bf_chr As String * 1 , Nx_chr As String * 1 , Cur_chr As String * 1
       Local Str_len As Byte , Index As Byte , I As Byte , Type_chr As Byte
       Farsi = ""

       Str_len = Len(s)
       For I = Str_len To 1 Step -1
         Bf_chr = ""
         Nx_chr = ""
         Cur_chr = ""

                  Index = I - 1
                  If Index = 0 Then
                  Bf_chr = " "
                  Else
                  Bf_chr = Mid(s , Index , 1)
                  End If
                  Index = I + 1
                  Nx_chr = Mid(s , Index , 1)
  '(
€€€ €
 ' ﬁ»· «“ «‰ Œ«» ‰Ê⁄ Õ—› ° Õ—› ﬁ»· —Ê çò „Ìò‰Ì„  « »œÊ‰„ ÌòÌ «“ «Ì‰ (« - ¬ - œ - – - — - “ - é - Ê - ›«’·Â)Õ—Ê› Â”  Ì« ‰Â »⁄œ ﬁ«’·Â çò „Ì‘Â „’· «Ì‰
3 - «ê— Õ—› ﬁ»· ÌòÌ «“ «Ì‰ ‰Â Õ—› »«‘œ »Â ‘—ÿÌ òÂ Õ—› »⁄œÌ ›«’·Â »«‘Â «“ ‰Ê⁄ çÂ«—„ Ì« «Œ—  ‰Â« Â” 
0 - «ê— Õ—› ﬁ»· ÌòÌ «“ «Ì‰ ‰Â Õ—› »«‘œ »Â ‘—ÿÌ òÂ Õ—› »⁄œÌ ›«’·Â ‰»«‘Â «“ ‰Ê⁄ «Ê· Ì« «Ê· ç”»«‰ Â” 
2 - «ê— Õ—› ﬁ»· ÌòÌ «“ «Ì‰ ‰Â Õ—› ‰»«‘œ »Â ‘—ÿÌ òÂ Õ—› »⁄œÌ ›«’·Â »«‘œ «“ ‰Ê⁄ ”Ê„ Ì« «Œ— ç”»«‰ Â” 
1 - «ê— Õ—› ﬁ»· ÌòÌ «“ «Ì‰ ‰Â Õ—› ‰»«‘œ »Â ‘—ÿÌ òÂ Õ—› »⁄œÌ ›«’·Â ‰»«‘œ «“ ‰Ê⁄ œÊ„ Ì« Ê”ÿ Â” 
')


            If Bf_chr = " " Or Bf_chr = "Ê" Or Bf_chr = "é" Or Bf_chr = "“" Or Bf_chr = "—" Or Bf_chr = "–" Or Bf_chr = "œ" Or Bf_chr = "¬" Or Bf_chr = "«" Then
                  If Nx_chr = " " Or Nx_chr = Chr(0) Then
                   Type_chr = 3
                   Else
                   Type_chr = 0
                  End If
            Else
                   If Nx_chr = " " Or Nx_chr = Chr(0) Then
                   Type_chr = 2
                   Else
                   Type_chr = 1
                  End If

            End If

            Cur_chr = Mid(s , I , 1)
         Select Case Cur_chr
         Case "«" :
                   Select Case Type_chr
                   'Case 1 : Cur_chr = Chr(173)
                   Case 1 :
                   If Bf_chr = "·" Then
                   Cur_chr = Chr(162)
                   Decr I
                   Else
                   Cur_chr = Chr(173)
                   End If
                   End Select
         Case "»" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(128)
                   End Select
         Case "Å" :                                         'pe
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(131)
                   End Select

         Case " " :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(132)
                   End Select
         Case "À" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(133)
                   End Select
         Case "Ã" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(134)
                   End Select

         Case "ç" :                                         'che
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(135)
                   End Select
         Case "Õ" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(136)
                   End Select
         Case "Œ" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(137)
                   End Select

         Case "”" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(138)
                   End Select
         Case "‘" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(139)
                   End Select

         Case "’" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(140)
                   End Select
         Case "÷" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(143)
                   End Select

         Case "⁄" :
                   Select Case Type_chr
                   Case 0 : Cur_chr = Chr(147)
                   Case 1 : Cur_chr = Chr(146)
                   Case 2 : Cur_chr = Chr(145)
                   End Select

         Case "€" :
                   Select Case Type_chr
                   Case 0 : Cur_chr = Chr(153)
                   Case 1 : Cur_chr = Chr(149)
                   Case 2 : Cur_chr = Chr(148)
                   End Select
         Case "›" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(157)
                   End Select
         Case "ﬁ" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(158)
                   End Select

         Case "ò" :                                         'kaf
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(160)
                   End Select



         Case "ê" :                                         'gaf
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(184)
                   End Select
         Case "·" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(163)
                   End Select

         Case "„" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(164)
                   End Select
         Case "‰" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(166)
                   End Select
         Case "Â" :
                   Select Case Type_chr
                   Case 0 : Cur_chr = Chr(170)
                   Case 1 : Cur_chr = Chr(167)
                   'Case 2 : Cur_chr = Chr(240)
                   End Select
         Case "Ì" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(168)
                   Case 2 : Cur_chr = Chr(172)
                   End Select
         Case "∆" :
                   Select Case Type_chr
                   Case 0 To 1 : Cur_chr = Chr(185)
                  ' Case 2 : Cur_chr = Chr(172)
                   End Select



         Case "0" : Cur_chr = Chr(174)
         Case "1" : Cur_chr = Chr(175)
         Case "2" : Cur_chr = Chr(176)
         Case "3" : Cur_chr = Chr(177)
         Case "4" : Cur_chr = Chr(178)
         Case "5" : Cur_chr = Chr(179)
         Case "6" : Cur_chr = Chr(180)
         Case "7" : Cur_chr = Chr(181)
         Case "8" : Cur_chr = Chr(182)
         Case "9" : Cur_chr = Chr(183)

         End Select
         Farsi = Farsi + Cur_chr
        Next


      End Function