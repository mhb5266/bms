$regfile = "m8def.dat"
$crystal = 11059200

$baud = 1200



Configs:
   Enable Interrupts
   Enable Urxc
   On Urxc Rx

   Config Lcdpin = 16 * 2 , Db7 = Portb.0 , Db6 = Portb.1 , Db5 = Portb.5 , Db4 = Portb.4 , E = Portb.3 , Rs = Portb.2
   'Config Serialin = Buffered , Size = 200
Defines:
   Dim F As Byte
   Dim Maxin As Byte
   Dim Inok As Bit
   Dim Din(5) As Byte
   Dim Cmd As Byte
   Dim I As Byte
   Dim X As Byte


Startup:

Cls
Lcd "hi"
Wait 2
Cls


Main:

Do
   Waitms 250


Loop


End


Rx:

      Incr X
      Incr F
      Inputbin Maxin
      'If Maxin > 0 And Maxin < 10 Then
         Home
         Lcd Maxin
         Lowerline
         Lcd X
         Waitms 2
      'End If
      If X = 255 Then Cls
'(
      Select Case Maxin
              Case 230
                   For I = 1 To 5
                       Din(i) = 0
                       Reset Inok
                   Next
              Case 110
                   If Din(1) <> 230 Then
                      For I = 1 To 5
                          Din(i) = 0
                      Next
                      F = 0
                   End If
              Case 53
                   If Din(1) <> 230 Or Din(2) <> 110 Then
                      For I = 1 To 5
                          Din(i) = 0
                      Next
                      F = 0
                   End If
              Case 210
                   If Din(1) <> 230 Or Din(2) <> 110 Or Din(4) <> 53 Then
                      For I = 1 To 5
                          Din(i) = 0
                      Next
                      F = 0
                   Else
                       Set Inok
                   End If
              Case Else
                   F = 3
      End Select

      Din(f) = Maxin


      If Inok = 1 Then
         Cls
         For I = 1 To 3
             Lcd Din(i) ; "  "
         Next
         Lowerline
         For I = 4 To 5
             Lcd Din(i) ; "  " ; X
         Next
         Wait 2
         Reset Inok
      End If


')


Return