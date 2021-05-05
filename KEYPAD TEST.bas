'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200

$baud = 9600

Dim Keyid As Byte
Keyid = 1
'-------------------------------------------------------------------------------
Configs:
         _in Alias Pinc.5 : Config Portc.5 = Input
        Buzz Alias Portc.3 : Config Portc.3 = Output
        Led4 Alias Portd.6 : Config Portd.6 = Output
        Led3 Alias Portd.7 : Config Portd.7 = Output
        Led1 Alias Portb.0 : Config Portb.0 = Output
        Led2 Alias Portd.5 : Config Portd.5 = Output
        Led Alias Portb.5 : Config Portb.5 = Output
        'BUZZ Alias Portc.3 : Config Portc.3 = Output
        Touch2 Alias Pinb.1 : Config Portb.1 = Input
        Touch4 Alias Pinb.2 : Config Portb.2 = Input
        Touch3 Alias Pinb.3 : Config Portb.3 = Input
        Touch1 Alias Pinb.4 : Config Portb.4 = Input

        Sensor Alias Pinc.4 : Config Portc.4 = Input


        Dim I As Byte


For I = 1 To 4
        Set Led1
        Reset Led2
        Reset Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Set Led2
        Reset Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Reset Led3
        Set Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Set Led3
        Reset Led4
        Waitms 150

        Reset Led1
        Reset Led2
        Reset Led3
        Reset Led4
Next

Set Buzz
Set Led
Wait 2
Reset Buzz
Reset Led

Do
If Touch1 = 0 Then
   Set Led1
Else
    Reset Led1
End If
If Touch2 = 0 Then
   Set Led2
Else
    Reset Led2
End If
If Touch3 = 0 Then
   Set Led3
Else
    Reset Led3
End If
If Touch4 = 0 Then
   Set Led4
Else
    Reset Led4
End If
If Touch1 = 1 And Touch2 = 1 And Touch3 = 1 And Touch4 = 1 Then
   Reset Buzz
End If
Loop


End