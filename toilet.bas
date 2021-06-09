$regfile = "m8def.dat"
$crystal = 8000000


Configs:

        Enable Interrupts
        Enable Timer1
        On Timer1 T1rutin

        Config Timer1 = Timer , Prescale = 256
        Timer1 = 34285
        Start Timer1


Configport:

In1 Alias Pinc.3 : Config In1 = Input
In2 Alias Pinc.4 : Config In2 = Input
In3 Alias Pinc.5 : Config In3 = Input

Out1 Alias Portc.0 : Config Out1 = Input
Out2 Alias Portc.1 : Config Out2 = Input
Out3 Alias Portc.2 : Config Out3 = Input

Pg Alias Portc.6 : Config Pg = Output

Defines:


        Dim T1 As Word
        Dim T2 As Word
        Dim T3 As Word

Main:


     Do

       If In1 = 1 Then
          T1 = 300
          Set Out1
       End If
       If In2 = 1 Then
          T2 = 300
          Set Out2
       End If
       If In3 = 1 Then
          T3 = 300
          Set Out3
       End If
       Waitms 30
     Loop


Gosub Main


T1rutin:
        Stop Timer1
        Toggle Pg

        If T1 > 0 Then
           Decr T1
           If T1 = 0 Then Reset Out1
        End If
        If T2 > 0 Then
           Decr T2
           If T2 = 0 Then Reset Out2
        End If
        If T3 > 0 Then
           Decr T3
           If T3 = 0 Then Reset Out3
        End If
        Timer1 = 34285
        Start Timer1
Return

End