$regfile = "m16def.dat"
$crystal = 11059200
configs:
Config Lcdpin = Pin ; Db7 = Portb.5 ; Db6 = Portb.4 ; Db5 = Portb.3 ; Db4 = Portb.2 ; Enable = Portb.1 ; Rs = Portb.0
Cursor Off
cls
Config Adc = single , Prescaler = Auto
Config Timer1 = Timer , Prescale =1024
Enable Interrupts
Enable Ovf1
On Ovf1 T1rutin
Timer1 = 65181
'Enable Int0
'On Int0 Intisr
'config int0=FALLING
'
'trig alias pind.2:config portd.2=INPUT
Pg Alias Portd.7 : Config Portd.7 = Output
Startt Alias Portd.5 : Config Portd.5 = Output
L1k1 Alias Portd.0 : Config Portd.0 = Output
L2k2 Alias Portd.2 : Config Portd.2 = Output
L1g Alias Portd.1 : Config Portd.1 = Output
L2g Alias Portd.3 : Config Portd.3 = Output
Sw Alias Portd.4 : Config Portd.4 = Output

Led1 Alias Portc.3 : Config Portc.3 = Output
Led2 Alias Portc.2 : Config Portc.0 = Output
Led3 Alias Portc.1 : Config Portc.1 = Output
Led4 Alias Portc.0 : Config Portc.2 = Output
key1 Alias Pinc.6 : Config Portc.6 = Input
key2 Alias Pinc.5 : Config Portc.5 = Input
Key3 Alias Pinc.4 : Config Portc.4 = Input
Key4 Alias Pinc.7 : Config Portc.7 = Input
Buz Alias Portd.6 : Config Portd.6 = Output

Defines:
Dim A As Byte
Dim X As Byte:x=35
dim z as byte
dim touchpad(4) as byte


Dim stoff As byte

dim inok(3) as byte

dim sttime as byte
dim esttime as byte
dim vtest as byte
dim lvtest as byte:lvtest=255
dim j as word
dim sensorvalue(3) as word
dim value1(100) as word
dim value2(100) as word
dim value3(100) as word
dim midv(3) as single
dim vmaxd as word
dim veffd(3) as single
Dim Veff(3) As Word
Dim Maxv As Word
Dim Minv As Word
Dim Emaxv As Word
Dim Eminv As Word

Declare Sub Readvolt
Declare Sub Showvolt
Declare Sub Readkeys
Declare Sub Testvolt
'Declare Sub Menu


Declare Sub Findorder

Dim Order As String * 10
dim status as string *10
Dim Turn As Byte
Dim Try As Byte
Dim T As Byte
Dim Beeptime As Byte
Dim Tms As Byte
Dim Touch As Byte
Dim Gen As Byte
dim _sec as byte
dim lsec as byte
'dim newtime as byte
Startup:


Set Buz
waitms 200
reset buz
status="auto"
order=""
sttime=esttime
waitms 100
if sttime>7 or sttime<1 then sttime=2
Esttime = Sttime
Waitms 100
Maxv = Emaxv
Waitms 100
If Maxv > 300 Then Maxv = 260
If Maxv < 250 Then Maxv = 260
Waitms 100
Minv = Eminv
Waitms 100
If Minv > 200 Then Minv = 170
If Minv < 150 Then Minv = 170
Waitms 100
Emaxv = Maxv
Waitms 100
Eminv = Minv
stoff=0
do
  wait 1
  if key1=1 and key2=1 and key3=1  and key4=1 then
     exit do
  end if
loop

Main:
do

   if lsec<> _sec  then
      lsec=_sec
      readvolt
      testvolt
      select case turn
             Case 19 To 40
                  showvolt
             case 15
                  showvolt
             case 11
                  showvolt
             Case 7
                  showvolt
             case 3
                  showvolt
             case 0
                  showvolt
      end select


      if status="stop" then
         reset sw
         reset startt
         Turn = 40
         Status = "auto"
      end if

      if status="run" then
               select case turn

                      case 38
                         Set Sw
                      case 35
                         if  inok(3)=0 then set startt
                      Case 19
                         if inok(3)=0 then incr try else try=5
                         if try<3 then turn=20
                      case 9
                           if inok(3)=1   then
                              Set L1g : Reset L1k1
                           Else
                               Reset L1g
                           End If
                      case 5
                           If Inok(3) = 1 Then
                              Set L2g : Reset L2k2
                           Else
                               Reset L2g
                           End If
               end select
      end if
      if status="test" then
            select case turn

                      case 38
                          Set Sw
                      case 35
                         if inok(3)=0 then set startt
                      case 21
                         if inok(3)=0 then incr try else try=5
                         if try<3 then turn=20

            End Select
      end if
      if status="auto" then


            if vtest<2 and turn>0 then
               select case turn

                      case 38
                         If Vtest < 2 Then Set Sw
                      case 35
                         if vtest<2 and inok(3)=0 then set startt
                      Case 19
                         if inok(3)=0 then incr try else try=5
                         if try<3 then turn=40

                      case 9
                           if inok(1)=0 and inok(3)=1   then set l1g else reset l1g
                      case 5
                           if inok(2)=0 and inok(3)=1  then set l2g else reset l2g
                      case 17
                           if inok(1)=1  then set l1k1 else reset l1k1
                      case 13
                           if inok(2)=1  then set l2k2 else reset l2k2
                      case 1
                           if inok(1)=1 and inok(2)=1 then reset sw
                           if try<5 then reset sw
               end select


            end if
            If Vtest = 2 And Turn > 0 Then

               select case turn


                      Case 19 To 38
                           If Inok(1) = 0 Or Inok(2) = 0 Then
                              Lvtest = 3
                           end if
                      case 17
                           if inok(1)=1  then reset l1g:set l1k1
                      case 13
                           if inok(2)=1  then reset l2g :set l2k2
                      case 1
                           if inok(1)=1 and inok(2)=1 then reset sw
               end select
            End If
      end if

      If Status = "gomenu" Then
         Wait 2
         Do
                  Readkeys

                  Showvolt
                  If Touch = 2 Or Touch = 22 Then Incr Z
                  If Touch = 4 Or Touch = 44 Then Z = 4
                  Select Case Z
                         case 1
                              If Touch = 1 Or Touch = 11 Then Decr Sttime
                              If Touch = 3 Or Touch = 33 Then Incr Sttime

                         case 2
                              If Touch = 1 Or Touch = 11 Then Maxv = Maxv -10
                              If Touch = 3 Or Touch = 33 Then Maxv = Maxv + 10

                         case 3
                              If Touch = 1 Or Touch = 11 Then Minv = Minv -10
                              If Touch = 3 Or Touch = 33 Then Minv = Minv + 10

                         Case 4
                              Esttime = Sttime : Waitms 100
                              Eminv = Minv : Waitms 100
                              Emaxv = Maxv : Waitms 100
                              Status = "auto"
                              Turn = 40
                              Exit Do
                  End Select

                  If Sttime > 9 Then Sttime = 1
                  If Sttime < 1 Then Sttime = 9
                  If Maxv > 300 Then Maxv = 250
                  If Maxv < 250 Then Maxv = 300
                  If Minv > 200 Then Minv = 150
                  If Minv < 150 Then Minv = 200

         Loop

      End If

   End If
   Readkeys
   select case status
          case "stop"
                set led1:reset led2:reset led3:reset led4
          case "auto"
                reset led1:set led2:reset led3:reset led4
          case "run"
                reset led1:reset led2:set led3:reset led4
          case "test"
                reset led1:reset led2:reset led3:set led4
   end select
   findorder

loop

T1rutin:
      Stop Timer1
           incr tms

           if tms=4 then
              tms=0
              Incr _sec
              if turn>0 then decr turn
              if t>0 then decr t
              if startt=1 then
                 incr stoff
                 if sttime>7 then sttime=2
                 if stoff= sttime then
                    reset startt
                    stoff=0
                 end if
              end if
              if x<36 then incr x
              'toggle l1k1
           end if

           If Beeptime > 0 Then
              set buz
              Decr Beeptime
              If Beeptime = 0 Then
                 Reset Buz
              End If
           End If

        'toggle l1k1    '
      'Timer1 = 54735
      Timer1 = 62835

      Start Timer1

return



end

sub readvolt
    midv(3)=0
    for j= 1 to 100
      sensorValue(1) = getadc(2)
      sensorValue(2) = getadc(1)
      sensorValue(3) = getadc(0)


      value1(j)=sensorvalue(1)

      value2(j)=sensorvalue(2)

      value3(j)=sensorvalue(3)

        waitus 200
    next
    for j=1 to 100
        veffd(1)=value1(j)+veffd(1)
        veffd(2)=value2(j)+veffd(2)
        veffd(3)=value3(j)+veffd(3)
    next
    midv(1)=veffd(1)/100
    midv(2)=veffd(2)/100
    midv(3)=veffd(3)/100

    if midv(1)>390 then
       veffd(1)=midv(1)-390
    else
        veffd(1)=0
    end if

    if midv(2)>390 then
       veffd(2)=midv(2)-390
    else
        veffd(2)=0
    end if

    if midv(3)>390 then
       veffd(3)=midv(3)-390
    else
        veffd(3)=0
    end if

    veff(1)=veffd(1)*1.04

    veff(2)=veffd(2)*1.04

    veff(3)=veffd(3)* 1.04


end sub

Sub Showvolt
   If Status <> "gomenu" Then
      cls
      Lcd "V1" ; "  " ; "V2" ; "  " ; "VG"
      lowerline
      Locate 2 , 1 : Lcd Veff(1)
      locate 2,5 :lcd  veff(2)
      locate 2,9 :lcd  veff(3)
      Locate 2 , 13
      if turn>0 then
       Lcd ">"
       Select Case Status
              Case "stop"
                    Lcd "1"
              Case "auto"
                    Lcd "2"
              Case "run"
                   Lcd "3"
              Case "test"
                   Lcd "4"
              Case "gomenu"
                   Lcd "5"
              Case Else
                   Lcd "?"
       End Select
       Else
           Lcd "  "
       End If
      If Startt = 1 Then Lcd "*" Else Lcd "!"
      if sw=1 then lcd "*" else lcd "!"
      Locate 1 , 13


      if l2g=1 then lcd "*" else lcd "!"
      if l2k2=1 then lcd "*" else lcd "!"
      if l1g=1 then lcd "*" else lcd "!"
      if l1k1=1 then lcd "*" else lcd "!"
   Elseif Status = "gomenu" Then
       A = _sec Mod 2
       If Touch > 0 Then A = 1
       Home : Lcd "StTime= " : If A = 0 And Z = 1 Then Lcd "  " Else Lcd Sttime
       Lowerline
       Lcd "Max=" : If A = 0 And Z = 2 Then Lcd "     " Else Lcd Maxv ; "  "
       Locate 2 , 10
       Lcd "Min=" : If A = 0 And Z = 3 Then Lcd "     " Else Lcd Minv ; "  "
   end if
End Sub

Sub Testvolt
    vtest=0
    If Veff(1) > Minv And Veff(1) < Maxv Then
       incr vtest : inok(1)=1
    else
        inok(1)=0
    End If
    If Veff(2) > Minv And Veff(2) < Maxv Then
       incr vtest : inok(2)=1
    else
        inok(2)=0
    end if

    If Veff(3) > Minv And Veff(3) < Maxv Then Inok(3) = 1 Else Inok(3) = 0

    if lvtest<>vtest then
       lvtest=vtest
       turn=40
       try=0
    end if
end sub

Sub Readkeys
    touch=0
    If Key1 = 0 Then
       Do
           Incr Touchpad(1)
           select case touchpad(1)
                  Case 1 To 4
                       set buz
                  Case 4 To 16
                       reset buz
                  Case 16 To 18
                       set buz
                  Case Is > 18
                  Reset Buz
                  Exit Do
           End Select
           Waitms 25
           If Key1 = 1 Then Exit Do
       Loop
       Select Case Touchpad(1)
           case 1 to 12
                touch=1
           case is>18
                Touch = 11
       End Select
       Touchpad(1) = 0
       Reset Buz

    End If

    If Key2 = 0 Then
       Do
           Incr Touchpad(2)
           Select Case Touchpad(2)
                  Case 1 To 4
                       set buz
                  Case 4 To 16
                       reset buz
                  Case 16 To 18
                       set buz
                  Case Is > 18
                       Reset Buz
                       Exit Do
           End Select
           Waitms 25
           If Key2 = 1 Then Exit Do
       Loop
       Select Case Touchpad(2)
           case 1 to 12
                Touch = 2
           case is>18
                Touch = 22
       End Select
       Touchpad(2) = 0
       Reset Buz
    End If

    If Key3 = 0 Then
       Do
           Incr Touchpad(3)
           Select Case Touchpad(3)
                  Case 1 To 4
                       set buz
                  Case 4 To 16
                       reset buz
                  Case 16 To 18
                       set buz
                  Case Is > 18
                  Reset Buz
                  Exit Do
           End Select
           Waitms 25
           If Key3 = 1 Then Exit Do
       Loop
       Select Case Touchpad(3)
           case 1 to 12
                Touch = 3
           case is>18
                Touch = 33
       End Select
       Touchpad(3) = 0
       Reset Buz
    End If

    If Key4 = 0 Then
       Do
           Incr Touchpad(4)
           Select Case Touchpad(4)
                  Case 1 To 4
                       set buz
                  Case 4 To 16
                       reset buz
                  Case 16 To 18
                       set buz
                  Case Is > 18
                  Reset Buz
                  Exit Do
           End Select
           Waitms 25
           If Key4 = 1 Then Exit Do
       Loop
       Select Case Touchpad(4)
           Case 1 To 12
                Touch = 4
           case is>18
                Touch = 44
       End Select
       Touchpad(4) = 0
       Reset Buz
    End If
end sub


Sub Findorder:
    select case touch
           case 1
               ' set led1:reset led2:reset led3:reset led4
                Status = "stop"

           case 2
                'reset led1:set led2:reset led3:reset led4
                status="auto"
                turn=40
           case 3
                'reset led1:reset led2:set led3:reset led4

                Cls
                Lcd "Press stop+test"
                Touchpad(1) = 0
                Do
                  If Key1 = 0 And Key4 = 0 Then
                     Waitms 200
                            If Key1 = 0 And Key4 = 0 Then
                               Status = "run"
                               Cls
                               Set Buz
                               Lcd "generator run"
                               Wait 1
                               Reset Buz
                               Do
                                 If Key1 = 1 And Key4 = 1 Then Exit Do
                               Loop
                               Exit Do
                            End If
                  End If
                  Incr Touchpad(1)
                  Waitms 250
                  If Touchpad(1) = 40 Then
                     Status = "auto" : Touchpad(1) = 0 : Exit Do
                  End If
                Loop
                Cls
                turn=40
           case 4
                'reset led1:reset led2:reset led3:set led4
                status="test"
                Turn = 40
           Case 22
                Status = "gomenu"
                Cls
                Z = 0
                'turn=40
    end select
end sub



