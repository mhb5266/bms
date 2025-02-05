$regfile = "m32def.dat"
$crystal = 11059200



Open "COMC.2:9600,8,n,1" For Output As #1
Dim I As Byte
Do
  Print#1 , I
  Incr I

  Wait 2

Loop