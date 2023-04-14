'**************************************
'LEARNING REMOTE DECODER
' Program by icpulse.ir
'**************************************
$regfile = "M8def.dat"
$crystal = 11059200




'-------------------------------------------------------------------------------
Configs:


         _in Alias PinB.0 : Config PortB.0 = Input

        Led1 Alias PortC.5: Config PortC.5 = Output
        Led2 Alias PortC.4 : Config PortC.4 = Output
        Led3 Alias PortC.3 : Config PortC.3 = Output
        Led4 Alias PortC.2 : Config PortC.2 = Output

        KEY ALIAS PIND.7:CONFIG PORTD.7=INPUT




        Config Timer1 = Timer , Prescale =8
        Stop Timer1 : Timer1 = 0
        Config Timer0 = Timer , Prescale = 1024
       ' Enable Interrupts









Defines:


        Declare Sub Remotelearn
        Declare Sub Remoteclear







        dim rise as word
        dim fall as word






       ' Dim El(12) As Eram Byte



        Dim S(24)as Word
        Dim I As Byte
        I = 0
        Dim Saddress As String * 20
        Dim Scode As String * 4
        Dim Address As Long
        Dim Code As Byte
        ''''''''''''''''''''''''''''''''
        Dim Ra As Long                                      'fp address
        Dim Rnumber As Byte                                 'remote know
        Dim Rnumber_e As Eram Byte
        Dim Okread As Bit
        Dim Error As Bit
        Dim Keycheck As Bit
        Dim T As Word
        Dim P As Byte                                       'check for pushing lean key time
        Error = 0
        Okread = 0
        T = 0
        Keycheck = 0
        'Dim Eaddress As Word                                        'eeprom address variable
        'Dim E_read As Byte
        'Dim E_write As Byte
        Dim Eevar(2) As Eram Long

        DIM Z AS BYTE

        dim maxstart as word
        dim minstart as word

        dim t1 as word
        dim t2 as word

        dim isok as bit
        dim databit as bit
        dim y as dword

Startup:


  '(
        Rnumber = Rnumber_e
        If Rnumber > 10 Then
        Rnumber = 0
        Rnumber_e = Rnumber
        Waitms 10
        End If
        '------------------- startup
        Waitms 500



        Waitms 500
        Enable Interrupts

     ')

    for i=1 to 8
      toggle led1
      waitms 500
    next

Main:

     Do



         'toggle led2
         'waitms 100
         Gosub _read

         '(
         IF KEY=1 THEN
            SET LED1
            DO

               INCR Z
               WAITMS 20

               IF Z>150 THEN
                  RESET LED1
                  SET LED2
                  REMOTECLEAR
                  Z=0
                  WAIT 2
                  RESET LED2
                  EXIT DO
               END IF
               IF KEY=0 THEN EXIT DO
            LOOP
               IF Z>150 THEN
                  RESET LED1
                  SET LED2
                  REMOTECLEAR
                  WAIT 2
                  RESET LED2
               END IF
            IF Z<100 THEN
               SET LED3
               REMOTELEARN
               WAIT 1
               RESET LED3
            END IF
         END IF
         ')
     Loop

  GOSUB MAIN


'--------------------------------------------------------------------------read
_read:
Okread = 0
timer1=0
set error
If _in = 1 Then
   start timer1
   Do
      'Reset Watchdog
      If _in = 0 Then Exit Do

   Loop
   stop timer1
   rise=timer1
   maxstart=rise*32
   minstart=rise*29
   Timer1 = 0
   Start Timer1
   While _in = 0

   Wend
   Stop Timer1
   fall=timer1
   If fall>minstart and fall < maxstart Then

      i=0
      Do
            If _in = 1 Then
               Timer1 = 0
               Start Timer1
               While _in = 1
                     'Reset Watchdog
               Wend
               Stop Timer1
               rise=timer1
               timer1=0
               start timer1
               while _in=0

               wend
               stop timer1
               fall=timer1

               if rise>fall then
                  t1=fall*2
                  t2=fall*4
                  if rise>t1 and rise <t2 then
                     set databit
                     set isok
                  else
                     set error
                     exit do
                  end if
               elseif fall>rise then
                  t1=rise*2
                  t2=rise*4
                  if fall>t1 and fall<t2 then
                     reset databit
                     set isok
                  else
                     set error
                     exit do
                  end if

               else
               end if
               if isok=1 then
                  Incr I
                  S(i) = databit
               else
                  set error
                  exit do
               end if
            End If
               'Reset Watchdog

            If I = 24 Then
               reset error
               Exit Do
            endif
      Loop
      if error =0 then
         I = 0
         Saddress = ""
         Scode = ""
         For I = 1 To 20
            Saddress = Saddress + Str(s(i))

         Next
         For I = 21 To 24

            Scode = Scode + Str(s(i))
         Next
         Address = Binval(saddress)
         Code = Binval(scode)
         Gosub Check
      ''''''''''''''''''''''''''''''''''''''''''
         I = 0
      end if
   End If
End If
Return
'================================================================ keys  learning


'========================================================================= CHECK
Check:
      Okread = 1

      select case code
         case 0
            led1=0 :led2=0:led3=0:led4=0
         case 1
            led1=0 :led2=0:led3=0:led4=1
         case 2
            led1=0 :led2=0:led3=1:led4=0
         case 3
            led1=0 :led2=0:led3=1:led4=1
         case 4
            led1=0 :led2=1:led3=0:led4=0
         case 5
            led1=0 :led2=1:led3=0:led4=1
         case 6
            led1=0 :led2=1:led3=1:led4=0
         case 7
            led1=0 :led2=1:led3=1:led4=1
         case 8
            led1=1 :led2=0:led3=0:led4=0
         case 9
            led1=1 :led2=0:led3=0:led4=1
         case 10
            led1=1 :led2=0:led3=1:led4=0
         case 11
            led1=1 :led2=0:led3=1:led4=1
         case 12
            led1=1 :led2=1:led3=0:led4=0
         case 13
            led1=1 :led2=1:led3=0:led4=1
         case 14
            led1=1 :led2=1:led3=1:led4=0
         case 15
            led1=1 :led2=1:led3=1:led4=1
      end select
'(
      If Keycheck = 0 Then
                                  'agar keycheck=1 bashad yani be ledeha farman nade
         For I = 1 To Rnumber

             Ra = Eevar(i)

             If Ra = Address Then                           'code

                Gosub Command
                Exit For
             End If
         Next
      End If
      Keycheck = 0
      ')
Return
'-------------------------------- leday command
Command:

            '(
                Select Case Code

                       Case 1
                           TOGGLE LED1
                       Case 2
                           TOGGLE LED2
                       Case 4

                           TOGGLE LED3
                       Case 8
                          TOGGLE LED4
                End Select

               ')


        'Gosub Tx
        Waitms 500
Return












End

 Sub Remoteclear


       For I = 1 To 8
           Toggle Led1
           Rnumber = 0
           Rnumber_e = Rnumber
           Waitms 50
           Eevar(i) = 0
           Waitms 50
           Waitms 400
       Next
End Sub



Sub Remotelearn
     For I = 1 To 8
         Toggle Led1
         Waitms 200
     Next
     Set Led4
     Wait 1
     Reset Led4
      OKREAD =1
     Do
       Gosub _read
       If Okread = 1 Then

               ''''''''''''''''''''''repeat check
               If Rnumber = 0 Then                          ' agar avalin remote as ke learn mishavad
                              Incr Rnumber
                              Rnumber_e = Rnumber
                              Waitms 10
                              Ra = Address
                              Eevar(rnumber) = Ra
                              Waitms 10
                              Exit Do
                              Else                          'address avalin khane baraye zakhire address remote
                              For I = 1 To Rnumber
                                  Ra = Eevar(i)
                                  If Ra = Address Then      'agar address remote tekrari bod yani ghablan learn shode

                                     Error = 1
                                     SET LED4
                                     WAIT 1
                                     RESET LED4
                                     Exit For
                                  Else
                                     Error = 0
                                  End If
                              Next
                              If Error = 0 Then             ' agar tekrari nabod
                                 Incr Rnumber               'be meghdare rnumber ke index tedade remote haye learn shode ast yek vahed ezafe kon
                                 If Rnumber > 2 Then        'agar bishtar az 100 remote learn shavad
                                    Rnumber = 2

                                 Else                       'agar kamtar az 100 remote bod
                                    Rnumber_e = Rnumber     'meghdare rnumber ra dar eeprom zakhore mikonad
                                    Ra = Address
                                    'If Rnumber = 2 Then 4chcode = Code
                                    Waitms 10
                                    Eevar(rnumber) = Ra
                                    Waitms 10
                                    For I = 1 To 8
                                        Toggle Led4
                                        Waitms 250
                                    Next
                                 End If
                              End If
               End If
               Exit Do
       End If
     Loop
     For I = 1 To 8
         Toggle Led2
         TOGGLE LED4
         Waitms 200
     Next
End Sub