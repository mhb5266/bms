$regfile = "m16def.dat"
$crystal = 11059200

$baud = 1200



Configs:

     Config Porta = Output
     Txpin Alias Portd.0 : Config Portd.0 = Output
Defines:


   Dim Cmd As Byte
   Dim I As Byte


   Declare Sub Tx
Startup:




Main:

   Do
      Set Txpin

      Incr Cmd
      If Cmd = 10 Then Cmd = 1
      Porta = Cmd
      Reset Txpin
      For I = 0 To 100
          Tx
          Waitms 10
      Next


   Loop


End


Sub Tx


    Waitms 10
    'Printbin 230 ; 110 ; Cmd ; 53 ; 210
    Printbin Cmd
    Waitms 50


End Sub