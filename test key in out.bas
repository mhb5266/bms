$regfile = "m8def.dat"
$crystal = 8000000

Fan Alias Portb.1 : Config Portb.1 = Output

Key Alias Pinb.1

Led Alias Portc.5 : Config Portc.5 = Output


Dim Timee As Word

Main:

Do

  Do
    Incr Timee
    Waitms 50
    If Timee > 200 Then Exit Do
    If Key = 1 Then
       Set Led
       Wait 2
    Else
        Reset Led
    End If


  Loop

  Set Fan
  Waitms 10



Loop



End