$nocompile

'*******************************************************************************
'*  Definitions for Serial-Driver ST7920                                       *
'*******************************************************************************

Declare Sub Lcds(byval Y1 As Byte , Byval X1 As Byte , Byval Text1 As String * 20)
Declare Sub Lcds_cls(byval D_type As Byte)
Declare Sub Lcds_init(byval D_type As Byte)

Declare Sub Lcds_command(byval Ir As Byte)
Declare Sub Lcds_data(byval Dr_en As Byte)
Declare Function Lcdget() As Byte
Declare Function Farsi(byval S As String * 20) As String * 20

Config Base = 0

Dim Mybyte As Byte
Dim Xadrs As Byte , Yadrs As Byte , Xpos As Byte
'Dim My_word As Word
'Dim Bytel As Byte At My_word Overlay
'Dim Byteh As Byte At My_word + 1 Overlay
Dim Byteh As Byte , Bytel As Byte
Dim Lcdx As Byte
Dim Lcdy As Byte

Outport Alias Portc
Getport Alias Pinc

Rs Alias Portd.7
Rw Alias Portd.6
E Alias Portd.5
'Psb Alias Portd.4      ' You can connect PSB pin to vcc (  8-bit mode )
Rst Alias Portd.3


Ddrc = &HFF
Ddrd = &HFF
Portc = 0
Portd = 0

'Set Psb
Set Rst
Reset Rw
Reset E

 Const White = &HFF
Const Black = &H00

Declare Sub Lcds_text(byval S As String , Byval Xoffset As Byte , Byval Yoffset As Byte , Byval Fontset As Byte)
Declare Sub Lcds_set_pixel(byval X As Byte , Byval Y As Byte , Byval color As Byte  )

Declare Sub Lcds_fill_circle(byval X As Byte , Byval Y As Byte , Byval Radius As Byte , Byval Color1 As Byte)
Declare Sub Lcds_circle(byval X As Byte , Byval Y As Byte , Byval Radius As Byte , Byval Color As Byte)
Declare Sub Lcds_line(byval X1 As Byte , Byval Y1 As Byte , Byval X2 As Byte , Byval Y2 As Byte , Byval Pen_width As Byte , Byval Color As Byte)
Declare Sub Lcds_box(byval Xs As Byte , Byval Ys As Byte , Byval Xe As Byte , Byval Ye As Byte , Byval Fill As Byte , Byval Color As Byte)
Declare Sub Lcds_show_bgf(byval Xs As Byte , Byval Ys As Byte)