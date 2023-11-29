
$regfile = "m16def.dat" ' 8515 used here. Other ATMEL AVR chips possible.
$baud = 9600 ' development board uses 4 MHZ XTAL
$crystal = 4000000
'$crystal = 7372800 ' use these 2 for production version
'$baud = 9600 ' uses a 7.3728 MHZ XTAL
Const Max_in_len = 3 ' define maximum input chars
Const Max_bytes = 10 ' define max shift reg bytes possible
Const Shift_delay = 20 ' shift delay in microseconds
Const Test_pattern = &HAA ' shift reg test pattern
Dim Bytes(max_bytes) As Byte ' byte shift reg output buffer
Dim String_input As String * Max_in_len ' dim to maximum input characters
Dim Raw_echo As String * Max_in_len
Dim Read_string As String * 40 ' Gets strings read from DATA statement
Dim Value As Byte ' becomes numeric value of command
Dim Opcode As String * 1 ' one character opcode goes here
Dim Temp As String * 2 ' temp string work variable
Dim Tempbyte1 As Byte ' more temp vars
Dim Tempbyte2 As Byte
Dim I As Byte
Dim J As Byte
Dim K As Byte
Dim Max_shift_len As Byte ' Test sets this to max bits found
Dim Arry_end As Byte ' Test sets this to last array element
Dim Set_clear_flag As Bit ' flag used to set or clear a bit
Dim Limit_bytes As Byte ' For compatibility with version 1.11.6.2
' *** readability definitions ***
' NOTE: 595 pin 13 must be low/GND.
' Note: connect the Qh' of the previous 595 to the SER of the next 595.
Clock_out Alias Portb.0 ' SRCLK - 74HC595
Data_out Alias Portb.1 ' SER - of the first 74HC595
Data_in Alias Portb.2 ' Qh - of the last 74HC595
Data_in_read Alias Pinb.2 ' Qh - of the last 74HC595
Latch_out Alias Portb.3 ' RCLK
Clear_out Alias Portb.4 ' SRCLR, available on 74HC595. LOW true.
Clock_out_dir Alias Ddrb.0 ' *** define direction regs ***
Data_out_dir Alias Ddrb.1
Data_in_dir Alias Ddrb.2
Latch_out_dir Alias Ddrb.3
Clear_out_dir Alias Ddrb.4
' *** sub definitions ***
Declare Sub Clearbytes(byval Bytecnt As Byte) ' clear byte array
Declare Sub Latchbytes() ' xfer shift reg to latch outputs
Declare Sub Clearshift() ' clear shift reg
Declare Sub Test_shift_reg() ' test and determine shift reg length
Declare Sub Set_clear_bit() ' set or clear bit based on flag
Declare Sub Send_bytes() ' send byte array to shift registers
Declare Sub Map_byte() ' print binary pattern for Bytes(I)
Init: ' *** set initial conditions for I/O ***
' MAIN starts here
Set Clock_out
Reset Data_out
Reset Latch_out
Set Clear_out
' set the data direction for I/O
Set Clock_out_dir
Set Data_out_dir
Reset Data_in_dir
Set Latch_out_dir
Set Clear_out_dir
Limit_bytes = Max_bytes ' NOTE**:For compatibility with version 1.11.6.2
Incr Limit_bytes ' NOTE**:For compatibility with version 1.11.6.2
Call Clearshift() ' clear shift reg
Call Latchbytes() ' xfer zeros to outputs
Call Clearbytes(max_bytes) ' clear output byte array
Call Test_shift_reg() ' test and set shift reg length
If Max_shift_len = 0 Then
   Print "Control Board Failure !!"
Else
   Print "Control Board OK !!"
End If

Do ' ****** MAIN LOOP ******
   String_input = Space(max_in_len) ' clear input string to spaces
   Input String_input ' read input string
   Raw_echo = String_input ' form echo string
   String_input = Trim(string_input) ' trim lead and trail spaces
   Opcode = Left(string_input , 1) ' extract opcode
   Opcode = Ucase(opcode) ' convert to upper case
   Temp = Mid(string_input , 2 , Max_in_len) ' get numeric string
   Temp = Trim(temp)
   Value = Val(temp) ' convert string to numeric
   If Value > Max_shift_len Then ' setting or clearing beyond bit range?
      Opcode = " " ' yes. set a bogus command code
   End If
   Select Case Opcode
      Case "S" ' Set a bit
         If Value = 0 Then ' improper bit value or format
            Print "ERR 7"
         Else
            Set Set_clear_flag ' flag to set a bit
            Call Set_clear_bit() ' go set the bit in array
            Call Send_bytes() ' send to shift regs
            Call Latchbytes() ' latch the bit pattern to outputs
            Print Raw_echo ' echo command
         End If
      Case "C" ' Clear a bit
         If Value = 0 Then ' improper bit value or format
            Print "ERR 8"
         Else
            Reset Set_clear_flag ' flag to clear a bit
            Call Set_clear_bit() ' clear the bit in the array
            Call Send_bytes() ' send to shift regs
            Call Latchbytes() ' latch the bit pattern to outputs
            Print Raw_echo ' echo command
         End If
      Case "M" ' Print map of output bits set/reset
         If Arry_end = 0 Then ' shows LSB to MSB
            Print "ERR 7"
         Else
            For I = 1 To Arry_end
               Call Map_byte()
               Print " ";
            Next I
            Print
         End If
      Case "V" ' print Version etc from DATA
         Restore Version_string ' Initialize DATA string pointer
         Do
            Read Read_string
            I = Instr(read_string , "^") ' ^ character exits loop
            If I <> 0 Then
               Exit Do
            End If
            Print Read_string;
         Loop
         Print
      Case "T" ' Test interface
         Call Clearshift() ' set shift reg to all zeros
         Call Test_shift_reg()
         Call Clearshift() ' clear shift reg again
         If Max_shift_len = 0 Then ' if failure, give error message
            Print "ERR 1"
         Else
            Print Max_shift_len ' otherwise, echo shift reg length found
         End If
      Case "R" ' Reset all outputs low
         Call Clearshift() ' clear shift reg
         Call Latchbytes() ' latch shift reg
         Call Clearbytes(max_bytes) ' clear byte array
         Print Raw_echo ' echo command input
      Case "I" ' Initialize
         Print Raw_echo ' echo command input
         Exit Do ' re-start this program
      Case Else ' unknown or improper command format
         Print "ERR 4"
   End Select
Loop ' ***** MAIN LOOP END *****
Print "Control Board Reset and Initialized"
Goto Init ' I command. restart program

End



' *** subroutines ***
Sub Clearbytes(byval Bytecnt As Byte) ' clear output byte array
   For I = Bytecnt To 1 Step -1 'NOTE**: Old DOWNTO no longer works
      Bytes(i) = 0
   Next I
End Sub
Sub Latchbytes()
   Set Latch_out ' latch the shift reg to outputs
   Waitms 1
   Reset Latch_out
End Sub
Sub Clearshift() ' clear shift reg to all 0's
   Tempbyte1 = 0 ' Modified 1-2-99 for ALLEGRO chips
   For I = 1 To Limit_bytes ' send lots of zeros to shift regs to clear
      Shiftout Data_out , Clock_out , Tempbyte1 , 0 , 8 , Shift_delay
   Next I
   Reset Clear_out ' toggle the clear out line (for 74HC595 parts)
   Waitms 1
   Set Clear_out
End Sub
Sub Test_shift_reg() ' send byte pattern &HAA to
   Tempbyte1 = Test_pattern ' shift reg and count how many 8 bit shifts til
   ' the pattern appears in cpu input shift reg
   Shiftout Data_out , Clock_out , Tempbyte1 , 0 , 8 , Shift_delay
   For I = 1 To Limit_bytes ' NOTE**: For compatibility with 1.11.6.2
      Shiftin Data_in_read , Clock_out , Tempbyte2 , 0 , 8 , Shift_delay
      If Tempbyte2 = Test_pattern Then
         Exit For ' we got a match to pattern
      End If
   Next I
   If Tempbyte2 <> Test_pattern Then
      Max_shift_len = 0 ' no match. hardware problem!!
      Arry_end = 0
   Else
      Max_shift_len = I * 8 ' match! calc. and save number of bits found
      Arry_end = I ' last array element
   End If
End Sub
Sub Set_clear_bit() ' set or clear a bit in byte array
   K = 1
   I = Value - 1 : I = I mod 8 : I = I + 1 ' calc array index
   J = Value - 1 : J = J Mod 8 ' calc bit position
   Tempbyte1 = Bytes(i)
   Rotate K , Left , J ' put a 1 in proper bit position
   If Set_clear_flag = 1 Then
      Tempbyte1 = Tempbyte1 Or K ' sets the bit position
   Else
      K = Not K
      Tempbyte1 = Tempbyte1 And K ' clear bit position
   End If
   Bytes(i) = Tempbyte1 ' update array byte
    'Print Hex(tempbyte1) ' ********* debug ***********
End Sub
Sub Send_bytes()
    For I = Arry_end To 1 Step -1 ' send byte array to shift regs
        Tempbyte1 = Bytes(i)
        Shiftout Data_out , Clock_out , Tempbyte1 , 0 , 8 , Shift_delay
    Next I
End Sub
Sub Map_byte() ' show map of output latch states
     Tempbyte1 = Bytes(i) ' LSB to MSB
     For J = 1 To 8 ' 8 bits per byte to process
         K = Tempbyte1 And 1 ' test LSB
         If K <> 0 Then
            Print "1";
         Else
             Print "0";
         End If
         Shift Tempbyte1 , Right , 1
     Next J
End Sub
$data ' Put some strings in DATA for V command
Version_string: ' just for fun
Data "Jim Gillespie" , " 08-16-2001" , " Version 5.01"
Data " Serial #" , "000401" , "^"



