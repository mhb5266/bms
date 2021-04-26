'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200

$baud = 9600
'-------------------------------------------------------------------------------
Configs:
         _in Alias Pinc.5 : Config Portc.5 = Input
        Buzz Alias Portc.3 : Config Portc.3 = Output
        Led4 Alias Portd.5 : Config Portd.5 = Output
        Led3 Alias Portd.6 : Config Portd.6 = Output
        Led1 Alias Portd.7 : Config Portd.7 = Output
        Led2 Alias Portb.0 : Config Portb.0 = Output
        'BUZZ Alias Portc.3 : Config Portc.3 = Output
        Touch2 Alias Pinb.1 : Config Portb.1 = Input
        Touch4 Alias Pinb.2 : Config Portb.2 = Input
        Touch3 Alias Pinb.3 : Config Portb.3 = Input
        Touch1 Alias Pinb.4 : Config Portb.4 = Input

        Sensor Alias Pinc.4 : Config Portc.4 = Input



        En Alias Portd.2 : Config Portd.2 = Output

        'Pg Alias Portc.3 : Config Portc.3 = Output



        Do
          If Touch1 = 0 Then
             Waitms 50
             If Touch1 = 0 Then
                Toggle Led1
             End If
          End If

          If Touch2 = 0 Then
             Waitms 50
             If Touch2 = 0 Then
                Toggle Led2
             End If
          End If

          If Touch3 = 0 Then
             Waitms 50
             If Touch3 = 0 Then
                Toggle Led3
             End If
          End If

          If Touch4 = 0 Then
             Waitms 50
             If Touch4 = 0 Then
                Toggle Led4
             End If
          End If
        Loop
End