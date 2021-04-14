
$regfile = "m32def.dat"

$crystal = 11059200

$baud = 9600

Configs:

Config Lcdpin = 16 * 4 , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 4
Cursor Off

Declare Sub Getline(s As String)
Declare Sub Flushbuf()

Dim Sret As String * 100
Dim B As Byte
Main:
Wait 5
Do
  Flushbuf
  Print "AT"
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls
Loop Until Sret = "OK"

Print "ATE0"

  Flushbuf
  Print "AT+CMGF=1"
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls

  Flushbuf
  Print "AT+CSCS=" ; Chr(34) ; "GSM" ; Chr(34)
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls

  Flushbuf
  Print "AT+CNMI=2,1,0,0"
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls

  Flushbuf
  Print "AT+CCLK?"
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls

Do
  Flushbuf
  Print "AT+CMNI=?"
  Getline Sret
  Cls : Lcd Sret : Wait 2 : Cls



  Waitms 10
Loop


End


Sub Getline(s As String)
    S = ""
    Do
      B = Inkey()
      Select Case B
             Case 0                                         'nothing
             Case 13                                        ' we do not need this one
             Case 10 : If S <> "" Then Exit Do              ' if we have received something
             Case Else
             S = S + Chr(b)                                 ' build string
      End Select
    Loop
End Sub


Sub Flushbuf()
    Waitms 100                                              'give some time to get data if it is there
    Do
    B = Inkey()                                             ' flush buffer
    Loop Until B = 0
End Sub