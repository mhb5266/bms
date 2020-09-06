$regfile = "m128def.dat"
$crystal = 11059200

$baud = 115200



$lib "glcdKS108.lbx"



'-------------------------------------------------------------------------------
Configs:
'Config Portd.0 = Input : _in Alias Pind.0                   'RF input                                     'RF INPUT
Config Pinb.4 = Output : Buzz Alias Portb.4
Config Pind.2 = Output : Led1 Alias Portd.2                 'Buzzer B.1
Config Porte.5 = Input : Touch1 Alias Pine.5
Config Porte.6 = Input : Touch2 Alias Pine.6
Config Porte.7 = Input : Touch3 Alias Pine.7
Config Portb.0 = Input : Touch4 Alias Pinb.0
Config Porta.3 = Output : Backlight Alias Porta.3
'Config Timer1 = Timer , Prescale = 8 : Stop Timer1 : Timer1 = 0

Config 1wire = Pinb.3

Config Scl = Portd.0                                        'at24cxx pin6
Config Sda = Portd.1

$lib "glcdKS108.lbx"
Config Graphlcd = 128 * 64sed , Dataport = Portf , Controlport = Porta , Ce = 0 , Ce2 = 1 , Cd = 4 , Rd = 6 , Reset = 2 , Enable = 7
Setfont Font8x8


Subs:

 Declare Sub Temp1()
 Declare Sub Menuu()
 Declare Sub Clock()
 Declare Sub Clockset()
 Declare Sub Disp()
 Declare Sub Remoteset()
 Declare Sub Lightset()
 Declare Sub Waterset()
 Declare Sub Jaccuziset()
 Declare Sub Plantset()

 Declare Sub Beep()
 Declare Sub Watchtouch()
 Declare Sub Textfind()

 Declare Sub Clocksave()
 Declare Sub Clockshow()

 Declare Sub Beepok()
 Declare Sub Errbeep()

 Declare Sub Lighttime()
 Declare Sub Lightsave()
 Declare Sub Showchoose()
 Declare Sub Jsave()
 Declare Sub Jtalarm()
 Declare Sub Jtimeout()
 Declare Sub Watertime()
 Declare Sub Watersave()
 Declare Sub Planttime()
 Declare Sub Plantsave()
 Declare Sub Datasend()

 Declare Sub Changestatus()
 Declare Sub Check_temp_time()
 Declare Sub Nrfsend()

Consts:


Const Ds1307w = &HD0                                        ' Addresses of Ds1307 clock
Const Ds1307r = &HD1                                        ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Const Eewrite = 160                                         'eeprom write address
Const Eeread = 161
Const Touchdelay = 10

Definess:

Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim Status As Byte
Dim Count As Byte
Dim Mm As Byte
Dim Hh As Byte

 Dim Dosave As Boolean
 Dim Touch As Byte


 'config PORTA.0 = input
Dim Temperature As String * 6
Dim Sens1 As String * 6
Dim Sens2 As String * 6

Dim Dahom As Word
Dim Sahih As Word

Dim Blank As Boolean
Dim Buffer1 As Integer

Dim Out1 As Bit : Dim Out2 As Bit : Dim Out3 As Bit : Dim Out4 As Bit : Dim Out5 As Bit
Dim Out6 As Bit : Dim Out7 As Bit : Dim Out8 As Bit : Dim Out9 As Bit : Dim Out10 As Bit
Dim Out11 As Bit : Dim Out12 As Bit : Dim Out13 As Bit : Dim Out14 As Bit : Dim Out15 As Bit
Dim Out16 As Bit : Dim Out17 As Bit : Dim Out18 As Bit : Dim Out19 As Bit : Dim Out20 As Bit
Dim Out21 As Bit : Dim Out22 As Bit : Dim Out23 As Bit : Dim Out24 As Bit : Dim Out25 As Bit
Dim Out26 As Bit : Dim Out27 As Bit : Dim Out28 As Bit : Dim Out29 As Bit : Dim Out30 As Bit
Dim Out31 As Bit : Dim Out32 As Bit : Dim Out33 As Bit : Dim Out34 As Bit : Dim Out35 As Bit
Dim Out36 As Bit : Dim Out37 As Bit : Dim Out38 As Bit : Dim Out39 As Bit : Dim Out40 As Bit

Dim Rdata As Byte
Dim Rcode As Byte
Dim Senddata As Byte
Dim Sendok As Bit
Dim Getdata As Byte
Dim Datain(5) As Byte

Dim Buffer_digital As Integer

Dim Temp As Byte
Dim Test As Word
Dim Remotedata As Byte                                      'learning led
'Key1 Alias Pinb.0
Dim Key1 As Bit : Set Key1                                  'learn key
                                      'eeprom read address
'--------------------------------- Timer ---------------------------------------

'Config Watchdog = 2048
'--------------------------------- Variable ------------------------------------
'Dim S(24)as Word
Dim I As Byte
I = 0
Dim Saddress As String * 20
Dim Scode As String * 4
Dim Address As Long
Dim Code As Byte
''''''''''''''''''''''''''''''''
Dim Ra As Long                                              'fp address
Dim Rnumber As Byte                                         'remote know
Dim Okread As Bit
Dim Error As Bit
Dim Keycheck As Bit
Dim T As Word                                               'check for pushing lean key time
Error = 0
Okread = 0
T = 0
Keycheck = 0
Dim Eaddress As Word                                        'eeprom address variable
Dim E_read As Byte
Dim E_write As Byte
Dim M As String * 8
Dim M1 As String * 2
Dim M2 As String * 2
Dim M3 As String * 2
Dim Inmenu As Bit
Dim Readen As Bit
Dim Timech As Word
'dim remotecode as Word
'-------------------------- read rnumber index from eeprom
Dim Ds18b20_id_1(9) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Action As Byte
Ds18b20_id_1(1) = 1wsearchfirst()
Ds18b20_id_2(1) = 1wsearchnext()
Dim Allremotes(10) As Eram Dword

Dim Text As String * 15
Dim Remotenum As Byte
Dim Remotecode As Word
Dim Eram_code(10) As Eram Word
'dim eramlight as eram Byte


Dim Wstatus As Eram Byte
Dim Pstatus As Eram Byte
Dim Lstatus As Eram Byte

Dim Wplstatus As Byte

Dim Wplonh As Byte
Dim Wplonm As Byte

Dim Wploffh As Byte
Dim Wploffm As Byte


Dim Elonh As Eram Byte : If Elonh = 255 Then Elonh = 0
Dim Elonm As Eram Byte : If Elonm = 255 Then Elonm = 0
Dim Eloffh As Eram Byte : If Eloffh = 255 Then Eloffh = 0
Dim Eloffm As Eram Byte : If Eloffm = 255 Then Eloffm = 0

Dim Ewonh As Eram Byte : If Ewonh = 255 Then Elonh = 0
Dim Ewonm As Eram Byte : If Ewonm = 255 Then Elonm = 0
Dim Ewoffh As Eram Byte : If Ewoffh = 255 Then Eloffh = 0
Dim Ewoffm As Eram Byte : If Ewoffm = 255 Then Eloffm = 0

Dim Eponh As Eram Byte : If Eponh = 255 Then Eponh = 0
Dim Eponm As Eram Byte : If Eponm = 255 Then Eponm = 0
Dim Epoffh As Eram Byte : If Epoffh = 255 Then Epoffh = 0
Dim Epoffm As Eram Byte : If Epoffm = 255 Then Epoffm = 0

Dim Jalarm As Eram Byte
Dim Jofftime As Eram Byte
Dim Choose As Byte
Dim Ejalarmtemp As Eram Byte
Dim Jalarmtemp As Byte
Dim Maxjtime As Byte
Dim Ejtimeout As Eram Byte
Dim Jstatus As Boolean
Dim Mterm As Byte

Dim Ii As Byte
Dim Ledlight As Byte
Dim Pwm As Byte
Dim Testt As Byte
Dim Remm As Byte



Startup:


        Set Backlight
        Cls
        Lcdat 1 , 1 , "hi"
        Wait 1



Main:

Do

     Call Temp1

     Waitms 800


  If Touch1 = 1 Then
     Do
     Waitms Touchdelay
     Loop Until Touch1 = 0
     Call Beep
     Call Menuu
  End If


Loop


Beep:
     'reset watchdog
     Set Buzz
     Waitms 80
     Reset Buzz
     Waitms 30
Return


Temp1:

   'reset watchdog
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 30
   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Sens1 = Temperature


   Dahom = Buffer_digital
   Do
   Dahom = Dahom - 10
   Loop Until Dahom < 10
   Sahih = Buffer_digital - Dahom
   Sahih = Sahih / 10




   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Gosub Conversion
   Sens2 = Temperature

Return

Conversion:
   Buffer_digital = Buffer_digital * 10 : Buffer_digital = Buffer_digital \ 16
   Temperature = Str(buffer_digital) : Temperature = Format(temperature , "0.0")
Return

Decode:
Select Case Rnumber
       Case 1:
       Eaddress = 10
       Case 2:
       Eaddress = 13
       Case 3:
       Eaddress = 16
       Case 4:
       Eaddress = 19
       Case 5:
       Eaddress = 22
       Case 6:
       Eaddress = 25
       Case 7:
       Eaddress = 28
       Case 8:
       Eaddress = 31
       Case 9:
       Eaddress = 34
       Case 10:
       Eaddress = 37
       Case 11:
       Eaddress = 40
       Case 12:
       Eaddress = 43
       Case 13:
       Eaddress = 46
       Case 14:
       Eaddress = 49
       Case 15:
       Eaddress = 52
       Case 16:
       Eaddress = 55
       Case 17:
       Eaddress = 58
       Case 18:
       Eaddress = 61
       Case 19:
       Eaddress = 64
       Case 20:
       Eaddress = 67
       Case 21:
       Eaddress = 70
       Case 22:
       Eaddress = 73
       Case 23:
       Eaddress = 76
       Case 24:
       Eaddress = 79
       Case 25:
       Eaddress = 82
       Case 26:
       Eaddress = 85
       Case 27:
       Eaddress = 88
       Case 28:
       Eaddress = 91
       Case 29:
       Eaddress = 94
       Case 30:
       Eaddress = 97
       Case 40:
       Eaddress = 100
       Case 41:
       Eaddress = 103
       Case 42:
       Eaddress = 106
       Case 43:
       Eaddress = 109
       Case 44:
       Eaddress = 112
       Case 45:
       Eaddress = 115
       Case 46:
       Eaddress = 118
       Case 47:
       Eaddress = 121
       Case 48:
       Eaddress = 124
       Case 49:
       Eaddress = 127
       Case 50:
       Eaddress = 130
       Case 51:
       Eaddress = 133
       Case 52:
       Eaddress = 136
       Case 53:
       Eaddress = 139
       Case 54:
       Eaddress = 142
       Case 55:
       Eaddress = 145
       Case 56:
       Eaddress = 148
       Case 57:
       Eaddress = 151
       Case 58:
       Eaddress = 154
       Case 59:
       Eaddress = 157
       Case 60:
       Eaddress = 160
       Case 70:
       Eaddress = 163
       Case 71:
       Eaddress = 166
       Case 72:
       Eaddress = 169
       Case 73:
       Eaddress = 172
       Case 74:
       Eaddress = 175
       Case 75:
       Eaddress = 178
       Case 76:
       Eaddress = 181
       Case 77:
       Eaddress = 184
       Case 78:
       Eaddress = 187
       Case 79:
       Eaddress = 190
       Case 80:
       Eaddress = 193
       Case 81:
       Eaddress = 196
       Case 82:
       Eaddress = 199
       Case 83:
       Eaddress = 202
       Case 84:
       Eaddress = 205
       Case 85:
       Eaddress = 208
       Case 86:
       Eaddress = 211
       Case 87:
       Eaddress = 214
       Case 88:
       Eaddress = 217
       Case 89:
       Eaddress = 220
       Case 90:
       Eaddress = 223
       Case 91:
       Eaddress = 226
       Case 92:
       Eaddress = 229
       Case 93:
       Eaddress = 232
       Case 94:
       Eaddress = 235
       Case 95:
       Eaddress = 238
       Case 96:
       Eaddress = 241
       Case 97:
       Eaddress = 244
       Case 98:
       Eaddress = 247
       Case 99:
       Eaddress = 250
       Case 100:
       Eaddress = 253
       Case Else
End Select
Return



Select Case Remotecode

   Case Eram_code(1)
      Text = "Main remote"
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(2)
        Text = "Room 1     "
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(3)
        Text = "Room 2     "
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(4)
        Text = "Room 3     "
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(5)
        Text = "Kitchen    "
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(6)
        Text = "Living room"
      Select Case Action
             Case 1
                      If Out1 = 0 Then
                         Set Out1
                         Rdata = 1
                      Else
                         Reset Out1
                         Rdata = 2
                      End If
             Case 2
                      If Out2 = 0 Then
                         Set Out2
                         Rdata = 3
                      Else
                         Reset Out2
                         Rdata = 4
                      End If
             Case 4
                      If Out3 = 0 Then
                         Set Out3
                         Rdata = 5
                      Else
                         Reset Out3
                         Rdata = 6
                      End If
             Case 8
                      If Out4 = 0 Then
                         Set Out4
                         Rdata = 7
                      Else
                         Reset Out4
                         Rdata = 8
                      End If
      End Select

   Case Eram_code(7)
        Text = "Basement   "
      Select Case Action
             Case 1
                      If Out40 = 0 Then
                         Set Out40
                         Rdata = 79
                      Else
                         Reset Out40
                         Rdata = 80
                      End If
             Case 2
                      If Out39 = 0 Then
                         Set Out39
                         Rdata = 77
                      Else
                         Reset Out39
                         Rdata = 78
                      End If
             Case 4
                 If Ledlight < 5 Then Incr Ledlight
             Case 8
                 If Ledlight > 0 Then Decr Ledlight

      End Select

       If Action = 4 Or Action = 8 Then
              If Ledlight = 0 Then Rdata = 250
              If Ledlight = 1 Then Rdata = 251
              If Ledlight = 2 Then Rdata = 252
              If Ledlight = 3 Then Rdata = 253
              If Ledlight = 4 Then Rdata = 254
              If Ledlight = 5 Then Rdata = 255
       End If

End Select
Return




Disp:

     Setfont Font8x8
 Lcdat 1 , 90 , Temperature
     'reset watchdog
     Setfont Font32x32
     'If Inmenu = 1 Then Goto Jump1
     'Gosub _read
     'lcdat 7 , 1 , action
     'lcdat 7 , 20 , remotecode
        Lcdat 3 , 1 , Sahih
        Setfont Font16x16
        'lcdat 5 , 60 , "."
        Lcdat 5 , 64 , Dahom
        Setfont Font8x8
        Lcdat 4 , 70 , "#"
        'lcdat 3 , 1 , sens2
        'showpic 1 , 49 , kelidha
        Setfont Font8x8
        'Lcdat 8 , 1 , " Back  <  >  Ok " , 1
        Lcdat 8 , 1 , "  ?   <   >   @ " , 1

     'Jump1:
           Setfont Font8x8
            If Hh < 10 Then
               Lcdat 1 , 1 , "0"
               Lcdat 1 , 8 , Hh
            Else
              Lcdat 1 , 1 , Hh
            End If

            '_sec = val(_sec)
            Remm = _sec Mod 2
            'lcdat 1 , 44 , remm
            'lcdat 1 , 57 , _sec
            If Remm = 0 Then Lcdat 1 , 16 , ":" Else Lcdat 1 , 16 , " "

            If Mm < 10 Then
               Lcdat 1 , 22 , "0"
               Lcdat 1 , 30 , Mm
            Else
              Lcdat 1 , 22 , Mm
            End If
              'lcdat 1 , 38 , ":"
              'if _sec < 10 then
               'lcdat 1 , 44 , "0"
               'lcdat 1 , 52 , _sec
            'else
              'lcdat 1 , 44 , _sec
            'endif

Return


Menuu:
     Waitms 50
     Cls
     Mterm = 1
     Do
     'reset watchdog

            If Touch = 2 Then
                   Touch = 0
                   Incr Mterm
                   If Mterm = 7 Then Mterm = 1
                   Cls
            End If
            If Touch = 3 Then
                   Touch = 0
                   Decr Mterm
                   If Mterm = 0 Then Mterm = 6
                   Cls
            End If
            If Touch = 4 Then
                   Touch = 0
                   Cls
                   Return
            End If
            Select Case Mterm
                   Case 1
                        Showpic 50 , 20 , Setclock
                   Case 2
                        Showpic 50 , 20 , Remote
                   Case 3
                        Showpic 50 , 20 , Plant
                   Case 4
                        Showpic 50 , 20 , Watersystem
                   Case 5
                        Showpic 50 , 20 , Light
                   Case 6
                        Showpic 50 , 20 , Jaccuzi
            End Select
            Setfont Font8x8
            'Lcdat 8 , 1 , " Back  <  >  Ok " , 1
             Lcdat 8 , 1 , "  ?   <   >   @ " , 1
            If Touch = 1 Then
                   Touch = 0
                   Cls
                   Select Case Mterm
                          Case 1
                               Cls
                               Call Clockset
                               If Dosave = 1 Then Call Clocksave
                          Case 2
                               Call Remoteset
                          Case 3
                               Wplstatus = Pstatus
                               Wplonh = Eponh
                               Wplonm = Eponm
                               Wploffh = Epoffh
                               Wploffm = Epoffm

                               Call Changestatus

                               Pstatus = Wplstatus
                               Eponh = Wplonh
                               Eponm = Wplonm
                               Epoffh = Wploffh
                               Epoffm = Wploffm

                               If Pstatus = 1 Then
                                  Senddata = 21
                               Elseif Pstatus = 2 Then
                                  Senddata = 22
                               End If
                          Case 4
                               Wplstatus = Wstatus
                               Wplonh = Ewonh
                               Wplonm = Ewonm
                               Wploffh = Ewoffh
                               Wploffm = Ewoffm
                               Call Changestatus
                               Wstatus = Wplstatus

                               Ewonh = Wplonh
                               Ewonm = Wplonm
                               Ewoffh = Wploffh
                               Ewoffm = Wploffm

                               If Wstatus = 1 Then
                                  Senddata = 17
                               Elseif Wstatus = 2 Then
                                  Senddata = 18
                               End If
                          Case 5
                               Wplstatus = Lstatus
                               Wplonh = Elonh
                               Wplonm = Elonm
                               Wploffh = Eloffh
                               Wploffm = Eloffm
                               Call Changestatus
                               Lstatus = Wplstatus
                               Elonh = Wplonh
                               Elonm = Wplonm
                               Eloffh = Wploffh
                               Eloffm = Wploffm

                               If Lstatus = 1 Then
                                  Senddata = 19
                               Elseif Lstatus = 2 Then
                                  Senddata = 20
                               End If
                          Case 6
                               Call Jaccuziset
                   End Select
            End If
            Touch = 0
            Call Watchtouch
     Loop
Return

Changestatus:

    Status = 0
    if wplstatus= 0 then wplstatus=1
    Choose = Wplstatus
    Count = Choose
    Call Showchoose
    Do
      Gosub Onoffauto
      Touch = 0
      Do
      Gosub Watchtouch
      Loop Until Touch > 0
      If Touch = 2 Then
       Incr Count
      Elseif Touch = 3 Then
       Decr Count
      End If
      If Count = 0 Then Count = 3
      If Count > 3 Then Count = 1

      If Touch = 1 Then
       If Count = 1 Or Count = 2 Then
          Wplstatus = Count
          Cls
          Return
       Elseif Count = 3 Then
              Status = 1
              Do
                Incr Test
                If Test = 50 Then
                   Toggle Blank
                   Test = 0
                End If
                Touch = 0
                Gosub Watchtouch
                Gosub Onoffauto
                If Touch = 1 Then Incr Status

                If Status = 5 Then
                   Wplstatus = Count
                   Cls
                   Return
                End If

                If Touch = 2 Then
                   If Status = 1 Then Incr Wplonh
                   If Status = 2 Then Incr Wplonm
                   If Status = 3 Then Incr Wploffh
                   If Status = 4 Then Incr Wploffm
                End If

                If Touch = 3 Then
                   If Status = 1 Then Decr Wplonh
                   If Status = 2 Then Decr Wplonm
                   If Status = 3 Then Decr Wploffh
                   If Status = 4 Then Decr Wploffm

                End If

                If Wplonh > 23 Then Wplonh = 0
                If Wplonm > 59 Then Wplonm = 0
                If Wploffh > 23 Then Wploffh = 0
                If Wploffm > 59 Then Wploffm = 0

                If Touch = 4 Then
                   Cls
                   Return
                End If
              Loop
       End If
      End If

      If Touch = 4 Then
         Cls
         Return
      End If

    Loop

Return

Clockset:
       Status = 0
       'Do
         'Waitms 10
       'Loop Until touch1 = 1
       Incr Status
       Call Clockshow
       Do
            Call Clockshow
            Touch = 0
            Call Watchtouch
            'reset watchdog
            If Touch = 1 Then
               Touch = 0
               Incr Status
               If Status = 4 Then
                  Set Dosave
                  Status = 0
                  Return
               End If
            End If
            '_min = Mm
            '_hour = Hh
            Incr Test
            If Test = 50 Then
                     Toggle Blank
                     Test = 0
            End If
            Set Inmenu
               'lcdat 4 , 32 , ":"
               'lcdat 4 , 80 , ":"
                 'if _sec < 10 then
                  'lcdat 4 , 96 , "0"
                  'lcdat 4 , 112 , _sec
               'else
                 'lcdat 4 , 96 , _sec
               'endif
            If Status = 2 Then
                     'If T = 1 Then Goto J1
                     If Touch = 2 Then
                        Touch = 0
                        'Toggle T
                        Incr Hh
                        If Hh > 23 Then Hh = 0
                     End If
                     If Touch = 3 Then
                        Touch = 0
                        'Toggle T
                        If Hh > 0 Then
                           Decr Hh
                        Else
                            Hh = 23
                        End If
                     End If
                     Call Watchtouch
            End If
         ' J1:
            If Status = 3 Then
                     'If T = 1 Then Goto J2
                     If Touch = 2 Then
                        Touch = 0
                        'Toggle T
                        Incr Mm
                        If Mm > 59 Then Mm = 0
                     End If
                     If Touch = 3 Then
                        Touch = 0
                        'Toggle T
                        If Mm > 0 Then
                           Decr Mm
                        Else
                            Mm = 59
                        End If
                     End If
                     Call Watchtouch
            End If
          'call clockshow
          'J2:
          If Touch = 4 Then
                 Touch = 0
                 Reset Dosave
                 Cls
                 Return
          End If
       Loop
       Cls
Return
Clockshow:
       'reset watchdog
       Setfont Font8x8
       Lcdat 8 , 1 , " Back  <  >  Ok " , 1
       Setfont Font16x16
       If Status < 2 Then
            If Hh < 10 Then
               Lcdat 4 , 1 , "0"
               Lcdat 4 , 16 , Hh
            Else
              Lcdat 4 , 1 , Hh
            End If
            Lcdat 4 , 32 , ":"
            If Mm < 10 Then
               Lcdat 4 , 48 , "0"
               Lcdat 4 , 64 , Mm
            Else
              Lcdat 4 , 48 , Mm
            End If
       End If
            If Status = 2 Then
                        If Blank = 1 Then
                           If Hh < 10 Then
                              Lcdat 4 , 1 , "0"
                              Lcdat 4 , 16 , Hh
                           Else
                              Lcdat 4 , 1 , Hh
                           End If
                        Else
                           Lcdat 4 , 1 , "  "
                        End If
                           Lcdat 4 , 32 , ":"
                           If Mm < 10 Then
                              Lcdat 4 , 48 , "0"
                              Lcdat 4 , 64 , Mm
                           Else
                              Lcdat 4 , 48 , Mm
                           End If
            End If
            If Status = 3 Then
                        If Hh < 10 Then
                           Lcdat 4 , 1 , "0"
                           Lcdat 4 , 16 , Hh
                        Else
                            Lcdat 4 , 1 , Hh
                        End If
                        Lcdat 4 , 32 , ":"
                        If Blank = 1 Then
                           If Mm < 10 Then
                              Lcdat 4 , 48 , "0"
                              Lcdat 4 , 64 , Mm
                           Else
                              Lcdat 4 , 48 , Mm
                           End If
                        Else
                           Lcdat 4 , 48 , "  "
                        End If
            End If
Return
Clocksave:
               'reset watchdog
                  _sec = 0
                  _sec = Makebcd(_sec) : _min = Makebcd(mm) : _hour = Makebcd(hh)
                  I2cstart
                  I2cwbyte Ds1307w
                  I2cwbyte 0
                  I2cwbyte _sec
                  I2cwbyte _min
                  I2cwbyte _hour
                  I2cstop
                  Waitms 500
                  Call Beepok
                  Cls
                  Goto Main
Return


Jaccuziset:
         Setfont Font8x8
         Jalarmtemp = Ejalarmtemp
         Maxjtime = Ejtimeout
         Choose = 0
         If Jstatus = 1 Then
            Choose = 1
         Else
             Choose = 2
         End If
         If Count > 4 Or Count = 0 Then Count = 1
         Cls
         Do
                  Lcdat 1 , 1 , "Jaccuzi" , 1
                  Call Showchoose
                  'reset watchdog
                  If Count = 1 Then
                                    Lcdat 3 , 41 , "   ON     " , 1
                                    Lcdat 4 , 41 , "   OFF    "
                                    Lcdat 5 , 41 , "  Alarm   "
                                    Lcdat 6 , 41 , " Time Out "
                  End If
                  If Count = 2 Then
                                    Lcdat 3 , 41 , "   ON     "
                                    Lcdat 4 , 41 , "   OFF    " , 1
                                    Lcdat 5 , 41 , "  Alarm   "
                                    Lcdat 6 , 41 , " Time Out "
                  End If
                  If Count = 3 Then
                                    Lcdat 3 , 41 , "   ON     "
                                    Lcdat 4 , 41 , "   OFF    "
                                    Lcdat 5 , 41 , "  Alarm   " , 1
                                    Lcdat 6 , 41 , " Time Out "
                  End If
                  If Count = 4 Then
                                    Lcdat 3 , 41 , "   ON     "
                                    Lcdat 4 , 41 , "   OFF    "
                                    Lcdat 5 , 41 , "  Alarm   "
                                    Lcdat 6 , 41 , " Time Out " , 1
                  End If

                  Do
                    Call Watchtouch
                  Loop Until Touch > 0
                  Cls
                  If Touch = 2 Then Incr Count
                  If Count > 4 Then Count = 1
                  If Touch = 3 Then Decr Count
                  If Count = 0 Then Count = 4
                  If Touch = 1 Then
                     If Count = 1 Then
                        Jstatus = 1
                     Elseif Count = 2 Then
                        Jstatus = 0
                     End If
                     If Count = 3 Then Call Jtalarm
                     If Count = 4 Then Call Jtimeout
                  End If
                  If Touch = 4 Then
                     Cls
                     Return
                  End If
         Loop
Return
Jtalarm:
Setfont Font8x8
Cls
Lcdat 1 , 1 , "Alarm Temp"
Lcdat 4 , 33 , "#"
Setfont Font16x16
Do
  'reset watchdog
  Touch = 0
  Call Watchtouch
  If Touch = 2 Then Incr Jalarmtemp
  If Touch = 3 Then Decr Jalarmtemp
  If Jalarmtemp < 20 Then Jalarmtemp = 20
  If Jalarmtemp > 45 Then Jalarmtemp = 45
  Lcdat 4 , 1 , Jalarmtemp
  If Touch = 1 Then
   Call Jsave
   Return
  End If
  If Touch = 4 Then
     Setfont Font8x8
     Cls
     Return
  End If
Loop
Return
Jtimeout:
Cls
Setfont Font8x8
Lcdat 1 , 1 , "Alarm Time out"
Setfont Font16x16
Do
  'reset watchdog
  Touch = 0
  Call Watchtouch
  If Touch = 2 Then Incr Maxjtime
  If Touch = 3 Then Decr Maxjtime
  If Maxjtime < 1 Then Maxjtime = 1
  If Maxjtime > 5 Then Maxjtime = 5
  Lcdat 4 , 1 , Maxjtime
  If Touch = 1 Then
     Call Jsave
     Return
  End If
  If Touch = 4 Then
     Setfont Font8x8
     Cls
     Return
  End If

Loop

Return
Jsave:
Setfont Font8x8
Cls
'reset watchdog
Ejalarmtemp = Jalarmtemp
Ejtimeout = Maxjtime
Call Beepok
Return


Onoffauto:
                  If Count = 1 Then
                                    Lcdat 2 , 41 , "  ON   " , 1
                                    Lcdat 3 , 41 , "  OFF  "
                                    Lcdat 4 , 41 , "  AUTO "
                  End If
                  If Count = 2 Then
                                    Lcdat 2 , 41 , "  ON   "
                                    Lcdat 3 , 41 , "  OFF  " , 1
                                    Lcdat 4 , 41 , "  AUTO "
                  End If
                  If Count = 3 Then
                                    Lcdat 2 , 41 , "  ON   "
                                    Lcdat 3 , 41 , "  OFF  "
                                    Lcdat 4 , 41 , "  AUTO " , 1
                  End If

                  Lcdat 6 , 20 , "ON"
                  Lcdat 7 , 20 , "OFF"

                             If Status = 1 Then
                                If Blank = 1 Then
                                    If Wplonh < 10 Then
                                       Lcdat 6 , 56 , "0"
                                       Lcdat 6 , 64 , Wplonh
                                    Else
                                       Lcdat 6 , 56 , Wplonh
                                    End If
                                Else
                                    Lcdat 6 , 56 , "  "
                                End If
                             Else
                                    If Wplonh < 10 Then
                                       Lcdat 6 , 56 , "0"
                                       Lcdat 6 , 64 , Wplonh
                                    Else
                                       Lcdat 6 , 56 , Wplonh
                                    End If
                             End If
                                    Lcdat 6 , 72 , ":"
                             If Status = 2 Then
                                If Blank = 1 Then
                                    If Wplonm < 10 Then
                                       Lcdat 6 , 80 , "0"
                                       Lcdat 6 , 88 , Wplonm
                                    Else
                                       Lcdat 6 , 80 , Wplonm
                                    End If
                                Else
                                    Lcdat 6 , 80 , "  "
                                End If
                             Else
                                    If Wplonm < 10 Then
                                       Lcdat 6 , 80 , "0"
                                       Lcdat 6 , 88 , Wplonm
                                    Else
                                       Lcdat 6 , 80 , Wplonm
                                    End If
                             End If

                             If Status = 3 Then
                                If Blank = 1 Then
                                    If Wploffh < 10 Then
                                       Lcdat 7 , 56 , "0"
                                       Lcdat 7 , 64 , Wploffh
                                    Else
                                       Lcdat 7 , 56 , Wploffh
                                    End If
                                Else
                                    Lcdat 7 , 56 , "  "
                                End If
                             Else
                                    If Wploffh < 10 Then
                                       Lcdat 7 , 56 , "0"
                                       Lcdat 7 , 64 , Wploffh
                                    Else
                                       Lcdat 7 , 56 , Wploffh
                                    End If
                             End If
                                    Lcdat 7 , 72 , ":"

                             If Status = 4 Then
                                If Blank = 1 Then
                                    If Wploffm < 10 Then
                                       Lcdat 7 , 80 , "0"
                                       Lcdat 7 , 88 , Wploffm
                                    Else
                                       Lcdat 7 , 80 , Wploffm
                                    End If
                                Else
                                    Lcdat 7 , 80 , "  "
                                End If
                             Else
                                    If Wploffm < 10 Then
                                       Lcdat 7 , 80 , "0"
                                       Lcdat 7 , 88 , Wploffm
                                    Else
                                       Lcdat 7 , 80 , Wploffm
                                    End If
                             End If

Return

Check_temp_time:
    Senddata = 0

    If Wstatus = 3 Then
       If Ewonh = Hh Then
          If Ewonm = Mm Then
             Senddata = 17
          End If
       End If
       If Ewoffh = Hh Then
          If Ewoffm = Mm Then
             Senddata = 18
          End If
       End If
    End If

    'If Senddata > 0 Then Call Nrfsend

    Senddata = 0

    If Lstatus = 3 Then
       If Elonh = Hh Then
          If Elonm = Mm Then
             Senddata = 19
          End If
       End If
       If Eloffh = Hh Then
          If Eloffm = Mm Then
             Senddata = 20
          End If
       End If
    End If

    'If Senddata > 0 Then Call Nrfsend

    Senddata = 0

    If Pstatus = 3 Then
       If Eponh = Hh Then
          If Eponm = Mm Then
             Senddata = 21
          End If
       End If
       If Epoffh = Hh Then
          If Epoffm = Mm Then
             Senddata = 22
          End If
       End If
    End If

    'If Senddata > 0 Then Call Nrfsend

Return

Beepok:
     'reset watchdog
     Set Buzz
     Waitms 100
     Reset Buzz
     Waitms 200
     'reset watchdog
     Set Buzz
     Waitms 500
     Reset Buzz
     Waitms 50

Return
Beeperr:
Return
Showchoose:

                  Select Case Choose
                         Case 1
                              Lcdat 2 , 33 , "*"
                         Case 2
                              Lcdat 3 , 33 , "*"
                         Case 3
                              Lcdat 4 , 33 , "*"
                         Case 4
                              Lcdat 5 , 33 , "*"
                  End Select
Return
Remoteset:
         Cls
         Setfont Font8x8
         Lcdat 3 , 20 , "Clear All   >"
         Lcdat 4 , 20 , "Learn a New <"
         Lcdat 8 , 1 , " Back  <  >  Ok " , 1
         Do
               'reset watchdog
               Call Watchtouch
                If Touch = 2 Then
                       Touch = 0
                       Cls
                       Reset Key1
                       Cls
                       Lcdat 1 , 1 , "clearing"
                       'Gosub Clearall
                       Gosub Main
                End If
                If Touch = 3 Then
                       Touch = 0
                       Cls
                       Remotenum = 1
                       Do
                            'reset watchdog
                            Call Watchtouch
                            If Touch = 3 Then Incr Remotenum
                            If Remotenum = 10 Then Remotenum = 1
                            If Touch = 2 Then Decr Remotenum
                            If Remotenum = 0 Then Remotenum = 7
                            If Touch = 4 Then
                               Cls
                               Return
                            End If
                            'lcdat 2 , 1 , "Remote :"
                            'call textfind
                                      Select Case Remotenum
                                             Case 1
                                                  Text = "Main remote"
                                             Case 2
                                                  Text = "Room 1     "
                                             Case 3
                                                  Text = "Room 2     "
                                             Case 4
                                                  Text = "Room 3     "
                                             Case 5
                                                  Text = "Kitchen    "
                                             Case 6
                                                  Text = "Living room"
                                             Case 7
                                                  Text = "Basement   "
                                      End Select
                            Lcdat 2 , 1 , Text

                       Loop Until Touch = 1
                       Touch = 0
                       'reset watchdog
                       'Gosub Learnnew
                       Eram_code(remotenum) = Remotecode
                       Cls
                       'lcdat 1 , 1 , remotecode
                       Lcdat 1 , 1 , "learn finished"
                       'reset watchdog
                       Wait 1
                       'reset watchdog
                       Cls
                       Gosub Main
                End If
                If Touch = 4 Then
                       Touch = 0
                       Cls
                       Return
                End If
                Touch = 0
         Loop
Return

Textfind:
'reset watchdog
          Select Case Remotecode
                 Case Eram_code(1)
                      Text = "Main remote"
                 Case Eram_code(2)
                      Text = "Room 1     "
                 Case Eram_code(3)
                      Text = "Room 2     "
                 Case Eram_code(4)
                      Text = "Room 3     "
                 Case Eram_code(5)
                      Text = "Kitchen    "
                 Case Eram_code(6)
                      Text = "Living room"
                 Case Eram_code(7)
                      Text = "Basement   "
          End Select
Return




Watchtouch:
Touch = 0
'do
  'reset watchdog
    If Touch1 = 1 Then
       Do
       Waitms Touchdelay
       Loop Until Touch1 = 0
       Call Beep
       Touch = 1
    End If
    If Touch2 = 1 Then
       Do
       Waitms Touchdelay
       Loop Until Touch2 = 0
       Call Beep
       Touch = 2
    End If
    If Touch3 = 1 Then
       Do
       Waitms Touchdelay
       Loop Until Touch3 = 0
       Call Beep
       Touch = 3
    End If
    If Touch4 = 1 Then
       Do
       Waitms Touchdelay
       Loop Until Touch4 = 0
       Call Beep
       Touch = 4
    End If
'loop until touch > 0
Return






$include "font32x32.font"
$include "font16x16.font"
$include "font8x8.font"
Setclock:
$bgf "clock.bgf"
Remote:
$bgf "remote.bgf"
Plant:
$bgf "plant.bgf"
Light:
$bgf "light.bgf"
Jaccuzi:
$bgf "jaccuzi.bgf"
Watersystem:
$bgf "watersystem.bgf"
Kelidha:
$bgf "kelidha.bgf"

End