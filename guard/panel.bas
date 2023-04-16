$regfile="m16def.dat"
$crystal=11059200
$baud=9600

configs:

config kbd=PORTa
Config Serialin = Buffered , Size = 50
CONFIG SERIALOUT=BUFFERED,SIZE=20
Open "comd.7:9600,8,n,1" For Output As #1

ENABLE INTERRUPTS
'ENABLE URXC
'ON URXC RXIN

ENABLE UTXC
ON UTXC TXRUTIN

config timer1=timer,prescale=1024
enable timer1
on timer1 t1rutin
start timer1

SIMRST ALIAS PORTD.6:CONFIG PORTD.6=OUTPUT
SIMON ALIAS PORTD.5:CONFIG PORTD.5=OUTPUT
LED1 ALIAS PORTA.0:CONFIG PORTA.0 =OUTPUT
LED2 ALIAS PORTA.1:CONFIG PORTA.1=OUTPUT

defines:
dim key as byte
DIM B AS BYTE
DIM ERRORT AS BYTE
dim status as byte
DIM K AS BYTE
DIM SS AS STRING*100
DIM TT AS WORD
dim timee as byte
dim ltime as byte
DIM I AS BYTE
DIM SIMOK AS BIT
DIM X AS BYTE
DIM AR(10) AS STRING*25
DIM J AS BYTE
DIM SENDOK AS BIT
DIM N AS String*2
DIM INNUMBER AS STRING*15 :INNUMBER="+989376921503"
DIM SMS AS STRING*100
DIM SMSOK AS BIT
DIM OUTBOX AS STRING*100
DIM ORDER AS STRING*10
DIM TEXT AS STRING*20

DECLARE SUB TX
DECLARE SUB RXIN
DECLARE SUB SIMCHECK
DECLARE SUB SMSCONFIG
DECLARE SUB READSMS
DECLARE SUB SENDSMS
declare sub flushbuf
DECLARE SUB SIMRESET

startup:
   RESET SIMON
   SET LED1
   TT=5
   DO
      IF TT=0 THEN EXIT DO
   LOOP
   SET SIMON
   RESET LED1
   SET LED2
   RESET SIMRST
   TT=2
   DO
      IF TT=0 THEN EXIT DO
   LOOP
   SET SIMRST
   TT=10
   DO
      IF TT=0 THEN EXIT DO
   LOOP
   RESET LED2
   status=0
   tt=10
   DO
      flushbuf
      TEXT= "ATE0"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.0
         EXIT DO
      else
         reset status.0
      end if
      if tt=0 then exit do
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

               PRINT #1,STR(STATUS)
               IF STATUS=127 THEN
                  PRINT #1,"SIM IS OK"

               ELSE
                  PRINT #1,"SIM IS RESTARTING"
                  SIMRESET
               END IF


SET LED1
RESET LED2
FOR I=1 TO 10
   TOGGLE LED1
   TOGGLE LED2
   WAITMS 250
NEXT
RESET LED1
RESET LED2
main:

   do



         if ltime<> timee then
            toggle led2
            IF ORDER="BLINK" THEN
               toggle led1

            END IF
            ltime=timee
            '(
            FLUSHBUF
            TEXT="AT"
            TX
            RXIN
            FLUSHBUF
            TEXT="AT+CSCLK=0"
            TX
            RXIN
            FLUSHBUF
            TEXT="AT+CMGR=1"
            TX
            RXIN
            IF SS<>"OK" THEN READSMS
            ')
            X=ISCHARWAITING()

            IF X>0 THEN
               RXIN
               X=INSTR(SS,"+CMT")
               IF X>0 THEN
                  X=SPLIT(SS,AR(1),",")
                  N=AR(2)
                  READSMS
               END IF
               '(
            ELSE
               X=TIMEE MOD 10
               IF X=0 THEN
                  TEXT="AT+CMGR=1"
                  TX
                  RXIN
                  X=INSTR(SS,"OK")
                  IF X=0 THEN READSMS
               END IF
               ')
            END IF


            IF TIMEE=80 THEN
               SIMCHECK
               PRINT #1,STR(STATUS)
               IF STATUS=127 THEN
                  PRINT #1,"SIM IS OK"

               ELSE
                  PRINT #1,"SIM IS RESTARTING"
                  SIMRESET
               END IF
            ENDIF
            '(IF ERRORT>9 THEN
               ERRORT=0
               PRINT #1, "NO ANSWER"
               PRINT #1, "SIM IS RESTARTING"
               SIMRESET
            END IF
            ')
         endif







   loop



end

TXRUTIN:
   SET SENDOK

RETURN

t1rutin:
   stop timer1
      timer1=54735

      incr timee
      if tt>0 then decr tt
   start timer1
   '(
      IF TIMEE=250 THEN
         FLUSHBUF
         PRINT "AT"
         K=5
         DO
            WAIT 1
            DECR K
            RXIN
            IF SS="OK" THEN
               ERRORT=0
               EXIT DO
            END IF
            IF K=0 THEN
               IF SS="" OR SS<>"OK" THEN ERRORT=10
               EXIT DO
            END IF
         LOOP
         K=0
      ENDIF
      ')
return


SUB SIMRESET
DO
      RESET SIMON
      SET LED1
      TT=5
      DO
         IF TT=0 THEN EXIT DO
      LOOP
      SET SIMON
      RESET LED1
      SET LED2
      RESET SIMRST
      TT=2
      DO
         IF TT=0 THEN EXIT DO
      LOOP
      SET SIMRST
      TT=10
      DO
         IF TT=0 THEN EXIT DO
      LOOP
      RESET LED2
      status=0
      tt=10
      DO
         flushbuf
         TEXT= "ATE0"
         TX
         RXIN
         X=INSTR(SS,"OK")
         IF X> 0 THEN
            set status.0
            EXIT DO
         else
            reset status.0
         end if
         if tt=0 then exit do
      LOOP
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
   PRINT #1,STR(STATUS)
   IF STATUS=127 THEN EXIT DO
LOOP
END SUB

SUB RXIN:
   timer1=54735
   'STOP TIMER1
   B=0
   TT=5
   SS=""
   DO
      B=INKEY()
      'IF B>0 THEN TT=5
      SELECT CASE B
         CASE 0

         CASE 10
            IF SS<>"" THEN EXIT DO
         CASE 13

         CASE ELSE
            SS=SS+CHR(B)


      END SELECT
      if tt=0 then exit do

   LOOP
   SS=UCASE(SS)
   PRINT #1,SS
   'START TIMER1
   TT=1
   DO
      IF TT=0 THEN EXIT DO
   LOOP

END SUB

SUB READSMS
   FLUSHBUF
   'TEXT= "AT+CMGR="+N
   PRINT "AT+CMGR=1"
   'TX

   RXIN
   X=SPLIT(SS,AR(1),CHR(34))
   INNUMBER=AR(4)
   'PRINT INNUMBER
   'PRINT AR(9)
   RXIN
   SMS=SS
   'PRINT SMS
   RXIN
   ORDER=""
   X=0
   X=INSTR(SMS,"TEMP")
   IF X>0 THEN ORDER="TEMP"


   X=0
   X=INSTR(SMS,"STATUS")
   IF X>0 THEN ORDER="STATUS"

   X=0
   X=INSTR(SMS,"ANTEN")
   IF X>0 THEN ORDER="ANTEN"

   X=0
   X=INSTR(SMS,"BLINK")
   IF X>0 THEN ORDER="BLINK"

   X=0
   X=INSTR(SMS,"ON")
   IF X>0 THEN ORDER="ON"

   X=0
   X=INSTR(SMS,"OFF")
   IF X>0 THEN ORDER="OFF"

   X=0
   X=INSTR(SMS,"?")
   IF X>0 THEN ORDER="?"

   IF SMS<>"" AND ORDER="" THEN ORDER="WRONGSMS"

   SELECT CASE ORDER
      CASE "TEMP"
        OUTBOX="TEMP=24 C"
      CASE "STATUS"
         OUTBOX="SMS WAS RECIEVED"
      CASE "ANTEN"
         OUTBOX="GOOD"
      CASE "ON"
         OUTBOX="LED IS ON"
         SET LED1
      CASE "OFF"
         RESET LED1
         OUTBOX="LED IS OFF"
      CASE "BLINK"
         RESET LED1
         OUTBOX="LED IS BLINKING"
      CASE "?"
         OUTBOX="ITS OK"
      CASE "WRONGSMS"
         OUTBOX="WRONG SMS"
   END SELECT
   IF SS="OK" THEN
      SENDSMS

   END IF
   FLUSHBUF
   DO
      TEXT= "AT+CMGDA=DEL ALL"
      TX
      TT=5
      DO
         IF TT=0 THEN EXIT DO
      LOOP
      RXIN
      IF SS="OK" THEN EXIT DO
      IF SS<>"" AND SS<>"OK" THEN INCR ERRORT
      IF ERRORT=9 THEN EXIT DO
   LOOP
   FLUSHBUF
   TEXT= "AT"
   TX
   RXIN

END SUB

SUB SENDSMS
  ' WAIT 5
   'PRINT "AT"
   'RXIN
   FLUSHBUF
   'IF SS="OK" THEN
      TEXT= "AT+CMGS="+CHR(34)+INNUMBER+CHR(34)
      TX
      do
         inputbin b
         if b=62 then exit do
      loop
      TEXT= OUTBOX+CHR(26)
      TX
      'TT=60
      DO
         RXIN
         X=INSTR(SS,"+CMGS")
         IF X>0 THEN EXIT DO
         'IF TT=0 THEN EXIT DO
      LOOP

  ' END IF

END SUB


SUB SIMCHECK
PRINT #1,"SIM CHECK PROCESS"
   RESET SIMOK
   ERRORT=0
   TT=5
   DO
      flushbuf
      TEXT= "ATE0"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.0
         EXIT DO
      else
         reset status.0
      end if
      if tt=0 then exit do
   LOOP
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
 '(
   DO
      PRINT "AT"
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
    ')
   TT=3
   DO
      flushbuf
      TEXT= "AT+CMGF=1"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.3
         EXIT DO
      else
         reset status.3
      end if
      if tt=0 then exit do
   LOOP
   '(
   DO
      TEXT= "AT+CMGF=1"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
  ')

   TT=3
   DO
      flushbuf
      TEXT= "AT+CSCS="+CHR(34)+"GSM"+CHR(34)
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.4
         EXIT DO
      else
         reset status.4
      end if
      if tt=0 then exit do
   LOOP
'(
   DO
      TEXT= "AT+CSCS="+CHR(34)+"GSM"+CHR(34)
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
   ')

   TT=3
   DO
      flushbuf
      TEXT= "AT+CNMI=1,1,0,0,0"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN
         set status.5
         EXIT DO
      else
         reset status.5
      end if
      if tt=0 then exit do
   LOOP
'(
   DO
      TEXT= "AT+CNMI=1,1,0,0,0"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
 ')
   TT=3
   DO
      flushbuf
      TEXT= "AT+CSMP=17,167,2,25"
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
'(
   DO
      TEXT= "AT+CSMP=17,167,2,25"
      TX
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
 ')

END SUB


sub flushbuf
i=0
b=0
 do

   b=inkey()
   if b=0 then incr i
   if i=50 then exit do
 loop

end sub

SUB TX
   timer1=54735
   RESET SENDOK
   PRINT TEXT


   DO
      IF SENDOK=1 THEN EXIT DO

   LOOP
   timer1=54735
   PRINT #1,TEXT

END SUB