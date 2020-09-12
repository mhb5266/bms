$regfile = "m8def.dat"
$crystal = 11059200

configs:
        'Config Timer1 = Pwm , Pwm = 10 , Compare_A_Pwm = Clear_Up , Compare_B_Pwm = Clear_Down , Prescale = 1
        Config Timer1 = Timer , Prescale = 8
        Config Timer0 = Timer , Prescale = 1024
        Enable Interrupts
        'Enable Timer1
        'On Timer1 T1rutin
        Start Timer1
        Start Timer0
        Config Int1 = Rising
        Enable Int1
        On Int1 Int1rutin


        Config Portb.2 = Output : Blink_ Alias Portb.2
        Config Portc.5 = Output : Led1 Alias Portc.5
        Config Portc.4 = Output : Led2 Alias Portc.4
        Config Portd.3 = Input : Ziro Alias Pind.3
        Config Portb.1 = Input : Key Alias Pinb.1

Defports:




defvals:
        dim test as word
        Dim Light As Word
        'dim down as Word
        dim plus as byte
        dim updown as Boolean
        dim secc as word
        dim term as Byte
        Dim pw As Word
        Dim Steps As Byte
        Dim Delay_ As Word
        Dim I As Byte


        const d = 0




Start Timer0
Light = 20
Main:

     Do


       If Timer1 > Light Then Set Led1 Else Reset Led1

       Debounce Key , 1 , Find


     Loop

Gosub Main


Find:



Return




Int1rutin:
          Stop Timer1
          Incr Test
          
          If Test = 300 Then
             Test = 0
             Toggle Blink_
             Incr I
             If I = 5 Then I = 1

                Select Case I
                       Case 1
                            Light = 0
                       Case 2
                            Light = 8800
                       Case 3
                            Light = 12000
                       Case 4
                            Light = 65535

                End Select
          End If

          Reset Led1
          Timer1 = 0
          Start Timer1

Return

End