$regfile="m16def.dat"
$crystal=11059200
$baud=9600

configs:

'config kbd=PORTa

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
DIM SENDOK AS BIT
DIM ERRORT AS BYTE
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

   PRINT "ATE0"


   DO
      flushbuf
      PRINT "AT"

      'WAITMS 500
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP



   DO
      flushbuf
      PRINT "AT+CPIN?"

      'WAITMS 500
      RXIN
      X=INSTR(SS,"+CPIN: READY")
        ' X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP
   DO
      PRINT "AT"
      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP

   DO
      PRINT "AT+CMGF=1"

      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP



   DO
      PRINT "AT+CSCS="+CHR(34)+"GSM"+CHR(34)

      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP



   DO
      PRINT "AT+CNMI=2,2,0,0,0"

      RXIN
      X=INSTR(SS,"OK")
      IF X> 0 THEN EXIT DO
   LOOP






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
            IF TIMEE=255 THEN
               INCR K
               IF K=255 THEN
                  INCR J
               END IF
            END IF
            ltime=timee
            FLUSHBUF
            RESET SENDOK
            print "AT"

            TT=5
            DO

               IF SENDOK=1 THEN EXIT DO
               IF TT=0 THEN EXIT DO
            LOOP
            RESET SENDOK

            RXIN
            PRINT #1,"AT";" #";J ;" #";K ;" #";TIMEE 
         endif







   loop



end

t1rutin:
   stop timer1
      timer1=54735
      toggle led2
      incr timee
         IF ORDER="BLINK" THEN
            toggle led1

         END IF
      if tt>0 then decr tt
   start timer1
return

TXRUTIN:
   SET   SENDOK

RETURN

SUB RXIN:
   timer1=54735
   'STOP TIMER1
   B=0
   TT=5
   SS=""
   DO
      INPUTBIN B
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

