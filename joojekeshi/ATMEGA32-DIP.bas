'*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*

'*******************************************************************************
'*         ---------------------- WWW.ECA.IR -----------------------           *
'*******************************************************************************                                                                            *
'*    Title                     : MADARE-KONTROLE-JOJEKESHI-BA-SHT1X           *
'*    Version                   : 1.6.6-DIP                                    *
'*    Last Updated              : 2019/05/05 --- 1398/02/17                    *
'*    MCU                       : ATMEGA32A                                    *
'*    Clock Frequency           : 8.00MHz                                      *
'*    Compiler                  : BASCOM-AVR V2.0.7.8                          *
'*    Author                    : MOHAMMAD                                     *
'*    Telegram                  :                                              *
'*    Email                     :                                              *
'*******************************************************************************
$regfile = "m32def.dat" : $crystal = 8000000
Config Lcdpin = Pin , Db4 = Portd.4 , Db5 = Portd.1 , Db6 = Portd.0 , Db7 = Portd.7 _
, E = Portd.5 , Rs = Portd.6
Config Lcd = 16 * 2
Cursor Off
'*/*/*/*/*/*/*/*/*/*/*/*
Config Portd = Output
Config Pinb.0 = Input
Config Pinb.1 = Input
Config Pinb.2 = Input
Config Pinb.3 = Input
Config Portb.7 = Output
Config Pinc.1 = Input
Config Portb.6 = Output
Config Portc.3 = Output
Config Portc.4 = Output
Config Portc.5 = Output
Config Portb.5 = Output
Config Portc.2 = Output
'*/*/*/*/*/*/*/*/*/*/*/*
config PORTB.4=OUTPUT
Config Timer1 = Timer , Prescale = 1
config timer0=timer,prescale =64
Config Single = Scientific , Digits = 1
Config Clock = Soft
Config Watchdog = 2048
Start Watchdog
Deflcdchar 0 , 6 , 9 , 9 , 6 , 32 , 32 , 32 , 32

'*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
Dim A As Word , Aq As Byte , Aw As Byte , Conter As Word , Ab As Byte
Dim B As Word , Ac As Byte , W As Byte , Gf As byte , Err3 As Byte
Dim C As Single , Gh As Byte , Qa As Byte , Qf As byte , Rt As Byte
Dim G As Single , Err2 As Byte , Ry As Byte , Ppt As byte , Ppr As byte
Dim K As Single , Hj As Byte , B8 As Integer , Er As Single , Ppy As byte
Dim Oi As Byte , Mw As byte , Mds As Byte , Eds As byte , Ak As Byte , Rv As Byte
Dim Lk As Byte , Dg As Byte , Ho As byte , Ao As byte , Rv2 As Byte
Dim Df As Byte , Fd As Single , Ck As byte , Sda As Byte
Dim Po As Byte , Fa As Byte , Jh As byte , Up_temp As Single , Lt As Byte
Dim Fan As Byte , Ff As Byte , M3 As Word , M6 As Word , Ekf As Byte
Dim X As Single , Rq As Byte , Pu As Byte , S5 As Byte , U5 As byte , An As byte
Dim Qw As Byte , Ee As Byte , J As Byte , N1 As byte , O As Byte , Dc As Byte
Dim B50 As Byte , W50 As Word , Dt50 As Single , Dy50 As String * 10 , R_s As Single
Dim B1 As byte , Sum As Single , Rs As Byte , Nbb As Byte , Ax As Byte
Dim Contm As Byte , Us As Byte , A77 As Integer , Ds As Byte
Dim Rv1 As Byte , D1 As Byte
Dim M_nt As Byte , Cont_rv As Byte , E_s As Single , E_rn As Byte , Rr As Byte
Dim Nnn As Byte , Humidity_test As Single , Dt50_test As Single
'*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
Dim Temp_sr As String * 8 , Temp_ar As String * 4 , Crc_data As Byte , Err_data As Byte
Dim Temp_s As Integer , Temp_a As Byte , Temp_data As String * 10 , Crcdata2 As Integer
Dim Temp_2 As String * 10 , Temp As Single , Read_sensor As Byte , Crc_data3 As Byte
Dim H_sr As String * 8 , H_ar As String * 4 , H_r As String * 12 , Crc_data2 As Byte
Dim H_s As Integer , H_data As String * 5 , H_1 As String * 10 , Crctemp_a As Byte
Dim Temp_datan As Single , H_datan As Single , Recive_data As String * 33
Dim T_d As Word , Temp_1 As String * 10 , H_2 As String * 10 , Crctemp_1 As Single
Dim H_a As Byte , Humidity As Single , I As Byte , H_str As String * 10
Dim R_str As String * 10 , E_str As String * 10 , K_str As String * 5 , Var As Byte
Dim G_str As String * 10 , Star_t As Byte , Err4 As Single , Crc_datarecive As String * 8
Dim Ml As Single , Bn As Byte , Temp_manfi As String * 1 , Crch_s As Byte
Dim Temp_r As String * 12 , Temp_r3 As String * 4 , Temp_sht As Single
Dim Temp_abs As Single , Crch_a As Byte , Crch_1 As Single , Sn As Byte , Fn As Byte
Dim Crc_data1 As Single , Crctemp_s As Integer , Crc_binval As Byte , Test_h As Byte
Dim Data_sens As String * 34 , Ty As Byte , H_k_str As String * 5 , T_k_str As String * 5
Dim Str_n As String * 16 , Str_b As String * 16 , Str_c As String * 1 , It As Byte
Dim Str_l As String * 16 , Str_e As String * 16 , Str_d As String * 1 , Ml_str As String * 5
Dim Rw As Byte , H_k As Single , Ed As Byte , T_k As Single , R_s_hach As Single
Dim V_help As Single , K_hach As Single , G_hach As Single , E_s_hach As Single
Dim Sal As Word , Mah As Byte , Ruz As Byte , Ruz_sater As Byte , Ruz_hacher As Byte
Dim Motor_hach As Byte , Ruz_j As Byte , Meno1 As Byte , Meno2 As Byte , Ruz_jojekeshi As Byte
Dim Vvv As byte , K_sater As Single , G_sater As Single , E_s_sater As Single , R_s_sater As Single
Dim Jjj As Byte , Pp As byte , M3_single As Single , M6_single As Single , Yu As Single
Dim Er_v As Byte , Program As Byte , Ef As Byte , Dk As Byte , Nb As Byte
dim d as Byte, time_hach_button as Byte,var_k as byte
dim save_time as byte,nj as Byte , bnm as byte
dim ravesh_motor as byte,var_cont as byte , nh as word
'/*/*/*/*/*/*/*/*/*/*/*/*/*
Dim Ss As String * 6
Dim I1 As Integer
Dim I2 As Integer
Dim I3 As Integer
Dim I4 As Integer
Dim Dsid1(8) As Byte
Dim Dsid2(8) As Byte
Dim Dsid3(8) As Byte
Dim Dsid4(8) As Byte
Dim Ds_a_str As String * 6
Dim Ds_b_str As String * 6
Dim Ds_c_str As String * 6
Dim Ds_d_str As String * 6
'*/*/*/*/*/*/*/*/*/*/*/*/*
Enter Alias Pinb.2
Up Alias Pinb.3
Down Alias Pinb.0
'*/*/*/*/*/*/*/*/*/*/*/*/*
Enable Interrupts
Enable Timer1
enable timer0
enable ovf0
on ovf0 lable
Reset Portb.4
Stop Timer1
stop timer0
Timer1 = 0
timer0 = 0
'*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
Err_data = 0
Readeeprom _hour , 142
Readeeprom _min , 144
Readeeprom _sec , 146
Submain:
Cls
Reset Watchdog
Start Watchdog
Reset Watchdog
Readeeprom O , 8
Readeeprom Fan , 12
Readeeprom Po , 14
Readeeprom K_sater , 18
Readeeprom G_sater , 22
Readeeprom M3 , 26
Readeeprom M6 , 30
Readeeprom Rs , 34
Readeeprom Up_temp , 46
Readeeprom Rv , 58
Readeeprom Rv1 , 62
Readeeprom Rv2 , 66
Readeeprom Fa , 70
Readeeprom E_s_sater , 86
Readeeprom R_s_sater , 94
Readeeprom H_k , 98
Readeeprom T_k , 102
Readeeprom K_hach , 108
Readeeprom G_hach , 112
Readeeprom E_s_hach , 116
Readeeprom R_s_hach , 120
Readeeprom Sal , 124
Readeeprom Mah , 126
Readeeprom Ruz , 128
Readeeprom Ruz_sater , 130
Readeeprom Ruz_hacher , 132
Readeeprom Motor_hach , 134
Readeeprom Ruz_jojekeshi , 136
Readeeprom Jjj , 138
Readeeprom Program , 140
Readeeprom ravesh_motor,148
'/*/*/*/*/*/*/*/*/*/*/*/*/*
If Program > 0 Then
Ruz_sater = 18 : Writeeeprom Ruz_sater , 130 : Waitms 5
Ruz_hacher = 3 : Writeeeprom Ruz_hacher , 132 : Waitms 5
Ruz_jojekeshi = 21 : Writeeeprom Ruz_jojekeshi , 136 : Waitms 5
K_sater = 37.4 : Writeeeprom K_sater , 18 : Waitms 5
G_sater = 37.7 : Writeeeprom G_sater , 22 : Waitms 5
E_s_sater = 55.9 : Writeeeprom E_s_sater , 86 : Waitms 5
R_s_sater = 59 : Writeeeprom R_s_sater , 94 : Waitms 5
K_hach = 37 : Writeeeprom K_hach , 108 : Waitms 5
G_hach = 37.3 : Writeeeprom G_hach , 112 : Waitms 5
E_s_hach = 62 : Writeeeprom E_s_hach , 116 : Waitms 5
R_s_hach = 65 : Writeeeprom R_s_hach , 120 : Waitms 5
'/*/*/*/*/*/*/*/*/*/*/*/*/*
Sal = 1398 : Writeeeprom Sal , 124 : Waitms 5
Mah = 1 : Writeeeprom Mah , 126 : Waitms 5
Ruz = 21 : Writeeeprom Ruz , 128 : Waitms 5
Rs = 0 : Writeeeprom Rs , 34 : Waitms 5
M3 = 300 : Writeeeprom M3 , 26 : Waitms 5
M6 = 310 : Writeeeprom M6 , 30 : Waitms 5
Rv = 0 : Writeeeprom Rv , 58 : Waitms 5
Rv1 = 0 : Writeeeprom Rv1 , 62 : Waitms 5
Rv2 = 0 : Writeeeprom Rv2 , 66 : Waitms 5
Fan = 1 : Writeeeprom Fan , 12 : Waitms 5
Fa = 3 : Writeeeprom Fa , 70 : Waitms 5
Po = 30 : Writeeeprom Po , 14 : Waitms 5
H_k = 0 : Writeeeprom H_k , 98 : Waitms 5
T_k = 0 : Writeeeprom T_k , 102 : Waitms 5
O = 3 : Writeeeprom O , 8 : Waitms 5
Up_temp = 0.6 : Writeeeprom Up_temp , 46 : Waitms 5
Motor_hach = 0 : Writeeeprom Motor_hach , 134 : Waitms 5
H_k = 0 : Writeeeprom H_k , 98 : Waitms 5
T_k = 0 : Writeeeprom T_k , 102 : Waitms 5
Jjj = 0 : Writeeeprom Jjj , 138 : Waitms 5
Program = 0 : Writeeeprom Program , 140 : Waitms 5
_hour=1:_min=5:_sec=0
Writeeeprom _hour,142:waitms 5
Writeeeprom _min,144:waitms 5
Writeeeprom _sec,146:waitms 5
ravesh_motor=0
Writeeeprom ravesh_motor,148:waitms 5
End If
if _hour>23 then _hour=0
if _min>59 then _min=6
if _sec>59 then _sec=21

'/*/*/*/*/*/*/*/*/*/*/*/*/*
Conter = 500
An = 0
Ho = 0
Lt = 0
Ty = 0
Meno1 = 0
Meno2 = 0
Er_v = 0
M3_single = M3
M6_single = M6
Ty = 1
Oi = 0
Star_t = 2
time_hach_button=0
if ravesh_motor=1 then start timer0
'/*/*/*/*/*/*/*/*/*/*/*/*/*
Do
save_time=0
if _min=0 or _min=30 then  save_time=1
if save_time=1 and var_k=0 then
Writeeeprom _hour,142:waitms 5
Writeeeprom _min,144:waitms 5
Writeeeprom _sec,146:waitms 5
var_k=1
endif
if _min=2 or _min=32 then var_k=0
If Up = 1 And Enter = 1 And Down = 1 And Ao = 0 And Conter >= 1 Then Er_v = 0
If Portc.2 = 0 Then Er_v = 1
'//////
'///////
'//////
If Portc.2 = 0 And Ao = 0 Or Portb.7 = 1 Or Ao = 1 Then
Lt = 0
Ty = 0
Meno1 = 0
Meno2 = 0
End If
If Portb.7 = 1 And Lt = 0 And Mw = 0 Then
Locate 1 , 1
If Rs = 0 Then Yu = M3_single -fd
If Rs = 1 Then Yu = M6_single -fd
If Ruz_jojekeshi > Ruz_hacher Or Motor_hach = 1 Then
if ravesh_motor=0 then
Lcd "T-MOTOR~~~" ; Yu ; "   "
elseif ravesh_motor=1 then
Lcd "T-MOTOR~~~ Wait "
endif
Else
Lcd " T-MOTOR~~~P-W  "
End If
Qw = 100
End If
'------------
Reset Watchdog
Start Watchdog
If Ruz_jojekeshi <= Ruz_hacher Then
K = K_hach
G = G_hach
E_s = E_s_hach
R_s = R_s_hach
Else
K = K_sater
G = G_sater
E_s = E_s_sater
R_s = R_s_sater
End If
'/*/*/*/*/*/*/*
Waitms 108  '! Dont Chenge This Time.......
if ravesh_motor=0 then
If Ck = 1 Then If Pinc.1 = 1 Then Aw = 1
If Aw = 1 And Rs = 0 Then
Fd = Fd + 1.37
If Fd >= M3_single Then Reset Portb.7
End If
If Aw = 1 And Rs = 1 Then
Fd = Fd + 1.37
If Fd >= M6_single Then Reset Portb.7
End If
endif
Waitms 55
Locate 2 , 8
If Err_data <> 14 And Lt = 0 Then Lcd ","
If Mw = 1 Then
Incr Sda
If Sda <= 1 And Lt = 0 Then
Locate 1 , 1
Lcd "                "
Elseif Lt = 0 Then
Locate 1 , 1
Lcd "   Err Motor!   "
If Sda >= 2 Then Sda = 0
End If
End If
If Ab = 0 And Gh = 0 Then
Locate 2 , 9
If Err_data <> 14 And Lt = 0 Then
Lcd "T=" ; Dt50 ; Chr(0) ; "c "
Elseif Lt = 0 Then
Locate 2 , 1
If Var <= 2 Then Lcd "Err Sensor Read!"
End If
Else
If Err_data <> 14 And Lt = 0 Then
If Ak = 0 Then
If Dt50 < 10 Then
Locate 2 , 11
Lcd "   "
End If
If Dt50 >= 10 And Dt50 <= 99.9 Then
Locate 2 , 11
Lcd "    "
End If
If Dt50 > 99.9 Then
Locate 2 , 11
Lcd "     "
End If
Elseif Lt = 0 Then
Locate 2 , 9
Lcd "T=" ; Dt50 ; Chr(0) ; "c "
End If
End If
Incr Ak
If Ak >= 2 Then Ak = 0
End If
If Conter >= 1 Then
Decr Conter
Set Portc.2
Else
Reset Portc.2
End If
If Ao = 0 Then
Set Portc.4
Reset Portc.5
End If
If Ao = 1 Then
Reset Portc.4
Set Portc.5
End If
'''''''''''''''''''''''''''''''''''''''''''
Er = G + 0.5
if dt50>=Er then set portb.5
Er = G + Up_temp
If Dt50 >= Er Then
Set Portb.5
Lk = 1
Aq = 1
If Ac = 0 Then Ab = 1
End If
'''''''''''''''''''''''''''''''''''''''''''
If Rv = 1 Then
Ab = 0 : Gh = 0 : Qf = 0 : Gf = 0 : Mw = 0
Ao = 0
End If
If Rv1 = 1 Or Rv2 = 1 Then
Qf = 0 : Gf = 0
End If
If Ab = 0 And Gh = 0 And Qf = 0 And Gf = 0 And Mw = 0 And Err_data <> 14 Then Ao = 0
If Ab = 1 Or Gh = 1 Or Qf = 1 Or Gf = 1 Or Mw = 1 Or Err_data = 14 Then
An = 1
Ao = 1
Er_v = 1
Conter = 400
Incr Pu
If Pu >= 6 Then Pu = 0
If Pu < 3 Then
Set Portc.3
Else
Reset Portc.3
End If
Else
If Enter = 1 Then An = 0
Reset Portc.3
Pu = 0
End If
If Dt50 <= G Then
Ac = 0
Ab = 0
End If
If Dt50 <= G And Lk = 1 Then
Reset Portc.3
Reset Portb.6
Err4 = R_s + 3
if humidity<err4 then Reset Portb.5
Aq = 0
Lk = 0
End If
'''''''''''''''''''''''''''''''''''''''''''
If Dt50 < K And Lk = 0 And Err_data <> 14 Then
If _sec => 58 Then Ppt = 1
If Ppt = 1 And _sec < 50 Then
Incr Err2
Ppt = 0
End If
End If
If Err2 >= 7 Then
Gh = 1
Err2 = 0
End If
If Dt50 => K Then
Err2 = 0
Gh = 0
End If
'/*/*/*/*/*/*/*/*/*
Err4 = R_s + 5
Er = K - 2
if humidity>=err4 and dt50>er then set portb.5
if dt50<=er then reset portb.5
If Humidity >= Err4 And Err_data <> 14 Then
If _sec >= 58 Then Ppr = 1
If Ppr = 1 And _sec < 50 Then
Incr W
Ppr = 0
End If
If W >= 10 Then
Gf = 1
Er = K - 2
if dt50>er then set portb.5
W = 0
End If
End If
If Humidity <= R_s Then
Gf = 0
W = 0
if dt50<=G then reset portb.5
End If
if dt50<=G then
Err4 = R_s + 5
if humidity<err4 then Reset Portb.5
endif
'*/*/*/*/*/*/*/*/*/*/*
If Humidity < E_s And Err_data <> 14 Then
If _sec >= 58 And Ppy = 0 Then Ppy = 1
If Ppy = 1 And _sec < 50 Then
Incr Qa
Ppy = 0
End If
If Qa >= 7 Then
Qf = 1
Qa = 0
End If
End If
If Humidity >= E_s Then
Qf = 0
Qa = 0
End If
'''''''''''''''''''''''''''''''''''''''''''
If _sec <> 59 Then Pp = 0
If Portb.7 = 1 Then Eds = 1
If Eds = 1 Then
If _sec >= 59 And Pp = 0 Then
Incr Mds
Pp = 1
End If
End If
If Mds >= 4 Then
Mds = 0
Reset Portb.7
Eds = 0
Mw = 1
End If
Incr Qw
If Qw >= 90 And Portb.7 = 0 Then Qw = 0
If Qw >= 90 And Ao = 1 Then Qw = 0
df=1
'=====================================
If O = 1 Then If _min = 0 And _sec =< 3 Or _min = 30 And _sec =< 3 Then Df = 0
'=====================================
If O = 2 Then If _min = 0 And _sec <= 3 Then Df = 0
'=====================================
If O = 3 Then Df = _hour Mod 2
'=====================================
If O = 4 Then Df = _hour Mod 3
'=====================================
If O = 5 Then Df = _hour Mod 4
'=====================================
'/////
If _hour = 0 And _min = 59 And _sec >= 0 Then Vvv = 0
If _hour = 0 And _min = 0 And _sec <= 10 And Vvv = 0 Then
If Ruz_jojekeshi >= 1 Then
Decr Ruz_jojekeshi
Writeeeprom Ruz_jojekeshi , 136
Waitms 5
Vvv = 1
End If
End If
'////

If Jjj = 0 And Motor_hach = 0 And Ruz_jojekeshi <= Ruz_hacher Then
if ravesh_motor=0 then
If _min >= 3 Then
Reset Portb.7
Jjj = 1
Writeeeprom Jjj , 138
Waitms 5
O = 6
Ck = 0
Df = 1
End If
endif 'end ravesh_motor
endif
If Df = 0 And Motor_hach = 0 And Ruz_jojekeshi <= Ruz_hacher Then
if ravesh_motor=0 then
If Pinc.1 = 1 Then
Reset Portb.7
O = 6
Ck = 0
Df = 1
Jjj = 1
Writeeeprom Jjj , 138
Waitms 5
End If
endif 'end ravesh_motor
Else
if ravesh_motor=0 then
If Jjj = 1 Then
Jjj = 0
Writeeeprom Jjj , 138
Waitms 5
End If
endif 'end ravesh_motor
'============
d=0
if _min=0 then d=1
if _min=30 and o=1 then d=1
If Ruz_jojekeshi >= Ruz_hacher And Df = 0 And d = 1 And _sec <= 2 Then Set Portb.7
If Motor_hach = 1 And Df = 0 And d = 1 And _sec <= 2 Then Set Portb.7

Ck = 1

End If
If Jjj = 1 Then Reset Portb.7
'=====================================
If O = 6 Then Reset Portb.7
'=====================================
if ravesh_motor=0 then
If Ck = 1 Then
If Rs = 0 Then
If Pinc.1 = 1 Then Aw = 1
If Aw = 1 Then
Fd = Fd + 1.37
If Fd >= M3_single Then
Reset Portb.7
Ck = 0
Fd = 0
Rs = 1
Fd = 0
Aw = 0
Eds = 0
Mds = 0
df=1
Writeeeprom Rs , 34
Waitms 5
End If
End If
End If
End If
endif 'end ravesh_motor
'=====================================
if ravesh_motor=0 then
If Ck = 1 Then
If Rs = 1 Then
If Pinc.1 = 1 Then Aw = 1
If Aw = 1 Then
Fd = Fd + 1.37
If Fd >= M6_single Then
Reset Portb.7
Ck = 0
Fd = 0
Rs = 0
Fd = 0
Aw = 0
Eds = 0
Mds = 0
df=1
Writeeeprom Rs , 34
Waitms 5
End If
End If
End If
End If
endif 'end ravesh_motor
'==========================================
If Fan = 1 Then
Rq = _min Mod 10
If Rq = 0 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 2 Then
Rq = _min Mod 20
If Rq = 0 And Po > _sec Or _min = 30 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 3 Then
If _min = 0 And Po > _sec Or _min = 30 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 4 Then
If _min = 0 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 5 Then
Rq = _hour Mod 2
If Rq = 0 And _min = 0 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 6 Then
Rq = _hour Mod 4
If Rq = 0 And _min = 0 And Po > _sec Then Set Portb.6
Else
If Po <= _sec And Aq = 0 Then Portb.6 = 0
End If
'==========================================
If Fan = 8 Then Set Portb.6                                 'all on
'==========================================
If Fan = 7 And Aq = 0 Then Reset Portb.6                    'all off
'==========================================
If Lt = 0 Then
If Qw < 30 And Mw = 0 And Portb.7 = 0 Then
Locate 1 , 1
Lcd "S=" ; K ; "C~~R=" ; G ; "C "
If Qw = 30 Then Cls
End If
If Qw >= 30 And Qw < 60 And Mw = 0 And Portb.7 = 0 Then
Locate 1 , 1
Lcd "S=" ; E_s ; "%" ; "~~" ; "R=" ; R_s ; "% "
If Qw = 60 Then Cls
End If
If Qw >= 60 And Qw < 90 And Mw = 0 And Portb.7 = 0 Then
Locate 1 , 1
Lcd "    " ; Time$ ; "      "
End If
If Rv1 = 0 Then
If Gf = 0 And Qf = 0 Then
If Humidity < 10 Then
If Err_data <> 14 Then
Locate 2 , 1
Lcd "H=" ; Humidity ; "%"
Else
If Var <= 2 Then Lcd "Err Sensor Read!"
End If
End If
If Humidity >= 10 Then
If Err_data <> 14 Then
Locate 2 , 1
Lcd "H=" ; Humidity ; "%"
Else
If Var <= 2 Then Lcd "Err Sensor Read!"
End If
End If
Else
If Dg = 0 Then
If Humidity < 10 And Err_data <> 14 Then
Locate 2 , 3
Lcd "   "
End If
If Humidity >= 10 And Humidity <= 99.9 And Err_data <> 14 Then
Locate 2 , 3
Lcd "    "
End If
Else
Locate 2 , 1
If Err_data <> 14 Then
Lcd "H=" ; Humidity ; "%"
Else
If Var <= 2 Then Lcd "Err sensor Read!"
End If
End If
Incr Dg
If Dg >= 2 Then Dg = 0
End If
Else
Locate 2 , 1
If Err_data <> 14 Then Lcd "H=" ; "OFF "
End If
End If
If Enter = 0 And Ho = 0 Then
Set Portc.2
Conter = 400
Ab = 0
Ac = 1
Gh = 0
Gf = 0
Qf = 0
Mw = 0
Ao = 0
Incr Ax
If Lt = 0 And Ty = 0 And Meno1 = 0 And Meno2 = 0 Then
If Ax >= 3 And Er_v = 0 Or Err_data = 14 And Ax >= 3 Then
Cls
Waitms 500
Reset Watchdog
Ax = 0
Sn = 1
Ho = 1
Reset Portc.4
Reset Portc.3
stop timer0
Goto Settemp_humidity
End If
Else
Lt = 0
Ty = 0
Meno1 = 0
Meno2 = 0
Ho = 1
End If
End If
If Enter = 1 Then
Ho = 0
Ax = 0
End If
If Up = 0 Or Down = 0 Then
Set Portc.2
Conter = 400
Ab = 0
Ac = 1
Gh = 0
Gf = 0
Qf = 0
Mw = 0
Ao = 0
End If
If Down = 1 And Up = 1 Then Us = 0
If Up = 0 And Er_v = 0 Then
If Meno1 = 0 And Ao = 0 And Us = 0 Then
Lt = 1
Ty = 1
Meno1 = 1
Meno2 = 0
Us = 1
Elseif Us = 0 And Meno1 = 1 And Up = 0 Then
Cls
Waitms 100
Lt = 0
Ty = 0
Meno1 = 0
Meno2 = 0
Us = 1
End If
End If
If Down = 0 And Meno2 = 0 And Portc.3 = 0 And Us = 0 And Er_v = 0 And Portb.7 = 0 Then
Cls
Waitms 100
Meno2 = 1
Meno1 = 0
Lt = 1
Us = 1
Elseif Us = 0 And Meno2 = 1 And Down = 0 Then
Meno2 = 0
Lt = 0
Us = 1
Cls
End If
Incr Oi
'/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
if ravesh_motor=0 then stop timer0
Reset Watchdog
I = 1
if ravesh_motor=1 then:disable ovf0:stop timer0:endif
Stop Timer1
Timer1 = 0
Ddrb.1 = 1
Portb.1 = 0
Waitms 20
Reset Watchdog
I = 1
Ddrb.1 = 0
T_d = 0
While I < 34
Timer1 = 0
While Pinb.1 = 0
Incr T_d
If T_d > 3000 Then Exit While
Reset Watchdog
Wend
If T_d <= 3000 Then T_d = 0
Start Timer1
While Pinb.1 = 1
Incr T_d
If T_d > 3000 Then Exit While
Reset Watchdog
Wend
If T_d <= 3000 Then T_d = 0
Stop Timer1
Incr T_d
If T_d > 3000 Then Exit While
If Timer1 < 500 Then Recive_data = Recive_data + "0"
If Timer1 > 700 Then Recive_data = Recive_data + "1"
Incr I
If Timer1 >= 1200 And I < 34 Then
Recive_data = ""
I = 1
Else
If Timer1 >= 1200 Then Exit While
End If
Wend
If I < 34 Then
Incr Err_data
If Err_data >= 14 Then
Err_data = 14
Gf = 0
W = 0
Qf = 0
Qa = 0
Err2 = 0
Gh = 0
Aq = 0
Lk = 0
Lt = 0
Ty = 0
If Meno1 = 1 Or Meno2 = 1 Then Cls
Meno1 = 0
Meno2 = 0
End If
Else
Err_data = 0
Var = 0
End If
Temp_manfi = Left(recive_data , 1)
Temp_r = Mid(recive_data , 2 , 12)
Temp_sr = Left(temp_r , 8)
Temp_ar = Right(temp_r , 4)
Temp_s = Binval(temp_sr)
Temp_a = Binval(temp_ar)
Temp_1 = Str(temp_s)
Temp_2 = Str(temp_a)
If Temp_manfi = "1" Then
Temp_data = "-" + Temp_1
Temp_data = Temp_data + "."
Temp_data = Temp_data + Temp_2
Elseif Temp_manfi = "0" Then
Temp_data = Temp_1 + "."
Temp_data = Temp_data + Temp_2
End If
Temp_datan = Val(temp_data)
Temp = Temp_datan
Temp_sht = Fusing(temp , "##.#")
Dt50_test = Val(temp_sht)
If Dt50_test >= 100 Then : Dt50_test = 99.9 : T_k = 0 : End If
'/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
H_r = Mid(recive_data , 14 , 12)
H_sr = Left(h_r , 8)
H_ar = Right(h_r , 4)
H_s = Binval(h_sr)
H_a = Binval(h_ar)
H_1 = Str(h_s)
H_2 = Str(h_a)
H_data = H_1 + "."
H_data = H_data + H_2
H_datan = Val(h_data)
H_str = Fusing(h_datan , "##.#")
Humidity_test = Val(h_str)
'/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
Temp_abs = Abs(dt50_test)
Crch_s = Int(humidity_test)
Crctemp_s = Int(temp_abs)
Crctemp_s = Abs(crctemp_s)
Crch_1 = Frac(humidity_test)
Crctemp_1 = Frac(temp_abs)
Crch_1 = Crch_1 * 10.01
Crctemp_1 = Crctemp_1 * 10.01
Crch_a = Int(crch_1)
Crctemp_a = Int(crctemp_1)
Crc_data1 = Crch_s + Crctemp_s
Crc_data1 = Crc_data1 + Crch_a
Crc_data1 = Crc_data1 + Crctemp_a
Crc_data = Int(crc_data1)
'=============
Crc_datarecive = Right(recive_data , 8)
Crc_binval = Binval(crc_datarecive)
If Star_t = 0 Then
If Humidity_test >= 100 Then : Humidity_test = 99.9 : H_k = 0 : End If
Dt50 = Dt50_test
Dt50 = Dt50 + T_k
Humidity = Humidity_test
Humidity = Humidity + H_k
End If
'/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
if ravesh_motor=1 then:timer0=0:enable ovf0:start timer0:endif
Reset Watchdog
If Humidity <= E_s And Err_data <> 14 Then
Set Portd.3
End If
If Humidity >= R_s Or Err_data = 14 Then
Reset Portd.3
End If

dt50=dt50-0.05
If Dt50 =< K And E_rn = 0 Then Set Portd.2
dt50=dt50+0.05

dt50=dt50+0.05
If Dt50 >= G Then Reset Portd.2
dt50=dt50-0.05
'/////'kod amniaty baraye hiter\\\\\
if err_data>=14 then dt50=0
If Dt50 < 2 Then
Reset Portd.2
E_rn = 1
Else
E_rn = 0
End If
'///////////////////////////////////
Reset Watchdog
If T_d < 50 Then
Test_h = 0
Else
Incr Test_h
If Test_h >= 16 Then
Dt50 = 0
Humidity = 0
End If
End If
If Err_data = 14 Then
Incr Var
If Var > 3 Then Var = 0
If Var > 2 Then
Locate 2 , 1
Lcd "                "
End If
End If
Waitms 20
Reset Watchdog
Reset Watchdog
If Star_t > 0 Then Decr Star_t
'//////////////////////////////////////////
If  Portb.7 = 0 and up=0 Then
Lt = 0
Ty = 0
Meno1 = 0
Meno2 = 0

incr time_hach_button
if time_hach_button=15 then
cls
locate 1,1
if Ruz_jojekeshi>Ruz_hacher then
Ruz_jojekeshi = Ruz_hacher
lcd"Vorod Be Hacher"
elseif Ruz_jojekeshi<=Ruz_hacher then
Ruz_jojekeshi = Ruz_sater
lcd"Vorod Be Sater"
endif
Writeeeprom Ruz_jojekeshi , 136 : Waitms 5
time_hach_button=16
wait 1
endif
endif
if up=1 then  time_hach_button=0
If Meno2 = 1 And Portb.7 = 0 Then
Locate 1 , 4 : Lcd Sal ; "/"
Locate 1 , 9
If Mah >= 10 Then
Lcd Mah ; "/"
Else
Lcd ; "0" ; Mah ; "/"
End If
Locate 1 , 12
If Ruz >= 10 Then
Lcd Ruz ; " "
Else
Lcd ; "0" ; Ruz ; " "
End If
Locate 2 , 2
If Ruz_jojekeshi > 0 Then
Lcd "RUZ=" ; Ruz_jojekeshi ; "  "
Else
Lcd "RUZ=END"
End If
If Ruz_jojekeshi > Ruz_hacher Then
Locate 2 , 10
Lcd ", SATER"
Else
Locate 2 , 9
Lcd ",HACHER "
End If
End If

'///////////////////////////////////////////
Loop
'###############################################################################
Settemp_humidity:
Reset Portb.7
Reset Portb.6
Reset Portb.5
Reset Portd.2
Reset Portd.3
Reset Portc.3
Cursor Off
Cls
Reset Watchdog
Waitms 500
Reset Watchdog
Dc = 0
If Sn = 1 Then V_help = K_sater
If Sn = 2 Then V_help = G_sater
If Sn = 3 Then V_help = E_s_sater
If Sn = 4 Then V_help = R_s_sater
If Sn = 5 Then V_help = K_hach
If Sn = 6 Then V_help = G_hach
If Sn = 7 Then V_help = E_s_hach
If Sn = 8 Then V_help = R_s_hach
Do
Reset Watchdog
If Enter = 1 Then Ho = 0
Locate 1 , 1
If Sn = 1 Then Lcd "SET T ON SATER"
If Sn = 2 Then Lcd "SET T OFF SATER"
If Sn = 3 Then Lcd "SET H ON SATER"
If Sn = 4 Then Lcd "SET H OFF SATER"
If Sn = 5 Then Lcd "SET T ON HACHER"
If Sn = 6 Then Lcd "SET T OFF HACHER"
If Sn = 7 Then Lcd "SET H ON HACHER"
If Sn = 8 Then Lcd "SET H OFF HACHER"
If Up = 1 And Down = 1 Then Dc = 0
If Up = 0 Then
V_help = V_help + 0.1
If Dc <= 10 Then Waitms 60
If Dc > 10 Then Waitms 5
If Dc <= 10 Then Incr Dc
End If
If V_help > 99 Then : V_help = 0
End If
If Down = 0 Then
V_help = V_help - 0.1
If Dc <= 10 Then Waitms 60
If Dc > 10 Then Waitms 5
If Dc <= 10 Then Incr Dc
End If
If V_help < 0 Then : V_help = 99
End If
K_str = Fusing(v_help , "##.#")
V_help = Val(k_str)
If Enter = 0 And Ho = 0 Then
If Sn = 2 Then Ml = V_help - K_sater
If Sn = 4 Then Ml = V_help - E_s_sater
If Sn = 6 Then Ml = V_help - K_hach
If Sn = 8 Then Ml = V_help - E_s_hach
Fn = Sn Mod 2
Ml_str = Fusing(ml , "##.#")
Ml = Val(ml_str)
If Ml < 0.2 And Fn = 0 Then
Cls
Locate 1 , 6
Lcd "Error"
Decr Sn
Waitms 200
Goto Settemp_humidity
Else
If Sn = 1 Then
K_sater = V_help
Writeeeprom K_sater , 18
Waitms 5
Elseif Sn = 2 Then
G_sater = V_help
Writeeeprom G_sater , 22
Waitms 5
Elseif Sn = 3 Then
E_s_sater = V_help
Writeeeprom E_s_sater , 86
Waitms 5
Elseif Sn = 4 Then
R_s_sater = V_help
Writeeeprom R_s_sater , 94
Waitms 5
Elseif Sn = 5 Then
K_hach = V_help
Writeeeprom K_hach , 108
Waitms 5
Elseif Sn = 6 Then
G_hach = V_help
Writeeeprom G_hach , 112
Waitms 5
Elseif Sn = 7 Then
E_s_hach = V_help
Writeeeprom E_s_hach , 116
Waitms 5
Elseif Sn = 8 Then
R_s_hach = V_help
Writeeeprom R_s_hach , 120
Waitms 5
End If
Ho = 1
Incr Sn
If Sn > 8 Then
Goto Tarikh
Else
Goto Settemp_humidity
End If
End If
End If
If Sn = 2 Then Ml = V_help - K_sater
If Sn = 4 Then Ml = V_help - E_s_sater
If Sn = 6 Then Ml = V_help - K_hach
If Sn = 8 Then Ml = V_help - E_s_hach
Locate 2 , 1
If Sn <= 2 Or Sn > 4 And Sn < 7 Then Lcd "TEMP=" ; V_help ; Chr(0) ; "c  "
If Sn > 2 And Sn < 5 Or Sn > 6 Then Lcd "HUMIDITY=" ; V_help ; "%  "
Loop
'###############################################################################
Tarikh:
       Cls
       Reset Watchdog
       Waitms 500
       Sn = 0
       Ee = 0
       Ho = 1
       Do
       Incr Sn
       Reset Watchdog
       Locate 1 , 1
       If Sn >= 5 And Ee = 0 Then
       Lcd "       "
       Else
       Lcd "   " ; Sal ; "/"
       End If
       Locate 1 , 9
       If Sn >= 5 And Ee = 1 Then
       Lcd "  "
       Else
       If Mah >= 10 Then Lcd Mah ; "/"
       If Mah < 10 Then Lcd ; "0" ; Mah ; "/"
       End If
       Locate 1 , 12
       If Sn >= 5 And Ee = 2 Then
       Lcd "     "
       Else
       If Ruz >= 10 Then Lcd Ruz ; "   "
       If Ruz < 10 Then Lcd ; "0" ; Ruz ; "   "
       End If
       Locate 2 , 5
       If Sn >= 5 And Ee = 3 Then
       Lcd "  "
       Else
       If _hour >= 10 Then Lcd _hour ; ":"
       If _hour < 10 Then Lcd ; "0" ; _hour ; ":"
       End If
       Locate 2 , 8
       If Sn >= 5 And Ee = 4 Then
       Lcd "  "
       Else
       If _min >= 10 Then Lcd _min ; ":"
       If _min < 10 Then Lcd ; "0" ; _min ; ":"
       End If
       Locate 2 , 11
       If _sec >= 10 Then Lcd _sec ; "   "
       If _sec < 10 Then Lcd ; "0" ; _sec ; "   "
'------------------------------------------
If Ee = 0 Then V_help = Sal
If Ee = 1 Then V_help = Mah
If Ee = 2 Then V_help = Ruz
If Ee = 3 Then V_help = _hour
If Ee = 4 Then V_help = _min
If Up = 0 Then
Incr V_help
Sn = 0
Waitms 50
End If
If Down = 0 Then
Decr V_help
Sn = 0
Waitms 50
End If
'-------------------------------------
If Ee = 0 Then
Sal = V_help : If Sal > 1999 Then Sal = 1394 : If Sal < 1394 Then Sal = 1999 : End If
If Ee = 1 Then : Mah = V_help : If Mah > 12 Then Mah = 1 : If Mah < 1 Then Mah = 12 : End If
If Ee = 2 Then
Ruz = V_help
If Mah <= 6 Then
If Ruz > 31 Then Ruz = 1 : If Ruz < 1 Then Ruz = 31
Else
If Ruz > 30 Then Ruz = 1 : If Ruz < 1 Then Ruz = 30
End If
End If
If Ee = 3 Then : If V_help > 23 Then V_help = 0 : If V_help < 0 Then V_help = 23 : _hour = V_help : End If
If Ee = 4 Then : If V_help > 59 Then V_help = 0 : If V_help < 0 Then V_help = 59 : _min = V_help : End If
'-------------------------------------
If Enter = 1 Then Ho = 0
If Enter = 0 And Ho = 0 Then
If Ee = 0 Then : Writeeeprom Sal , 124 : Waitms 5 : End If
If Ee = 1 Then : Writeeeprom Mah , 126 : Waitms 5 : End If
If Ee = 2 Then : Writeeeprom Ruz , 128 : Waitms 5 : End If
Incr Ee
Ho = 1
End If
If Ee = 5 Then
Writeeeprom _hour,142:waitms 5
Writeeeprom _min,144:waitms 5
Writeeeprom _sec,146:waitms 5
Goto Setmotor
endif
If Sn > 10 Then Sn = 0
Loop
'###############################################################################
Setmotor:
         Cls
         Reset Watchdog
         Readeeprom O , 8
         Waitms 500
         Reset Watchdog
         If O > 100 Then O = 1
         Us = 0
         Ho = 1
         Do
         If Us >= 17 Then Us = 0
         Incr Us
         Reset Watchdog
         If Enter = 1 Then Ho = 0
         If Up = 0 Then
         Incr O
         Us = 0
         Waitms 200
         If O > 6 Then O = 1
         End If
         If Down = 0 Then
         Decr O
         Waitms 200
         Us = 0
         If O < 1 Then O = 6
         End If
         If O <= 5 Then
         Home
         Lcd "TIME MOTOR = ON "
         If Us <= 9 Then
         Home L
         If O = 1 Then Lcd "OFTER 30 MIN  "
         If O = 2 Then Lcd "OFTER 1 HOUR  "
         If O = 3 Then Lcd "OFTER 2 HOUR  "
         If O = 4 Then Lcd "OFTER 3 HOUR  "
         If O = 5 Then Lcd "OFTER 4 HOUR  "
         Else
         Home L
         Lcd "               "
         End If
         End If
         If O = 6 And Us <= 9 Then
         Home
         Lcd "TIME MOTOR = OFF"
         Home L
         Lcd "                "
         End If
         If O = 6 And Us > 9 Then
         Locate 1 , 14
         Lcd "   "
         Waitms 20
         End If
         Waitms 10
         If Enter = 0 And Ho = 0 Then
         Writeeeprom O , 8
         Waitms 5
         Ho = 1
         Goto Hach_and_day
         End If
         Loop
'###############################################################################
Hach_and_day:
             Cls
             Reset Watchdog
             Waitms 500
             Do
             Reset Watchdog
             Home
             Lcd "T-RUZE SAT&HACH?"
             Home L
             Lcd "YES=UP...NO=DOWN"
             If Up = 0 Then Exit Do
             If Down = 0 Then
             Cls
             Goto Check1
             End If
             Loop
             Cls
             Waitms 500
             Reset Watchdog
             Ho = 1
             Ee = 0
             Sn = 0
             Us = 0
             If Motor_hach > 10 Then Motor_hach = 0
             Do
             Incr Sn
             If Sn > 20 Then Sn = 0
             If Enter = 1 Then Ho = 0
             If Up = 1 And Down = 1 Then Ee = 0
             If Us = 0 Then Ruz_j = Ruz_sater
             If Us = 1 Then Ruz_j = Ruz_hacher
             Locate 1 , 1
             If Us = 0 Then Lcd "TEDAD-RUZ-SATER "
             If Us = 1 Then Lcd "TEDAD-RUZ-HACHER"
             If Us = 2 Then Lcd " MOTOR-DAR-HECH!"
             Locate 2 , 2
             If Us = 0 And Sn <= 10 Then Lcd Ruz_j ; " RUZ!  "
             If Us = 1 And Sn <= 10 Then Lcd Ruz_j ; " RUZ!  "
             If Us = 2 And Motor_hach = 0 And Sn <= 10 Then Lcd "KHAMOSH_BASHAD  "
             If Us = 2 And Motor_hach = 1 And Sn <= 10 Then Lcd "ROSHAN_BASHAD   "
             Locate 2 , 2
             If Sn > 10 And Us < 2 Then
             If Ruz_j < 10 Then Lcd "  "
             If Ruz_j >= 10 Then Lcd "   "
             End If
             If Sn > 10 And Us = 2 Then Lcd "                "
             If Up = 0 Then
             Sn = 0
             Waitms 50
             If Us < 2 Then Incr Ruz_j
             If Us = 2 And Ee = 0 Then
             Incr Motor_hach
             If Motor_hach > 1 Then Motor_hach = 1
             Ee = 1
             End If
             If Ruz_j > 99 And Us = 0 Then Ruz_j = 1
             If Ruz_j > 10 And Us = 1 Then Ruz_j = 1
             End If
             If Down = 0 Then
             Sn = 0
             Waitms 50
             If Us < 2 Then Decr Ruz_j
             If Us = 2 And Ee = 0 Then
             Decr Motor_hach
             If Motor_hach > 10 Then Motor_hach = 0
             Ee = 1
             End If
             If Ruz_j < 1 And Us = 0 Then Ruz_j = 99
             If Ruz_j < 1 And Us = 1 Then Ruz_j = 10
             End If
             If Us = 0 Then Ruz_sater = Ruz_j
             If Us = 1 Then Ruz_hacher = Ruz_j
             If Enter = 0 And Ho = 0 Then
             Cls
             If Us = 0 Then Writeeeprom Ruz_sater , 130
             Waitms 5
             If Us = 1 Then
             Writeeeprom Ruz_hacher , 132
             Waitms 5
             Ruz_jojekeshi = Ruz_sater + Ruz_hacher
             Writeeeprom Ruz_jojekeshi , 136
             Waitms 5
             End If
             If Us = 2 Then Writeeeprom Motor_hach , 134
             Waitms 5
             Incr Us
             If Us >= 3 Then Goto Check1
             Waitms 200
             Ho = 1
             End If
             Reset Watchdog
             Loop
'###############################################################################
Check1:
       'Reset Portb.7
       'Reset Portb.6
       'Reset Portb.5
       'Reset Portd.2
       'Reset Portd.3
       'Reset Portc.3
       Cls
       Reset Watchdog
       Waitms 500
       Reset Watchdog
       Do
       Reset Watchdog
       If Enter = 1 Then Ho = 0
       If Down = 1 And D1 = 1 Then D1 = 2
       If Down = 1 And D1 = 3 Then D1 = 0
       Locate 1 , 1
       Lcd "MOTOR=UP"
       Locate 2 , 1
       Lcd "ROTUBAT=DOWN"
       If Up = 0 Then
       Set Portb.7
       Else
       If Up = 1 Then Reset Portb.7
       End If
       If Portb.7 = 1 Then
       Locate 1 , 16
       Lcd "S"
       End If
       If Portb.7 = 0 Then
       Locate 1 , 16
       Lcd "R"
       End If
       If Down = 0 And D1 = 0 Then
       Set Portd.3
       D1 = 1
       End If
       If Down = 0 And D1 = 2 Then
       Reset Portd.3
       D1 = 3
       End If
       If Portd.3 = 1 Then
       Locate 2 , 16
       Lcd "S"
       End If
       If Portd.3 = 0 Then
       Locate 2 , 16
       Lcd "R"
       End If
       If Enter = 0 And Ho = 0 Then
       Cls
       Ho = 1
       Reset Portd.3
       Waitms 100
       Goto Check2
       End If
       Waitms 100
       Loop
'###############################################################################
Check2:
       Reset Portb.7
       Reset Portb.6
       Reset Portb.5
       Reset Portd.2
       Reset Portd.3
       Reset Portc.3
       Cls
       Reset Watchdog
       Waitms 500
       Reset Watchdog
       Do
       Reset Watchdog
       If Enter = 1 Then Ho = 0
       If Down = 1 And D1 = 1 Then D1 = 2
       If Down = 1 And D1 = 3 Then D1 = 0
       If Up = 1 And Nb = 1 Then Nb = 2
       If Up = 1 And Nb = 3 Then Nb = 0
       Locate 1 , 1
       Lcd "DAMA=UP"
       Locate 2 , 1
       Lcd "TAHVIE=DOWN"
       If Up = 0 And Nb = 0 Then
       Set Portd.2
       Nb = 1
       Else
       If Up = 0 And Nb = 2 Then
       Reset Portd.2
       Nb = 3
       End If
       End If
       If Portd.2 = 1 Then
       Locate 1 , 16
       Lcd "S"
       End If
       If Portd.2 = 0 Then
       Locate 1 , 16
       Lcd "R"
       End If
       If Down = 0 And D1 = 0 Then
       Set Portb.6
       D1 = 1
       End If
       If Down = 0 And D1 = 2 Then
       Reset Portb.6
       D1 = 3
       End If
       If Portb.6 = 1 Then
       Locate 2 , 16
       Lcd "S"
       End If
       If Portb.6 = 0 Then
       Locate 2 , 16
       Lcd "R"
       End If
       If Enter = 0 And Ho = 0 Then
       Cls
       Ho = 1
       Reset Portb.6
       Waitms 100
       Goto Check3
       End If
       Loop
'###############################################################################
Check3:
       Reset Portb.7
       Reset Portb.6
       Reset Portb.5
       Reset Portd.2
       Reset Portd.3
       Reset Portc.3
       Cls
       Reset Watchdog
       Waitms 500
       Reset Watchdog
       Do
       Reset Watchdog
       If Enter = 1 Then Ho = 0
       If Up = 1 And Bn = 1 Then Bn = 2
       If Up = 1 And Bn = 3 Then Bn = 0
       Locate 1 , 1
       Lcd "T-EZTERARY=UP"
       If Up = 0 And Bn = 0 Then
       Set Portb.5
       Bn = 1
       End If
       If Up = 0 And Bn = 2 Then
       Reset Portb.5
       Bn = 3
       End If
       If Portb.5 = 0 Then
       Locate 1 , 16
       Lcd "R"
       Else
       Locate 1 , 16
       Lcd "S"
       End If
       If Enter = 0 And Ho = 0 Then
       Cls
       Ho = 1
       Reset Portb.5
       Waitms 100
       Goto Tahvie
       End If
       Loop
'###############################################################################
Tahvie:
       Cls
       Reset Watchdog
       Waitms 500
       Reset Watchdog
       Ee = 1
       ho=1
       nj=0:nh=0
       Do
       incr nj : if Ee=2 then incr nh
       Reset Watchdog
       If Enter = 1 Then Ho = 0
       If Up = 0 And Ee = 1 Then
       Incr Fan
       If Fan > 8 Then Fan = 1
       Waitms 300
       End If
       If Down = 0 And Ee = 1 Then
       Decr Fan
       If Fan < 1 Then Fan = 8
       Waitms 300
       End If
       If Up = 0 And Ee = 2 Then
       Incr Fa
       If Fa > 5 Then Fa = 1
       Waitms 300
       End If
       If Down = 0 And Ee = 2 Then
       Decr Fa
       If Fa < 1 Then Fa = 5
       Waitms 300
       End If
       If Enter = 0 And Ho = 0 Then
       Incr Ee
       If Ee > 3 Then Ee = 3
       ho=1
       End If
       If Fan = 1 Then Ff = 10
       If Fan = 2 Then Ff = 20
       If Fan = 3 Then Ff = 30
       If Fan = 4 Then Ff = 1
       If Fan = 5 Then Ff = 2
       If Fan = 6 Then Ff = 4
       If Fan = 7 Then
       Home
       Lcd "TIME T= ALL OFF  "
       End If
       If Fan >= 8 Then
       Home
       Lcd "TIME T= ALL ON  "
       End If
       If Ee = 1 Then
       If Fan < 7 and nj>13 Then
       Locate 1 , 8
       Lcd "  "
       End If
       End If
       If Fan => 1 And Fan <= 3 and nj<=13 Then
       Locate 1 , 1
       Lcd "TIME T=" ; Ff ; " M      "
       End If
       If Fan > 3 And Fan < 7 and nj<=13 Then
       Locate 1 , 1
       Lcd "TIME T=" ; Ff ; " H      "
       End If
       If Fa = 1 Then Po = 10
       If Fa = 2 Then Po = 20
       If Fa = 3 Then Po = 30
       If Fa = 4 Then Po = 40
       If Fa = 5 Then Po = 50

       If Ee = 2 and nh>17 Then
       Locate 2 , 7
       Lcd "   "
       End If
       If Fan < 7 Then
       if nh<=17 then
       Locate 2 , 1
       Lcd "SET T=" ; Po ; "  SEC   "
       endif
       Else
       Locate 2 , 1
       Lcd "                "
       End If
       If Ee = 3 Then
       Ee = 1
       Cls
       Writeeeprom Fan , 12
       Waitms 5
       Writeeeprom Po , 14
       Waitms 5
       Writeeeprom Fa , 70
       Waitms 5
       Jh = 0
       Cls
       Ho = 1
       Waitms 500
       Reset Watchdog
       Goto Rav_motor
       End If
       if nj>26 then nj=0
       if nh>35 then nh=0
       if up=0 or down=0 then : nh = 0 : nj = 0 : endif
       Loop
'###############################################################################
Rav_motor:
          Var_cont = 0
          do
          Reset Watchdog
          incr var_cont
          Home
          Lcd " CONTROL MOTOR?   "
          Home L
          if var_cont<15 then
          if ravesh_motor=1 then
          Lcd "Ba Micro Switch"
          else
          Lcd "    Ba Madon    "
          endif
          else
          Lcd "                 "
          endif
          if var_cont>23 then var_cont=0
          if up=0 then
          ravesh_motor=1
          var_cont=0
          endif
          if down=0 then
          ravesh_motor=0
          var_cont=0
          endif
          if enter=0 and ho=0 then
          ho=1
          if ravesh_motor>1 then ravesh_motor=0
          Writeeeprom ravesh_motor , 148
          cls
          waitms 500
          Reset Watchdog
          if ravesh_motor=0 then
          Goto Check_motor
          else
          goto Kalibre_rotubat
          endif
          endif
          if enter=1 then ho=0
          loop
'###############################################################################
Check_motor:
            Do
            Reset Watchdog
            Home
            Lcd " TANZIM MOTOR?   "
            Home L
            Lcd "YES=UP...NO=DOWN"
            If Up = 0 Then Goto Zaviemotor
            If Down = 0 Then
            Cls
            Goto Kalibre_rotubat
            End If
            Loop
'###############################################################################
Zaviemotor:
           Cls
           Waitms 5
           ho=1
           Do
           Reset Watchdog
           Locate 1 , 3
           Lcd " PLEASE WAIT"
           If Pinc.1 = 0 And Ef = 0 Then
           Set Portb.7
           Dk = 1
           End If
           If Pinc.1 = 1 And Ef = 0 And Dk = 1 Then
           Ef = 1
           Dk = 0
           End If
           If Pinc.1 = 1 And Ef = 0 Then
           Set Portb.7
           Ef = 3
           End If
           If Ef = 3 Then If Pinc.1 = 0 Then Ef = 2
           If Ef = 2 Then If Pinc.1 = 1 Then Ef = 1
           If Ef = 1 Then
           Ef = 0
           Dk = 0
           If Jh = 0 Then
           Reset Portb.7
           Goto Zaviemotor40
           Else
           Reset Portb.7
           Goto Zaviemotor_40
           End If
           End If
           if enter=0 and ho=0 then
           reset portb.7
           goto Kalibre_rotubat
           endif
           if enter=1 then ho=0
Loop
'###############################################################################
Zaviemotor40:
             Cls
             Readeeprom M3 , 26
             Reset Watchdog
             Waitms 500
             Reset Watchdog
             Do
             Reset Watchdog
             If Down = 0 Then M3 = 0
             If Enter = 1 Then Ho = 0
             Home
             Lcd "ZAVIE(40)MOTOR "
             Locate 2 , 1
             Lcd "TIME1= " ; M3 ; "    "
             If Up = 0 And Ho = 0 Then
             Set Portb.7
             Waitms 59
             Incr M3
             Else
             Reset Portb.7
             End If
             If Enter = 0 And Ho = 0 Then
             If M3 > 0 Then
             Writeeeprom M3 , 26
             Waitms 5
             End If
             Jh = 1
             Ho = 1
             Goto Zaviemotor
             End If
             Loop
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Zaviemotor_40:
              Cls
              Readeeprom Rs , 34
              Waitms 5
              Readeeprom M6 , 30
              Waitms 5
              Reset Watchdog
              Waitms 500
              Reset Watchdog
              Do
              Reset Watchdog
              If Down = 0 Then M6 = 0
              If Enter = 1 Then Ho = 0
              Home
              Lcd "ZAVIE(-40)MOTOR "
              Locate 2 , 1
              Lcd "TIME2= " ; M6 ; "    "
              If Up = 0 Then
              Set Portb.7
              Waitms 59
              Incr M6
              Else
              Reset Portb.7
              End If
              If Enter = 0 And Ho = 0 Then
              If M6 > 0 Then
              Writeeeprom M6 , 30
              Waitms 5
              End If
              Rs = 0
              Writeeeprom Rs , 34
              Waitms 5
              Cls
              Ho = 1
              Jh = 0
              Goto Kalibre_rotubat
              End If
Loop
'###############################################################################
Kalibre_rotubat:
                Cls
                Ho = 1
                Ed = 0
                Reset Watchdog
                Waitms 500
                Reset Watchdog
                Do
                H_k_str = Fusing(h_k , "#.#")
                H_k = Val(h_k_str)
                Home
                Lcd " H=ROTUBAT+K...!"
                If Ed <= 1 Then
                Home L
                Lcd " K=" ; H_k_str ; "      "
                Else
                Locate 2 , 4
                Lcd "        "
                End If
                Incr Ed
                If Ed > 3 Then Ed = 0
                If Enter = 1 Then Ho = 0
                If Enter = 0 And Ho = 0 Then
                Writeeeprom H_k , 98
                Waitms 5
                Goto Kalibre_dama
                End If
                If Up = 1 And Down = 1 Then Us = 0
                If Up = 0 Then
                Ed = 0
                If Us <= 10 Then Incr Us
                H_k = H_k + 0.1
                If H_k > 5 Then H_k = -5
                End If
                If Down = 0 Then
                Ed = 0
                If Us <= 10 Then Incr Us
                H_k = H_k - 0.1
                If H_k < -5 Then H_k = 5
                End If
                If Us <= 10 Then
                Waitms 100
                Else
                Waitms 5
                End If
                Reset Watchdog
                Loop
'###############################################################################
Kalibre_dama:
             Cls
             Ho = 1
             Ed = 0
             Reset Watchdog
             Waitms 500
             Reset Watchdog
             Do
             T_k_str = Fusing(t_k , "#.#")
             T_k = Val(t_k_str)
             Home
             Lcd " T=DAMA+K...!"
             If Ed <= 1 Then
             Home L
             Lcd " K=" ; T_k_str ; "      "
             Else
             Locate 2 , 4
             Lcd "          "
             End If
             Incr Ed
             If Ed > 3 Then Ed = 0
             If Enter = 1 Then Ho = 0
             If Enter = 0 And Ho = 0 Then
             Writeeeprom T_k , 102
             Waitms 5
             Goto Tanzim_uptemp
             End If
             If Up = 1 And Down = 1 Then Us = 0
             If Up = 0 Then
             Ed = 0
             If Us <= 10 Then Incr Us
             T_k = T_k + 0.1
             If T_k > 5 Then T_k = -5
             End If
             If Down = 0 Then
             Ed = 0
             If Us <= 10 Then Incr Us
             T_k = T_k - 0.1
             If T_k < -5 Then T_k = 5
             End If
             If Us <= 10 Then
             Waitms 100
             Else
             Waitms 5
             End If
             Reset Watchdog
             Loop
'###############################################################################
Tanzim_uptemp:
              Cls
              Ho = 1
              Reset Watchdog
              Waitms 500
              Reset Watchdog
              Do
              Reset Watchdog
              Home
              Lcd "MAX NORMAL TEMP? "
              Home L
              Lcd Up_temp ; "     "
              If Down = 1 Then Ho = 0
              If Up = 0 Then Up_temp = Up_temp + 0.1
              If Down = 0 And Ho = 0 Then Up_temp = Up_temp - 0.1
              If Up_temp < 0.2 Then Up_temp = 3
              If Up_temp > 3 Then Up_temp = 0.2
              If Enter = 0 And Ho = 0 Then
              Writeeeprom Up_temp , 46
              Waitms 5
              Cls
              Waitms 500
              Reset Watchdog
              Do
              Reset Watchdog
              Home
              Lcd "MENO OF ALLARMS?"
              Locate 2 , 1
              Lcd "YES=UP...NO=DOWN"
              If Up = 0 Then Goto On_off_alarms
              If Down = 0 Then Exit Do
              Loop
              Cls
              Locate 1 , 2
              Lcd "  ...SAVE..."
              Locate 2 , 3
              Lcd " PLEASE WAIT"
              Waitms 500
              Reset Watchdog
              Waitms 500
              Reset Watchdog
              Ho = 1
              Goto Submain
              End If
              Waitms 150
              Loop
'###############################################################################
On_off_alarms:
              Cls
              Ho = 1
              Reset Watchdog
              Waitms 500
              Reset Watchdog
              M_nt = 0
              Cont_rv = 0
              Do
              Reset Watchdog
              If Enter = 1 Then Ho = 0
              If Up = 1 And Down = 1 Then Ekf = 0
              Incr Cont_rv
              If Cont_rv > 4 Then Cont_rv = 0
              If Up = 0 And Ekf = 0 Or Down = 0 And Ekf = 0 Then
              If M_nt = 0 Then
              Incr Rv
              If Rv > 1 Then Rv = 0
              End If
              If M_nt = 1 Then
              Incr Rv1
              If Rv1 > 1 Then Rv1 = 0
              End If
              If M_nt = 2 Then
              Incr Rv2
              If Rv2 > 1 Then Rv2 = 0
              End If
              Ekf = 1
              End If
              If Enter = 0 And Ho = 0 Then
              If Rv1 = 1 And M_nt = 1 Then
              M_nt = 3
              Else
              Incr M_nt
              End If
              Ho = 1
              If M_nt = 1 Then
              Cls
              Waitms 500
              Reset Watchdog
              End If
              End If
              If Rv = 0 And M_nt = 0 Then
              If Cont_rv <= 1 Then
              Locate 1 , 1
              Lcd "ALL ALLARMS=ON "
              Else
              Locate 1 , 1
              Lcd "ALL ALLARMS=   "
              End If
              End If
              If Rv = 1 And M_nt = 0 Then
              If Cont_rv <= 1 Then
              Locate 1 , 1
              Lcd "ALL ALLARMS=OFF "
              Else
              Locate 1 , 1
              Lcd "ALL ALLARMS=    "
              End If
              End If
              If Rv1 = 0 And M_nt = 1 Then
              If Cont_rv <= 1 Then
              Locate 1 , 1
              Lcd "ROTUBAT=ON "
              If Rv2 = 0 Then
              Home L
              Lcd "ALLARM=ON  "
              Else
              Home L
              Lcd "ALLARM=OFF "
              End If
              Else
              Locate 1 , 1
              Lcd "ROTUBAT=   "
              If Rv2 = 0 Then
              Home L
              Lcd "ALLARM=ON  "
              Else
              Home L
              Lcd "ALLARM=OFF "
              End If
              End If
              End If
              If Rv1 = 1 And M_nt = 1 Then
              If Cont_rv <= 1 Then
              Locate 1 , 1
              Lcd "ROTUBAT=OFF"
              Locate 2 , 1
              Lcd "                  "
              Else
              Locate 1 , 1
              Lcd "ROTUBAT=   "
              Locate 2 , 1
              Lcd "                  "
              End If
              End If
              If Rv2 = 0 And M_nt = 2 Then
              If Rv1 = 0 Then
              Locate 1 , 1
              Lcd "ROTUBAT=ON "
              Else
              Locate 1 , 1
              Lcd "ROTUBAT=OFF"
              End If
              If Cont_rv <= 1 Then
              Home L
              Lcd "ALLARM=ON  "
              Else
              Home L
              Lcd "ALLARM=    "
              End If
              End If
              If Rv2 = 1 And M_nt = 2 Then
              If Rv1 = 0 Then
              Locate 1 , 1
              Lcd "ROTUBAT=ON "
              Else
              Locate 1 , 1
              Lcd "ROTUBAT=OFF"
              End If
              If Cont_rv <= 1 Then
              Home L
              Lcd "ALLARM=OFF  "
              Else
              Home L
              Lcd "ALLARM=     "
              End If
              End If
              If M_nt >= 3 Then
              Cls
              Locate 1 , 2
              Lcd "  ...SAVE..."
              Locate 2 , 3
              Lcd " PLEASE WAIT"
              Waitms 500
              Reset Watchdog
              Waitms 500
              Reset Watchdog
              Ho = 1
              Writeeeprom Rv , 58
              Waitms 5
              Writeeeprom Rv1 , 62
              Waitms 5
              Writeeeprom Rv2 , 66
              Waitms 5
              Goto Submain
              End If
              Waitms 100
              Loop



lable:
      If Portb.7 = 1 And _sec > 3 And Pinc.1 = 1 And Ravesh_motor = 1 Then : Portb.7 = 0 : Eds = 0 : Mds = 0 : End If
      Return
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
$eeprom
Data 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 , 15 , 16 , 17 , _
18 , 19 , 20 , 21 , 22 , 23 , 24 , 25 , 26 , 27 , 28 , 29 , 30 , 31 , 32 , 33 , 34 , _
35 , 36 , 37 , 38 , 39 , 40 , 41 , 42 , 43 , 44 , 45 , 46 , 47 , 48 , 49 , 50 , 51 , _
52 , 53 , 54 , 55 , 56 , 57 , 58 , 59 , 60 , 61 , 62 , 63 , 64 , 65 , 66 , 67 , 68 , _
69 , 70 , 71 , 72 , 73 , 74 , 75 , 76 , 77 , 78 , 79 , 80 , 81 , 82 , 83 , 84 , 85 , _
86 , 87 , 88 , 89 , 90 , 91 , 92 , 93 , 94 , 95 , 96 , 97 , 98 , 99 , 100 , 101 , 102 , _
103 , 104 , 105 , 106 , 107 , 108 , 109 , 110 , 11 , 112 , 113 , 114 , 115 , 116 , 117 , _
118 , 119 , 120 , 121 , 122 , 123 , 124 , 125 , 126 , 127 , 128 , 129 , 130 , 131 , 132 , _
133 , 134 , 135 , 136 , 137 , 138 , 139 , 140 , 141 , 142 , 143,144,145,146,147,148,149,150 , _
151,152,153,154,155,156,157,158,159,160
$data
'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% www.eca.ir %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%