$REGFILE="m32def.dat"
$crystal=1000000

config lcd=16*2
config lcdbus=4
config lcdpin=pin , Db4=PORTA.0 ,  Db5=PORTA.1 , Db6=PORTA.2 , Db7=PORTA.3 , E=PORTA.4 , RS=PORTA.5

DO

CLS
LCD " ZAHRA "
WAIT 1


LOOP
END