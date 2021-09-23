
Clk Alias Porta.0
Dio Alias Porta.1

brightness alias 7 ' 0~7 >>  0=off >>  7=Max light
delay_scroll alias 300 ' ms


Declare Sub Tm1637_init()
Declare Sub Tm1637_scroll(byval S As String)
Declare Sub Tm1637_print(byval S As String)
Declare Sub Tm1637_num(byval N As Word)
Declare Sub Disp_1_2_3_4_dot(byval Dig1 As Byte , Byval Dig2 As Byte , Byval Dig3 As Byte , Byval Dig4 As Byte , Byval Dot As Byte)
Declare Sub Disp(byval addr As Byte , Byval dataa As Byte)
Declare Sub Wrbyte(byval _data As Byte)
Declare Sub _start()
Declare Sub _stop()
Declare Sub _ack()