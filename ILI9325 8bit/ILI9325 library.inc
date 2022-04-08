'
'                          ILI9325 LCD 8-bit Library
'                      (Based on Mr.Hkipnik's sources)
'                            Resolution: 240x320
'
'                                  MrShilov
'                            Sankt-Peterburg , Russia
'                                    2014
'*******************************************************************************
$nocompile


Dim Color_h_ili9325 As Byte
Dim Color_l_ili9325 As Byte

Dim Temp_string_ili9325 As String * 32 , Temp_s_overlay(32) As Byte At Temp_string_ili9325 Overlay
Dim Digit_font As Bit

Dim Label_point_ili9325 As Word , Fontset_ili9325 As Word

Dim Rgb16_ili9325 As Word
Dim Rgb16_ili9325_low As Byte At Rgb16_ili9325 Overlay
Dim Rgb16_ili9325_high As Byte At Rgb16_ili9325 + 1 Overlay

Dim Rgb16_ili9325d As Word
Dim Rgb16_ili9325d_low As Byte At Rgb16_ili9325d Overlay
Dim Rgb16_ili9325d_high As Byte At Rgb16_ili9325d + 1 Overlay

Dim Temp_x_ili9325 As Word
Dim Temp_x_ili9325_l As Byte At Temp_x_ili9325 Overlay
Dim Temp_x_ili9325_h As Byte At Temp_x_ili9325 + 1 Overlay

Dim Temp_y_ili9325 As Word
Dim Temp_y_ili9325_l As Byte At Temp_y_ili9325 Overlay
Dim Temp_y_ili9325_h As Byte At Temp_y_ili9325 + 1 Overlay

Dim Spi_address_ili9325 As Dword
Dim Spi_address_ili9325_1 As Byte At Spi_address_ili9325 Overlay
Dim Spi_address_ili9325_2 As Byte At Spi_address_ili9325 + 1 Overlay
Dim Spi_address_ili9325_3 As Byte At Spi_address_ili9325 + 2 Overlay

Macro Send_data
   Rs_disp = 1 : Wr_disp = 0 : Wr_disp = 1
End Macro

Macro Send_com
   Rs_disp = 0 : Wr_disp = 0 : Wr_disp = 1
End Macro

Macro Send
   Wr_disp = 0 : Wr_disp = 1
End Macro

'-------------------------------------------------------------------------------
' Init display
'-------------------------------------------------------------------------------
Sub Display_init
Res_disp = 0 : Waitms 5 : Res_disp = 1                      'Hardware Reset
#if Portrait = 0
   Ili9325_write_reg 1 , &H0100                             'Shift direction
   Ili9325_write_reg 3 , &H1030                             'Entry Mode
#else
   Ili9325_write_reg 1 , &H0000                             'Shift direction
   Ili9325_write_reg 3 , &H1038                             'Entry Mode
#endif
Ili9325_write_reg 2 , &H0200                                'Line inversion for noflicker
Ili9325_write_reg 16 , &H1690                               'Power Control 1
Ili9325_write_reg 17 , &H0227                               'Power Control 2
Waitms 25
Ili9325_write_reg 18 , &H000D                               'Power Control 3
Waitms 5
Ili9325_write_reg 43 , &H000D                               'Frame Rate and Color Control
Ili9325_write_reg 96 , &H2700
Ili9325_write_reg 97 , &H0001                               'Base Image Display Control
Ili9325_write_reg 7 , &H0133                                'Display Control 1
End Sub


'-------------------------------------------------------------------------------
' Ili9325_write_reg       Write 16 Bit Data to Index Register
'-------------------------------------------------------------------------------
Sub Ili9325_write_reg(byval Index As Byte , Byval Data_16 As Word)
   Rgb16_ili9325d = Data_16
   Data_disp = Index : Send_com
   Data_disp = Rgb16_ili9325d_high : Send_data
   Data_disp = Rgb16_ili9325d_low : Send
End Sub

'-------------------------------------------------------------------------------
' Write data 16 bit
'-------------------------------------------------------------------------------
Sub Write_data(byval Data_16 As Word)
   Rgb16_ili9325d = Data_16
   Data_disp = Rgb16_ili9325d_high : Send_data
   Data_disp = Rgb16_ili9325d_low : Send
End Sub


'-------------------------------------------------------------------------------
' Reset window to full screen
'-------------------------------------------------------------------------------
Sub Reset_window
    Data_disp = 80 : Send_com
    Data_disp = 0 : Send_data : Send
    Data_disp = 81 : Send_com
    Data_disp = 0 : Send_data
    Data_disp = 239 : Send
    Data_disp = 82 : Send_com
    Data_disp = 0 : Send_data : Send
    Data_disp = 83 : Send_com
    Data_disp = 1 : Send_data
    Data_disp = 63 : Send
    Data_disp = 32 : Send_com
    Data_disp = 0 : Send_data : Send
    Data_disp = 33 : Send_com
    Data_disp = 0 : Send_data : Send
End Sub


'-------------------------------------------------------------------------------
' Clear LCD with color
'-------------------------------------------------------------------------------
Sub Lcd_clear(byval Color As Word)
   Local A As Byte , B As Byte
   Color_h_ili9325 = High(color) : Color_l_ili9325 = Low(color)
   Reset_window                                             'Set full screen
   Data_disp = &H22 : Send_com                              'Write Data to GRAM
   Rs_disp = 1
   If Color_h_ili9325 = Color_l_ili9325 Then                'SpeedUp for Black, White ect colors
       Data_disp = Color_h_ili9325
       For A = 0 To 59
          For B = 0 To 79
             Send 
             Send
             Send : Send : Send : Send : Send : Send
             Send : Send : Send : Send : Send : Send : Send : Send
             Send : Send : Send : Send : Send : Send : Send : Send
             Send : Send : Send : Send : Send : Send : Send : Send
          Next B
       Next A
   Else
       For A = 0 To 119
          For B = 0 To 79
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
             Data_disp = Color_h_ili9325 : Send             'High(color)
             Data_disp = Color_l_ili9325 : Send             'Low(color)
          Next B
       Next A
   End If
End Sub



'-------------------------------------------------------------------------------
' Negative   0 -> negative  1 -> normal
'-------------------------------------------------------------------------------
Sub Lcd_negative(byval Negative As Byte )
Color_l_ili9325 = 1 - Negative.0
Data_disp = 97 : Send_com
Data_disp = 0 : Send_data
Data_disp = Color_l_ili9325 : Send
End Sub



'-------------------------------------------------------------------------------
' Text         before Call Sub you must Restore the Font
'             otherwise it will use previously restored Font
'-------------------------------------------------------------------------------
Sub Lcd_text(byval S As String , Byval Xoffset As Word , Byval Yoffset As Word , Byval Forecolor As Word , Byval Backcolor As Word)
    Local A As Word , Pixels As Byte , Count As Byte , Carcount As Byte , Temp As Word
    Local Row As Byte , Block As Byte , Byteseach As Byte , Blocksize As Byte
    Local Colums As Byte , Columcount As Byte , Rowcount As Byte , Stringsize As Byte
    Local Pixelcount As Byte , Offset As Word , Y As Word
   Reset_window
   Rgb16_ili9325 = Forecolor : Rgb16_ili9325d = Backcolor
   Stringsize = Len(s) - 1                                  'Size of the text string -1 because we must start with 0
   !sts {Fontset_ILI9325} , _DPTRL                          'Save Font Label
   !sts {Fontset_ILI9325+1} , _DPTRH
   Read Block
   Read Byteseach
   Read Blocksize
   Colums = Blocksize / Block                               'Calculate the numbers of columns
   Row = Block * 8                                          'Row is always 8 pixels high = 1 byte, so working with row in steps of 8.
   Row = Row - 1                                            'Want to start with row=0 instead of 1
   Colums = Colums - 1                                      'Same for the colums
   Temp_string_ili9325 = S
   For Carcount = 0 To Stringsize                           'Loop for the numbers of characters that must be displayed
      Offset = Temp_s_overlay(carcount + 1) - 32            'Font files start with character 32
      If Digit_font = 1 And Offset > 14 Then Offset = Offset - 15       'For reduced Digit Font
      Offset = Offset * Blocksize
      Offset = Offset + 4
      Label_point_ili9325 = Fontset_ili9325 + Offset        'Point to Character
      !Lds _DPTRL , {Label_point_ILI9325}
      !Lds _DPTRH , {Label_point_ILI9325+1}
      Temp = Carcount * Byteseach
      Temp = Temp + Xoffset
      For Rowcount = 0 To Row Step 8                        'Loop for numbers of rows
          A = Rowcount + Yoffset
          Temp_x_ili9325 = Temp
          For Columcount = 0 To Colums                      'Loop for numbers of Columns
             Read Pixels
             Temp_y_ili9325 = A
             #if Portrait = 0
               Data_disp = &H20
             #else
               Data_disp = &H21
             #endif
             Send_com                                       '------ Y
             Data_disp = Temp_y_ili9325_h : Send_data
             Data_disp = Temp_y_ili9325_l : Send
             #if Portrait = 0
               Data_disp = &H21
             #else
               Data_disp = &H20
             #endif
             Send_com                                       '------ X
             Data_disp = Temp_x_ili9325_h : Send_data
             Data_disp = Temp_x_ili9325_l : Send
             Data_disp = &H22 : Send_com
             Rs_disp = 1
             For Pixelcount = 0 To 7                        'Loop for 8 pixels to be set or not
                If Pixels.pixelcount = 1 Then
                   Data_disp = Rgb16_ili9325_high : Send    'VH
                   Data_disp = Rgb16_ili9325_low : Send     'VL
                Else
                   Data_disp = Rgb16_ili9325d_high : Send   'VH
                   Data_disp = Rgb16_ili9325d_low : Send    'VL
                End If
             Next Pixelcount
             Temp_y_ili9325 = Temp_y_ili9325 + 8            'Increment Y position
             Incr Temp_x_ili9325                            'Do some calculation to get the character on the correct Xposition
          Next Columcount
      Next Rowcount
   Next Carcount
   !Lds _DPTRL , {Fontset_ILI9325}                          'Restore Font Label
   !Lds _DPTRH , {Fontset_ILI9325+1}
End Sub



'-------------------------------------------------------------------------------
' Color Font Text          before Call Sub you must Restore the Font
'                        otherwise it will use previously restored Font
'-------------------------------------------------------------------------------
Sub Lcd_text_color(byval S As String , Byval Xoffset As Word , Byval Yoffset As Word , Byval Forecolor As Word , Byval Backcolor As Word)
Local A As Word , Pixels As Byte , Carcount As Word , Temp As Word
Local Row As Byte , Block As Byte , Byteseach As Byte , Blocksize As Byte
Local Colums As Word , Columcount As Word , Rowcount As Byte , Stringsize As Byte
Local Pixelcount As Byte , Offset As Word , Temp1 As Word
   Reset_window
   Stringsize = Len(s) - 1                                  'Size of the text string -1 because we must start with 0
   !sts {Fontset_ILI9325} , _DPTRL                          'Save Font Label
   !sts {Fontset_ILI9325+1} , _DPTRH
   Read Block
   Read Byteseach
   Read Blocksize
   Colums = Byteseach / 8 : Colums = Colums - 1             'Numbers of Columns
   Row = Block * 8 : Temp1 = Row : Row = Row - 1            'Number of Rows
   #if Portrait = 0
      Ili9325_write_reg 3 , &H1038                          'Change X/Y order
   #else
      Ili9325_write_reg 3 , &H1030
   #endif
   Temp_string_ili9325 = S
   Rgb16_ili9325 = Forecolor : Rgb16_ili9325d = Backcolor
   For Carcount = 0 To Stringsize                           'Loop for the numbers of characters that must be displayed
      Offset = Temp_s_overlay(carcount + 1) - 32            'Font files start with character 32
      If Digit_font = 1 And Offset > 14 Then Offset = Offset - 15       'For reduced Digit Font
      Offset = Offset * Blocksize
      Offset = Offset + 4
      Label_point_ili9325 = Fontset_ili9325 + Offset        'Point to Character
      !Lds _DPTRL , {Label_point_ILI9325}
      !Lds _DPTRH , {Label_point_ILI9325+1}
      Temp = Temp1 * Carcount
      Temp = Temp + Xoffset
      Temp_x_ili9325 = Temp
      Temp_y_ili9325 = Yoffset
      For Rowcount = 0 To Row                               'Loop for numbers of rows
         #if Portrait = 0
             Data_disp = &H20                               '------ Y
         #else
             Data_disp = &H21
         #endif
         Send_com
         Data_disp = Temp_y_ili9325_h : Send_data
         Data_disp = Temp_y_ili9325_l : Send
         #if Portrait = 0
             Data_disp = &H21                               '------ X
         #else
             Data_disp = &H20
         #endif
         Send_com
         Data_disp = Temp_x_ili9325_h : Send_data
         Data_disp = Temp_x_ili9325_l : Send
         Data_disp = &H22 : Send_com
         Rs_disp = 1
         For Columcount = 0 To Colums                       'Loop for numbers of Columns
            Read Pixels
            For Pixelcount = 0 To 7                         'Loop for 8 pixels to be set or not
               If Pixels.pixelcount = 1 Then
                  Data_disp = Rgb16_ili9325_high : Send     'VH
                  Data_disp = Rgb16_ili9325_low : Send      'VL
               Else
                  Data_disp = Rgb16_ili9325d_high : Send    'VH
                  Data_disp = Rgb16_ili9325d_low : Send     'VL
               End If
            Next Pixelcount
         Next Columcount
         Incr Temp_y_ili9325                                'Increment Y position
      Next Rowcount
   Next Carcount
   !Lds _DPTRL , {Fontset_ILI9325}                          'Restore Font Label
   !Lds _DPTRH , {Fontset_ILI9325+1}
#if Portrait = 0
   Ili9325_write_reg 3 , &H1030                             'Normal X/Y order
#else
   Ili9325_write_reg 3 , &H1038
#endif
End Sub


'-------------------------------------------------------------------------------
' Set Pixel
'-------------------------------------------------------------------------------
Sub Lcd_set_pixel(byval X1 As Word , Byval Y1 As Word , Byval Color As Word)
Rgb16_ili9325 = Color : Temp_x_ili9325 = X1 : Temp_y_ili9325 = Y1
#if Portrait = 0
   Data_disp = &H20                                         '------ Y
#else
   Data_disp = &H21
#endif
Send_com                                                    '------------ Y
Data_disp = Temp_y_ili9325_h : Send_data
Data_disp = Temp_y_ili9325_l : Send
#if Portrait = 0
   Data_disp = &H21                                         '------ X
#else
   Data_disp = &H20
#endif
Send_com                                                    '------------ X
Data_disp = Temp_x_ili9325_h : Send_data
Data_disp = Temp_x_ili9325_l : Send
Data_disp = &H22 : Send_com                                 '------------ Data
Data_disp = Rgb16_ili9325_high : Send_data
Data_disp = Rgb16_ili9325_low : Send
End Sub


'-------------------------------------------------------------------------------
' Draw Line   left-top (x1,y1) right-bottom(x2,y2),
'-------------------------------------------------------------------------------
Sub Lcd_line(byval X1 As Word , Byval Y1 As Word , Byval X2 As Word , Byval Y2 As Word , Byval Color As Word)
Local Y As Word , X As Word , X_diff As Single , Y_diff As Single , Pos As Word
Local X_factor As Single , X_pos As Word , Y_pos As Word , Base As Word
Reset_window
Y_diff = Y2 - Y1 : X_diff = X2 - X1 : Pos = 0
X_factor = Abs(y_diff) : Y = X_factor
X_factor = Abs(x_diff) : X = X_factor
Rgb16_ili9325 = Color
If Y > X Then
   X_factor = X_diff / Y_diff
   If Y1 > Y2 Then
      Swap Y1 , Y2 : Base = X2
   Else
      Base = X1
   End If
   For Temp_y_ili9325 = Y1 To Y2
      X_diff = Pos * X_factor
      Temp_x_ili9325 = X_diff + Base
      #if Portrait = 0
         Data_disp = &H20                                   '------ Y
      #else
         Data_disp = &H21
      #endif
      Send_com
      Data_disp = Temp_y_ili9325_h : Send_data
      Data_disp = Temp_y_ili9325_l : Send
      #if Portrait = 0
         Data_disp = &H21                                   '------ X
      #else
         Data_disp = &H20
      #endif
      Send_com
      Data_disp = Temp_x_ili9325_h : Send_data
      Data_disp = Temp_x_ili9325_l : Send
      Data_disp = &H22 : Send_com                           '--------- Data
      Data_disp = Rgb16_ili9325_high : Send_data
      Data_disp = Rgb16_ili9325_low : Send
      Incr Pos
   Next Temp_y_ili9325
Else
   X_factor = Y_diff / X_diff
   If X1 > X2 Then
      Swap X1 , X2 : Base = Y2
   Else
      Base = Y1
   End If
   For Temp_x_ili9325 = X1 To X2
      Y_diff = Pos * X_factor
      Temp_y_ili9325 = Y_diff + Base
      #if Portrait = 0
         Data_disp = &H20                                   '------ Y
      #else
         Data_disp = &H21
      #endif
      Send_com
      Data_disp = Temp_y_ili9325_h : Send_data
      Data_disp = Temp_y_ili9325_l : Send
      #if Portrait = 0
         Data_disp = &H21                                   '------ X
      #else
         Data_disp = &H20
      #endif
      Send_com
      Data_disp = Temp_x_ili9325_h : Send_data
      Data_disp = Temp_x_ili9325_l : Send
      Data_disp = &H22 : Send_com                           '--------- Data
      Data_disp = Rgb16_ili9325_high : Send_data
      Data_disp = Rgb16_ili9325_low : Send
      Incr Pos
   Next Temp_x_ili9325
End If
End Sub



'-------------------------------------------------------------------------------
'Fill Circle
'-------------------------------------------------------------------------------
Sub Lcd_fill_circle(byval X As Word , Byval Y As Word , Byval Radius As Word , Byval Color As Word)
Local Count_y As Integer , Count_x As Integer
Local Y1 As Integer , X1 As Integer , Xy_radius As Integer
Local Y11 As Integer , X11 As Integer , Xy As Integer
Reset_window
Rgb16_ili9325 = Color : Xy_radius = Radius * Radius : Y1 = -radius : X1 = -radius
For Count_y = Y1 To Radius
   Y11 = Count_y * Count_y
   Temp_y_ili9325 = Y + Count_y
   For Count_x = X1 To Radius
      X11 = Count_x * Count_x
      Xy = X11 + Y11
      If Xy <= Xy_radius Then
         Temp_x_ili9325 = X + Count_x
         #if Portrait = 0
            Data_disp = &H20                                '------ Y
         #else
            Data_disp = &H21
         #endif
         Send_com
         Data_disp = Temp_y_ili9325_h : Send_data
         Data_disp = Temp_y_ili9325_l : Send
         #if Portrait = 0
            Data_disp = &H21                                '------ X
         #else
            Data_disp = &H20
         #endif
         Send_com
         Data_disp = Temp_x_ili9325_h : Send_data
         Data_disp = Temp_x_ili9325_l : Send
         Data_disp = &H22 : Send_com                        '--------- Data
         Data_disp = Rgb16_ili9325_high : Send_data
         Data_disp = Rgb16_ili9325_low : Send
      End If
   Next Count_x
Next Count_y
End Sub


'-------------------------------------------------------------------------------
' Circle
'-------------------------------------------------------------------------------
Sub Lcd_circle(byval X As Word , Byval Y As Word , Byval Radius As Word , Byval Color As Word)
Local Count_y As Integer , Count_x As Integer
Local Y1 As Integer , X1 As Integer , Xy As Integer , Xy_radius As Integer
Reset_window
Rgb16_ili9325 = Color : Xy_radius = Radius * Radius
For Count_y = 0 To Radius
   Y1 = Count_y * Count_y
   For Count_x = Radius To 0 Step -1
       X1 = Count_x * Count_x
       Xy = X1 + Y1
       If Xy <= Xy_radius Then
          Temp_y_ili9325 = Y - Count_x : Temp_x_ili9325 = X + Count_y : Gosub Set_point
          Temp_y_ili9325 = Y + Count_x : Gosub Set_point
          Temp_y_ili9325 = Y - Count_x : Temp_x_ili9325 = X - Count_y : Gosub Set_point
          Temp_y_ili9325 = Y + Count_x : Gosub Set_point
          Temp_y_ili9325 = Y - Count_y : Temp_x_ili9325 = X + Count_x : Gosub Set_point
          Temp_y_ili9325 = Y + Count_y : Gosub Set_point
          Temp_y_ili9325 = Y - Count_y : Temp_x_ili9325 = X - Count_x : Gosub Set_point
          Temp_y_ili9325 = Y + Count_y : Gosub Set_point
          Exit For
       End If
   Next Count_x
Next Count_y
Goto End_sub_circle
Set_point:
   #if Portrait = 0
      Data_disp = &H20                                      '------ Y
   #else
      Data_disp = &H21
   #endif
   Send_com
   Data_disp = Temp_y_ili9325_h : Send_data
   Data_disp = Temp_y_ili9325_l : Send
   #if Portrait = 0
      Data_disp = &H21                                      '------ X
   #else
      Data_disp = &H20
   #endif
   Send_com
   Data_disp = Temp_x_ili9325_h : Send_data
   Data_disp = Temp_x_ili9325_l : Send
   Data_disp = &H22 : Send_com                              '--------- Data
   Data_disp = Rgb16_ili9325_high : Send_data
   Data_disp = Rgb16_ili9325_low : Send
Return
End_sub_circle:
End Sub


'-------------------------------------------------------------------------------
' Filled Box
'-------------------------------------------------------------------------------
Sub Lcd_fill_box(byval X1 As Word , Byval Y1 As Word , Byval X2 As Word , Byval Y2 As Word , Byval Color As Word)
Local Y_count As Word , X_count As Word
#if Portrait > 0
   Swap X1 , Y1
   Swap X2 , Y2
#endif
If X1 > X2 Then Swap X1 , X2 : If Y1 > Y2 Then Swap Y1 , Y2
Temp_x_ili9325 = X2 - X1 : Temp_y_ili9325 = Y2 - Y1
Decr X2 : Decr Y2
   Ili9325_write_reg 80 , Y1                                'Y start
   Ili9325_write_reg 81 , Y2                                'Y end
   Ili9325_write_reg 82 , X1                                'X start
   Ili9325_write_reg 83 , X2                                'X end
   Ili9325_write_reg 32 , Y1
   Ili9325_write_reg 33 , X1
Rgb16_ili9325 = Color
Data_disp = &H22 : Send_com : Rs_disp = 1                   'Data
   For X_count = 0 To Temp_x_ili9325
      For Y_count = 0 To Temp_y_ili9325
         Data_disp = Rgb16_ili9325_high : Send              'VH
         Data_disp = Rgb16_ili9325_low : Send               'VL
      Next Y_count
   Next X_count
End Sub


'-------------------------------------------------------------------------------
' Box
'-------------------------------------------------------------------------------
Sub Lcd_box(byval X1 As Word , Byval Y1 As Word , Byval X2 As Word , Byval Y2 As Word , Byval Color As Word)
Local Count As Word
#if Portrait > 0
   Swap X1 , Y1
   Swap X2 , Y2
#endif
If X1 > X2 Then Swap X1 , X2
If Y1 > Y2 Then Swap Y1 , Y2
Rgb16_ili9325 = Color
   Ili9325_write_reg 80 , Y1                                'Y start
   Ili9325_write_reg 81 , Y1                                'Y end
   Ili9325_write_reg 82 , X1                                'X start
   Ili9325_write_reg 83 , X2                                'X end
   Ili9325_write_reg 32 , Y1
   Ili9325_write_reg 33 , X1
Data_disp = &H22 : Send_com : Rs_disp = 1
   For Count = X1 To X2
      Data_disp = Rgb16_ili9325_high : Send                 'VH
      Data_disp = Rgb16_ili9325_low : Send                  'VL
   Next Count
   Ili9325_write_reg 80 , Y2                                'Y start
   Ili9325_write_reg 81 , Y2                                'Y end
   Ili9325_write_reg 32 , Y2
   Ili9325_write_reg 33 , X1
Data_disp = &H22 : Send_com : Rs_disp = 1
   For Count = X1 To X2
      Data_disp = Rgb16_ili9325_high : Send                 'VH
      Data_disp = Rgb16_ili9325_low : Send                  'VL
   Next Count
   Ili9325_write_reg 80 , Y1                                'Y start
   Ili9325_write_reg 81 , Y2                                'Y end
   Ili9325_write_reg 82 , X1                                'X start
   Ili9325_write_reg 83 , X1                                'X end
   Ili9325_write_reg 32 , Y1
   Ili9325_write_reg 33 , X1
Data_disp = &H22 : Send_com : Rs_disp = 1
   For Count = Y1 To Y2
      Data_disp = Rgb16_ili9325_high : Send                 'VH
      Data_disp = Rgb16_ili9325_low : Send                  'VL
   Next Count
   Ili9325_write_reg 82 , X2                                'X start
   Ili9325_write_reg 83 , X2                                'X end
   Ili9325_write_reg 32 , Y1                                'Y2
   Ili9325_write_reg 33 , X2
Data_disp = &H22 : Send_com : Rs_disp = 1
   For Count = Y1 To Y2
      Data_disp = Rgb16_ili9325_high : Send                 'VH
      Data_disp = Rgb16_ili9325_low : Send                  'VL
   Next Count
End Sub


'-------------------------------------------------------------------------------
' Draw 16-bit Picture from SRAM Bin file     X start - Y start - Width - Height
'               before Call Sub you must Restore the Label
'-------------------------------------------------------------------------------
Sub Lcd_pic_sram(byval Xs As Word , Byval Ys As Word , Byval Width As Word , Byval Height As Word)
Local Count As Dword , Length As Dword
#if Portrait = 0
   Ili9325_write_reg 3 , 4152                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4144
   Swap Xs , Ys
   Swap Width , Height
#endif
Length = Width * Height
Temp_x_ili9325 = Width + Xs : Temp_y_ili9325 = Height + Ys
Decr Temp_x_ili9325 : Decr Temp_y_ili9325
   Ili9325_write_reg 80 , Ys                                'Y start
   Ili9325_write_reg 81 , Temp_y_ili9325                    'Y end
   Ili9325_write_reg 82 , Xs                                'X start
   Ili9325_write_reg 83 , Temp_x_ili9325                    'X end
   Ili9325_write_reg 32 , Ys
   Ili9325_write_reg 33 , Xs
Data_disp = &H22 : Send_com : Rs_disp = 1                   'Data
   For Count = 1 To Length
      Read Color_h_ili9325 : Data_disp = Color_h_ili9325 : Send
      Read Color_h_ili9325 : Data_disp = Color_h_ili9325 : Send
   Next Count
#if Portrait = 0
   Ili9325_write_reg 3 , 4144                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4152
#endif
End Sub

'-------------------------------------------------------------------------------
' Draw BGC Picture              X Start -  Y Start
'                before Call Sub you must Restore the Label
'-------------------------------------------------------------------------------
Sub Lcd_pic_bgc(byval Xoffset As Word , Byval Yoffset As Word)
Local Ysize As Byte , Xsize As Byte , Imagesize As Word
Local L As Word , Pixel As Byte , Repeat As Byte
Read Ysize : Read Xsize : Read Imagesize                    'Read the first 4 bytes from the BGC, this contains info about the image
#if Portrait = 0
   Ili9325_write_reg 3 , 4152                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4144
   Swap Xoffset , Yoffset
   Swap Xsize , Ysize
#endif
Temp_y_ili9325 = Yoffset + Ysize : Decr Temp_y_ili9325
Temp_x_ili9325 = Xoffset + Xsize : Decr Temp_x_ili9325
Ili9325_write_reg 80 , Yoffset                              'Y start
Ili9325_write_reg 81 , Temp_y_ili9325                       'Y end
Ili9325_write_reg 82 , Xoffset                              'X start
Ili9325_write_reg 83 , Temp_x_ili9325                       'X end
Ili9325_write_reg 32 , Yoffset
Ili9325_write_reg 33 , Xoffset
Data_disp = &H22 : Send_com : Rs_disp = 1                   'Data
Do
Read Pixel                                                  'Read the value for the pixel
   If Pixel = &HAA Then                                     'BGC file is rle coded &HAA represents this, the byte after &HAA is the number of times that the byte before &HAA wil be repeated
      Read Repeat                                           'Byte after &HAA contains the number of times to repeat
      Repeat = Repeat - 1
      For L = 1 To Repeat                                   'Loop the repeat
          Data_disp = Rgb16_ili9325_high : Send             'Write the pixel data to the display
          Data_disp = Rgb16_ili9325_low : Send
      Next L                                                'Next repeat loop
      Imagesize = Imagesize - Repeat                        'Decrease the bytes still to be processed
   Else                                                     'It's a regular byte, not LRE encoded
      Gosub Color_convert
      Data_disp = Rgb16_ili9325_high : Send                 'Write the pixel data to the display
      Data_disp = Rgb16_ili9325_low : Send
      Decr Imagesize                                        'Decrease the bytes still to be processed
   End If
Loop Until Imagesize = 0                                    'Do until all bytes are processed
#if Portrait = 0
   Ili9325_write_reg 3 , 4144                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4152
#endif
Goto End_bgc
'-------------------------------------------------------------------------------
'Convert the 8bit RRRGGGBB bgc data to 16 bit RRRRRGGGGGGBBBBB
'-------------------------------------------------------------------------------
Color_convert:
Rgb16_ili9325 = 0
If Pixel.0 = 1 Then Rgb16_ili9325_low = Rgb16_ili9325_low Or 10       'Blue
If Pixel.1 = 1 Then Rgb16_ili9325_low = Rgb16_ili9325_low Or 21
If Pixel.2 = 1 Then Rgb16_ili9325 = Rgb16_ili9325 Or 288    'Green
If Pixel.3 = 1 Then Rgb16_ili9325 = Rgb16_ili9325 Or 576
If Pixel.4 = 1 Then Rgb16_ili9325 = Rgb16_ili9325 Or 1152
If Pixel.5 = 1 Then Rgb16_ili9325_high = Rgb16_ili9325_high Or 32       'Red
If Pixel.6 = 1 Then Rgb16_ili9325_high = Rgb16_ili9325_high Or 72
If Pixel.7 = 1 Then Rgb16_ili9325_high = Rgb16_ili9325_high Or 144
Return
End_bgc:
End Sub


'-------------------------------------------------------------------------------
' Draw 16-bit Picture from SPI-ROM
'                X start - Y start - Width - Height - Address
'-------------------------------------------------------------------------------
Sub Lcd_pic_spi(byval Xs As Word , Byval Ys As Word , Byval Width As Word , Byval Height As Word , Byval Address As Dword)
Local Count_x As Word , Count_y As Word
#if Portrait = 0
   Ili9325_write_reg 3 , 4152                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4144
   Swap Xs , Ys
   Swap Width , Height
#endif
Temp_x_ili9325 = Xs + Width : Temp_y_ili9325 = Ys + Height
Decr Temp_y_ili9325 : Decr Temp_x_ili9325
Ili9325_write_reg 80 , Ys                                   'Y start
Ili9325_write_reg 81 , Temp_y_ili9325                       'Y end
Ili9325_write_reg 82 , Xs                                   'X start
Ili9325_write_reg 83 , Temp_x_ili9325                       'X end
Ili9325_write_reg 32 , Ys
Ili9325_write_reg 33 , Xs
Ss_spi_rom = 0                                              'Select SPI-ROM
Data_disp = &H22 : Send_com : Rs_disp = 1                   'Data
Spi_address_ili9325 = Address : Temp_x_ili9325_l = 3
Spiout Temp_x_ili9325_l , 1 : Spiout Spi_address_ili9325_3 , 1       'Start reading
Spiout Spi_address_ili9325_2 , 1 : Spiout Spi_address_ili9325_1 , 1
For Count_y = 1 To Height
   For Count_x = 1 To Width
      Spiin Temp_x_ili9325 , 2                              'Read 2 bytes from ROM
      Data_disp = Temp_x_ili9325_l : Send                   'White to display
      Data_disp = Temp_x_ili9325_h : Send
   Next Count_x
Next Count_y
Ss_spi_rom = 1                                              'deselect SPI-ROM
#if Portrait = 0
   Ili9325_write_reg 3 , 4144                               'Change X/Y order
#else
   Ili9325_write_reg 3 , 4152
#endif
End Sub

'------------------------------ Colors -----------------------------------------
Const Aliceblue = &HF7DF
Const Antiquewhite = &HFF5A
Const Aqua = &H07FF
Const Aquamarine = &H7FFA
Const Azure = &HF7FF
Const Beige = &HF7BB
Const Bisque = &HFF38
Const Black = &H0000
Const Blanchedalmond = &HFF59
Const Blue = &H001F
Const Blueviolet = &H895C
Const Brown = &HA145
Const Burlywood = &HDDD0
Const Cadetblue = &H5CF4
Const Chartreuse = &H7FE0
Const Chocolate = &HD343
Const Coral = &HFBEA
Const Cornflowerblue = &H64BD
Const Cornsilk = &HFFDB
Const Crimson = &HD8A7
Const Cyan = &H07FF
Const Darkblue = &H0011
Const Darkcyan = &H0451
Const Darkgoldenrod = &HBC21
Const Darkgray = &HAD55
Const Darkgreen = &H0320
Const Darkkhaki = &HBDAD
Const Darkmagenta = &H8811
Const Darkolivegreen = &H5345
Const Darkorange = &HFC60
Const Darkorchid = &H9999
Const Darkred = &H8800
Const Darksalmon = &HECAF
Const Darkseagreen = &H8DF1
Const Darkslateblue = &H49F1
Const Darkslategray = &H2A69
Const Darkturquoise = &H067A
Const Darkviolet = &H901A
Const Darkyellow = &HF700
Const Deeppink = &HF8B2
Const Deepskyblue = &H05FF
Const Dimgray = &H6B4D
Const Dodgerblue = &H1C9F
Const Firebrick = &HB104
Const Floralwhite = &HFFDE
Const Forestgreen = &H2444
Const Fuchsia = &HF81F
Const Gainsboro = &HDEFB
Const Ghostwhite = &HFFDF
Const Gold = &HFEA0
Const Goldenrod = &HDD24
Const Gray = &H8410
Const Green = &H07E0
Const Green1 = &H0700
Const Greenyellow = &HAFE5
Const Honeydew = &HF7FE
Const Hotpink = &HFB56
Const Indianred = &HCAEB
Const Indigo = &H4810
Const Ivory = &HFFFE
Const Khaki = &HF731
Const Lavender = &HE73F
Const Lavenderblush = &HFF9E
Const Lawngreen = &H7FE0
Const Lemonchiffon = &HFFD9
Const Lightblue = &HAEDC
Const Lightcoral = &HF410
Const Lightcyan = &HE7FF
Const Lightgold = &HFFDA
Const Lightgreen = &H9772
Const Lightgrey = &HD69A
Const Lightpink = &HFDB8
Const Lightsalmon = &HFD0F
Const Lightseagreen = &H2595
Const Lightskyblue = &H867F
Const Lightslategray = &H7453
Const Lightsteelblue = &HB63B
Const Lightyellow = &HFFFC
Const Lime = &H07E0
Const Limegreen = &H3666
Const Linen = &HFF9C
Const Magenta = &HF81F
Const Maroon = &H8000
Const Mediumaquamarine = &H6675
Const Mediumblue = &H0019
Const Mediumorchid = &HBABA
Const Mediumpurple = &H939B
Const Mediumseagreen = &H3D8E
Const Mediumslateblue = &H7B5D
Const Mediumspringgreen = &H07D3
Const Mediumturquoise = &H4E99
Const Mediumvioletred = &HC0B0
Const Midnightblue = &H18CE
Const Mintcream = &HF7FF
Const Mistyrose = &HFF3C
Const Moccasin = &HFF36
Const Navajowhite = &HFEF5
Const Navy = &H0010
Const Oldlace = &HFFBC
Const Olive = &H8400
Const Olivedrab = &H6C64
Const Orange = &HFD20
Const Orangered = &HFA20
Const Orchid = &HDB9A
Const Palegoldenrod = &HEF55
Const Palegreen = &H9FD3
Const Paleturquoise = &HAF7D
Const Palevioletred = &HDB92
Const Papayawhip = &HFF7A
Const Peachpuff = &HFED7
Const Peru = &HCC27
Const Plum = &HDD1B
Const Powderblue = &HB71C
Const Purple = &H8010
Const Red = &HF800
Const Rosybrown = &HBC71
Const Royalblue = &H435C
Const Saddlebrown = &H8A22
Const Salmon = &HFC0E
Const Sandybrown = &HF52C
Const Seagreen = &H2C4A
Const Seashell = &HFFBD
Const Sienna = &HA285
Const Silver = &HC618
Const Skyblue = &H867D
Const Slateblue = &H6AD9
Const Slategray = &H7412
Const Snow = &HFFDF
Const Springgreen = &H07EF
Const Steelblue = &H4416
Const Teal = &H0410
Const Thistle = &HDDFB
Const Tomato = &HFB08
Const Turquoise = &H471A
Const Violet = &HEC1D
Const Wheat = &HF6F6
Const White = &HFFFF
Const Whitesmoke = &HF7BE
Const Yellow = &HFFE0
Const Yellowgreen = &H9E66