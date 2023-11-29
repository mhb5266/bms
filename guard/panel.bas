$regfile = "m16def.dat"
$crystal = 11059200
$baud = 9600

configs:

''config kbd = PORTa
'Config Serialin = Bufferout , Size = 50
'CONFIG SERIALOUT = BUFFErout , SIZE = 20
Open "COMC.2:9600,8,n,1" For Output As #1
Open "COMC.3:9600,8,n,1" For input As #2

'config WATCHDOG=2048
ENABLE INTERRUPTS
ENABLE URXC
ON URXC RXIN

'ENABLE UTXC
'ON UTXC TXRUTIN

config timer1 = timer , prescale = 1024
enable timer1
on timer1 t1rutin
start timer1

SIMRST ALIAS PORTd.4 : CONFIG PORTd.4 = OUTPUT
SIMON ALIAS PORTD.5 : CONFIG PORTD.5 = OUTPUT

relay alias porta.3:config porta.3=OUTPUT
rout ALIAS PORTb.0 : CONFIG PORTb.0 = OUTPUT
bstatus ALIAS PORTA.1 : CONFIG PORTA.1 = OUTPUT
gpg ALIAS PORTA.0 : CONFIG PORTA.0 = OUTPUT
'rout ALIAS PORTc.1 : CONFIG PORTc.1 = OUTPUT
pir alias pinc.5 : config portc.5 = INPUT
en485 alias portc.4:config portc.4=OUTPUT
set en485
set simrst




defines:
dim rwd as word
dim state as byte
dim w as byte
dim key as byte
DIM B AS BYTE
DIM ERRORT AS BYTE
dim status as byte
DIM K AS BYTE
DIM SS AS STRING * 100
DIM TT AS WORD
dim timee as byte
dim ltime as byte
DIM I AS BYTE
DIM SIMOK AS BIT
DIM X AS BYTE
DIM AR(10) AS STRING * 25
DIM J AS BYTE
DIM SENDOK AS BIT
DIM N AS String * 2
DIM INNUMBER AS STRING * 15 : INNUMBER = "+989376921503"
'DIM ADMIN AS STRING * 15 : ADMIN = "+989376921503"
CONST ADMIN= "+989376921503"
DIM OWNER1 AS ERAM STRING * 15 : DIM OWN1 AS STRING * 15
DIM OWNER2 AS ERAM STRING * 15 : DIM OWN2 AS STRING * 15
DIM PASSWORD AS ERAM STRING * 4 : DIM pass as string *  4:DIM PASSEN AS ERAM BYTE
CONST APASS="5266"
CONST DPASS="1234"
'dim eID as eram string * 10
 dim ID as string * 15
'DIM ENID AS ERAM BYTE
DIM SMS AS STRING * 100
DIM SMSOK AS BIT
DIM OUTBOX AS STRING * 100
DIM ORDER AS STRING * 10
DIM TEXT AS STRING * 40
dim timeout as byte
dim shh as string *2
dim smin as string*2
dim _hour as  byte
dim _min as byte
dim _sec as byte
dim intime as string * 25
dim elock as eram byte
dim lock as byte
dim leds as byte
DIM ETYP AS ERAM BYTE
DIM TYP AS BYTE
DIM TTT AS BYTE

DECLARE SUB TX
DECLARE SUB RXIN
DECLARE SUB SIMCHECK
DECLARE SUB SMSCONFIG
DECLARE SUB READSMS
DECLARE SUB SENDSMS
declare sub flushbuf
DECLARE SUB SIMRESET
declare sub makeacall
DECLARE SUB SIMCONFIG

startup:
'(
   do
     print #1,"Hi"

     wait 2
     toggle relay
     wait 2
  loop
  ')
   state=0
   OWN1=OWNER1
   WAITMS 30
   OWN2=OWNER2
   WAITMS 30
   X=INSTR (OWN1,"+98")
   IF X=0 THEN
      OWN1="111111111111111"
   END IF
   X=INSTR (OWN2,"+98")
   IF X=0 THEN
      OWN2="111111111111111"
   END IF

   OWNER1=OWN1
   WAITMS 30
   OWNER2=OWN2
   WAITMS 30

   state=1
   lock = elock
   if lock > 2 and lock <> 0 then
      lock = 0
      elock = lock
      waitms 10
   end if

   TYP = eTYP
   if TYP > 2 and TYP <> 0 then
      TYP = 0
      eTYP = TYP
      waitms 10
   end if
   'do
    '  if pir=0 then set rout else reset rout

   'loop
   RESET SIMON
   SET rout
   print #1,"SIM IS POWERDOWN"
   TT = 5
   DO
      IF TT = 0 THEN EXIT DO
   LOOP
   print #1,"SIM IS POWERUP"
   SET SIMON
   RESET rout
   SET bstatus
   RESET SIMRST
   print #1,"SIM IS RESETING"
   TT = 5
   DO
      IF TT = 0 THEN EXIT DO
   LOOP
   SET SIMRST
   TT = 25
   DO
      IF TT = 0 THEN EXIT DO
   LOOP
   RESET bstatus
   status = 0

   K = 0
   print "ATE0"
   'print "AT"
   'TEXT="AT&F"

   'TX

  ' print #1,"Wait until normal"





   TT = 5
   DO
      IF TT = 0 THEN EXIT DO
   LOOP
   DO
      flushbuf
      TEXT = "ATE0"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.0
         EXIT DO
      else
         reset status.0
      end if
      INCR K
      IF K = 5 THEN GOSUB STARTUP
   LOOP
   state=2
   SIMCHECK

   state=3
   print #1 , STR(STATUS)
   IF STATUS = 127 THEN
      print #1 , "SIM IS OK"

   ELSE
      print #1 , "SIM IS RESTARTING"
      SIMRESET
   END IF

   innumber = "+989376921503"
   outbox = "Power Up"
   sendsms
SET rout
RESET bstatus
FOR I = 1 TO 10
   TOGGLE rout
   TOGGLE bstatus
   WAITMS 250

NEXT
RESET rout
RESET bstatus
'start WATCHDOG
main:

   do


          state=4
          if ltime <> timee then
            reset watchdog
            rwd=0
            toggle bstatus
            if leds = 0 then reset rout
            if leds = 1 then set rout
            if leds = 2 then toggle rout
            ltime = timee

            k = timee mod 3
            if k = 0 then
               X = ISCHARWAITING()

               IF X > 0 THEN
                  RXIN
                  X = INSTR(SS , "+CMT")
                  IF X > 0 THEN
                     X = SPLIT(SS , AR(1) , ",")
                     N = AR(2)
                     READSMS
                  END IF

               ELSE

               END IF
            end if

            'IF TIMEE=123 THEN
            k = timee mod 30
            if k = 0 then
               TT = 5
               DO
                  flushbuf
                  TEXT = "AT"
                  TX
                  RXIN
                  X = INSTR(SS , "OK")
                  IF X > 0 THEN
                     set status.0
                     EXIT DO
                  else
                     reset status.0
                  end if
                  if tt = 0 then exit do
               LOOP
                  X = INSTR(SS , "OK")
                  IF X > 0 THEN
                     set status.0

                  else
                      k = 0
                      do

                        SIMCHECK
                        IF STATUS = 127 THEN
                           print #1 , "SIM IS OK"
                           exit do
                        end if
                        if status < 64 then
                           print #1 , "SIM IS RESTARTING"
                           PRINT "AT+CFUN=1,1"
                           TT=15
                           do
                              if tt=0 then exit do
                           loop
                           tt=20
                           DO
                              RXIN
                              X=INSTR(SS,"OK")
                              IF X>0 THEN
                                 EXIT DO
                              ELSE
                                 SIMRESET
                                 EXIT DO
                              END IF
                              if tt=0 then exit do
                           LOOP

                        end if
                        print #1 , STR(STATUS)
                        incr k
                        if k = 3 then exit do
                      loop
                  end if
            end if
          endif
            '(
            IF LOCK = 1 THEN

               if pir = 0 then set rout else reset rout
               if pir = 0 and timeout = 0 then
                  if pir = 0 then
                  timeout = 50
                     IF TYP = 0 THEN

                        outbox = "alarm"
                        tt=50
                        do
                           innumber = ADMIN
                           sendsms
                           if sendok = 1 then exit do
                           if tt=0 then exit do
                        loop
                        X=INSTR(OWN1,"+98")

                        IF X>0 THEN
                           tt=50
                           do
                                 innumber = OWN1
                                 sendsms
                                 if sendok = 1 then exit do
                                 if tt=0 then exit do
                           loop
                        END IF
                        X=INSTR(OWN2,"+98")
                        IF X>0 THEN
                           tt=50
                           do
                                 innumber = OWN2
                                 sendsms
                                 if sendok = 1 then exit do
                                 if tt=0 then exit do
                           loop
                        END IF
                     ELSEIF TYP = 2 THEN
                        TEXT = "AT+CCALR?"
                        TX
                        RXIN
                        X = INSTR(SS , " +CCALR: 1")
                        IF X > 0 THEN
                           FLUSHBUF
                           makeacall
                           rxin
                           tt = 40
                           do

                              rxin
                              if tt = 0 then exit do
                              X = INSTR(SS , "OK")
                              IF X > 0 THEN
                                 EXIT DO
                              end if
                              X = INSTR(SS , "BUSY")
                              IF X > 0 THEN
                                 EXIT DO
                              end if
                           loop
                        END IF
                     END IF
                  endif



                  K = 0
                  do
                     if pir = 1 then exit do
                     waitms 250
                     toggle bstatus
                     INCR K
                     IF K = 40 THEN EXIT DO
                  loop
                  if pir = 0 then set rout else reset rout
               end if
            END IF


            ')


   loop



end

TXRUTIN:
   SET SENDOK

RETURN

t1rutin:
   stop timer1
      'timer1 = 54735
      timer1=62835
      incr w
      if w=4 then
            incr rwd
            if rwd<1800 then
               reset watchdog
            end if
            w=0
            incr _sec
            if _sec > 59 then
               _sec = 0
               incr _min
               if _min > 59 then
                  incr _hour
                  _min = 0
                  if _hour > 23 then
                     _hour = 0
                  end if
               end if
            end if
            shh =str(_hour)
            smin=str(_min)
            incr timee
            TOGGLE gpg
            if tt > 0 then decr tt
            IF TTT > 0 THEN DECR TTT

         if pir = 0 AND LOCK = 1 then set rout
         IF PIR = 1 THEN RESET rout
         IF PIR = 0 AND LOCK = 0 THEN TOGGLE rout

         if timeout > 0 then

             decr timeout
             if timeout = 0 then reset rout
         end if
         'print #1,shh;":";smin;":";str(_sec)
      end if
   start timer1

return


SUB SIMRESET
DO
      reset watchdog
      state=5
      RESET SIMON
      SET rout
      TT = 5
      DO
         IF TT = 0 THEN EXIT DO
      LOOP
      SET SIMON
      RESET rout
      SET bstatus
      RESET SIMRST
      TT = 2
      DO
         IF TT = 0 THEN EXIT DO
      LOOP
      SET SIMRST
      TT = 20
      DO
         IF TT = 0 THEN EXIT DO
      LOOP
      RESET bstatus
      status = 0
      K = 0
      'TEXT="AT&F"
      'TX
      TT = 5
      DO
         IF TT = 0 THEN EXIT DO
      LOOP
      DO
         flushbuf
         TEXT = "ATE0"
         TX
         RXIN
         X = INSTR(SS , "OK")
         IF X > 0 THEN
            set status.0
            EXIT DO
         else
            reset status.0
         end if
         INCR K
         IF K = 5 THEN GOSUB STARTUP
      LOOP
      '(
      TT=3
      DO
         flushbuf
         TEXT= "AT"
         TX
         RXIN
         X=INSTR(SS,"OK")
         IF X> 0 THEN
            set status.1
            EXIT DO
         else
            reset status.1
         end if
         if tt=0 then exit do
      LOOP

      TT=3
      DO
         flushbuf
         TEXT= "AT+CPIN?"
         TX
         RXIN
         X=INSTR(SS,"+CPIN: READY")
         IF X> 0 THEN
            set status.2
            EXIT DO
         else
            reset status.2
         end if
         if tt=0 then exit do
      LOOP
')

    '(
      DO
         flushbuf
         TEXT= "AT+CPIN?"
         TX
         'WAITMS 500
         RXIN
         X=INSTR(SS,"+CPIN: READY")
           ' X=INSTR(SS,"OK")
         IF X> 0 THEN EXIT DO
      LOOP
')
   SIMCHECK

   'SMSCONFIG
   print #1 , STR(STATUS)
   innumber = "+989376921503"
   'outbox="sim is restarted"
   'sendsms
   'outbox="empty"
   IF STATUS = 127 THEN EXIT DO

LOOP
END SUB

SUB RXIN:
   timer1 = 54735
   'STOP TIMER1
   B = 0
   TTT = 3
   SS = ""
   DO
      reset watchdog
      B = INKEY()
      'IF B>0 THEN TT=5
      SELECT CASE B
         CASE 0

         CASE 10
            IF SS <> "" THEN EXIT DO
         CASE 13

         CASE ELSE
            SS = SS + CHR(B)


      END SELECT
      if ttT = 0 then exit do

   LOOP
   SS = UCASE(SS)
   print #1 , SS
   'START TIMER1
   TT = 1
   DO
      IF TT = 0 THEN EXIT DO
   LOOP

END SUB

SUB READSMS
   FLUSHBUF
   'TEXT= "AT+CMGR="+N
   PRINT "AT+CMGR=1"
   'TX
   'tt=5
   'do
     ' if tt=0 then exit do
   'loop
   RXIN
   X = SPLIT(SS , AR(1) , CHR(34))
   INNUMBER = AR(4)

   RXIN
   SMS = SS
   'PRINT SMS
   RXIN

   X = INSTR(SMS , DPASS)
   IF X > 0 THEN
      IF OWN1= "111111111111111" THEN
         OWN1=INNUMBER
         OWNER1=OWN1
         WAITMS 30
      ELSEIF OWN2= "111111111111111" THEN
         OWN2=INNUMBER
         OWNER2=OWN2
      END IF
      OUTBOX=INNUMBER+" IS SAVED"
   END IF


   IF INNUMBER=OWN1 OR INNUMBER=OWN2 OR INNUMBER=ADMIN THEN
      ORDER = ""
      X = 0

      X = INSTR(SMS , APASS)
      IF X > 0 THEN ORDER = "APASS"
      X = INSTR(SMS , DPASS)
      IF X > 0 THEN ORDER = "DPASS"
      'X = INSTR(SMS , "PERSIAN")
      'IF X > 0 THEN ORDER = "PERSIAN"

      X = INSTR(SMS , "SMS")
      IF X > 0 THEN ORDER = "SMS"

      X = INSTR(SMS , "CALL")
      IF X > 0 THEN ORDER = "CALL"

      X = INSTR(SMS , "TEMP")
      IF X > 0 THEN ORDER = "TEMP"

      X = INSTR(SMS , "LOCK")
      IF X > 0 THEN ORDER = "LOCK"

      X = INSTR(SMS , "UNLOCK")
      IF X > 0 THEN ORDER = "UNLOCK"

      X = 0
      X = INSTR(SMS , "STATUS")
      IF X > 0 THEN ORDER = "STATUS"

      X = 0
      X = INSTR(SMS , "ANTEN")
      IF X > 0 THEN ORDER = "ANTEN"

      X = 0
      X = INSTR(SMS , "BLINK")
      IF X > 0 THEN ORDER = "BLINK"

      X = 0
      X = INSTR(SMS , "ON")
      IF X > 0 THEN ORDER = "ON"

      X = 0
      X = INSTR(SMS , "OFF")
      IF X > 0 THEN ORDER = "OFF"

      X = 0
      X = INSTR(SMS , "?")
      IF X > 0 THEN ORDER = "?"

      IF SMS <> "" AND ORDER = "" THEN ORDER = "WRONGSMS"

      SELECT CASE ORDER
         CASE "TEMP"
           OUTBOX = "TEMP=24 C"
         CASE "STATUS"
            IF LOCK = 1 THEN OUTBOX = "SYSTEM IS LOCKED"
            IF LOCK = 0 THEN OUTBOX = "SYSTEM IS UNLOCKED"
         CASE "ANTEN"
            OUTBOX = "GOOD"
         CASE "APASS"

         CASE "DPASS"

         CASE "ON"
            leds = 1
            OUTBOX = "LED IS ON"
         CASE "LOCK"
            LOCK = 1
            ELOCK = LOCK
            WAITMS 10
            OUTBOX = "SYSTEM IS LOCKED"
         CASE "UNLOCK"
            LOCK = 0
            ELOCK = LOCK
            WAITMS 10
            OUTBOX = "SYSTEM IS UNLOCKED"
         'CASE "PERSIAN"
            'outbox=" ”·«„"
         CASE "OFF"
            leds = 0
            OUTBOX = "LED IS OFF"
         CASE "BLINK"
            leds = 2
            OUTBOX = "LED IS BLINKING"
         CASE "?"
            OUTBOX = "ITS OK"
         CASE "SMS"
            TYP = 0
            OUTBOX = "SMS IS ACTIVE"
         CASE "CALL"
            TYP = 2
            OUTBOX = "CALL IS ACTIVE"
         CASE "WRONGSMS"
            OUTBOX = "WRONG SMS"
      END SELECT
   END IF
   IF SS = "OK" THEN
      SENDSMS

   END IF
   FLUSHBUF
   ERRORT = 0
   K=0
   DO
      TEXT = "AT+CMGDA=DEL READ"
      INCR K
      TX
      TT = 25
      DO
         RXIN
         IF SS = "OK" THEN EXIT DO
         IF SS <> "" AND SS <> "OK" THEN INCR ERRORT
         IF ERRORT = 10 THEN EXIT DO
         IF TT = 0 THEN EXIT DO
      LOOP
      'RXIN
      IF SS = "OK" THEN EXIT DO
      IF SS <> "" AND SS <> "OK" THEN INCR ERRORT
      IF ERRORT = 10 THEN EXIT DO
      IF K=3 THEN EXIT DO
   LOOP
   FLUSHBUF
   TEXT = "AT"
   TX
   RXIN

END SUB

sub makeacall
   text = "ATD"
   innumber = "+989376921503"
   text = text + innumber
   text = text + ";"
   tx
end sub

SUB SENDSMS


   FLUSHBUF
   reset sendok

   'IF SS="OK" THEN
      x=instr(innumber,"+98")
      if x>0 then

         TEXT = "AT+CMGS=" + CHR(34) + INNUMBER + CHR(34)
         TX
         tt = 70
         do
            inputbin b
            waitms 100
            if b = 62 then exit do
            'incr k
            if tt = 0 then exit do
            reset watchdog
         loop
         IF INNUMBER=OWN1 OR INNUMBER=OWN2  OR INNUMBER=ADMIN THEN
            TEXT = outbox + " -> "
            TEXT = TEXT + shh
            TEXT = TEXT + ":"
            TEXT = TEXT + smin
            TEXT = TEXT + CHR(10)
            TEXT=TEXT+"ID= "
            TEXT=TEXT+ID
            TEXT=TEXT+CHR(26)
         ELSE
            TEXT="Access Denied"+CHR(26)
         END IF
         TX
         FLUSHBUF
         TT=70
         k = 0
         DO
            RXIN
            X = INSTR(SS , "+CMGS")
            IF X > 0 THEN EXIT DO
            'incr k
            'if k = 3 then exit do
            IF TT=0 THEN EXIT DO
         LOOP
         'k = 0
         tt=70
         DO
            RXIN
            X = INSTR(SS , "OK")
            IF X > 0 THEN EXIT DO
            'incr k
            'if k = 10 then exit do
            IF TT=0 THEN EXIT DO
         LOOP
         if x = 0 then simreset
         if x > 0 then set sendok
      else
         print #1,"number is invalid"
      end if


END SUB


SUB SIMCHECK

   print #1 , "SIM CHECK PROCESS"
   RESET SIMOK
   ERRORT = 0
   TT = 5
   DO
      flushbuf
      TEXT = "ATE0&W"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.0
         EXIT DO
      else
         reset status.0
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.0
   TT = 3
   DO
      flushbuf
      TEXT = "AT"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.1
         EXIT DO
      else
         reset status.1
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.1
   K = 0
   DO
      flushbuf
      TEXT = "AT+CPIN?"
      TX
      TT=15
      DO
         x=ischarwaiting()
         if x>0 then exit do
         IF TT=0 THEN EXIT DO
      LOOP
      RXIN
      X = INSTR(SS , "+CPIN: READY")
      IF X > 0 THEN
         set status.2
         EXIT DO
      else
         reset status.2
      end if
      INCR K
      if K = 5 then exit do
   LOOP
   print #1 , STATUS.2
   TT = 3
   DO
      flushbuf
      TEXT = "AT+CMGF?"
      TX
      RXIN
      X = INSTR(SS , "CMGF: 1")
      IF X > 0 THEN
         set status.3
         EXIT DO
      else
         reset status.3
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.3
   TT = 3
   DO
      flushbuf
      TEXT = "AT+CSCS?"
      TX
      RXIN
      X = INSTR(SS , "GSM")
      IF X > 0 THEN
         set status.4
         EXIT DO
      else
         reset status.4
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.4

   TT = 3
   DO
      flushbuf
      TEXT = "AT+CNMI?"
      TX
      RXIN
      X = INSTR(SS , "1,1,0,0,0")
      IF X > 0 THEN
         set status.5
         EXIT DO
      else
         reset status.5
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.5
   TT = 3
   DO
      flushbuf
      TEXT = "AT+CSMP?"
      TX
      RXIN
      X = INSTR(SS , "17,167")
      'X = INSTR(SS , "49,167")
      IF X > 0 THEN
         set status.6
         EXIT DO
      else
         reset status.6
      end if
      if tt = 0 then exit do
   LOOP
   print #1 , STATUS.6
   flushbuf
   text= "AT+GSN"
   tx
   RXIN
   ID=SS
   print #1, SS
   RXIN
   FLUSHBUF
   ERRORT = 0
   DO
      TEXT = "AT+CMGDA=DEL ALL"
      TX
      TT = 30
      DO
          RXIN
         IF SS = "OK" THEN EXIT DO
         IF TT = 0 THEN EXIT DO
      LOOP
      'RXIN
      IF SS = "OK" THEN EXIT DO
      IF SS <> "" AND SS <> "OK" THEN INCR ERRORT
      IF ERRORT = 3 THEN
         errort = 9
         EXIT DO
      end if
   LOOP
   print #1 , STATUS
   IF STATUS < 100 THEN SIMCONFIG
END SUB


sub flushbuf
i = 0
b = 0
 do

   b = inkey()
   if b = 0 then incr i
   if i = 50 then exit do
 loop

end sub

SUB TX
   timer1 = 54735
   RESET SENDOK
   PRINT TEXT


   DO
      IF SENDOK = 1 THEN EXIT DO

   LOOP
   timer1 = 54735
   print #1 , TEXT

END SUB


SUB SIMCONFIG

   print #1 , "SIM CONFIG PROCESS"
   RESET SIMOK
   ERRORT = 0
   TT = 5
   DO
      flushbuf
      TEXT = "ATE0"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.0
         EXIT DO
      else
         reset status.0
      end if
      if tt = 0 then exit do
   LOOP
   TT = 3
   DO
      flushbuf
      TEXT = "AT"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.1
         EXIT DO
      else
         reset status.1
      end if
      if tt = 0 then exit do
   LOOP

   TT = 3
   DO
      flushbuf
      TEXT = "AT+CPIN?"
      TX
      RXIN
      X = INSTR(SS , "+CPIN: READY")
      IF X > 0 THEN
         set status.2
         EXIT DO
      else
         reset status.2
      end if
      if tt = 0 then exit do
   LOOP

   TT = 3
   DO
      flushbuf
      TEXT = "AT+CMGF=1"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.3
         EXIT DO
      else
         reset status.3
      end if
      if tt = 0 then exit do
   LOOP

   TT = 3
   DO
      flushbuf
      TEXT = "AT+CSCS=" + CHR(34) + "GSM" + CHR(34)
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.4
         EXIT DO
      else
         reset status.4
      end if
      if tt = 0 then exit do
   LOOP


   TT = 3
   DO
      flushbuf
      TEXT = "AT+CNMI=1,1,0,0,0"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.5
         EXIT DO
      else
         reset status.5
      end if
      if tt = 0 then exit do
   LOOP

   TT = 3
   DO
      flushbuf
      TEXT = "AT+CSMP=17,167,2,25"
      'TEXT = "AT+CSMP=49,167,0,8"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.6
         EXIT DO
      else
         reset status.6
      end if
      if tt = 0 then exit do
   LOOP

    TT = 3
   DO
      flushbuf
      TEXT = "AT&W"
      TX
      RXIN
      X = INSTR(SS , "OK")
      IF X > 0 THEN
         set status.6
         EXIT DO
      else
         reset status.6
      end if
      if tt = 0 then exit do
   LOOP
   '(
   TT=3
   DO
      flushbuf
      TEXT= "AT+IFC=1"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.6
         EXIT DO
      else
         reset status.6
      end if
      if tt=0 then exit do
   LOOP
')
   FLUSHBUF
   ERRORT = 0

   DO
      TEXT = "AT+CMGDA=DEL READ"
      TX
      TT = 3
      DO
          RXIN
         IF SS = "OK" THEN EXIT DO
         IF TT = 0 THEN EXIT DO
      LOOP
      'RXIN
      IF SS = "OK" THEN EXIT DO
      IF SS <> "" AND SS <> "OK" THEN INCR ERRORT
      IF ERRORT = 3 THEN
         errort = 9
         EXIT DO
      end if
   LOOP
END SUB