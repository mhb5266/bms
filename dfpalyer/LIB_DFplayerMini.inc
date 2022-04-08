' ##############################################################################
' #
' # MP3-Player DFPlayer mini (c) HFEDV 2018
' #
' # Diese Bibliothek entstand unter dankenswerter Mitarbeit der Mitglieder
' # "mac5150" & "Willie" aus dem Forum https://bascomforum.de/
' #
' # LIZENZBESTIMMUNGEN:
' # Jedwede kommerzielle Nutzung ist untersagt
' # Ausschlieszlich fuer die private Verwendung!
' #
' # Bitte auch die Ausfuehrungen zu SUBs und Funktionen (dies betrifft vor
' # allen auch eigene nicht mit dieser Bibliothek zusammenhaengende) weiter
' # unten beachten!
' #
' # Die Musikdateien muessen im jeweiligen Verzeichnis immer im jeweils bei der
' # Prozedur angegeben Dateiformat gespeichert werden wie zum Beispiel:
' # 123.MP3 = 001.MP3 bis 999.MP3
' # 1234.MP3 = 0001.MP3 bis 9999.MP3
' # Der Dateiname kann nach der Nummerierung weiteren Text enthalten wie
' # zum Beispiel 123_Testdatei.MP3.
' # Gueltige Ordnerbezeichnungen sind 01 bis 99, MP3 und ADVISE.
' #
' # Es ist auch wichtig zu wissen, dass das Modul auch nicht direkt mit
' # Dateinamen arbeitet sondern sich immer an der File Allocation Table (FAT)
' # des Speichermediums orientiert. Die bedeutet, dass das es wichtig ist, dass
' # die Dateien immer geordnet auf dem Medium abgespeichert werden. Durch
' # nachtraegliche Aenderungen kann die FAT "durcheinander" kommen und ab dann
' # stimmen die FAT-Nummern nicht mehr mit der Sortierreihenfolge der
' # Dateinamen ueberein!
' # Dies wiederum bedeutet, dass ab dann die Dateien nicht mehr korrekt
' # angesprochen werden können!
' #
' # ES WIRD GRUNDSAETZLICH EMPFOHLEN DIE KOMMENTARE ZU LESEN!
' #
' # HINWEIS:   DIESE DFPLAYER-MINI-MODULE GIBT ES IN VERSCHIEDENEN VERSIONEN!
' #            DIES BEDEUTET, DASS JE NACH MODULVARIANTE NICHT ALLE BEFEHLE
' #            FUNKTIONIEREN WERDEN!
' #
' ##############################################################################
' #
' # FOLGENDE BENUTZEREINSTELLUNGEN SIND VORZUNEHMEN
' #-----------------------------------------------------------------------------
' # MP3_COMPORT   Stellt den verwendeten Com-Port ein
' #               0= Softwareschnittstelle (siehe den Ausnahmehinweis unten!)
' #               1= Hardwareport 1
' #               2= Hardwareport 2
' #-----------------------------------------------------------------------------
' # MP3_IRQ       Aktiviert ab hier die Interrupts
' #               Dies ist nur bei HW-Com-Port notwendig!
' #               0= Nein, Interrupts muessen aber dennoch spaeter selbst
' #                  aktiviert werden auch wenn diese selbst im Programm nicht
' #                  benoetigt werden weil ansonsten der Softwarebuffer nicht
' #                  funktionieren wuerde!
' #               1= Ja, Interrupts werden bereits ab hier aktiviert
' #-----------------------------------------------------------------------------
' # MP3_BASE      Setze die Arraybasis auf 0 oder 1 (Arrays beginnen entweder
' #               mit 0 oder 1)
' #               HINWEIS: Dies ist eine globale Einstellung und gilt dann
' #                        IMMER fuer das gesamte Programm (auch eigene Arrays
' #                        muessen dann entsprechend dieser Einstellung
' #                        verwendet werden!
' #-----------------------------------------------------------------------------
' # MP3_SUBMODE   Setzt das globale Verhalten mit SUBs und Funktionen
' #               0= Alte Variante
' #                  Alle SUBs und Funktionen MueSSEN deklariert werden.
' #                  Die SUBs und Funktionen muessen NACH dem Hauptprogramm
' #                  platziert werden!
' #                  HINWEIS: Die SUBs und Funktionen dieser Bibliothek werden
' #                           dadurch automatisch deklariert, alle anderen
' #                           eigenen SUBs und Funktionen muessen dann auch dort
' #                           deklariert werden!
' #               1= Neue Variante
' #                  SUBs und Funktionen werden NICHT deklariert.
' #                  Die SUBs und Funktionen muessen VOR dem Hauptprogramm
' #                  platziert werden (auch eigene)!
' #
' ##############################################################################

Const MP3_COMPORT = 1
Const MP3_IRQ = 1
Const MP3_BASE = 0
Const MP3_SUBMODE = 1

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
   MP3_aSend(MP3_Array6) = 0
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
' # Setzt die zu verwendente Datenquelle fest.
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
' # Schalte den Verstaerker stumm.
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
' # RUECKGABE: 0-65535 (nicht wirklich Bekannt!).
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
' # Gibt die Anzahl der Dateien im abgefragten Ordner zurueck.
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
