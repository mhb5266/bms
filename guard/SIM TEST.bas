$REGFILE="M16DEF.DAT"
$CRYSTAL=11059200

$BAUD=9600
Open "COMC.2:9600,8,n,1" For Output As #1
dim a as byte
dim b as byte
dim x as string*10

simrst alias portd.4:config portd.4=OUTPUT

reset simrst
wait 2
set simrst
wait 15
DO
   PRINT "ATE0"
   print #1,"ATE0"
   waitms 500
   a=ischarwaiting()
   if a>0 then
      DO

         B = INKEY()

         SELECT CASE B
            CASE 0
            CASE 10
               IF x <> "" THEN EXIT DO
            CASE 13
            CASE ELSE
               x = x + CHR(B)

         END SELECT

      LOOP
   end if
   print #1,x
   WAIT 1


LOOP