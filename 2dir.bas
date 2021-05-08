$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600
Enable Interrupts
Enable Urxc
On Urxc Rx
Config Serialout = Buffered , Size = 100

$hwstack = 32                                               ' default use 32 for the hardware stack

$swstack = 10                                               ' default use 10 for the SW stack

$framesize = 40                                             ' default use 40 for the frame space


Config Lcdpin = 16x2 , Db4 = Portc.0 , Db5 = Portc.1 , Db6 = Portc.2 , Db7 = Portc.3 , E = Portc.5 , Rs = Portc.4
Cursor Off

'Declare Sub Rx

K Alias Pinb.0 : Config Portb.0 = Input
En Alias Portd.2 : Config Portd.2 = Output

Dim A As Byte
Dim I As Byte
Dim Din(5) As Byte
Dim Inok As Bit
Dim X As Byte
Dim Typ As Byte
Dim Cmd As Byte
Dim Id As Byte
Dim Maxin As Byte

Const Direct = 242 : Const Endbit = 220
Typ = 101 : Cmd = 123

Lcd "hi" : Wait 1 : Cls
Reset En
Main:
Do
If K = 0 Then
   Incr A
   Set En
   Waitms 5
   Printbin Direct ; Typ ; Cmd ; A ; Endbit
   Waitms 70
   Reset En
   Lcd "send " ; A
   Waitms 500
   Cls
   Do
   Loop Until K = 1
End If
Waitms 10
'If Ischarwaiting() = 1 Then Gosub Rx
Loop

Rx:
Disable Urxc
   Do
   Incr I
     Inputbin Maxin
     If Maxin = 242 Then I = 1
     If Maxin = 220 Then I = 5
     Din(i) = Maxin
   Loop Until Ischarwaiting() = 0
   If I = 5 Then
   I = 0
   For A = 1 To 5
      Lcd Din(a) : Lowerline : Lcd A : Wait 1 : Cls : Waitms 500
   Next
   End If
   Enable Urxc
Return

End


