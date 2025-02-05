$regfile = "m328def.dat"
$crystal = 8000000
$baud = 9600


Configs:

        Config Lcdpin = 16 * 2 , Db4 = Portd.2 , Db5 = Portd.3 , Db6 = Portd.4 , Db7 = Portb.5 , E = Portd.1 , Rs = Portd.0
        Config Lcd = 16x2
        Config 1wire = Portc.2
        Declare Sub Temp
        Dim P As Byte

Startup:
        Cls
        Lcd "hi"
        Wait 2
   

End