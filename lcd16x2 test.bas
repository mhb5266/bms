
$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600
Config Lcdpin = Pin , Db4 = Portb.0 , Db5 = Portb.1 , Db6 = Portb.2 , Db7 = Portb.3 , E = Portb.4 , Rs = Portb.5
Config Lcd = 16 * 2
Cursor Off

Lcd "hi"
End