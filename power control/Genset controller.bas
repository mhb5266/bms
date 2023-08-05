$regfile = "m16def.dat"
$crystal = 1000000
configs:
Config Lcdpin = Pin ; Db7 = Portb.5 ; Db6 = Portb.4 ; Db5 = Portb.3 ; Db4 = Portb.2 ; Enable = Portb.1 ; Rs = Portb.0
Cursor Off
cls
Config Adc = Free , Prescaler = Auto
Config Timer1 = Timer , Prescale =256
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
buz Alias Portd.6 : Config Portd.6 = Output

defines:
Dim In1ok As Bit : Dim In2ok As Bit : Dim Ingok As Bit
Dim B As Byte
Dim X As Byte:x=35
dim z as byte

Dim I As Word
dim adcin as dword
Dim Vin As Single
Dim In1 As Word
Dim In2 As Word
Dim Ing As Word
dim inok(3) as byte
Dim Min1(5) As Single
dim min2(5) as single
dim ming(5) as single
dim backup as  single
dim volt as string*5
dim v(3) as string*5
Dim Times As Byte
Dim Etimes As Eram Byte
dim sttime as byte
dim esttime as byte
Declare Sub Calvolt
Declare Sub Startgen
Declare Sub Readvolt
Declare Sub Showvolt
Declare Sub Readkeys
declare sub testvolt
declare sub keyorder
declare sub initial
Declare Sub Beep
Declare Sub Errorbeep
Declare Sub Lbeep
Declare Sub Findorder
declare sub findstatus
Declare Sub Resetall

Dim Order As String * 10
dim status as string *10
Dim Turn As Byte
Dim Move As Byte
Dim T As Byte
Dim Beeptime As Byte
Dim Tms As Byte
Dim Touch As Byte
Dim Gen As Byte
dim _sec as byte
dim lsec as byte
dim newtime as byte
startup:

status="auto"
order=""

main:
   initial
   cls
   do
      readkeys
      if touch>0 then
         select case touch
            case 1
               order="stop"

            case 2
               order="auto"
            case 3
               order="run"

            case 4
               order="test"

         end select
         status=order
      end if

      findorder




      if _sec<>lsec then

            lsec=_sec
            readvolt
            showvolt
            findstatus


      end if




   loop



t1rutin:
      Stop Timer1
           incr tms
           if tms=10 then
            tms=0
            Incr _sec

            if t>0 then decr t

               if x<36 then incr x

           end if
           If Beeptime > 0 Then
              set buz
              Decr Beeptime
              If Beeptime = 0 Then
                 Reset Buz
              End If
           End If

      'Timer1 = 64910
      Timer1 = 65181

      Start Timer1

return



end

sub findorder

      select case order

         case "stop"
               set led1:reset led2:reset led3:reset led4
               cls
               lcd "push test & stop"
               z=80
               do
                  if key1=0 and key4=0 then
                     set buz
                     waitms 500
                     reset buz
                     cls
                     lcd "Stop All"
                     for turn=1 to 12
                        t=2
                        do
                           'readkeys
                           'if touch>0 then exit do
                           if t=0 then exit do
                        loop
                        if _sec<>lsec then
                           lsec=_sec
                           i=turn mod 2
                           if i=0 then lcd "*"
                           select case turn
                              case 1
                                 reset  l1k1
                              case 3
                                 reset l2k2
                              case 5
                                reset l1g
                              case 7
                                 reset l2g
                              case 9
                                 reset startt
                              case 11
                                 reset sw
                           end select
                        end if
                     next
                     cls
                     lcd "Stop All Done"
                     lowerline
                     lcd "Press Any Key"
                     do
                        readkeys
                        if touch>0 then exit do
                     loop
                     if touch>0 then keyorder
                  else
                     waitms 100
                     decr z
                     if z=0 then
                        status="auto"
                        cls
                        exit do
                     end if
                  end if
               loop

         case "auto"
         '(
            reset led1:set led2:reset led3:reset led4
            z=0
            i=0
            x=0
            do
               'do
                  'if key1=1 and key2=1 and key3=1 and key4=1 then exit do
               'loop
               readkeys
               if touch>0 then exit do
               if _sec<>lsec then
                  lsec=_sec
                  select case x
                     case 1 to 20

                           readvolt
                           showvolt
                           if in1ok=1 then incr z else decr z
                           if in2ok=1 then incr i else decr z

                     case 21 to 24
                        if z>12 and in1ok=1 then
                           set l1k1
                        end if
                     case 25

                     case 27 to 29
                        if i>12 and in2ok=1 then
                           set l2k2
                        end if
                        x=35
                        if l1k1=1 and l2k2=1 then exit do
                  end select
               end if
            loop

            ')
         case "run"
            reset led1:reset led2:set led3:reset led4
            cls
            lcd order
            turn=0
            do
               startgen
               if in1ok=1 and in2ok=1 then
                  status="auto"
                  exit do
               end if
               if ingok=1 then
                  if in1ok=0 or in2ok=0 then
                   status="run"
                   exit do
                  end if
               else
                  incr turn
               endif
               if turn>5 then
                  cls
                  lcd "Genarator Error"
                  wait 3
                  cls
                  exit do
               end if
            loop
         case "test"
               status="test"
               reset led1:reset led2:reset led3:set led4
               t=3
               do
                  if t=0 then exit do
               loop
               cls
               lcd "Test"
               t=2
               do
                  if t=0 then exit do
               loop
               cls
               t=2
               do
                  if t=0 then exit do
               loop
               startgen
               if ingok=1 then
                  do
                     showvolt
                     readkeys
                     if touch>0 then exit do
                  loop
               end if
      end select
      order=""
end sub

sub findstatus
      select case status
         case "stop"
            set led1:reset led2:reset led3:reset led4
            cls
            lcd "Status= ";status
            do
               readkeys
               if touch>0 then
                  cls
                  exit do
               end if
            loop
            if touch>0 then keyorder

         case "auto"

            reset led1:set led2:reset led3:reset led4
            testvolt
            if in1ok=0 or in2ok=0 then
               t=30
               do
                  readvolt
                  showvolt
                  readkeys
                  if touch>0 then exit do

                  if t=0 then exit do
               loop
               if touch>0 then keyorder
               if in1ok=0 or in2ok=0 then  order="run"
            else
                  wait 2
                  set l1k1
                  wait 3
                  set l2k2
                  wait 7

               do
                  readvolt
                  showvolt
                  if in1ok=0 or in2ok=0 then
                     order="run"
                     exit do
                  end if
                  readkeys
                  if touch>0 then exit do
               loop
               if touch>0 then keyorder
            end if

         case "run"

            reset led1:reset led2:set led3:reset led4
            testvolt
            if in1ok=1 and in2ok=1 then
               order="auto"
            else
               b=0
               do
                  if ingok=1 then
                     x=0
                     do
                        select case x
                           case 1
                              if in1ok=0 then reset l1k1
                           case 2
                              readvolt
                              showvolt

                           case 4
                              if in1ok=0 then set l1g
                           case 6
                              readvolt
                              showvolt
                           case 8
                              if in2ok=0 then reset l2k2
                           case 10
                              readvolt
                              showvolt
                           case 12
                              if in2ok=0 then set l2g
                           case 14
                              readvolt
                              showvolt
                           case 16
                              if in1ok=1 then reset l1g
                           case 18
                              readvolt
                              showvolt
                           case 20
                              if in1ok=1 then set l1k1
                           case 22
                              readvolt
                              showvolt
                           case 24
                              if in2ok=1 then reset l2g
                           case 26
                              readvolt
                              showvolt
                           case 28
                              if in2ok=1 then set l2k2
                           case 30
                              readvolt
                              showvolt
                           case 32
                              if in1ok=1 and in2ok=1 and l1g=0 and l2g=0 then
                                 reset sw
                                 reset startt
                                 status="auto"
                                 exit do
                              end if
                           case 34
                              readvolt
                              showvolt
                        end select
                        if x>35 then x=7
                        readkeys
                        if touch>0 then exit do

                     loop
                     if touch>0 then keyorder
                     if status="auto" then exit do
                  else
                     order="run"
                     exit do

                  end if
               loop
            end if
         case "test"
            reset led1:reset led2:reset led3:set led4

      end select
end sub

sub readkeys
   t=0
   touch=0
    If Key1 = 0 Then
       Set Buz
       Waitms 25
       Touch = 1
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key1 = 1
       Reset Buz
    End If

    If Key2 = 0 Then
       Set Buz
       Waitms 25
       Touch = 2
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key2 = 1
       Reset Buz
    End If

    If Key3 = 0 Then
       Set Buz
       Waitms 25
       Touch = 3
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key3 = 1
       Reset Buz
    End If

    If Key4 = 0 Then
       Set Buz
       Waitms 25
       Touch = 4
       I = 0
       Do
         Incr I
         Waitms 50
         If I = 4 Then Exit Do
       Loop Until Key4 = 1
       Reset Buz
    End If
end sub


Sub Readvolt
           adcin=getadc(0)
           calvolt
           v(1)=volt
           min1(i)=vin
           Adcin = Getadc(2)
           calvolt
           v(2)=volt
           min2(i)=vin
           Adcin = Getadc(1)
           Calvolt
           V(3) = Volt
           Ming(i) = Vin

           In1 = Val(v(1))
           In2 = Val(v(2))
           Ing = Val(v(3))

           If In1 > 170 And In1 < 250 Then In1ok = 1 Else In1ok = 0
           If In2 > 170 And In2 < 250 Then In2ok = 1 Else In2ok = 0
           If Ing > 170 And Ing < 250 Then Ingok = 1 Else Ingok = 0
           If In1ok = 1 And In2ok = 1 And Ingok = 0 Then
              'In1 = In1 - 9
              'In2 = In2 - 9
           End If
           If In1ok = 0 And In2ok = 1 And Ingok = 1 Then
              'Ing = Ing - 9
              'In2 = In2 - 9
           End If
           If In1ok = 1 And In2ok = 0 And Ingok = 1 Then
              'In1 = In1 - 9
              'Ing = Ing - 9
           End If
           If In1ok = 1 And In2ok = 0 And Ingok = 0 Then
              'In1 = In1 - 22
           End If
           If In1ok = 0 And In2ok = 1 And Ingok = 0 Then
              'In2 = In2 - 22
           End If
           If In1ok = 0 And In2ok = 0 And Ingok = 1 Then
              'Ing = Ing - 22
           End If
           Waitms 200
End Sub


Sub Calvolt
      Vin = Adcin
      vin=vin/0.0033
      vin=vin*0.633
      vin=vin/132
      vin=vin*1.14
      Volt = Fusing(vin , "##.#")
End Sub

sub testvolt
   turn=0
   do

         for turn=0 to 10
            do
               if _sec<>lsec then exit do

            loop
            lsec=_sec
            readvolt
            showvolt
            readkeys
            if touch>0 then
               exit do
            end if
            if in1ok=1 then incr inok(1)
            if in2ok=1 then incr inok(2)
            if ingok=1 then incr inok(3)
         next
         exit do
   loop
   if touch>0 then keyorder
end sub

Sub Startgen
   status="rungen"
   readvolt
   if ingok=1 then
      cls
      lcd "Genarator ON"
      set sw
      set startt
   else
      x=0
      newtime=sttime+6
      do
         if _sec<>lsec then
            lsec=_sec
            select case x
               case 1

                  reset sw:reset startt
               case 2
                  cls:lcd "SW ON"
                  set sw
               case  6
                  cls:lcd "Start ON"
                  set startt
               case newtime
                  cls:lcd "Start OFF"
                  reset startt
               case 16 to 35

                     readvolt
                     showvolt
                     readkeys
                     if touch>0 then exit do
                     if ingok=1 then incr z
                     if in1ok=1 and in2ok=1 then
                        status="auto"
                        exit do
                     end if
                     if z>10 then exit do
                     if x>28 then exit do

            end select
          endif
      loop
      if touch>0 then keyorder
   end if

End Sub

Sub Showvolt
    'Waitms 300
    If status = "auto" or status="run" or status="run" Then
         Home
         If In1ok = 1 And In2ok = 1 Then
            Lcd "V1=" ; In1 ; "       "
            Lowerline
            Lcd "V2=" ; In2 ; "      "
         End If
         If In1ok = 0 And In2ok = 1 Then
            Lcd "V2=" ; In2 ; "       "
            Lowerline
            Lcd "VG=" ; Ing ; "      "
         End If
         If In1ok = 1 And In2ok = 0 Then
            Lcd "V1=" ; In1 ; "        "
            Lowerline
            Lcd "VG=" ; Ing ; "       "
         End If
         If In1ok = 0 And In2ok = 0 And Ingok = 1 Then
            Lcd "Gen=ON  Line=OFF"
            Lowerline
            Lcd "VG=" ; Ing ; "       "
         End If
         If In1ok = 0 And In2ok = 0 And Ingok = 0 Then
            Lcd "V1=" ; In1 ; " VG=";ing;"   "
            Lowerline
            Lcd "V2=" ; In2 ; "      "
         End If
         'Lcd V(3) ; " G "
    End If
    If status = "rungen" or status="test" Then
         Cls
         Lcd "Voltage Test"
         Lowerline
         Lcd "VG=" ; Ing ; "      "
    End If
    locate 2,8
    lcd status ;" ";_sec ;"   "
End Sub


sub keyorder
   wait 1
   do
      readkeys
      if touch=0 then exit do
   loop
   cls
   lcd "Press Any Key"
   do
      readkeys
      if touch>0 then exit do
   loop
   cls
      if touch>0 then
         select case touch
            case 1
               order="stop"
            case 2
               order="auto"
            case 3
               order="run"
            case 4
               order="test"
         end select
         status=order
      end if
      findorder
end sub

sub initial
   cls
   lcd "  Em Electronic "
   if etimes>250 then etimes=10
   times=etimes
   if esttime>250 then esttime=5
   sttime=esttime
   x=0
   wait 2
   cls
   do
      if _sec<>lsec then
         lsec=_sec
         readkeys
         if touch>0 then x=0
         select case touch
            case 1
               decr times
            case 2
                 exit do
            case 3
                incr times
            case 4
                 exit do
         end  select
         if x=10 then exit do
         if times>20 then times=5
         if times<5 then times=20
         home
         lcd "time=";times;" s    "; x
      end if
   loop
   cls : lcd times
   wait 3
   cls
   etimes=times
   x=0
   do
      if _sec<>lsec then
         lsec=_sec
         readkeys
         if touch>0 then x=0
         select case touch
            case 1
               decr sttime
            case 2
                 exit do
            case 3
                incr sttime
            case 4
                 exit do
         end  select
         if x=10 then exit do
         if sttime>6 then sttime=2
         if sttime<2 then sttime=6
         home
         lcd "start time=";sttime;" s    "; t
      end if
   loop
   cls : lcd sttime
   esttime=sttime
   wait 3
   cls
end sub