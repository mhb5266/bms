$regfile = "m16def.dat"
$crystal = 1000000
$hwstack = 80
$swstack = 100
$framesize = 100

$include "tm1637_config.bas"

CONFIG CLOCK = SOFT , GOSUB = SECTIC
ENABLE INTERRUPTS
dim pointer as Boolean
'dim light as byte':light=&H89
dim i as byte
tm1637_init

pg alias portd.6:config portd.6=OUTPUT
Date$ = "01.09.09"
Time$ = "14:07:50"

DO
  waitms 50

LOOP
END

SECTIC:
toggle pointer
toggle pg
'call displight(i)
call disp_1_2_3_4_dot( _hour / 10 , _hour mod 10 , _min / 10 ,_min mod 10,pointer)
RETURN

$include "tm1637_function.bas"