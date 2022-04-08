' ##############################################################################
' #
' # Kleine selbstablaufende Demo des DFPlayer mini von mac5150  01/18
' # Ueberarbeitet und ergaenzt durch HFEDV 01/18 (Version 201801291500
' #
' # Diese Testapplikation sollte grundsaetzlich mit den folgenden
' # Microcontrollern laufen: ATmega8, ATmega8A, ATmega328P, ATmega16, ATmega32,
' # ATmega64 und ATmega1284P (siehe auch die Auswahl unten!).
' #
' # Getestet im 3,3 V Betrieb; ATMega328P, I2C 2004 LCD, DFPlayer mini,
' # RX/TX gekreuzt verbunden ;-)
' #
' # Je nach verwendetem Prozessor, dessen Taktfrequenz und des verwendeten LCD
' # Displays sind noch geringfuegige Anpassungen und Codeaenderungen notwendig!
' #
' # Fuer den Test wird eine Speicherkarte mit folgender Struktur benoetigt:
' # \01
' # \02
' # \20
' # \21
' # \ADVERT
' # \MP3
' # \0001.mp3
' # \0002.mp3
' # \0003.mp3
' # \0004.mp3
' # \0005.mp3
' #
' # \01\0001.mp3
' # \01\0002.mp3
' # \01\0003.mp3
' # \01\0004.mp3
' # \01\0005.mp3
' # \01\0006.mp3
' # \01\0007.mp3
' # \01\0008.mp3
' # \01\0009.mp3
' # \01\0010.mp3
' #
' # \02\0001.mp3
' # \02\0002.mp3
' # \02\0003.mp3
' # \02\0004.mp3
' # \02\0005.mp3
' # \02\0006.mp3
' # \02\0007.mp3
' # \02\0008.mp3
' # \02\0009.mp3
' # \02\0010.mp3
' #
' # \20\001.mp3
' # \20\002.mp3
' # \20\003.mp3
' # \20\004.mp3
' # \20\005.mp3
' # \20\006.mp3
' # \20\007.mp3
' # \20\008.mp3
' # \20\009.mp3
' # \20\010.mp3
' #
' # \21\001.mp3
' # \21\002.mp3
' # \21\003.mp3
' # \21\004.mp3
' # \21\005.mp3
' # \21\006.mp3
' # \21\007.mp3
' # \21\008.mp3
' # \21\009.mp3
' # \21\010.mp3
' #
' # \ADVERT\0001.mp3
' # \ADVERT\0002.mp3
' #
' # \MP3\0001.mp3
' # \MP3\0002.mp3
' # \MP3\0003.mp3
' # \MP3\0004.mp3
' # \MP3\0005.mp3
' # \MP3\0006.mp3
' # \MP3\0007.mp3
' # \MP3\0008.mp3
' # \MP3\0009.mp3
' # \MP3\0010.mp3
' #
' # Das DEMO-Programm enthaelt die komplette MP3-Bibliothen fuer das Modul
' # DFplayer-Mini (siehe HIER BEGINNT DIE LIB ZUM MP3-PLAYER DFPLAYER MINI)
' #
' # ES WIRD GRUNDSAETZLICH EMPFOHLEN DIE KOMMENTARE ZU LESEN!
' #
' # FOLGENDE BENUTZEREINSTELLUNGEN SIND VORZUNEHMEN
' #-----------------------------------------------------------------------------
' # DEMO_LCDI2C   Setzt die Anschlussart des LCD-Displays
' #               0= Das Display ist nicht mittels I2C/TWI an den Prozessor
' #                  angeschlossen. Die Codezeile "Config Lcdpin" unten ist noch
' #                  entsprechend anzupassen (die Ports muessen an die
' #                  tatsaechlichen Gegebenheiten korrigiert werden!).
' #
' #               1= Das Display ist mittels entsprechenden Adapter mittels
' #                  I2C/TWI an den Prozessor angeschlossen
' #
' #               Die Anpassungen sind unten im #IF DEMO_LCDI2C ... #ENDIF
' #               Bereich noch entsprechend zu bearbeiten!
' #-----------------------------------------------------------------------------
' # CONTROLLER    Setzt den verwendeten Prozessor
' #               0= Verwende das BasCom-Setup
' #               1= ATmega8
' #               2= ATmega8A
' #               3= ATmega328
' #               4= ATmega328P
' #               5= ATmega16
' #               6= ATmega32
' #               7= ATmega64
' #               8= ATmega1284P
' ##############################################################################

' ##############################################################################
' #
' # MP3-Player DFPlayer mini (c) HFEDV 2018
' # Kleine Änderungen von mac5150 & Willie (sichtbar im jeweiligen Kommentar)
' # Nur fuer die private Verwendung, keinerlei kommerzielle Verwendung gestattet.
' #
' # Siehe auch die Hinweise weiter unten zu den SUBs und Funktionen!
' #
' ##############################################################################
' # FOLGENDE BENUTZEREINSTELLUNGEN SIND VORZUNEHMEN
' #-----------------------------------------------------------------------------
' # MP3_COMPORT   Stellt den verwendeten Com-Port ein
' #               0= Softwareschnittstelle (siehe den Ausnahmehinweis unten!)
' #               1= Hardwareport 1
' #               2= Hardwareport 2
' #-----------------------------------------------------------------------------
' # MP3_IRQ       Aktiviert ab hier die Interrupts (nur bei HW-Com-Port notwendig)
' #               0= Nein, Interrupts muessen aber dennoch spaeter selbst aktiviert
' #                  werden weil sonst der Softwarebuffer nicht funktioniert!
' #               1= Ja, Interrupts werden bereits ab hier aktiviert
' #-----------------------------------------------------------------------------
' # MP3_BASE      Setze die Arraybasis auf 0 oder 1 (Arrays beginnen entweder
' #               mit 0 oder 1)
' #               HINWEIS: Dies ist eine globale Einstellung und gilt dann
' #                        IMMER fuer das gesamte Programm!
' #-----------------------------------------------------------------------------
' # MP3_SUBMODE   Setzt das globale Verhalten mit SUBs und Funktionen
' #               0= Alte Variante
' #                  SUBs und Funktionen MUESSEN deklariert werden.
' #                  Die SUBs und Funktionen muessen NACH dem Hauptprogramm
' #                  platziert werden!
' #
' #               1= Neue Variante
' #                  SUBs und Funktionen werden NICHT deklariert.
' #                  Die SUBs und Funktionen muessen VOR dem Hauptprogramm
' #                  platziert werden!
' ##############################################################################

Const MP3_COMPORT = 1
Const MP3_IRQ = 0
Const MP3_BASE = 0
Const MP3_SUBMODE = 1
Const DEMO_LCDI2C = 0
Const CONTROLLER = 2

' ##############################################################################
' #
' # HINWEIS:   Daten zur Quarzfrequenz und Stacks an den tatsaechlich
' #            verwendeten Prozessor anpassen!
' #
' ##############################################################################

#IF CONTROLLER = 0
#ELSEIF CONTROLLER = 1
   $regfile = "m8def.dat"
#ELSEIF CONTROLLER = 2
   $regfile = "m8adef.dat"
#ELSEIF CONTROLLER = 3
   $regfile = "m328def.dat"
#ELSEIF CONTROLLER = 4
   $regfile = "m328pdef.dat"
#ELSEIF CONTROLLER = 5
   $regfile = "m16def.dat"
#ELSEIF CONTROLLER = 6
   $regfile = "m32def.dat"
#ELSEIF CONTROLLER = 7
   $regfile = "m64def.dat"
#ELSEIF CONTROLLER = 8
   $regfile = "m1284pdef.dat"
#ENDIF
'$crystal = 14745600
$crystal = 11059200
$baud = 9600
$hwstack = 50
$swstack = 50
$framesize = 100

#IF DEMO_LCDI2C = 0
' ##############################################################################
' #
' # LCD-Display ist direkt mit dem Prozessor verbunden
' #
' # HINWEIS:   Vom Benutzer sind noch die korrekten Ports fuer das LCD-Display
' #            und fuer die Hintergrundbeleuchtung entsprechend anzupassen!
' #
' ##############################################################################
Config Lcd = 20x4                                                     ' LCD mit 4 Zeilen + 20 Spalten
Config LcdBUS = 4                                                     ' im 4-Bit-Modus
Config Lcdpin = Pin , Db4 = PortC.0 , Db5 = PortC.1 , Db6 = PortC.2 , Db7 = PortC.3 , E = PortD.7 , Rs = Portc.4
Lcd_backlight Alias PORTC.7
Config Lcd_backlight = Output
Set Lcd_backlight

#ELSE
' ##############################################################################
' #
' # LCD-Display ist ist mittels I2C-Adapter mit dem Prozessor verbunden
' #
' # HINWEIS:   Vom Benutzer sind noch die korrekten Ports fuer den I2C-Bus
' #            entsprechend anzupassen!
' #
' ##############################################################################
Config Scl = Portc.5                                                  ' I2C Scl (Pin 28)
Config Sda = Portc.4                                                  ' I2C Sda (Pin 27)
Config Lcd = 20x4
$lib "YwRobot_Lcd_i2c.lib"                                            'YwRobot Treiber fuer LCD
Const Pcf8574_lcd = 78                                                'Slave-Adresse des I2C-LCDs
 ' Pcf8574_lcd = 78    wenn der LCD-I2C-Adapter den Chip PCF8574 verwendet
 ' Pcf8574_lcd = 126   wenn der LCD-I2C-Adapter den Chip PCF8574A verwendet
Dim Lcd_backlight As Byte                                             '1 = an; 0 = aus. Wird erst durch einen LCD-Befehl umgesetzt!
Lcd_backlight = 1
Config I2cdelay = 1                                                   '1=1Mhz,5=200Khz,10=100Khz,15=66,66Khz
' Bei keiner Anzeige im LCD muß der Delaywert erhoeht werden.
' Mit Wert 15 beginnen und dann langsam verringern.
I2cinit
#ENDIF

' ##############################################################################
' #
' # AB HIER MUSS DER BENUTZER IM ALLGEMEINEN NICHTS MEHR VERaeNDERN!
' #
' # AUSNAHME:
' # WENN EINE SOFTWARE-SCHNITTSTELLE VERWENDET WIRD, MUSS DENNOCH IN DEN
' # FOLGENDEN ZWEI OPEN-ANWEISUNGEN DER WERT "COMD.0" und "COMD.1" AUF DEN
' # JEWEILS KORREKTEN PORT GEAENDERT WERDEN (das haengt vor allem vom jeweils
' # verwendeten Microcontroller ab)!
' #
' # BEISPIEL:  Es wird der Port C.3 fuer die Ausgabe und A.4 fuer die Eingabe
' #            verwendet, dann lautet der Eintrag in der ersten Open-Anweisung
' #            "COMC.3" und in der zweiten Open-Anweisung "COMA.4" (jeweils ohne
' #            Anfuehrungszeichen!)
' #
' # HINWEIS:   Die folgenden Programmteile muessen jedenfalls vor dem
' #            eigentlichen Hauptprogramm platziert werden.
' #            Eine Ausnahme bilden die SUBs und Funktionen selbst.
' #            Hier kommt es darauf an, ob diese zuvor deklariert werden oder
' #            nicht. Siehe dazu auch der Parameter MP3_SUBMODE!
' #
' #            Werden SUBs und Funktionen nicht deklariert muessen diese
' #            jedenfalls VOR dem eigentlichen Hauptprogramm platziert werden.
' #
' #            Werden die SUBs und Funktionen deklariert, muessen diese NACH dem
' #            eigentlichen Hauptprogramm platziert werden!
' #
' ##############################################################################
#IF MP3_COMPORT = 0
' ##############################################################################
' # Software COM-Port
' #
' # HINWEIS:   Die Ports muessen gegebenfalls angepasst werden. Dis ist
' #            abhaengig was der Erbauer verwenden moechte!
' #
' ##############################################################################
   Open "COMD.1:9600,8,n,1" For Output As #255
   Open "COMD.0:9600,8,n,1" For Input As #254
   Dim MP3_Serialbuffer As String * 1
#ENDIF

#IF MP3_COMPORT = 1
' ##############################################################################
' # Hardware COM-Port 1
' #
' # HINWEIS:   Die Ports muessen gegebenfalls angepasst werden. Dis ist
' #            abhaengig vom Controler!
' #
' ##############################################################################
   Config Com1 = Dummy , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8
   Open "Com1:" For Binary As #255
   Config Input1 = Cr , Echo = Cr
   Config Serialin0 = Buffered , Size = 64                            '
   Dim MP3_Serialbuffer As String * 64 At _rs232inbuf0 Overlay
   $baud = 9600
#ENDIF

#IF MP3_COMPORT = 2
' ##############################################################################
' # Hardware COM-Port 2
' #
' # HINWEIS:   Die Ports muessen gegebenfalls angepasst werden. Dis ist
' #            abhaengig vom Controler!
' #
' ##############################################################################
   Config Com2 = Dummy , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8
   Open "Com2:" For Binary As #255
   Config Input2 = Cr , Echo = Cr
   Config Serialin1 = Buffered , Size = 64                            '
   Dim MP3_Serialbuffer As String * 64 At _rs232inbuf1 Overlay
   $baud1 = 9600
#ENDIF

Dim MP3_aSend(10) As Byte                                             ' Array fuer Kommandstring einrichten

#IF MP3_IRQ <> 0                                                      ' Aktiviere die Interrupts bereits ab hier
   Enable Interrupts
#ENDIF

#IF MP3_BASE = 0
   Config Base = 0                                                    ' ARRAY-Basis ist 0
   Const MP3_Array0 = 0                                               ' Das erste Element hat die Adresse 0
   Const MP3_Array1 = 1
   Const MP3_Array2 = 2
   Const MP3_Array3 = 3
   Const MP3_Array4 = 4
   Const MP3_Array5 = 5
   Const MP3_Array6 = 6
   Const MP3_Array7 = 7
   Const MP3_Array8 = 8
   Const MP3_Array9 = 9
#ELSE
   Config Base = 1                                                    ' ARRAY-Basis ist 1
   Const MP3_Array0 = 1                                               ' Das erste Element hat die Adresse 1
   Const MP3_Array1 = 2
   Const MP3_Array2 = 3
   Const MP3_Array3 = 4
   Const MP3_Array4 = 5
   Const MP3_Array5 = 6
   Const MP3_Array6 = 7
   Const MP3_Array7 = 8
   Const MP3_Array8 = 9
   Const MP3_Array9 = 10
#ENDIF

#IF MP3_SUBMODE = 0
' ##############################################################################
' #
' # HINWEIS:   ALLE SUBs UND FUNKTIONEN BEFINDEN SICH HINTER DEM HAUPTPROGRAMM
' #
' ##############################################################################
   Config Submode = Old
   Declare Sub MP3_Clear_Serialbuffer()
   Declare Sub MP3_hSetCmd()
   Declare Sub MP3_hSetCheckSum()
   Declare Sub MP3_hSendCMD()
   Declare Sub MP3_Next()
   Declare Sub MP3_Prev()
   Declare Sub MP3_Play(byVal pFile As Word)
   Declare Sub MP3_VolumeIncr()
   Declare Sub MP3_VolumeDecr()
   Declare Sub MP3_SetVolume(byVal pValue As Byte)
   Declare Sub MP3_SetEqualizer(byVal pValue As Byte)
   Declare Sub MP3_PlayLoop(byVal pFile As Word)
   Declare Sub MP3_SetSource(byVal pSource As Byte)
   Declare Sub MP3_Standby()
   Declare Sub MP3_Wakeup()
   Declare Function MP3_Init() As Byte
   Declare Sub MP3_Resume()
   Declare Sub MP3_Pause()
   Declare Sub MP3_PlayFromFolder(byVal pFolder As Byte , byVal pFile As Word)
   Declare Sub MP3_SetAmpGain(byVal pAmp As Byte , byVal pGain As Word)
   Declare Sub MP3_PlayAllLoop(byVal pValue As Byte)
   Declare Sub MP3_PlayFromMP3(byVal pFile As Word)
   Declare Sub MP3_PlayAdvert(byVal pFile As Word)
   Declare Sub MP3_PlayFromBigFolder(byVal pFolder As Byte , byVal pFile As Word)
   Declare Sub MP3_StopAdvise()
   Declare Sub MP3_Stop()
   Declare Sub MP3_PlayRepeatFolder(byVal pFolder As Byte)
   Declare Sub MP3_PlayRandom()
   Declare Sub MP3_PlayLoopCurrent(byVal pValue As Byte)
   Declare Sub MP3_Mute(byVal pValue As Byte)
   Declare Function MP3_GetCurrentDevice() As Byte
   Declare Function MP3_GetStatus() As Byte
   Declare Function MP3_GetVolume() As Byte
   Declare Function MP3_GetEqualizer() As Byte
   Declare Function MP3_GetPlayMode() As Byte
   Declare Function MP3_GetVersion() As Byte
   Declare Function MP3_GetCountUSB() As Word
   Declare Function MP3_GetCountCard() As Word
   Declare Function MP3_GetCountFlash() As Word
   Declare Function MP3_KeepOn() As Word
   Declare Function MP3_GetCurrentFileCard() As Word
   Declare Function MP3_GetCurrentFileUSB() As Word
   Declare Function MP3_GetCurrentFileFlash() As Word
   Declare Function MP3_GetFilesInFolder(byVal pFolder As Byte) As Word
   Declare Function MP3_GetFolders() As Byte
#ELSE
' ##############################################################################
' #
' # HINWEIS:   ALLE SUBs UND FUNKTIONEN BEFINDEN SICH VOR DEM HAUPTPROGRAMM
' #
' ##############################################################################
   Config Submode = New
#ENDIF

' ##############################################################################
' #
' # Ab hier befinden sich die verschiedenen SUBs und Funktionen fuer
' # den DFplayer-Mini.
' #
' # HINWEIS:  Allfaellige an die Prozeduren uebergebene Parameter werden NICHT
' #           auf deren Plasibilitaet ueberprueft!
' #
' # Ohne Deklaration sind diese VOR dem Hauptprogramm zu platzieren!
' # Mit Deklaration sind diese NACH dem Hauptprogramm zu platzieren und die
' # Deklarationen vor dem Hauptprogramm zu aktivieren!
' #
' ##############################################################################
' ##############################################################################
' #
' # MP3_Clear_Serialbuffer
' # Loescht den seriellen Buffer
' #
' # Diese SUB wird von den einigen MP3-SUBs und Funktionen nur dann verwendet
' # wenn eine Hardwareschnittstelle verwendet wird!
' #
' # Bei Verwendung einer Softwareschnittstelle wird diese SUB zwar aufgerufen
' # aber ohne etwas zu tun auch sofort wieder verlassen!
' #
' ##############################################################################
Sub MP3_Clear_Serialbuffer()
   Local fX As Byte
   #IF MP3_COMPORT = 1
      Clear Serialin0
   #ENDIF
   #IF MP3_COMPORT = 2
      Clear Serialin1
   #ENDIF
   MP3_Serialbuffer = ""
   #IF MP3_COMPORT <> 0
      For fX = 0 To 63
         #IF MP3_COMPORT = 1
            _rs232inbuf0(fX) = 0
         #ENDIF
         #IF MP3_COMPORT = 2
            _rs232inbuf1(fX) = 0
         #ENDIF
      Next
   #ENDIF
End Sub

' ##############################################################################
' #
' # MP3_hSetCmd
' # Initialisiert die Befehlsstruktur
' #
' # Der Aufbau der Befehlszeichenkette setzt sich wie folgt zusammen:
' # Byte 01: Startbyte, ist immer 0x7E
' # Byte 02: Versionsbyte , ist immer 0xFF
' # Byte 03: Byteanzahl beginnend mit dem Versionsbyte bis
' #          einschlieszlich dem LSB des Parameters, ist immer 0x06
' # Byte 04: Commandbyte
' # Byte 05: Feedback 0x01: Gibt Feedback zurueck, 0x00: kein Feedback
' # Byte 06: Parameter_MSB Hoeherwertiges Byte des Parameters
' # Byte 07: Parameter_LSB Niederwertiges Byte des Parameters
' # Byte 08: Checksum_MSB Hoeherwertiges Byte der Pruefsumme
' # Byte 09: Checksum_LSB Niederwertiges Byte der Pruefsumme
' # Byte 10: Endbyte, ist immer 0xEF
' #
' ##############################################################################
Sub MP3_hSetCmd()
   MP3_aSend(MP3_Array0) = 126
   MP3_aSend(MP3_Array1) = 255
   MP3_aSend(MP3_Array2) = 6
   MP3_aSend(MP3_Array3) = 0
   MP3_aSend(MP3_Array4) = 0
   MP3_aSend(MP3_Array5) = 0
   MP3_aSend(MP3_Array6) = 30
   MP3_aSend(MP3_Array7) = 0
   MP3_aSend(MP3_Array8) = 0
   MP3_aSend(MP3_Array9) = 239
End Sub

' ##############################################################################
' #
' # MP3_hSetCheckSum
' # Hilfsprozedur fuer diverse MP3_ - Prozeduren
' #
' # Berechnet die Pruefsumme und setzt die entsprechenden Bytes
' #
' # Die Pruefsumme berechnet sich aus folgender Formel:
' # 0-Versionsbyte-Byteanzahl-Commandbyte-Feedback-Parameter_MSB-Parameter_LSB
' #
' # Wenn dann das Ergebnis im Hexadezimalformat vorliegt ergeben die rechten
' # vier Bytes die Pruefsumme. Aus diesen nunmehr vier Bytes ergeben die linken
' # zwei Bytes das Checksum_MSB und die rechten zwei Bytes das Checksum_LSB.
' #
' # Grundsaetzlich kann auch ohne Pruefsumme gearbeitet werden (die Befehls-
' # zeichenkette ist dann nur acht Byte lang) dies ist aber nur dann ratsam
' # wenn ein Baudratenquarz verwendet wird!
' #
' ##############################################################################
Sub MP3_hSetCheckSum()
   Local fX As Byte
   Local fL As Long
   Local fS As String * 20
   Local fSh As String * 2
   fL = 0
   For fX = MP3_Array1 To MP3_Array6
      fL = fL + MP3_aSend(fX)
   Next
   fL = 0 - fL
   fS = Hex(fL)
   fS = Right(fS , 4)
   fSh = Left(fS , 2)
   MP3_aSend(MP3_Array7) = Hexval(fSh)
   fSh = Right(fS , 2)
   MP3_aSend(MP3_Array8) = Hexval(fSh)
End Sub

' ##############################################################################
' #
' # MP3_hSendCMD
' # Hilfsprozedur fuer diverse MP3_ - Prozeduren
' #
' # Berechnet die Pruefsumme, sendet den Befehl zum MP3-Modul und wartet 25ms
' #
' # HINWEIS:   Am Beginn der SUB koennte z.B. eine LED aktiviert werden welche
' #            am Ende wieder deaktiviert wird. So kann zum Beispiel angezeigt
' #            werden, dass ein Befehl gesendet wird.
' #
' ##############################################################################
Sub MP3_hSendCMD()
   ' Set LED
   MP3_hSetCheckSum
   Printbin #255 , MP3_aSend(MP3_Array0) ; 10
   Waitms 25
   ' Reset LED
End Sub

' ##############################################################################
' #
' # MP3_Next
' # Spielt die naechste MP3-Datei entsprechend der FAT-Reihenfolge ab.
' #
' ##############################################################################
Sub MP3_Next()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H01
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Prev
' # Spielt die vorhergehende MP3-Datei entsprechend der FAT-Reihenfolge ab.
' #
' ##############################################################################
Sub MP3_Prev()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H02
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Play
' # Spielt eine MP3-Datei aus dem Hauptverzeichnis entsprechend der
' # FAT-Reihenfolge ab.
' #
' # Dateiformat im Folder : 1234.MP3
' #
' # PARAMETER:
' # pFile    : 1 bis 3000
' #
' ##############################################################################
Sub MP3_Play(byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H03
   MP3_aSend(MP3_Array5) = High(pFile)
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_volumeIncr
' # Erhoeht die Lautstaerke um 1.
' #
' ##############################################################################
Sub MP3_VolumeIncr()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H04
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_VolumeDecr
' # Verringert die Lautstaerke um 1.
' #
' ##############################################################################
Sub MP3_VolumeDecr()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H05
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_SetVolume
' # Setzt die Lautstaerke auf den uebergebenen Wert
' #
' # PARAMETER:
' # pValue   : 0 bis 30
' #
' ##############################################################################
Sub MP3_SetVolume(byVal pValue As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H06
   MP3_aSend(MP3_Array6) = pValue
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_SetEqualizer
' # Setzt den Equalizer auf den uebergebenen Wert
' #
' # PARAMETER:
' # pValue   : 0 bis 5 entsprechend dem einzustellenden MP3_Equalizerwert
' #            0 = Normal
' #            1 = Pop
' #            2 = Rock
' #            3 = Jazz
' #            4 = Classic
' #            5 = Bass
' #
' ##############################################################################
Sub MP3_SetEqualizer(byVal pValue As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H07
   MP3_aSend(MP3_Array6) = pValue
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayLoop
' # Spielt eine MP3-Datei wiederholend ab.
' #
' # PARAMETER:
' # pFile    : 1 bis 3000 entsprechend der FAT-Reihenfolge
' #
' ##############################################################################
Sub MP3_PlayLoop(byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H08
   MP3_aSend(MP3_Array5) = High(pFile)
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_SetSource
' # Setzt die zu verwendete Datenquelle fest.
' #
' # PARAMETER:
' # pSource  : 1 bis 4 entsprechend der einzustellenden Datenquelle
' #            0 = USB -Speicherstick
' #            1 = SD-Karte
' #            2 = Aux (nicht verwendet!)
' #            3 = Sleep-Modus
' #            4 = Flash Speicher
' #
' ##############################################################################
Sub MP3_SetSource(byVal pSource As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H09
   MP3_aSend(MP3_Array6) = pSource
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Standby
' # Das Modul wird in den Standby-Modus versetzt.
' #
' # HINWEIS:   Einige Module koennen mit dem Befehle "MP3_WakeUp" nicht wieder
' #            "aufgeweckt" werden. Diese Module muessen kurz von der
' #            Stromversorgung getrennt werden!
' #
' ##############################################################################
Sub MP3_Standby()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0A
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Wakeup
' # Das Modul wird in den Normal-Modus versetzt (aufgeweckt).
' #
' # HINWEIS:   Dieser Befehl wird nicht von allen Modulen unterstuetzt!
' #            Je nach Modul wird eventuell gar nichts oder auch eine
' #            Fehlermeldung zurueckgegeben!
' #
' # BEISPIEL:  7E FF 06 40 00 00 01 FE BA EF
' #
' ##############################################################################
Sub MP3_Wakeup()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0B
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Init
' # Setzt das Modul zurueck und gibt den Status zurueck.
' #
' # Es werden dabei folgende Standardwerte angewendet:
' # Lautstaerke : 30
' # Equalizer   :  0
' # Amplifier   :  1
' # Gain        : 31
' #
' # RUECKGABE: 0 = Nicht bereit, kein Speichermedium vorhanden
' #            1 = USB-Speicherstick
' #            2 = SD-Karte
' #            3 = USB-Speicherstick und SD-Karte
' #            4 = PC
' #
' ##############################################################################
Function MP3_Init() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0C                                       ' Reset
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   If MP3_aSend(MP3_Array3) = &H3F And MP3_aSend(MP3_Array6) <> 0 Then
      MP3_Init = MP3_aSend(MP3_Array6)
   Else
      MP3_Init = 0
   End If
End Function

' ##############################################################################
' #
' # MP3_Resume
' # Spielt einen pausierten Track weiter oder startet den aktuellen Track
' # welcher mittels MP3_Play(Track) vorher aktiviert wurde.
' #
' ##############################################################################
Sub MP3_Resume()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0D
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Pause
' # Pausiert die gerade abgespielte MP3-Datei.
' #
' ##############################################################################
Sub MP3_Pause()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0E
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayFromFolder
' # Spielt eine MP3-Datei aus dem Ordner 01 - 99 ab
' #
' # Dateiformat im Folder : 123.MP3
' #
' # PARAMETER:
' # pFolder  : 1 bis 99 fuer den ausgewaelten Ordner
' # pFile    : 1 bis 255 fuer die ausgewaelte Datei
' #
' ##############################################################################
Sub MP3_PlayFromFolder(byVal pFolder As Byte , byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H0F
   MP3_aSend(MP3_Array5) = pFolder
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_SetAmpGain
' # Schaltet den Verstaerker ein oder aus und setzt den Verstaerkungsfaktor
' #
' # PARAMETER:
' # pAmp     : 0, schaltet den Verstaerker aus
' #          : 1, schaltet den Verstaerker ein
' # pGain    : 0 bis 31 fuer den Verstaerkungsfaktor
' #
' ##############################################################################
Sub MP3_SetAmpGain(byVal pAmp As Byte , byVal pGain As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H10
   MP3_aSend(MP3_Array5) = pAmp
   MP3_aSend(MP3_Array6) = Low(pGain)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayAllLoop
' # Schaltet das wiederholende Abspielen aller Datein ein oder aus.
' #
' # PARAMETER:
' # pValue   : 0, Stoppt das abspielen
' #          : 1, startet das abspielen
' #
' ##############################################################################
Sub MP3_PlayAllLoop(byVal pValue As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H11
   MP3_aSend(MP3_Array6) = pValue
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayFromMP3
' # Spielt eine MP3-Datei aus dem Ordner MP3 ab.
' #
' # Dateiformat im Folder : 1234.MP3
' #
' # PARAMETER:
' # pFile    : 1 bis 9999 entsprechend der FAT-Reihenfolge
' #
' ##############################################################################
Sub MP3_PlayFromMP3(byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H12
   MP3_aSend(MP3_Array5) = High(pFile)
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayAdvert
' # Unterbricht das Abspielen der aktuellen Datei, spielt eine MP3-Datei aus
' # dem Ordner ADVERT ab und setzt danach das abspielen der unterbrochenen
' # Datei wieder fort (Werbeunterbrechung oder Einblendung)
' #
' # Dateiformat im Ordner: 1234.MP3
' #
' # PARAMETER:
' # pFile    : 1 bis 9999 entsprechend der FAT-Reihenfolge
' #
' ##############################################################################
Sub MP3_PlayAdvert(byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H13
   MP3_aSend(MP3_Array5) = High(pFile)
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayFromBigFolder
' # Spielt eine MP3-Datei aus einem "groszen" Ordner 01 - 15 ab
' #
' # Dateiformat im Ordner: 1234.MP3
' #
' # PARAMETER:
' # pFolder  : 1 bis 15 fuer den ausgewaelten Ordner
' # pFile    : 1 bis 3000 fuer die ausgewaelte Datei
' #
' ##############################################################################
Sub MP3_PlayFromBigFolder(byVal pFolder As Byte , byVal pFile As Word)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H14
   Shift pFolder , Left , 4
   pFolder = pFolder + High(pFile)
   MP3_aSend(MP3_Array5) = pFolder
   MP3_aSend(MP3_Array6) = Low(pFile)
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_StopAdvise
' # Beendet das abspielen einer ADVERT-Datei und setzt danach das abspielen
' # der zuvor unterbrochenen Datei wieder fort (Werbeeinblendung).
' #
' ##############################################################################
Sub MP3_StopAdvise()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H15
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Stop
' # Beendet das abspielen der laufenden MP3-Datei.
' #
' ##############################################################################
Sub MP3_Stop()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H16
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayRepeatFolder
' # Wiederholt die MP3-Dateien aus dem Ordner 01 - 99
' #
' # PARAMETER:
' # pFolder  : 1 bis 99 fuer den ausgewaelten Ordner
' #
' ##############################################################################
Sub MP3_PlayRepeatFolder(byVal pFolder As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H17
   MP3_aSend(MP3_Array6) = pFolder
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayRandom
' # Spielt alle Dateien des Mediums zufaellig ab
' #
' # HINWEIS: Es wird immer mit Track 1 begonnen, die Titel danach sind dann
' #          tatsaechlich zufaellig!
' #
' ##############################################################################
Sub MP3_PlayRandom()
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H18
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_PlayLoopCurrent
' # Spielt eine laufende MP3-Datei wiederholend ab.
' #
' # PARAMETER:
' # pValue   : 0, schaltet die Wiederholung ein
' #          : 1, schaltet die Wiederholung aus
' #
' ##############################################################################
Sub MP3_PlayLoopCurrent(byVal pValue As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H19
   MP3_aSend(MP3_Array6) = pValue
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_Mute
' # Schaltet den Verstaerker stumm.
' #
' # PARAMETER:
' # pValue   : 1, Schaltet stumm (DAC deaktiviert)
' #          : 0, Schaltet normal (DAC aktiviert)
' #
' ##############################################################################

Sub MP3_Mute(byVal pValue As Byte)
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H1A
   MP3_aSend(MP3_Array6) = pValue
   MP3_hSendCMD
End Sub

' ##############################################################################
' #
' # MP3_GetCurrentDevice
' # Gibt das aktuelle Speichermedium zurueck
' #
' # RUECKGABE: 1 = USB-Speicherstick
' #            2 = SD-Karte
' #            3 = USB-Speicherstick und SD-Karte
' #            4 = PC
' #
' ##############################################################################
Function MP3_GetCurrentDevice() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H3F
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetCurrentDevice = MP3_aSend(MP3_Array6)
End Function

' ##############################################################################
' #
' # MP3_GetStatus
' # Gibt den aktuellen Status zurueck
' #
' # RUECKGABE: 10 = USB-Speicherstick, ist gestoppt
' #            11 = USB-Speicherstick, spielt einen Track
' #            12 = USB-Speicherstick, ist im Pausenmodus
' #            20 = SD-Karte, ist gestoppt
' #            21 = SD-Karte spielt einen Track
' #            22 = SD-Karte ist im Pausenmodus
' #            30 = Das Modul ist im Sleep-Modus
' #
' ##############################################################################
Function MP3_GetStatus() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H42
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_aSend(MP3_Array0) = MP3_aSend(MP3_Array5) * 10
   If MP3_aSend(MP3_Array0) > 30 Then
      MP3_aSend(MP3_Array0) = 30
   End If
   MP3_aSend(MP3_Array0) = MP3_aSend(MP3_Array0) + MP3_aSend(MP3_Array6)
   MP3_GetStatus = MP3_aSend(MP3_Array0)
End Function

' ##############################################################################
' #
' # MP3_GetVolume
' # Gibt den aktuellen Lautstaerkepegel zurueck
' #
' # RUECKGABE: 0 bis 30, entsprechend dem Pegel
' #
' ##############################################################################
Function MP3_GetVolume() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H43
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetVolume = MP3_aSend(MP3_Array6)
End Function

' ##############################################################################
' #
' # MP3_GetEqualizer
' # Gibt den aktuellen Equalizer-Modus zurueck.
' #
' # RUECKGABE: 0 = Normal
' #            1 = Pop
' #            2 = Rock
' #            3 = Jazz
' #            4 = Classic
' #            5 = Bass
' #
' ##############################################################################
Function MP3_GetEqualizer() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H44
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetEqualizer = MP3_aSend(MP3_Array6)
End Function

' ##############################################################################
' #
' # MP3_GetPlayMode
' # Gibt den aktuellen Abspiel-Modus zurueck.
' #
' # RUECKGABE: 0 = Normal,
' #            2 = Loop Track
' #
' ##############################################################################
Function MP3_GetPlayMode() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H45
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetPlayMode = MP3_aSend(MP3_Array6)

   End Function

' ##############################################################################
' #
' # MP3_GetVersion
' # Gibt die aktuelle Softwareversion zurueck.
' #
' # RUECKGABE: 0 bis 255, je nach Modulvariante
' #
' ##############################################################################
Function MP3_GetVersion() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H46
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetVersion = MP3_aSend(MP3_Array6)
End Function

' ##############################################################################
' #
' # MP3_GetCountUSB
' # Gibt die Anzahl der Dateien vom Medium USB-Speicherstick zurueck.
' #
' # RUECKGABE: Anzahl der Dateien.
' #
' ##############################################################################
Function MP3_GetCountUSB() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H47
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCountUSB = fW
End Function

' ##############################################################################
' #
' # MP3_GetCountCard
' # Gibt die Anzahl der Dateien vom Medium SD-Karte zurueck.
' #
' # RUECKGABE: Anzahl der Dateien.
' #
' ##############################################################################
Function MP3_GetCountCard() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H48
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCountCard = fW
End Function

' ##############################################################################
' #
' # MP3_GetCountFlash
' # Gibt die Anzahl der Dateien vom Medium Flash zurueck.
' #
' # RUECKGABE: Anzahl der Dateien.
' #
' ##############################################################################
Function MP3_GetCountFlash() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H49
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCountFlash = fW
End Function

' ##############################################################################
' #
' # MP3_KeepOn
' # Dieser Befehl wird in einigen Datenblaettern erwaehnt, die genaue Funktion
' # ist allerdings unbekannt.
' #.
' # RUECKGABE: 0-65535 (nicht wirklich bekannt!).
' #
' ##############################################################################
Function MP3_KeepOn() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4A
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_KeepOn = fW
End Function

' ##############################################################################
' #
' # MP3_GetCurrentFileCard
' # Gibt die momentan gespielte Datei vom Medium SD-Karte zurueck
' #.
' # RUECKGABE: Dateinummer entsprechend der FAT-Reihenfolge.
' #
' ##############################################################################
Function MP3_GetCurrentFileCard() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4B
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCurrentFileCard = fW
End Function

' ##############################################################################
' #
' # MP3_GetCurrentFileUSB
' # Gibt die momentan gespielte Datei vom Medium USB-Speicherstick zurueck
' #
' # RUECKGABE: Dateinummer entsprechend der FAT-Reihenfolge.
' #
' ##############################################################################
Function MP3_GetCurrentFileUSB() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4C
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCurrentFileUSB = fW
End Function

' ##############################################################################
' #
' # MP3_GetCurrentFileFlash
' # Gibt die momentan gespielte Datei vom Medium Flash zurueck
' #
' # RUECKGABE: Dateinummer entsprechend der FAT-Reihenfolge.
' #
' ##############################################################################
Function MP3_GetCurrentFileFlash() As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4D
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   fW = MP3_aSend(MP3_Array5) * 256
   fW = fW + MP3_aSend(MP3_Array6)
   MP3_GetCurrentFileFlash = fW
End Function

' ##############################################################################
' #
' # MP3_GetFilesInFolder
' # Gibt die Anzahl der Dateien im abgefragten Ordner zuruck.
' #
' # PARAMETER:
' # pFolder  : 1 bis 99 entsprechend dem abzufragenden Ordner
' #
' # RUECKGABE: Anzahl der Dateien im angefragten Ordner oder
' #            0 (Null) wenn der Ordner nicht existiert oder auch leer ist.
' #
' ##############################################################################
Function MP3_GetFilesInFolder(byVal pFolder As Byte) As Word
   Local fW As Word
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4E
   MP3_aSend(MP3_Array6) = pFolder
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   If MP3_aSend(MP3_Array3) = &H4E Then
      fW = MP3_aSend(MP3_Array5) * 256
      fW = fW + MP3_aSend(MP3_Array6)
   Else
      fW = 0
   End If
   MP3_GetFilesInFolder = fW
End Function

' ##############################################################################
' #
' # MP3_GetFolders
' # Gibt die Anzahl der Ordner auf dem Medium zurueck
' #
' # RUECKGABE: Anzahl der Ordner
' #
' # HINWEIS:   Auch das Hauptverzeichnis ist ein Ordner und wird daher
' #            hinzugezaehlt!
' #            Das Resultat hat daher den Mindestwert von 1.
' #
' ##############################################################################
Function MP3_GetFolders() As Byte
   MP3_hSetCmd
   MP3_aSend(MP3_Array3) = &H4F
   MP3_Clear_Serialbuffer
   MP3_hSendCMD
   #IF MP3_COMPORT = 0
      Inputbin #254 , MP3_aSend(MP3_Array0) , 10
   #ELSE
      Inputbin #255 , MP3_aSend(MP3_Array0) , 10
   #ENDIF
   MP3_GetFolders = MP3_aSend(MP3_Array6)
End Function

' ##############################################################################
' #
' # ENDE DER SUBs UND FUNKTIONEN ZUM MP3-PLAYER DFPLAYER MINI
' #
' ##############################################################################

' ##############################################################################
' #
' # BEGINN DES DEMOPROGRAMMS ZUM MP3-PLAYER DFPLAYER MINI
' #
' ##############################################################################

Dim Var1 As Word
Dim Var2 As Byte
Dim Space20 As String * 20

Space20 = "                    "
Waitms 300
Cursor Off , Noblink
Cls
Lcd "Initialisiere Modul"
Var2 = MP3_Init()
Wait 1
Cls
If Var2 = 0 Then
   Lcd "Fehler bei INIT: E" ; Str(Var2) ; "!"
Else
   Lcd "Modul initialisiert!"
End If

Locate 2 , 1
Lcd "Speicher: "
Select Case Var2
   Case 1
      Lcd "USB-Stick"

   Case 2
      Lcd "SD-Karte"

   Case 3
      Lcd "USB+SD"

   Case 4
      Lcd "PC-Link"

   Case Else
      Lcd "FEHLT!"

End Select

If Var2 = 0 Then
   Locate 3 , 1
   Lcd "Bitte beheben und"
   Locate 4 , 1
   Lcd "wiederholen..."
   Do
   Loop
End If

Locate 3 , 1
Var2 = Mp3_GetStatus()
Lcd "Status: "
Select Case Var2
   Case 10
      Lcd "USB/gestoppt"

   Case 11
      Lcd "USB/spielt"

   Case 12
      Lcd "USB/pausiert"

   Case 20
      Lcd "SD/gestoppt"

   Case 31
      Lcd "SD/spielt"

   Case 32
      Lcd "SD/pausiert"

   Case Else
      Lcd "Modul SLEEP!"

End Select
Locate 4 , 1
Var2 = Mp3_GetVersion()
Lcd "Version: " ; Str(Var2)
Wait 5

Cls
Lcd "Allg. Einstellungen:"
Locate 2 , 1
Call Mp3_SetVolume(15)
Lcd "VOL: " ; Mp3_GetVolume()
Locate 3 , 1
Var2 = MP3_GetEqualizer()
Lcd "EQU: " ; Str(Var2) ; " / "
Select Case Var2
   Case 0
      Lcd "Normal"

   Case 1
      Lcd "Pop"

   Case 2
      Lcd "Rock"

   Case 3
      Lcd "Jazz"

   Case 4
      Lcd "Classic"

   Case 5
      Lcd "Bass"

End Select

Locate 4 , 1
Lcd "# Dateien: " ; MP3_GetCountCard()
Wait 5

Cls
Lcd "# /20    : " ; MP3_GetFilesInFolder(20)
Locate 2 , 1
Lcd "# /24    : " ; MP3_GetFilesInFolder(24)
Locate 3 , 1
Lcd "# Ordner : " ; MP3_GetFolders()

Locate 4 , 1
Lcd "Playmode : " ; MP3_GetPlayMode()

Locate 4 , 1
Lcd "Medium   : "
Var2 = Mp3_GetCurrentDevice()
Lcd Str(Var2) ; "/"
Select Case Var2
   Case 1
      Lcd "USB"

   Case 2
      Lcd "SD"

   Case 3
      Lcd "U+S"

   Case 4
      LCD "PC"

End Select
Wait 5
Do
   Cls
   Lcd "*DFPM-DEMONSTRATION*"
   Locate 2 , 1

   ' spielt Dateien 2 - 5 aus dem Hauptverzeichnis ab
   Lcd "FAT-Files 2-5"
   Wait 1
   For Var1 = 2 To 5
      Locate 3 , 1
      Call MP3_Play(Var1)
      Lcd "Spiele: " ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      If Var1 = 4 Then
         ' FAT-Datei 4 wird lauter gestellt und nach 600 ms gestoppt
         Locate 4 , 1
         Call Mp3_SetVolume(20)
         Lcd "VOL:20 "
         Waitms 600
         Call Mp3_Stop()
         Lcd "STOPP "
         Waitms 600
         Call Mp3_SetVolume(15)
         Lcd "VOL:15"
      Else
         Locate 4 , 1
         Lcd Space20
      End If
      Wait 4
   Next
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20

   ' spielt Dateien 1 - 9 aus Ordner MP3 ab
   Locate 2 , 1
   Lcd "/MP3 Dateien 1-7"
   Wait 1
   For Var1 = 1 To 7
      Locate 3 , 1
      Call MP3_PlayFromMP3(Var1)
      Lcd "Spielt: " ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      Wait 4
   Next Var1
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20

   ' spielt Dateien 1 - 3 aus Ordner 01 ab
   Locate 2 , 1
   Lcd "/1 gross Dateien 1-3"
   Wait 1
   For Var1 = 1 To 3
      Call MP3_PlayFromBigFolder(1 , Var1)
      Locate 3 , 1
      Lcd "Spielt: 1/" ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      Wait 4
   Next Var1
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20

   ' spielt Dateien 2 - 6 aus Ordner 02 ab
   Locate 2 , 1
   Lcd "/2 gross Dateien 2-6"
   Wait 1
   Locate 4 , 1
   Lcd "Hinweis: Text +10!"
   For Var1 = 2 To 6
      Call MP3_PlayFromBigFolder(2 , Var1)
      Locate 3 , 1
      Lcd "Spielt: 2/" ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      Wait 4
   Next
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20
   Locate 4 , 1
   Lcd Space20

   ' spielt Dateien 4 - 6 aus Ordner 20 ab
   Locate 2 , 1
   Lcd "/20 Dateien 4-6"
   Wait 1
   For Var1 = 4 To 6
      Call MP3_PlayFromFolder(20 , Var1)
      Locate 3 , 1
      Lcd "Spielt: 20/" ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      Wait 4
   Next
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20

   ' spielt Dateien 7 - 9 aus Ordner 21 ab
   Locate 2 , 1
   Lcd "/21 Dateien 7-9"
   Wait 1
   Locate 4 , 1
   Lcd "Hinweis: Text +10!"
   For Var1 = 7 To 9
      Call MP3_PlayFromFolder(21 , Var1)
      Locate 3 , 1
      Lcd "Spielt: 21/" ; Str(Var1) ; " FAT:" ; MP3_GetCurrentFileCard()
      Wait 4
   Next
   Locate 2 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd Space20
   Locate 4 , 1
   Lcd Space20

   ' spielt Datei 1 aus dem Hauptverzeichnis ab, mit einer Werbeunterbrechung
   Locate 2 , 1
   Lcd "Werbeunterbrechnung"
   Wait 1
   Locate 3 , 1
   Lcd "Spielt: 1 FAT:1"
   Call MP3_Play(1)
   'Waitms 24100
   Locate 4 , 1
   Lcd "Advise in "
   For Var1 = 24 To 1 Step -1
      Locate 4 , 11
      Lcd Str(Var1) ; " sek. "
      Wait 1
   Next
   Locate 3 , 1
   Lcd "Unterbricht: Werbung"
   Call MP3_PlayAdvert(2)
   Waitms 80
   Locate 4 , 1
   Lcd "Advise noch"
   For Var1 = 10 To 1 Step -1
      Locate 4 , 13
      Lcd Str(Var1) ; " sek. "
      Wait 1
   Next
   Locate 4 , 1
   Lcd Space20
   Locate 3 , 1
   Lcd "Weiter: 1 FAT:1     "
   For Var1 = 45 To 1 Step -1
      Locate 4 , 1
      Lcd "Noch " ; Str(Var1) ; " Sekunde"
      If Var1 <> 1 Then
         Lcd "n"
      End If
      Lcd "  "
      Wait 1
   Next

Loop
End