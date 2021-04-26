'--------------------------------------------------------------
' Atmega32 and ENC28J60 I/O Webserver from www.it-wns.de
' Build by Thomas Heldt
'--------------------------------------------------------------
' Software Version 1.0.X Copyright by Thomas Heldt
' Software based on Code by Ben Zijlstra and Viktor Varga
'--------------------------------------------------------------
' Free only for non comercial use !!!
' For commercial use contact thomas@heldt.eu
'--------------------------------------------------------------
' Fuse: CLKDIV/8 must be disabled

$regfile = "m32def.dat"
$crystal = 16000000
$baud = 19200                                               'Baudrate 19200 Baud wenn das BTM-222 genutzt wird!

$hwstack = 100
$swstack = 130
$framesize = 100

$include "enc28j60.inc"

$lib "tcpip.lbx"
$lib "datetime.lbx"

Config Timer1 = Timer , Prescale = 256                      'Konfiguriere Timer1 für Uhrzeit Clock
Enable Timer1                                               'Schalte den Timer1 ein
On Timer1 Sek_isr                                           'Verzweige bei Timer1 überlauf zu Sek_Isr (nach jeweils 1 Sek.)

Enc28j60_cs Alias Portb.4

'/* Konfiguration für das ENC28J60 I/O Webserver Board und die Addon-Boards von Thomas Heldt
Const Prgversion = "V1.0.5"
Const Mctype = "ATMEGA32"

Const Debugging = 0                                         'Debug Informationen per UART einfach=1, genau=2, aus=0

Const Userelais = 1                                         'Relais benutzen ja=1, nein=0
Const Useinput = 1                                          'Optokoppler-Eingänge benutzen ja=1, nein=0
Const Usebuzzer = 1                                         'Buzzer angeschlossen ja=1, nein=0
Const Usebtm = 1                                            'BTM222 angeschlossen ja=1, nein=0
Const Configbtm = 0                                         'Ältere BTM-222 =1, neuere =0
Const Uselcd = 1                                            'LCD angeschlossen=1, nicht angeschlossen=0
Const Uselcdweb = 1                                         'LCD auf der Webseite nutzen, nur wenn uselcd=1, ja=1, nein=0
Const Dispclock = 0                                         'LCD soll Datum und Uhrzeit anzeigen, nur wenn uselcd=1, ja=1, nein=0
Const Usentp = 1                                            'NTP Zeit nutzen ja=1, nein=0

'/* Konfiguration Ende

#if Userelais = 1
   Relais1 Alias Portc.0
   Config Relais1 = Output
   Dim Relais1_status As Bit
   Relais1_status = 0

   Relais2 Alias Portc.1
   Config Relais2 = Output
   Dim Relais2_status As Bit
   Relais2_status = 0

   Relais3 Alias Portc.2
   Config Relais3 = Output
   Dim Relais3_status As Bit
   Relais3_status = 0

   Relais4 Alias Portc.3
   Config Relais4 = Output
   Dim Relais4_status As Bit
   Relais4_status = 0
#endif

#if Useinput = 1
   Ok1 Alias Porta.0
   Ok1_status Alias Pina.0
   Config Ok1 = Input

   Ok2 Alias Porta.1
   Ok2_status Alias Pina.1
   Config Ok2 = Input

   Ok3 Alias Porta.2
   Ok3_status Alias Pina.2
   Config Ok3 = Input

   Ok4 Alias Porta.3
   Ok4_status Alias Pina.3
   Config Ok4 = Input
#endif

#if Usebuzzer = 1
   Buzzer Alias Portc.4
   Config Buzzer = Output
   Dim Buzzer_status As Bit
   Buzzer_status = 0
#endif

#if Uselcd = 1
   Config Lcdpin = Pin , Db4 = Portd.4 , Db5 = Portd.5 , Db6 = Portd.6 , Db7 = Portd.7 , E = Portb.0 , Rs = Portd.3
   Config Lcd = 16 * 2
   Cls
   Cursor Off
#endif

Config Adc = Single , Prescaler = Auto , Reference = Aref

Dim Charwaiting As Word
Dim Uart_char As Byte
Dim Uart_command As String * 10

#if Uselcd = 1
   Cls
   Lcd "Starte System >>"
   Locate 2 , 1
   #if Usebtm
      #if Configbtm = 1
         Lcd "Setup BTM-222"
      #endif
   #endif
#endif

#if Usebtm = 1
   #if Configbtm = 1
      Wait 3

      'BTM-222 soll keine Echos senden
      Print "ATE0"

      #if Uselcd = 1
         Locate 2 , 1
         Lcd "ATE0 -> BTM-222 "
      #endif

      Wait 1

      Charwaiting = Ischarwaiting()

      If Charwaiting > 1 Then
         Input Uart_command

         #if Uselcd = 1
            Locate 2 , 1
            Lcd "                "
            Locate 2 , 1
            Lcd Uart_command ; " <- BTM-222 "
         #endif

         Wait 1
      End If

      'BTM Name des BTM-222 Modul
      Print "ATN=I/O Webserver"

      #if Uselcd = 1
         Locate 2 , 1
         Lcd "ATN -> BTM-222  "
      #endif

      Wait 1

      Charwaiting = Ischarwaiting()

      If Charwaiting > 1 Then
         Input Uart_command

         #if Uselcd = 1
            Locate 2 , 1
            Lcd "                "
            Locate 2 , 1
            Lcd Uart_command ; " <- BTM-222 "
         #endif

         Wait 1
      End If

      'BTM-222 soll Slave sein
      Print "ATR1"

      #if Uselcd = 1
         Locate 2 , 1
         Lcd "ATR1 -> BTM-222 "
      #endif

      Wait 1

      Charwaiting = Ischarwaiting()

      If Charwaiting > 1 Then
         Input Uart_command

         #if Uselcd = 1
            Locate 2 , 1
            Lcd "                "
            Locate 2 , 1
            Lcd Uart_command ; " <- BTM-222 "
         #endif

         Wait 1
      End If

      'BTM-222 so einrichten das Verbindungen von jedem Master erlaubt sind
      Print "ATD0"

      #if Uselcd = 1
         Locate 2 , 1
         Lcd "ATD0 -> BTM-222 "
      #endif

      Wait 1

      Charwaiting = Ischarwaiting()

      If Charwaiting > 1 Then
         Input Uart_command

         #if Uselcd = 1
            Locate 2 , 1
            Lcd "                "
            Locate 2 , 1
            Lcd Uart_command ; " <- BTM-222 "
         #endif

         Wait 1
      End If
   #endif
#endif

Const Usedns = 0                                            'Only for demonstration, let it be 0
Const Max_framelen = 1500                                   '1500 byte will be enough for common tasks

Config Enc28j60_cs = Output

Config Clock = Soft
Config Date = Dmy , Separator = .

#if Uselcd = 1
   Dim Lcdzeile1 As String * 16
   Dim Lcdzeile2 As String * 16
   Lcdzeile1 = "                "
   Lcdzeile2 = "                "
#endif

Dim Lsec As Long

Dim Htmlpage As Byte                                        'V1.0.2

Dim X As Word
Dim A(5) As Byte
Dim Bank As Byte
Dim Enc28j60_data As Byte
Dim Nextpacketptr As Word
Dim Value As Byte
Dim Wdata As Word
Dim Buffer(max_framelen) As Byte
Dim Length As Word
Dim Rxstat As Word
Dim Ip_id As Word
Dim I_header_length As Word
Dim Mymac(6) As Byte
Dim Gwmac(6) As Byte
Dim Ntpip(4) As Byte

'Ethernet packet destination
Dim T_enetpacketdest0 As Byte At Buffer Overlay
Dim T_enetpacketdest1 As Byte At Buffer + &H01 Overlay
Dim T_enetpacketdest2 As Byte At Buffer + &H02 Overlay
Dim T_enetpacketdest3 As Byte At Buffer + &H03 Overlay
Dim T_enetpacketdest4 As Byte At Buffer + &H04 Overlay
Dim T_enetpacketdest5 As Byte At Buffer + &H05 Overlay
'Ethernet packet source
Dim T_enetpacketsrc0 As Byte At Buffer + &H06 Overlay
Dim T_enetpacketsrc1 As Byte At Buffer + &H07 Overlay
Dim T_enetpacketsrc2 As Byte At Buffer + &H08 Overlay
Dim T_enetpacketsrc3 As Byte At Buffer + &H09 Overlay
Dim T_enetpacketsrc4 As Byte At Buffer + &H0A Overlay
Dim T_enetpacketsrc5 As Byte At Buffer + &H0B Overlay
'Ethernet packet type
Dim T_enetpackettype As Word At Buffer + &H0C Overlay
Dim T_arp_hwtype1 As Byte At Buffer + &H0F Overlay
'Arp
Dim T_arp_prttype1 As Byte At Buffer + &H11 Overlay
Dim T_arp_hwlen As Byte At Buffer + &H12 Overlay
Dim T_arp_prlen As Byte At Buffer + &H13 Overlay
Dim T_arp_op1 As Byte At Buffer + &H15 Overlay
'arp source ip address
Dim T_arp_sipaddr0 As Byte At Buffer + &H1C Overlay
Dim T_arp_sipaddr1 As Byte At Buffer + &H1D Overlay
Dim T_arp_sipaddr2 As Byte At Buffer + &H1E Overlay
Dim T_arp_sipaddr3 As Byte At Buffer + &H1F Overlay
'arp target IP address
Dim T_arp_tipaddr0 As Byte At Buffer + &H26 Overlay
Dim T_arp_tipaddr1 As Byte At Buffer + &H27 Overlay
Dim T_arp_tipaddr2 As Byte At Buffer + &H28 Overlay
Dim T_arp_tipaddr3 As Byte At Buffer + &H29 Overlay
Dim T_arp_tipaddr As Long At Buffer + &H26 Overlay
'IP header layout IP version and header length
Dim T_ip_vers_len As Byte At Buffer + &H0E Overlay
Dim T_arp_hwtype0 As Byte At Buffer + &H0E Overlay
'Arp
Dim T_arp_prttype0 As Byte At Buffer + &H10 Overlay
Dim T_arp_op0 As Byte At Buffer + &H14 Overlay
'arp source mac address
Dim T_arp_src_enetpacket0 As Byte At Buffer + &H16 Overlay
Dim T_arp_src_enetpacket1 As Byte At Buffer + &H17 Overlay
Dim T_arp_src_enetpacket2 As Byte At Buffer + &H18 Overlay
Dim T_arp_src_enetpacket3 As Byte At Buffer + &H19 Overlay
Dim T_arp_src_enetpacket4 As Byte At Buffer + &H1A Overlay
Dim T_arp_src_enetpacket5 As Byte At Buffer + &H1B Overlay
'arp source mac address
Dim T_arp_dest_enetpacket0 As Byte At Buffer + &H20 Overlay
Dim T_arp_dest_enetpacket1 As Byte At Buffer + &H21 Overlay
Dim T_arp_dest_enetpacket2 As Byte At Buffer + &H22 Overlay
Dim T_arp_dest_enetpacket3 As Byte At Buffer + &H23 Overlay
Dim T_arp_dest_enetpacket4 As Byte At Buffer + &H24 Overlay
Dim T_arp_dest_enetpacket5 As Byte At Buffer + &H25 Overlay
Dim T_tos As Byte At Buffer + &H0F Overlay

'Buffer length
Dim T_ip_pktlen0 As Byte At Buffer + &H10 Overlay
Dim T_ip_pktlen1 As Byte At Buffer + &H11 Overlay

Dim T_id0 As Byte At Buffer + &H12 Overlay
Dim T_id1 As Byte At Buffer + &H13 Overlay
Dim T_flags As Byte At Buffer + &H14 Overlay
Dim T_offset As Byte At Buffer + &H15 Overlay
Dim T_ttl As Byte At Buffer + &H16 Overlay
'protocol (ICMP=1, TCP=6, UDP=11)
Dim T_ip_proto As Byte At Buffer + &H17 Overlay
'header checksum
Dim T_ip_hdr_cksum0 As Byte At Buffer + &H18 Overlay
Dim T_ip_hdr_cksum1 As Byte At Buffer + &H19 Overlay
Dim T_ip_hdr_cksum As Word At Buffer + &H18 Overlay
'IP address of source
Dim T_ip_srcaddr0 As Byte At Buffer + &H1A Overlay
Dim T_ip_srcaddr1 As Byte At Buffer + &H1B Overlay
Dim T_ip_srcaddr2 As Byte At Buffer + &H1C Overlay
Dim T_ip_srcaddr3 As Byte At Buffer + &H1D Overlay
Dim T_ip_srcaddr As Long At Buffer + &H1A Overlay
'IP address of destination
Dim T_ip_destaddr0 As Byte At Buffer + &H1E Overlay
Dim T_ip_destaddr1 As Byte At Buffer + &H1F Overlay
Dim T_ip_destaddr2 As Byte At Buffer + &H20 Overlay
Dim T_ip_destaddr3 As Byte At Buffer + &H21 Overlay
Dim T_ip_destaddr As Long At Buffer + &H1E Overlay
Dim T_icmp_type As Byte At Buffer + &H22 Overlay
Dim T_icmp_code As Byte At Buffer + &H23 Overlay
Dim T_icmp_cksum0 As Byte At Buffer + &H24 Overlay
Dim T_icmp_cksum1 As Byte At Buffer + &H25 Overlay
Dim T_icmp_cksum As Word At Buffer + &H24 Overlay
Dim Tcp_srcporth As Byte At Buffer + &H22 Overlay
Dim Tcp_srcportl As Byte At Buffer + &H23 Overlay
Dim Tcp_destporth As Byte At Buffer + &H24 Overlay
Dim Tcp_destportl As Byte At Buffer + &H25 Overlay
Dim Tcp_seqnum3 As Byte At Buffer + &H26 Overlay
Dim Tcp_seqnum2 As Byte At Buffer + &H27 Overlay
Dim Tcp_seqnum1 As Byte At Buffer + &H28 Overlay
Dim Tcp_seqnum0 As Byte At Buffer + &H29 Overlay
Dim Tcp_acknum3 As Byte At Buffer + &H2A Overlay
Dim Tcp_acknum2 As Byte At Buffer + &H2B Overlay
Dim Tcp_acknum1 As Byte At Buffer + &H2C Overlay
Dim Tcp_acknum0 As Byte At Buffer + &H2D Overlay
'Dim Tcp_hdr As Byte At Buffer + &H2E Overlay
Dim Tcp_flags As Byte At Buffer + &H2F Overlay
Dim Tcp_cksumh As Byte At Buffer + &H32 Overlay
Dim Tcp_cksuml As Byte At Buffer + &H33 Overlay
Dim Tcp_cksum As Word At Buffer + &H32 Overlay
'UDP header
Dim T_udp_srcport0 As Byte At Buffer + &H22 Overlay
Dim T_udp_srcport1 As Byte At Buffer + &H23 Overlay
Dim T_udp_srcport As Word At Buffer + &H22 Overlay
Dim T_udp_destport0 As Byte At Buffer + &H24 Overlay
Dim T_udp_destport1 As Byte At Buffer + &H25 Overlay
Dim T_udp_destport As Word At Buffer + &H24 Overlay
Dim T_udp_len0 As Byte At Buffer + &H26 Overlay
Dim T_udp_len1 As Byte At Buffer + &H27 Overlay
Dim T_udp_chksum0 As Byte At Buffer + &H28 Overlay
Dim T_udp_chksum1 As Byte At Buffer + &H29 Overlay
Dim T_udp_chksum As Word At Buffer + &H28 Overlay
Dim T_udp_data(32) As Byte At Buffer + &H2A Overlay

Dim I_chksum32 As Long
Dim I_checksum16 As Word
Dim T_ip_pktlen As Word
Dim Result16 As Word
Dim Result16h As Byte At Result16 + 1 Overlay
Dim Result16l As Byte At Result16 Overlay
Dim I_value16 As Word
Dim I_value16h As Byte At I_value16 + 1 Overlay
Dim I_value16l As Byte At I_value16 Overlay
Dim Hulp2 As Word
Dim Work As Byte
Dim L As Byte

#if Uselcd = 1
   Dim Heartbeat As Bit
#endif

#if Usedns = 1
   Dim Dns_name(4) As String * 10
#endif

Dim Mydns(4) As Byte

'variables with overlays
Dim Myip(4) As Byte
Dim My_ip As Long At Myip Overlay

Dim Incoming_ack As Long
Dim Incoming_ack0 As Byte At Incoming_ack Overlay
Dim Incoming_ack1 As Byte At Incoming_ack + 1 Overlay
Dim Incoming_ack2 As Byte At Incoming_ack + 2 Overlay
Dim Incoming_ack3 As Byte At Incoming_ack + 3 Overlay

'for NTP-routine
Dim S(4) As Byte
Dim L1 As Long At S Overlay                                 ' Overlay a long variable to receive-string
' with overlay you need no transfer from the byte-array to a long-variable
Dim L2 As Long

'toegevoegd voor TCP
Dim Tcp_fin As Bit
Dim Tcp_syn As Bit
Dim Tcp_rst As Bit
Dim Tcp_psh As Bit
Dim Tcp_ack As Bit
Dim Tcp_urg As Bit
Dim Tcpdatalen_in As Word
Dim Flags As Byte

Dim Client_seqnum As Long
Dim Client_seqnum0 As Byte At Client_seqnum Overlay
Dim Client_seqnum1 As Byte At Client_seqnum + 1 Overlay
Dim Client_seqnum2 As Byte At Client_seqnum + 2 Overlay
Dim Client_seqnum3 As Byte At Client_seqnum + 3 Overlay

Dim Tempword As Word
Dim Tempwordh As Byte At Tempword + 1 Overlay
Dim Tempwordl As Byte At Tempword Overlay

Dim Val1 As Word
Dim Val2 As Word
Dim Y As Word

Const Synflag = 0
Const Finflag = 1

Declare Sub Enc28j60init
Declare Sub Enc28j60readcontrolregbyte(byval Register As Byte)
Declare Sub Enc28j60writecontrolregbyte(byval Register As Byte , Byval Value As Byte)
Declare Sub Enc28j60selectbank(byval Bank As Byte)
Declare Sub Enc28j60bitfield_set(byval Register As Byte , Byval Value As Byte)
Declare Sub Enc28j60bitfield_clear(byval Register As Byte , Byval Value As Byte)
Declare Sub Enc28j60readphyword(byval Phyregister As Byte)
Declare Sub Enc28j60writephyword(byval Phyregister As Byte , Byval Wdata As Word)
Declare Sub Enc28j60packetsend(byval Pcktlen As Word)
Declare Sub Enc28j60packetreceive
Declare Sub Enc28j60poll
Declare Sub Arpreply
Declare Sub Pingreply
Declare Sub Setip_id
Declare Sub Udp_receive
Declare Sub Udp_checksum
Declare Sub Setipaddrs
Declare Sub Tcp
Declare Sub Echopacket
Declare Sub Ip_header_checksum
Declare Sub Icmp_checksum
Declare Sub Uartrx

Declare Sub Http
Declare Sub Tcp_checksum
Declare Sub Src2dest
Declare Sub Inc2seq
Declare Sub Seq2ack
Declare Sub Ack2inc
Declare Sub Src2mymac
Declare Sub Srcdestchksum
Declare Sub Rtr2dest

#if Usedns = 1
   Declare Sub Udp_dns_query
   Declare Function Dns_query(byval S As String) As String
   Declare Sub Dns
#endif

#if Usentp = 1
   Declare Sub Ntp_get
   Declare Sub Ntp
#endif

#if Uselcd = 1 And Uselcdweb = 1
   Declare Function Convert(byval Startpos As Byte , Byval Endepos As Byte , Byval Zeile As Byte) As String
   Declare Function Replacespaces(lcdtext As String) As String
#endif

'Eigene MAC Addresse
Mymac(1) = &H45
Mymac(2) = &HC6
Mymac(3) = &HB3
Mymac(4) = &HF3
Mymac(5) = &HAB
Mymac(6) = &H9E

'Eigene IP Addresse
Myip(1) = 192
Myip(2) = 168
Myip(3) = 1
Myip(4) = 99

'DNS Server IP Adresse
Mydns(1) = 192
Mydns(2) = 168
Mydns(3) = 1
Mydns(4) = 1

'Gateway MAC Adresse
Gwmac(1) = &H00
Gwmac(2) = &H02
Gwmac(3) = &H03
Gwmac(4) = &H04
Gwmac(5) = &H05
Gwmac(6) = &H06

'NTP Server IP Adresse
Ntpip(1) = 193
Ntpip(2) = 67
Ntpip(3) = 79
Ntpip(4) = 202

'Configuration of the SPI-bus
Config Spi = Hard , Interrupt = Off , Data Order = Msb , Master = Yes , Polarity = Low , Phase = 0 , Clockrate = 4 , Noss = 1

'init the spi pins
Spiinit

Waitms 500

Enc28j60_cs = 0
'reset ENC28J60
X = Enc28j60_soft_reset
Spiout X , 1
Enc28j60_cs = 1
Do
Call Enc28j60readcontrolregbyte(estat)
X = Enc28j60_data.estat_clkrdy
Loop Until X = 1

'clock from default divide/4 (6.25 Mhz) to divide/2 (12.5 Mhz)
'Call Enc28j60writecontrolregbyte(ecocon , &B00000010)

'Waitms 500

Print
Print "Starte System..."
Print
Print "Starte Netzwerk..."

#if Uselcd = 1
   Locate 2 , 1
   Lcd "Starte Netzwerk "
   Wait 1
#endif

Call Enc28j60selectbank(3)

A(1) = &B000_10010
Enc28j60_cs = 0
Spiout A(1) , 1
Spiin A(1) , 2

Print "Enc28j60 Version = " ; A(2)

#if Uselcd = 1
   Locate 2 , 1
   Lcd "ENC28J60 Ver = " ; A(2)
   Wait 1
#endif

Enc28j60_cs = 1

Print "IP-Adresse: " ; Myip(1) ; "." ; Myip(2) ; "." ; Myip(3) ; "." ; Myip(4)
Print "MAC-Adresse: " ; Hex(mymac(1)) ; ":" ; Hex(mymac(2)) ; ":" ; Hex(mymac(3)) ; ":" ; Hex(mymac(4)) ; ":" ; Hex(mymac(5)) ; ":" ; Hex(mymac(6))

#if Uselcd = 1
   Cls
   Lcd "IP-Adresse:"
   Locate 2 , 1
   Lcd Myip(1) ; "." ; Myip(2) ; "." ; Myip(3) ; "." ; Myip(4)
   Wait 1
   Cls
   Lcd "MAC-Adresse:"
   Locate 2 , 1
   Lcd Hex(mymac(1)) ; Hex(mymac(2)) ; Hex(mymac(3)) ; Hex(mymac(4)) ; Hex(mymac(5)) ; Hex(mymac(6))
   Wait 1
   Cls
   Lcd "Webserver ready"
   Locate 2 , 1
   Lcd "---------------"
   Wait 1
   Cls
#endif

Enable Interrupts
Timer1 = 3035                                               'Timer1 soll schon von 3035 wegzählen

Call Enc28j60init

#if Usentp = 1
   Call Ntp_get                                             'get the Network Time once
#else
   Print "ENC28J60 I/O-Webserver Befehls Interpreter V1.0"
   Print "? = Hilfe"
   Print
   Print "Befehl>";
#endif

#if Usedns = 1
   Call Dns                                                 'lets try the DNS-query
#endif

Do
   Charwaiting = Ischarwaiting()

   If Charwaiting = 1 Then
      Uart_char = Inkey()

      If Uart_char = 13 Or Len(uart_command) > 9 Then
         Call Uartrx
         Print
         Print "Befehl>";
         Uart_command = ""
      Else
         Uart_command = Uart_command + Chr(uart_char)
         Print Chr(uart_char);
      End If
   End If

   #if Usentp = 1
      If _hour = 3 And _min = 0 And _sec = 0 Then
         Call Ntp_get

         Do
           'verhindert das die NTP-Anfrage mehrmals innerhalb der Sekunde ausgeführt wird
         Loop Until _sec > 0
      End If
   #endif

   Call Enc28j60poll
Loop

End

Sub Uartrx:
   Print

   'Befehlsinterpreter
   Select Case Uart_command
      Case "DATE"
         Print Date$
      Case "TIME"
         Print Time$
      Case "IP"
         Print "Eigene IP-Adresse: " ; Myip(1) ; "." ; Myip(2) ; "." ; Myip(3) ; "." ; Myip(4)
      Case "DNS"
         Print "DNS Server IP-Adresse: " ; Mydns(1) ; "." ; Mydns(2) ; "." ; Mydns(3) ; "." ; Mydns(4)
      Case "MAC"
         Print "Eigene MAC-Adresse: " ; Hex(mymac(1)) ; ":" ; Hex(mymac(2)) ; ":" ; Hex(mymac(3)) ; ":" ; Hex(mymac(4)) ; ":" ; Hex(mymac(5)) ; ":" ; Hex(mymac(6))
      Case "GW"
         Print "Gateway MAC-Adresse: " ; Hex(gwmac(1)) ; ":" ; Hex(gwmac(2)) ; ":" ; Hex(gwmac(3)) ; ":" ; Hex(gwmac(4)) ; ":" ; Hex(gwmac(5)) ; ":" ; Hex(gwmac(6))
      Case "NTP"
         Print "NTP Server IP-Adresse: " ; Ntpip(1) ; "." ; Ntpip(2) ; "." ; Ntpip(3) ; "." ; Ntpip(4)
      Case "NTP?"
         Call Ntp_get
      Case "VER"
         Print "Programm Version " ; Prgversion ; " kompiliert am/um " ; Version(1)
      Case "RESET"
         Goto 0
      Case "ADC?"
         Print "ADC1=" ; Str(getadc(4))
         Print "ADC2=" ; Str(getadc(5))
         Print "ADC3=" ; Str(getadc(6))
         Print "ADC4=" ; Str(getadc(7))
      Case "ADC1?"
         Print "ADC1=" ; Str(getadc(4))
      Case "ADC2?"
         Print "ADC2=" ; Str(getadc(5))
      Case "ADC3?"
         Print "ADC3=" ; Str(getadc(6))
      Case "ADC4?"
         Print "ADC4=" ; Str(getadc(7))

      #if Usebuzzer = 1
         Case "BUZ?"
            If Buzzer_status = 0 Then
               Print "BUZZER ist aus"
            Else
               Print "BUZZER ist an"
            End If
         Case "BUZ=1"
            Set Buzzer
            Buzzer_status = 1
         Case "BUZ=0"
            Reset Buzzer
            Buzzer_status = 0
      #endif

      #if Useinput = 1
         Case "E?"
            Print "EINGANG1=" ; Ok1_status
            Print "EINGANG2=" ; Ok2_status
            Print "EINGANG3=" ; Ok3_status
            Print "EINGANG4=" ; Ok4_status
         Case "E1?"
            Print "EINGANG1=" ; Ok1_status
         Case "E2?"
            Print "EINGANG2=" ; Ok2_status
         Case "E3?"
            Print "EINGANG3=" ; Ok3_status
         Case "E4?"
            Print "EINGANG4=" ; Ok4_status
      #endif

      #if Userelais = 1
         Case "REL?"
            Print "REL1=" ; Relais1_status
            Print "REL2=" ; Relais2_status
            Print "REL3=" ; Relais3_status
            Print "REL4=" ; Relais4_status
         Case "REL1?"
            Print "REL1=" ; Relais1_status
         Case "REL2?"
            Print "REL2=" ; Relais2_status
         Case "REL3?"
            Print "REL3=" ; Relais3_status
         Case "REL4?"
            Print "REL4=" ; Relais4_status
         Case "REL1=0"
            Reset Relais1
            Relais1_status = 0
         Case "REL1=1"
            Set Relais1
            Relais1_status = 1
         Case "REL2=0"
            Reset Relais2
            Relais2_status = 0
         Case "REL2=1"
            Set Relais2
            Relais2_status = 1
         Case "REL3=0"
            Reset Relais3
            Relais3_status = 0
         Case "REL3=1"
            Set Relais3
            Relais3_status = 1
         Case "REL4=0"
            Reset Relais4
            Relais4_status = 0
         Case "REL4=1"
            Set Relais4
            Relais4_status = 1
         Case "MOD"
            #if Usentp = 1
               Print "NTP = aktiviert"
            #else
               Print "NTP = deaktiviert"
            #endif

            Print "ADC = aktiviert"

            #if Useinput = 1
               Print "Eingaenge = aktiviert"
            #else
               Print "Eingaenge = deaktiviert"
            #endif
            #if Userelais = 1
               Print "Relais = aktiviert"
            #else
               Print "Relais = deaktiviert"
            #endif
            #if Usebuzzer = 1
               Print "Buzzer = aktiviert"
            #else
               Print "Buzzer = deaktiviert"
            #endif
            #if Usebtm = 1
               Print "BTM-222 = aktiviert"
            #else
               Print "BTM-222 = deaktiviert"
            #endif
            #if Uselcd = 1
               Print "LCD = aktiviert"
            #else
               Print "LCD = deaktiviert"
            #endif
       #endif

      Case "?"
         Print "Befehle"
         Print "-----------------------------------"
         Print "DATE   = Systemdatum"
         Print "TIME   = Systemzeit"
         Print
         Print "IP     = IP-Adresse des Webserver"
         Print "MAC    = MAC-Adresse des Webserver"
         Print "GW     = MAC-Adresse des Gateway"
         Print "DNS    = IP-Adressse des DNS Server"
         Print "NTP    = IP-Adressse des NTP Server"
         Print "NTP?   = Neue NTP Anfrage senden"
         Print
         Print "VER    = Programmversion"
         Print "MOD    = Status der Erweiterungen"
         Print
         Print "RESET  = Neustart des Systems"
         Print
         Print "ADC?   = Ausgabe aller ADC-Kanaele"
         Print "ADC1?  = Ausgabe ADC-Kanal 1"
         Print "ADC2?  = Ausgabe ADC-Kanal 2"
         Print "ADC3?  = Ausgabe ADC-Kanal 3"
         Print "ADC4?  = Ausgabe ADC-Kanal 4"

         #if Usebuzzer = 1
            Print
            Print "BUZ?   = Status des Buzzers"
            Print "BUZ=1  = Buzzer einschalten"
            Print "BUZ=0  = Buzzer ausschalten"
         #endif

         #if Useinput = 1
            Print
            Print "E?     = Status aller Eingaenge"
            Print "E1?    = Status Eingang 1"
            Print "E2?    = Status Eingang 2"
            Print "E3?    = Status Eingang 3"
            Print "E4?    = Status Eingang 4"
         #endif

         #if Userelais = 1
            Print
            Print "REL?   = Stellung aller Relais"
            Print "REL1?  = Stellung Relais 1"
            Print "REL2?  = Stellung Relais 2"
            Print "REL3?  = Stellung Relais 3"
            Print "REL4?  = Stellung Relais 4"
            Print "REL1=0 = Relais 1 ausschalten"
            Print "REL2=0 = Relais 2 ausschalten"
            Print "REL3=0 = Relais 3 ausschalten"
            Print "REL4=0 = Relais 4 ausschalten"
            Print "REL1=1 = Relais 1 einschalten"
            Print "REL2=1 = Relais 2 einschalten"
            Print "REL3=1 = Relais 3 einschalten"
            Print "REL4=1 = Relais 4 einschalten"
         #endif

         Print
         Print "?       = Diese Befehlsliste"
      Case ""
         Exit Sub
      Case Else
         Print "Befehl " ; Uart_command ; " ist nicht bekannt -> ? = Befehlsliste"
   End Select

   Print

End Sub

Sub Enc28j60init
   'do bank 0 stuff
   'initialize receive buffer
   '16-bit transfers, must write low byte first
   'set receive buffer start address
   Nextpacketptr = Rxstart_init
   Value = Low(rxstart_init)
   Call Enc28j60writecontrolregbyte(erxstl , Value)
   Value = High(rxstart_init)
    Call Enc28j60writecontrolregbyte(erxsth , Value)
    'set receive pointer address
    Value = Low(rxstart_init)
    Call Enc28j60writecontrolregbyte(erxrdptl , Value)
    Value = High(rxstart_init)
    Call Enc28j60writecontrolregbyte(erxrdpth , Value)
    'set receive buffer end
    Value = Low(rxstop_init)
    Call Enc28j60writecontrolregbyte(erxndl , Value)
    Value = High(rxstop_init)
    Call Enc28j60writecontrolregbyte(erxndh , Value)
    'set transmit buffer start
    Value = Low(txstart_init)
    Call Enc28j60writecontrolregbyte(etxstl , Value)
    Value = High(txstart_init)
    Call Enc28j60writecontrolregbyte(etxsth , Value)
    'do bank 2 stuff
    'enable MAC receive
    Value = 0
    Value.macon1_marxen = 1
    Value.macon1_txpaus = 1
    Value.macon1_rxpaus = 1
    Call Enc28j60writecontrolregbyte(macon1 , Value)
    'bring MAC out of reset
    'enable automatic padding and CRC operations
    Value = 0
    Value.macon3_padcfg0 = 1
    Value.macon3_txcrcen = 1
    Value.macon3_frmlnen = 1
    Call Enc28j60writecontrolregbyte(macon3 , Value)
    'set inter-frame gap (non-back-to-back)
    Call Enc28j60writecontrolregbyte(maipgl , &H12)
    Call Enc28j60writecontrolregbyte(maipgh , &H0C)
    'set inter-frame gap (back-to-back)
    Call Enc28j60writecontrolregbyte(mabbipg , &H12)
    'set the maximum packet size which the controller will accept
    Value = Low(max_framelen)
    Call Enc28j60writecontrolregbyte(mamxfll , Value)
    Value = High(max_framelen)
    Call Enc28j60writecontrolregbyte(mamxflh , Value)

    'bank 3 stuff
    Call Enc28j60writecontrolregbyte(maadr5 , Mymac(1))
    Call Enc28j60writecontrolregbyte(maadr4 , Mymac(2))
    Call Enc28j60writecontrolregbyte(maadr3 , Mymac(3))
    Call Enc28j60writecontrolregbyte(maadr2 , Mymac(4))
    Call Enc28j60writecontrolregbyte(maadr1 , Mymac(5))
    Call Enc28j60writecontrolregbyte(maadr0 , Mymac(6))
    'no loopback of transmitted frames
    Call Enc28j60writephyword(phcon2 , Phcon2_hdldis)
    'switch to bank 0
    Call Enc28j60selectbank(0)
    'enable interrupts
    Value = 0
    Value.eie_intie = 1
    Value.eie_pktie = 1
    Call Enc28j60bitfield_set(eie , Value)

    'filters according to Guido
    Call Enc28j60writecontrolregbyte(epmm0 , &H3F)
    Call Enc28j60writecontrolregbyte(epmm1 , &H30)
    Call Enc28j60writecontrolregbyte(epmcsl , &HF9)
    Call Enc28j60writecontrolregbyte(epmcsh , &HF7)

    Value = 0
    Value.erxfcon_pmen = 1                                  'Pattern Match enable (ARP only)
    Value.erxfcon_ucen = 1                                  'Unicast enable
    Call Enc28j60bitfield_set(erxfcon , Value)

    Value = 0
    Value.erxfcon_bcen = 1                                  'Broadcast disable
    Call Enc28j60bitfield_clear(erxfcon , Value)
    'CRC check is enabled by default

    'Something is wrong with the Broadcast filter (or the whole theory), it seems
    'like every packet is coming in

    'enable packet reception
    Value = 0
    Value.econ1_rxen = 1
    Call Enc28j60bitfield_set(econ1 , Value)

    'Reset transmit logic
    Value = 0
    Value.econ1_txrst = 1
    Call Enc28j60bitfield_set(econ1 , Value)
    Call Enc28j60bitfield_clear(econ1 , Value)
 End Sub


Sub Enc28j60selectbank(bank As Byte)
   'get ECON1 (BSEL1 en BSEL0)
   A(1) = &B000_11111
   Enc28j60_cs = 0
   Spiout A(1) , 1
   Spiin A(1) , 2
   Enc28j60_cs = 1
   A(2) = A(2) And &B1111_1100                              'strip bank part
   A(2) = A(2) Or Bank
   A(1) = &B010_11111
   Enc28j60_cs = 0
   Spiout A(1) , 2
   Enc28j60_cs = 1
End Sub


Sub Enc28j60writecontrolregbyte(register As Byte , Value As Byte)
   Bank = 0
   If Register.7 = 1 Then Bank = 2
   If Register.6 = 1 Then Bank = Bank + 1
   Register = Register And &B00011111
   Call Enc28j60selectbank(bank)
   Register.6 = 1                                           'to get a 010_register
   A(1) = Register
   A(2) = Value
   Enc28j60_cs = 0
   Spiout A(1) , 2
   Enc28j60_cs = 1
End Sub


Sub Enc28j60readcontrolregbyte(register As Byte)
   Local Mcphy As Byte
   Bank = 0
   Mcphy = 0
   If Register.7 = 1 Then Bank = 2
   If Register.6 = 1 Then Bank = Bank + 1
   If Register.5 = 1 Then Mcphy = 1
   Register = Register And &B00011111
   Call Enc28j60selectbank(bank)
   A(1) = Register
   Enc28j60_cs = 0
   Spiout A(1) , 1
   Spiin A(1) , 3
   Enc28j60_cs = 1
   'Depending of register (E, MAC, MII) yes or no dummybyte
   If Mcphy = 1 Then
      Enc28j60_data = A(2)
      Else
      Enc28j60_data = A(1)
   End If
End Sub


Sub Enc28j60bitfield_set(register As Byte , Value As Byte)
   Bank = 0
   If Register.7 = 1 Then Bank = 2
   If Register.6 = 1 Then Bank = Bank + 1
   Register = Register And &B00011111
   Call Enc28j60selectbank(bank)
   Register = Register Or &B100_00000
   A(1) = Register
   A(2) = Value
   Enc28j60_cs = 0
   Spiout A(1) , 2
   Enc28j60_cs = 1
End Sub


Sub Enc28j60bitfield_clear(register As Byte , Value As Byte)
   Bank = 0
   If Register.7 = 1 Then Bank = 2
   If Register.6 = 1 Then Bank = Bank + 1
   Register = Register And &B00011111
   Call Enc28j60selectbank(bank)
   Register = Register Or &B101_00000
   A(1) = Register
   A(2) = Value
   Enc28j60_cs = 0
   Spiout A(1) , 2
   Enc28j60_cs = 1
End Sub


Sub Enc28j60readphyword(phyregister As Byte)
   'set the right address and start the register read operation
   Call Enc28j60writecontrolregbyte(miregadr , Phyregister)
   Call Enc28j60writecontrolregbyte(micmd , Micmd_miird)
   'wait until the PHY read complets
   Do
   Call Enc28j60readcontrolregbyte(mistat)
   Loop Until Enc28j60_data.mistat_busy = 0
   'quit reading
   Call Enc28j60writecontrolregbyte(micmd , 0)
   'get data value
   Call Enc28j60readcontrolregbyte(mirdl)
   Wdata = Enc28j60_data
   Shift Wdata , Left , 8
   Call Enc28j60readcontrolregbyte(mirdh)
   Wdata = Wdata + Enc28j60_data
End Sub


Sub Enc28j60writephyword(phyregister As Byte , Wdata As Word)
   Call Enc28j60readphyword(phyregister)
   Local Temp As Byte
   'set the PHY register address
   Call Enc28j60writecontrolregbyte(miregadr , Phyregister)
   Call Enc28j60readcontrolregbyte(miregadr)
   Temp = Miregadr
   Value = Low(wdata)
   Call Enc28j60writecontrolregbyte(miwrl , Value)
   Value = High(wdata)
   Call Enc28j60writecontrolregbyte(miwrh , Value)
   Do
   Call Enc28j60readcontrolregbyte(mistat)
   Loop Until Enc28j60_data.mistat_busy = 0
End Sub


Sub Enc28j60poll
   Call Enc28j60readcontrolregbyte(epktcnt)
   If Enc28j60_data > 0 Then
      Call Enc28j60packetreceive
   End If
End Sub


Sub Enc28j60packetreceive
   Local Wtemp As Word
   'set the read pointer to the start of the received packet
   Value = Low(nextpacketptr)
   Call Enc28j60writecontrolregbyte(erdptl , Value)
   Value = High(nextpacketptr)
   Call Enc28j60writecontrolregbyte(erdpth , Value)
    Enc28j60_cs = 0
    'Send Read Buffer Memory command
    Spdr = &H3A
    Do
    Loop Until Spsr.spif = 1
    'Get the first 6 byte (3 word: Nextpacketptr, Packetlength, Rxstat)
    For X = 1 To 6
          Spdr = &HFF                                       'SPI read
          Do
          Loop Until Spsr.spif = 1                          'SPI ready
          Buffer(x) = Spdr
    Next X
    Nextpacketptr = Buffer(2) * 256
    Nextpacketptr = Nextpacketptr + Buffer(1)
    Length = Buffer(4) * 256
    Length = Length + Buffer(3)
    Rxstat = Buffer(6) * 256
    Rxstat = Rxstat + Buffer(5)
    'Get the payload
    Length = Length - 4                                     'Discard CRC
    For X = 1 To Length
          Spdr = &HFF                                       'SPI read
          Do
          Loop Until Spsr.spif = 1                          'SPI ready
          Buffer(x) = Spdr
    Next X
    Enc28j60_cs = 1
   'move the rx read pointer to the start of the next received packet
   'this frees the memory we just read out
   Value = Low(nextpacketptr)
   Call Enc28j60writecontrolregbyte(erxrdptl , Value)
   Value = High(nextpacketptr)
   Call Enc28j60writecontrolregbyte(erxrdpth , Value)
   'decrement the packet counter indicate we are done with this packet
   Value = 0
   Value.econ2_pktdec = 1
   Call Enc28j60bitfield_set(econ2 , Value)
   'Set Led


    'Handle the packet
    If Buffer(13) = &H08 Then
      If Buffer(14) = &H06 Then                             'Type:ARP
         If Buffer(21) = &H00 Then                          'ARP request
            If Buffer(22) = &H01 Then                       'ARP request
              If Buffer(39) = Myip(1) Then                  'ARP for us
                If Buffer(40) = Myip(2) Then
                   If Buffer(41) = Myip(3) Then
                      If Buffer(42) = Myip(4) Then
                        #if Debugging > 0
                           Print
                           Print "ARP request"
                        #endif
                        Call Arpreply
                      End If
                   End If
                End If
              End If
            End If
         End If
      End If
      If Buffer(14) = &H00 Then                             'Type:IP
         If Buffer(15) = &H45 Then                          'We handle only simple IP packets
            'If Buffer(21) = 0 Then                          'We handle only non fragmented packets
              If Buffer(31) = Myip(1) Then                  'Ip packet for us
                If Buffer(32) = Myip(2) Then
                   If Buffer(33) = Myip(3) Then
                      If Buffer(34) = Myip(4) Then
                        If Buffer(24) = 1 Then              'Protocol:ICMP
                           If Buffer(35) = &H08 Then        'ICMP echo request
                              #if Debugging > 0
                                 Print
                                 Print "ICMP echo request"
                              #endif
                              Call Pingreply
                           End If
                        End If
                        If Buffer(24) = 17 Then             'Protocol:UDP
                           #if Debugging > 0
                              Print
                              Print "UDP request"
                           #endif
                           Call Udp_receive
                        End If
                        If Buffer(24) = 6 Then              'Protocol:TCP
                           #if Debugging > 0
                              Print
                              Print "TCP request"
                           #endif
                           Call Tcp
                        End If
                      End If
                   End If
                End If
              End If
            End If
         'End If
      End If
    End If
End Sub


Sub Enc28j60packetsend(pcktlen As Word)
   'Load packet into the ENC
   Enc28j60_cs = 0
   Spdr = Enc28j60_write_buf_mem
   Do
   Loop Until Spsr.spif = 1
   Spdr = &B000_1110                                        'per packet byte
   Do
   Loop Until Spsr.spif = 1
   For X = 1 To Pcktlen
      Spdr = Buffer(x)
      Do
      Loop Until Spsr.spif = 1
   Next X
   Enc28j60_cs = 1
   'Minimum packet length is 60
   If Pcktlen < 60 Then Pcktlen = 60
   'Reset transmit logic
   Value = 0
   Value.econ1_txrst = 1
   Call Enc28j60bitfield_set(econ1 , Value)
   Call Enc28j60bitfield_clear(econ1 , Value)
   'set the write pointer to start of transmit buffer area
   Value = Low(txstart_init)
   Call Enc28j60writecontrolregbyte(ewrptl , Value)
   Value = High(txstart_init)
   Call Enc28j60writecontrolregbyte(ewrpth , Value)
   'set the TXND pointer to correspond to the packet size given
   Value = Low(txstart_init)
   Value = Value + Low(pcktlen)
   Call Enc28j60writecontrolregbyte(etxndl , Value)
   Value = High(txstart_init)
   Value = Value + High(pcktlen)
   Call Enc28j60writecontrolregbyte(etxndh , Value)
   'write per-packet control byte has been put in the writeroutine
   'send the contents of the transmit buffer onto the network
   Value = 0
   Value.econ1_txrts = 1
   Call Enc28j60bitfield_set(econ1 , Value)
End Sub


Sub Arpreply
   'The original request packet is in the buffer, we just change some things
   'Swap MAC addresses
   Call Src2dest
   'Set source MAC in ethernet frame, pos 7
   Call Src2mymac
   'Copy target MAC in ARP packet
   T_arp_dest_enetpacket0 = T_enetpacketdest0
   T_arp_dest_enetpacket1 = T_enetpacketdest1
   T_arp_dest_enetpacket2 = T_enetpacketdest2
   T_arp_dest_enetpacket3 = T_enetpacketdest3
   T_arp_dest_enetpacket4 = T_enetpacketdest4
   T_arp_dest_enetpacket5 = T_enetpacketdest5
   'Set target IP in ARP packet
   T_arp_tipaddr0 = T_arp_sipaddr0
   T_arp_tipaddr1 = T_arp_sipaddr1
   T_arp_tipaddr2 = T_arp_sipaddr2
   T_arp_tipaddr3 = T_arp_sipaddr3
   'Copy source MAC to ARP
   T_arp_src_enetpacket0 = T_enetpacketsrc0
   T_arp_src_enetpacket1 = T_enetpacketsrc1
   T_arp_src_enetpacket2 = T_enetpacketsrc2
   T_arp_src_enetpacket3 = T_enetpacketsrc3
   T_arp_src_enetpacket4 = T_enetpacketsrc4
   T_arp_src_enetpacket5 = T_enetpacketsrc5
   'Set source IP to ARP packet pos 29
   T_arp_sipaddr0 = Myip(1)
   T_arp_sipaddr1 = Myip(2)
   T_arp_sipaddr2 = Myip(3)
   T_arp_sipaddr3 = Myip(4)
   'Set ARP type from Request to Reply
   T_arp_op1 = 2
   'Send the reply packet
   Call Enc28j60packetsend(42)
End Sub


Sub Pingreply
   Local Packetlength As Word
   Packetlength = Buffer(17) * 256
   Packetlength = Packetlength + Buffer(18)
   Packetlength = Packetlength + 13                         'We are going to calculate the checksum till the end of packet (IP length + 14 byte of the ethernet stuff), -1 to get word start
   'set echo reply
   T_icmp_type = &H00
   T_icmp_code = &H00
   'setup the IP-header
   Call Setipaddrs
   Call Icmp_checksum
   Packetlength = Packetlength + 1
   'Send the reply packet
   Call Enc28j60packetsend(packetlength)
End Sub


Sub Setip_id
   Buffer(19) = High(ip_id)
   Buffer(20) = Low(ip_id)
   Ip_id = Ip_id + 1
End Sub


' Routine to handle UDP-traffic
'
Sub Udp_receive
   Local Udp_port As Word
   Local Udp_porth As Byte
   Local Udp_portl As Byte

   Udp_porth = &H88
   Udp_portl = &H13

   Udp_port = Udp_porth
   Shift Udp_port , Left , 8
   Udp_port = Udp_port + Udp_portl

   If T_udp_srcport = &H3500 Then                           '53 DNS-response
      #if Debugging > 0
         Print "DNS response"
         Print
      #endif
      Exit Sub
   End If

   If T_udp_destport = Udp_port Then
      If T_udp_srcport = &H2500 Then                        '25 NTP protocol
         #if Debugging > 0
            Print "NTP response"
            Print
         #endif
         #if Usentp = 1
            Call Ntp
         #endif
         Exit Sub
      End If
      Exit Sub
   End If
End Sub

' Routine to calculate a IP-header checksum
'
Sub Ip_header_checksum
  Local Ip_checksum16 As Word
  Local Ip_header_length As Byte
  T_ip_hdr_cksum = &H00                                     'Calc starts with chksum=0
  'Calculate IP header length
  Ip_header_length = T_ip_vers_len And &H0F                 'Number of 32 bit words
  Ip_header_length = 4 * Ip_header_length                   'Calc number of bytes
  Ip_checksum16 = Tcpchecksum(buffer(15) , Ip_header_length )
  'Store the checksum value in the packet buffer
  T_ip_hdr_cksum1 = High(ip_checksum16)
  T_ip_hdr_cksum0 = Low(ip_checksum16)
End Sub


' Routine to calculate a ICMP-checksum
'
Sub Icmp_checksum
  'Clear the ICMP checksum before starting calculation
  T_icmp_cksum = &H00
  'Calculate the ICMP checksum
  I_header_length = T_ip_pktlen1 - 20
  I_checksum16 = Tcpchecksum(buffer(35) , I_header_length ) 'built-in way
  T_icmp_cksum1 = High(i_checksum16)
  T_icmp_cksum0 = Low(i_checksum16)
End Sub


' Routine to echo packet
'
Sub Echopacket
   'packetlengte
   Hulp2 = T_udp_len0 * 256
   Hulp2 = Hulp2 + T_udp_len1
   Hulp2 = Hulp2 + 34
   Call Enc28j60packetsend(hulp2)
End Sub


' Routine to handle the source/destination address
'
Sub Setipaddrs
   T_ip_destaddr = T_ip_srcaddr
   'make ethernet module IP address source address
   T_ip_srcaddr = My_ip
   Call Src2dest
   'Set source MAC in ethernet frame, pos 7
   Call Src2mymac
   Call Ip_header_checksum
End Sub


' Routine to get the NetWork Time from a time-server
'
#if Usentp = 1
   Sub Ntp_get
      'MAC-header
      'Destination hardware address                               ' You have to put your router-mac-address here
      Call Rtr2dest
      ' source (own source)
      Call Src2mymac
      T_enetpackettype = &H0008                             ' = &h0800
      ' fill IP-header
      T_ip_vers_len = &H45
      T_tos = &H00
      T_ip_pktlen0 = &H00
      T_ip_pktlen1 = &H30
      T_id0 = &H4A
      T_id1 = &HA5
      T_flags = &H00
      T_offset = &H00
      T_ttl = &H80
      'protocol (ICMP=1, TCP=6, UDP=11)
      T_ip_proto = &H11
      'IP address of source (Eigene IP-Adresse)
      T_ip_srcaddr0 = Myip(1)
      T_ip_srcaddr1 = Myip(2)
      T_ip_srcaddr2 = Myip(3)
      T_ip_srcaddr3 = Myip(4)
      'IP address of destination (NTP-Server)
      T_ip_destaddr0 = Ntpip(1)                             '193
      T_ip_destaddr1 = Ntpip(2)                             '67
      T_ip_destaddr2 = Ntpip(3)                             '79
      T_ip_destaddr3 = Ntpip(4)                             '202
      'UDP-header
      T_udp_srcport0 = &H13
      T_udp_srcport1 = &H88
      T_udp_destport0 = &H00                                ' port 0025 = 37 NTP
      T_udp_destport1 = &H25
      T_udp_len0 = &H00
      T_udp_len1 = &H1C
      T_udp_data(1) = Asc( "X")
      T_udp_data(2) = &H0A                                  ' lf
      T_udp_data(3) = &H0D                                  ' cr
      Call Ip_header_checksum
      Call Udp_checksum
      Call Echopacket
   End Sub


   ' Routine to convert the LONG from the NTP-server in to date and time
   '
   Sub Ntp
      S(1) = T_udp_data(1)
      S(2) = T_udp_data(2)
      S(3) = T_udp_data(3)
      S(4) = T_udp_data(4)
      Swap S(1) , S(4) : Swap S(2) , S(3)
      L2 = L1 + 1139293696
      L2 = L2 + 3600                                        ' offset UTC + 1 hour
      Print
      Print "NTP-Datum   : " ; Date(l2)
      Print "NTP-Uhrzeit : " ; Time(l2)
      Date$ = Date(l2)
      Time$ = Time(l2)
      Print
      Print "ENC28J60 I/O-Webserver Befehls Interpreter V1.0"
      Print "? = Hilfe"
      Print
      Print "Befehl>";
   End Sub
#endif

'Tcp-checksum
'
Sub Tcp_checksum
   Local Whulp1 As Word
   Local Tempword2 As Word
   Tcp_cksum = 0
   Call Srcdestchksum
   'resultaat in I_chksum32
   Tempwordh = T_ip_pktlen0
   Tempwordl = T_ip_pktlen1
   I_chksum32 = I_chksum32 + Tempword
   Tempword2 = T_ip_vers_len And &H0F
   Tempword2 = Tempword2 * 4
   I_chksum32 = I_chksum32 - Tempword2
   Whulp1 = Tempword - 20
   Val2 = Highw(i_chksum32)
   Val1 = I_chksum32
   I_checksum16 = Tcpchecksum(buffer(&H23) , Whulp1 , Val2 , Val1)
   Tcp_cksuml = High(i_checksum16)
   Tcp_cksumh = Low(i_checksum16)
End Sub


' Routine to calculate the IP-checkum
'
Sub Udp_checksum
   T_udp_chksum = &H00
   Call Srcdestchksum
   'resultaat in I_chksum32
   'packet length
   I_value16h = T_udp_len0
   I_value16l = T_udp_len1
   I_chksum32 = I_chksum32 + I_value16
   Result16h = T_udp_len0
   Result16l = T_udp_len1

   Val2 = Highw(i_chksum32)
   Val1 = I_chksum32

   I_checksum16 = Tcpchecksum(buffer(&H23) , Result16 , Val1 , Val2)

   T_udp_chksum1 = High(i_checksum16)
   T_udp_chksum0 = Low(i_checksum16)
End Sub

Sub Srcdestchksum
   'checksum TCP header
   I_chksum32 = 0
   I_value16h = T_ip_srcaddr0
   I_value16l = T_ip_srcaddr1
   I_chksum32 = I_chksum32 + I_value16
   I_value16h = T_ip_srcaddr2
   I_value16l = T_ip_srcaddr3
   I_chksum32 = I_chksum32 + I_value16
   I_value16h = T_ip_destaddr0
   I_value16l = T_ip_destaddr1
   I_chksum32 = I_chksum32 + I_value16
   I_value16h = T_ip_destaddr2
   I_value16l = T_ip_destaddr3
   I_chksum32 = I_chksum32 + I_value16
   'proto
   I_chksum32 = I_chksum32 + T_ip_proto
End Sub


'HTTP
'
Sub Http
   Local Msg_temp2 As String * 10
   Local Msg_temp As String * 80
   Local Tempstring1 As String * 1
   Local Ackpsh As Byte
   Local Pkthulp As Word
   Local Tempword1 As Word
   Local Tempword3 As Word
   Local Z As Byte
   Local Ztemp As Byte
   Local Tempstring2 As String * 20
   Local Strpos As Byte
   Local Strposa As Byte
   Local Strpose As Byte

   Work = Tcp_flags
   Tcp_fin = Work.0
   Tcp_syn = Work.1
   Tcp_rst = Work.2
   Tcp_psh = Work.3
   Tcp_ack = Work.4
   Tcp_urg = Work.5

   ' This code segment processes the incoming SYN from the client
   ' and sends back the initial sequence number (ISN) and acknowledges
   ' the incoming SYN packet
   If Tcp_syn = 1 Then
         'Move IP source address to destination address
         T_ip_destaddr = T_ip_srcaddr
         'Make ethernet module IP address source address
         T_ip_srcaddr = My_ip
         Swap Tcp_srcportl , Tcp_destportl
         Swap Tcp_srcporth , Tcp_destporth
         Tcpdatalen_in = 1
         Client_seqnum0 = Tcp_seqnum0
         Client_seqnum1 = Tcp_seqnum1
         Client_seqnum2 = Tcp_seqnum2
         Client_seqnum3 = Tcp_seqnum3
         Client_seqnum = Client_seqnum + Tcpdatalen_in
         Tcp_acknum0 = Client_seqnum0
         Tcp_acknum1 = Client_seqnum1
         Tcp_acknum2 = Client_seqnum2
         Tcp_acknum3 = Client_seqnum3
         Tcp_seqnum0 = &HFF                                 'Initial sequencenumber
         Tcp_seqnum1 = &HFF                                 '
         Tcp_seqnum2 = &H10                                 '
         Tcp_seqnum3 = &H11                                 '
         Call Src2dest
         Set Flags.synflag
         Tcp_flags = 0
         Set Tcp_flags.1
         Set Tcp_flags.4
         T_ip_pktlen0 = &H00
         T_ip_pktlen1 = 48
         Call Ip_header_checksum
         Call Tcp_checksum
         Call Enc28j60packetsend(62)
   End If


    If Tcp_ack = 1 Then
       If Buffer(17) = 0 Then
          If Buffer(18) = 40 Then
             If Ackpsh = 1 Then
                 'ACK after a ACK-PSH
                 'set flags
                   Tcp_flags = 0
                 Set Tcp_flags.4                            'ack
                 Set Tcp_flags.3                            'psh
                 Set Tcp_flags.0                            'fin
                 'Move IP source address to destination address
                 T_ip_destaddr = T_ip_srcaddr
                 'Make ethernet module IP address source address
                 T_ip_srcaddr = My_ip
                 Swap Tcp_srcportl , Tcp_destportl
                 Swap Tcp_srcporth , Tcp_destporth
                 'swap mac
                 Call Src2dest
                 Call Inc2seq
                 Call Seq2ack
                 Call Ack2inc
                 Tempword3 = &H37

                 #if Debugging > 1
                  Print "Parse und sende HTML Seite"
                 #endif

                 If Htmlpage = 0 Then
                    Restore Notfound_page
                 Elseif Htmlpage = 1 Then
                    Restore Index_html
                 Elseif Htmlpage = 2 Then
                    #if Uselcd = 1
                       Restore Lcd_html
                    #else
                       Restore Notfound_page
                    #endif
                 Elseif Htmlpage = 3 Then
                    Restore Daten_html
                 Elseif Htmlpage = 4 Then
                    Restore Stats_html
                 Elseif Htmlpage = 5 Then
                    Restore Impressum_html
                 End If

                 Do
                     Read Msg_temp
                     Msg_temp2 = Right(msg_temp , 8)
                     If Msg_temp2 = "endblock" Then
                        Exit Do
                     End If
                     If Msg_temp2 = "sizeused" Then
                        Tempword1 = Tempword3 + 24
                        Msg_temp = "Seitengr&ouml;&szlig;e: " + Str(tempword1) + " Bytes"
                     End If
                     If Msg_temp2 = "date    " Then
                        #if Usentp = 1
                           Msg_temp = Left(date$ , 6) + "20" + Right(date$ , 2)
                        #else
                           Msg_temp = "n/a"
                        #endif
                     End If
                     If Msg_temp2 = "time    " Then
                        #if Usentp = 1
                           Msg_temp = Time$
                        #else
                           Msgtemp = "n/a"
                        #endif
                     End If
                     If Msg_temp2 = "--BUZ---" Then
                        If Buzzer_status = 0 Then
                           Msg_temp = "<a href=" + Chr(34) + "/BUZ=1" + Chr(34) + "><b><font color=" + Chr(34) + "red" + Chr(34) + ">einschalten</font></b></a>"
                        Else
                           Msg_temp = "<a href=" + Chr(34) + "/BUZ=0" + Chr(34) + "><b><font color=" + Chr(34) + "green" + Chr(34) + ">ausschalten</font></b></a>"
                        End If
                        #if Debugging > 1
                           Print "BUZZER = " ; Str(buzzer_status)
                        #endif
                     End If
                     If Msg_temp2 = "--REL1--" Then
                        If Relais1_status = 0 Then
                           Msg_temp = "<a href=" + Chr(34) + "/REL1=1" + Chr(34) + "><b><font color=" + Chr(34) + "green" + Chr(34) + ">einschalten</font></b></a>"
                        Else
                           Msg_temp = "<a href=" + Chr(34) + "/REL1=0" + Chr(34) + "><b><font color=" + Chr(34) + "red" + Chr(34) + ">ausschalten</font></b></a>"
                        End If
                        #if Debugging > 1
                           Print "RELAIS1 = " ; Str(relais1_status)
                        #endif
                     End If
                     If Msg_temp2 = "--REL2--" Then
                        If Relais2_status = 0 Then
                           Msg_temp = "<a href=" + Chr(34) + "/REL2=1" + Chr(34) + "><b><font color=" + Chr(34) + "green" + Chr(34) + ">einschalten</font></b></a>"
                        Else
                           Msg_temp = "<a href=" + Chr(34) + "/REL2=0" + Chr(34) + "><b><font color=" + Chr(34) + "red" + Chr(34) + ">ausschalten</font></b></a>"
                        End If
                        #if Debugging > 1
                           Print "RELAIS2 = " ; Str(relais2_status)
                        #endif
                     End If
                     If Msg_temp2 = "--REL3--" Then
                         If Relais3_status = 0 Then
                           Msg_temp = "<a href=" + Chr(34) + "/REL3=1" + Chr(34) + "><b><font color=" + Chr(34) + "green" + Chr(34) + ">einschalten</font></b></a>"
                        Else
                           Msg_temp = "<a href=" + Chr(34) + "/REL3=0" + Chr(34) + "><b><font color=" + Chr(34) + "red" + Chr(34) + ">ausschalten</font></b></a>"
                        End If
                        #if Debugging > 1
                           Print "RELAIS3 = " ; Str(relais3_status)
                        #endif
                     End If
                     If Msg_temp2 = "--REL4--" Then
                        If Relais4_status = 0 Then
                           Msg_temp = "<a href=" + Chr(34) + "/REL4=1" + Chr(34) + "><b><font color=" + Chr(34) + "green" + Chr(34) + ">einschalten</font></b></a>"
                        Else
                           Msg_temp = "<a href=" + Chr(34) + "/REL4=0" + Chr(34) + "><b><font color=" + Chr(34) + "red" + Chr(34) + ">ausschalten</font></b></a>"
                        End If
                        #if Debugging > 1
                           Print "RELAIS4 = " ; Str(relais4_status)
                        #endif
                     End If
                     If Msg_temp2 = "---OK1--" Then
                        Msg_temp = "<b>" + Str(ok1_status) + "</b>"
                        #if Debugging > 1
                           Print "EINGANG1 = " ; Str(ok1_status)
                        #endif
                     End If
                     If Msg_temp2 = "---OK2--" Then
                        Msg_temp = "<b>" + Str(ok2_status) + "</b>"
                        #if Debugging > 1
                           Print "EINGANG2 = " ; Str(ok2_status)
                        #endif
                     End If
                     If Msg_temp2 = "---OK3--" Then
                        Msg_temp = "<b>" + Str(ok3_status) + "</b>"
                        #if Debugging > 1
                           Print "EINGANG3 = " ; Str(ok3_status)
                        #endif
                     End If
                     If Msg_temp2 = "---OK4--" Then
                        Msg_temp = "<b>" + Str(ok4_status) + "</b>"
                        #if Debugging > 1
                           Print "EINGANG4 = " ; Str(ok4_status)
                        #endif
                     End If
                     If Msg_temp2 = "--ADC1--" Then
                        Msg_temp = "<b>" + Str(getadc(4)) + "</b>"
                        #if Debugging > 1
                           Print "ADC1 = " ; Str(getadc(4))
                        #endif
                     End If
                     If Msg_temp2 = "--ADC2--" Then
                        Msg_temp = "<b>" + Str(getadc(5)) + "</b>"
                        #if Debugging > 1
                           Print "ADC2 = " ; Str(getadc(5))
                        #endif
                     End If
                     If Msg_temp2 = "--ADC3--" Then
                        Msg_temp = "<b>" + Str(getadc(6)) + "</b>"
                        #if Debugging > 1
                           Print "ADC3 = " ; Str(getadc(6))
                        #endif
                     End If
                     If Msg_temp2 = "--ADC4--" Then
                        Msg_temp = "<b>" + Str(getadc(7)) + "</b>"
                        #if Debugging > 1
                           Print "ADC4 = " ; Str(getadc(7))
                        #endif
                     End If
                     If Msg_temp2 = "BUZSTAT?" Then
                        #if Usebuzzer = 1
                           Msg_temp = "Buzzer = aktiv"
                        #else
                           Msg_temp = "Buzzer = nicht aktiv"
                        #endif
                     End If
                     If Msg_temp2 = "RELSTAT?" Then
                        #if Userelais = 1
                           Msg_temp = "Relais = aktiv"
                        #else
                           Msg_temp = "Relais = nicht aktiv"
                        #endif
                     End If
                     If Msg_temp2 = "EINSTAT?" Then
                        #if Useinput = 1
                           Msg_temp = "Eing&auml;nge = aktiv"
                        #else
                           Msg_temp = "Eing&auml;nge = nicht aktiv"
                        #endif
                     End If
                     If Msg_temp2 = "BTMSTAT?" Then
                        #if Usebtm = 1
                           Msg_temp = "BTM-222 = aktiv"
                        #else
                           Msg_temp = "BTM-222 = nicht aktiv"
                        #endif
                     End If
                     If Msg_temp2 = "LCDSTAT?" Then
                        #if Uselcd = 1
                           Msg_temp = "LCD = aktiv"
                        #else
                           Msg_temp = "LCD = nicht aktiv"
                        #endif
                     End If
                     If Msg_temp2 = "-LCDZ1--" Then
                        #if Uselcd = 1
                           Msg_temp = Replacespaces(lcdzeile1)
                        #else
                           Msg_temp = ""
                        #endif
                     End If
                     If Msg_temp2 = "-LCDZ2--" Then
                        #if Uselcd = 1
                           Msg_temp = Replacespaces(lcdzeile2)
                        #else
                           Msg_temp = ""
                        #endif
                     End If
                     If Msg_temp2 = "-MCTYPE-" Then
                        Msg_temp = Mctype
                     End If
                     If Msg_temp2 = "PVERSION" Then
                        Msg_temp = Prgversion
                     End If
                     If Msg_temp2 = "copyleft" Then
                        Msg_temp = "<a href=" + Chr(34) + "http://mikrocontroller.heldt.eu" + Chr(34) + " target=" + Chr(34) + "_blank" + Chr(34) + "><b>Projekte</b></a>"
                     End If
                     For Y = 1 To Len(msg_temp)
                         Tempstring1 = Mid(msg_temp , Y , 1)
                         Buffer(tempword3) = Asc(tempstring1)
                     Incr Tempword3
                     Next Y
                Loop
                Buffer(tempword3) = &H0D
                Incr Tempword3
                Buffer(tempword3) = &H0A
                Tempword3 = Tempword3 - 14
                Pkthulp = Tempword3 / 256
                T_ip_pktlen0 = Pkthulp
                Pkthulp = T_ip_pktlen0 * 256
                T_ip_pktlen1 = Tempword3 - Pkthulp
                Tempword3 = Tempword3 + 14
                Call Ip_header_checksum
                Call Tcp_checksum
                Call Enc28j60packetsend(tempword3)
                Ackpsh = 0
                #if Debugging > 1
                  Print "HTML Seite gesendet"
                  Print "Setze Ackpsh = 0"
                #endif
              End If
           End If
        End If
     End If

   ' If an ACK and PSH is received and the destination port address is valid
   If Tcp_ack = 1 Then
        If Tcp_psh = 1 Then

           #if Debugging > 1
               Print "Suche /GET"
           #endif

           'search for GET / and check for a parameter
           '
           ' walk through the packet until GET / is found

           For Z = 40 To 200
               Ztemp = Z
               Tempstring2 = Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               Incr Ztemp
               Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
               If Left(tempstring2 , 5) = "GET /" Then
                  Exit For
               End If
           Next Z

           'V1.0.2
           Htmlpage = 0

           Strpos = Instr(tempstring2 , "HTTP/")
           If Strpos > 0 Then
               Htmlpage = 1
           Else
               Strpos = Instr(tempstring2 , "index")
               If Strpos > 0 Then
                  Htmlpage = 1
               Else
                  Strpos = Instr(tempstring2 , "lcd.h")
                  If Strpos > 0 Then
                     Htmlpage = 2
                  Else
                     Strpos = Instr(tempstring2 , "daten")
                     If Strpos > 0 Then
                        Htmlpage = 3
                     Else
                        Strpos = Instr(tempstring2 , "stats")
                        If Strpos > 0 Then
                           Htmlpage = 4
                        Else
                           Strpos = Instr(tempstring2 , "impre")
                           If Strpos > 0 Then
                             Htmlpage = 5
                           End If
                        End If
                     End If
                  End If
               End If
           End If

           #if Uselcd = 1 And Uselcdweb = 1
              If Mid(tempstring2 , 6 , 6 ) = "?LCD1=" Then
                  Htmlpage = 2

                  Strposa = Ztemp                           'Start Lcdzeile1
                  Strpose = Strposa + 48

                  For Z = Strposa To Strpose
                     Ztemp = Z
                     Tempstring2 = Chr(buffer(ztemp))
                     Incr Ztemp
                     Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
                     Incr Ztemp
                     Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
                     Incr Ztemp
                     Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
                     Incr Ztemp
                     Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
                     Incr Ztemp
                     Tempstring2 = Tempstring2 + Chr(buffer(ztemp))
                     If Left(tempstring2 , 6) = "&LCD2=" Then
                        Exit For
                     End If
                  Next

                  Strpose = Ztemp - 6                       'Ende Lcdzeile1

                  Lcdzeile1 = Convert(strposa , Strpose , 1)

                  Locate 1 , 1
                  Lcd Lcdzeile1

                  Strposa = Ztemp                           'Start Lcdzeile2
                  Strpose = Strposa + 48

                  For Z = Strposa To Strpose
                     Tempstring2 = Chr(buffer(z))
                     If Left(tempstring2 , 1) = " " Then
                        Exit For
                     End If
                  Next

                  Strpose = Z                               'Ende Lcdzeile2

                  Lcdzeile2 = Convert(strposa , Strpose , 2)

                  Locate 2 , 1
                  Lcd Lcdzeile2

                  #if Debugging > 1
                     Print "LCD Zeile1=" ; Lcdzeile1
                     Print "LCD Zeile2=" ; Lcdzeile2
                  #endif
              End If
           #endif

           #if Debugging > 1
              Print "Angeforderte Seite=" ; Str(htmlpage) ; " -> " ; Tempstring2
           #endif

           #if Usebuzzer = 1
              If Mid(tempstring2 , 6 , 5) = "BUZ=1" Then
                    Set Buzzer
                    Buzzer_status = 1
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 5) = "BUZ=0" Then
                    Reset Buzzer
                    Buzzer_status = 0
                    Htmlpage = 3
              End If
           #endif

           #if Userelais = 1
              If Mid(tempstring2 , 6 , 6) = "REL1=1" Then
                    Set Relais1
                    Relais1_status = 1
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL1=0" Then
                    Reset Relais1
                    Relais1_status = 0
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL2=1" Then
                    Set Relais2
                    Relais2_status = 1
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL2=0" Then
                    Reset Relais2
                    Relais2_status = 0
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL3=1" Then
                    Set Relais3
                    Relais3_status = 1
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL3=0" Then
                    Reset Relais3
                    Relais3_status = 0
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL4=1" Then
                    Set Relais4
                    Relais4_status = 1
                    Htmlpage = 3
              End If
              If Mid(tempstring2 , 6 , 6) = "REL4=0" Then
                    Reset Relais4
                    Relais4_status = 0
                    Htmlpage = 3
              End If
           #endif

           'set flags
           Tcp_flags = 0
           Set Tcp_flags.4                                  'ack
           'Move IP source address to destination address
           T_ip_destaddr = T_ip_srcaddr
           'Make ethernet module IP address source address
           T_ip_srcaddr = My_ip
           Swap Tcp_srcportl , Tcp_destportl
           Swap Tcp_srcporth , Tcp_destporth
           'swap mac
           Call Src2dest
           Call Inc2seq
           T_ip_pktlen = T_ip_pktlen0 * 256
           T_ip_pktlen = T_ip_pktlen + T_ip_pktlen1
           Incoming_ack = Incoming_ack + T_ip_pktlen
           Call Seq2ack
           Call Ack2inc
           Buffer(17) = 0
           Buffer(18) = 40
           '5 x 4 = 20 bytes
           Buffer(47) = &H50
           'padding
           Buffer(55) = 0
           Buffer(56) = 0
           Buffer(57) = 0
           Buffer(58) = 0
           Buffer(59) = 0
           Buffer(60) = 0
           Call Ip_header_checksum
           Call Tcp_checksum
           Call Enc28j60packetsend(60)
           Ackpsh = 1
           #if Debugging > 1
            Print "GET gefunden und Daten ausgewertet"
            Print "Setze Ackpsh=1"
           #endif
        End If
    End If
End Sub


' TCP
'
Sub Tcp
   If Tcp_destporth = 0 Then
      If Tcp_destportl = 80 Then
         #if Debugging > 1
            Print "HTTP request"
            Print
         #endif
         Call Http
      End If
   End If
End Sub


Sub Inc2seq
    Incoming_ack0 = Tcp_seqnum0
    Incoming_ack1 = Tcp_seqnum1
    Incoming_ack2 = Tcp_seqnum2
    Incoming_ack3 = Tcp_seqnum3
End Sub


Sub Seq2ack
    Tcp_seqnum0 = Tcp_acknum0
    Tcp_seqnum1 = Tcp_acknum1
    Tcp_seqnum2 = Tcp_acknum2
    Tcp_seqnum3 = Tcp_acknum3
End Sub


Sub Ack2inc
    Tcp_acknum0 = Incoming_ack0
    Tcp_acknum1 = Incoming_ack1
    Tcp_acknum2 = Incoming_ack2
    Tcp_acknum3 = Incoming_ack3
End Sub


Sub Src2mymac
   'Make ethernet module mac address the source address
   T_enetpacketsrc0 = Mymac(1)
   T_enetpacketsrc1 = Mymac(2)
   T_enetpacketsrc2 = Mymac(3)
   T_enetpacketsrc3 = Mymac(4)
   T_enetpacketsrc4 = Mymac(5)
   T_enetpacketsrc5 = Mymac(6)
End Sub


Sub Src2dest
   'move hardware source address to destination address
   T_enetpacketdest0 = T_enetpacketsrc0
   T_enetpacketdest1 = T_enetpacketsrc1
   T_enetpacketdest2 = T_enetpacketsrc2
   T_enetpacketdest3 = T_enetpacketsrc3
   T_enetpacketdest4 = T_enetpacketsrc4
   T_enetpacketdest5 = T_enetpacketsrc5
   Call Src2mymac
End Sub

#if Usedns = 1
   Sub Dns
   Local Msg_temp As String * 55
   Msg_temp = Dns_query( "www.google.de")
   Msg_temp = Dns_query( "www.it-wns.de")
   Msg_temp = Dns_query( "www.heldt.eu")
   End Sub

   Function Dns_query(s As String) As String
   Local Dns1 As Byte
   Local Dns2 As Byte
   Local Dns3 As Byte
   Local Dns4 As String * 1
   Local Dns5 As Byte
   Local Msg_temp As String * 50
       Dns1 = Split(s , Dns_name(1) , ".")
       Dns2 = Len(s)
       Call Rtr2dest
       Call Src2mymac
       T_enetpackettype = &H0008                            ' = &h0800
       T_ip_vers_len = &H45
       T_tos = &H00
       T_ip_pktlen0 = &H00                                  'this depends on length string
       T_ip_pktlen1 = 46 + Dns2
       T_id0 = &H48
       T_id1 = &H15
       T_flags = &H00
       T_offset = &H00
       T_ttl = &H80
       'protocol (ICMP=1, TCP=6, UDP=11)
       T_ip_proto = &H11
       'IP address of source
       T_ip_srcaddr0 = Myip(1)
       T_ip_srcaddr1 = Myip(2)
       T_ip_srcaddr2 = Myip(3)
       T_ip_srcaddr3 = Myip(4)
       'IP address of destination                              'you have to put the IP-number of
       T_ip_destaddr0 = Mydns(1)                            ' the DNS-server here (@HOME)
       T_ip_destaddr1 = Mydns(2)
       T_ip_destaddr2 = Mydns(3)
       T_ip_destaddr3 = Mydns(4)
       'UDP-header
       T_udp_srcport0 = &H04
       T_udp_srcport1 = &H12
       T_udp_destport0 = &H00                               ' port 0035 = 53 DNS
       T_udp_destport1 = &H35

       T_udp_len0 = &H00                                    'this depends on length string
       T_udp_len1 = 26 + Dns2                               'len string
       'DNS-query
       T_udp_data(1) = &H00                                 'ID
       T_udp_data(2) = &HB4
       T_udp_data(3) = &H01                                 'flags
       T_udp_data(4) = &H00
       T_udp_data(5) = &H00                                 'questions
       T_udp_data(6) = &H01
       T_udp_data(7) = &H00                                 'Answer RRs
       T_udp_data(8) = &H00
       T_udp_data(9) = &H00                                 'Authority
       T_udp_data(10) = &H00
       T_udp_data(11) = &H00                                'Additional
       T_udp_data(12) = &H00
       'queries
       T_udp_data(13) = Len(dns_name(1))
       Dns5 = 14
       For Dns3 = 1 To Len(dns_name(1))
           Dns4 = Mid(dns_name(1) , Dns3 , 1)
           T_udp_data(dns5) = Asc(dns4)
           Incr Dns5
       Next Dns3
       T_udp_data(dns5) = Len(dns_name(2))
       Incr Dns5
       For Dns3 = 1 To Len(dns_name(2))
           Dns4 = Mid(dns_name(2) , Dns3 , 1)
           T_udp_data(dns5) = Asc(dns4)
           Incr Dns5
       Next Dns3
       T_udp_data(dns5) = Len(dns_name(3))
       Incr Dns5
       For Dns3 = 1 To Len(dns_name(3))
           Dns4 = Mid(dns_name(3) , Dns3 , 1)
           T_udp_data(dns5) = Asc(dns4)
           Incr Dns5
       Next Dns3
       T_udp_data(dns5) = &H00
       'host address
       T_udp_data(dns5 + 1) = &H00
       T_udp_data(dns5 + 2) = &H01
       'Class: INET
       T_udp_data(dns5 + 3) = &H00
       T_udp_data(dns5 + 4) = &H01
       Call Ip_header_checksum
       Call Udp_checksum
       Call Echopacket
   End Function
#endif

Sub Rtr2dest
   T_enetpacketdest0 = Gwmac(1)
   T_enetpacketdest1 = Gwmac(2)
   T_enetpacketdest2 = Gwmac(3)
   T_enetpacketdest3 = Gwmac(4)
   T_enetpacketdest4 = Gwmac(5)
   T_enetpacketdest5 = Gwmac(6)
End Sub

#if Uselcd = 1 And Uselcdweb = 1
   Function Replacespaces(lcdtext As String) As String
      Local Pos As Byte

      For Pos = 1 To 16
         If Mid(lcdtext , Pos , 1) = " " Then
            Mid(lcdtext , Pos , 1) = "_"
         End If
      Next

      Replacespaces = Lcdtext
   End Function

   Function Convert(startpos As Byte , Endepos As Byte , Zeile As Byte) As String
      Local Anzchars As Byte
      Local Convpostemp As Byte
      Local Cstring As String * 3
      Local Lcdtempzeile As String * 16

      #if Debugging > 1
         Print "Konvertiere Zeile " ; Zeile ; "  Anfang=" ; Startpos ; " Ende=" ; Endepos
      #endif

      If Startpos = Endepos Then
         Convert = Space(16)
         Exit Function
      End If

      Convpostemp = Endepos - Startpos

      If Convpostemp > 48 Then
         Endepos = Startpos + 47
      End If

      Lcdtempzeile = ""

      Anzchars = 0

      Convpostemp = Startpos

      Do
         Incr Convpostemp

         If Chr(buffer(convpostemp)) = "+" Then
            Cstring = " "
         Else
            Cstring = Chr(buffer(convpostemp))
         End If

         Incr Convpostemp

         If Chr(buffer(convpostemp)) = "+" Then
            Cstring = Cstring + " "
         Else
            Cstring = Cstring + Chr(buffer(convpostemp))
         End If

         Incr Convpostemp

         If Chr(buffer(convpostemp)) = "+" Then
            Cstring = Cstring + " "
         Else
            Cstring = Cstring + Chr(buffer(convpostemp))
         End If

         Select Case Cstring
            Case "%21"
               Lcdtempzeile = Lcdtempzeile + "!"
            Case "%22"
               Lcdtempzeile = Lcdtempzeile + Chr(34)
            Case "%23"
               Lcdtempzeile = Lcdtempzeile + "#"
            Case "%24"
               Lcdtempzeile = Lcdtempzeile + "$"
            Case "%25"
               Lcdtempzeile = Lcdtempzeile + "%"
            Case "%26"
               Lcdtempzeile = Lcdtempzeile + "&"
            Case "%27"
               Lcdtempzeile = Lcdtempzeile + "'"
            Case "%28"
               Lcdtempzeile = Lcdtempzeile + "("
            Case "%29"
               Lcdtempzeile = Lcdtempzeile + ")"
            Case "%2A"
               Lcdtempzeile = Lcdtempzeile + "*"
            Case "%2B"
               Lcdtempzeile = Lcdtempzeile + "+"
            Case "%2C"
               Lcdtempzeile = Lcdtempzeile + ","
            Case "%2D"
               Lcdtempzeile = Lcdtempzeile + "-"
            Case "%2E"
               Lcdtempzeile = Lcdtempzeile + "."
            Case "%2F"
               Lcdtempzeile = Lcdtempzeile + "/"
            Case "%3A"
               Lcdtempzeile = Lcdtempzeile + ":"
            Case "%3B"
               Lcdtempzeile = Lcdtempzeile + ";"
            Case "%3C"
               Lcdtempzeile = Lcdtempzeile + "<"
            Case "%3D"
               Lcdtempzeile = Lcdtempzeile + "="
            Case "%3E"
               Lcdtempzeile = Lcdtempzeile + ">"
            Case "%3F"
               Lcdtempzeile = Lcdtempzeile + "?"
            Case "%40"
               Lcdtempzeile = Lcdtempzeile + "@"
            Case "%5B"
               Lcdtempzeile = Lcdtempzeile + "["
            Case "%5C"
               Lcdtempzeile = Lcdtempzeile + "\"
            Case "%5D"
               Lcdtempzeile = Lcdtempzeile + "]"
            Case "%5E"
               Lcdtempzeile = Lcdtempzeile + "^"
            Case "%5F"
               Lcdtempzeile = Lcdtempzeile + "_"
            Case "%60"
               Lcdtempzeile = Lcdtempzeile + "`"
            Case "%7B"
               Lcdtempzeile = Lcdtempzeile + "{"
            Case "%7C"
               Lcdtempzeile = Lcdtempzeile + "|"
            Case "%7D"
               Lcdtempzeile = Lcdtempzeile + "}"
            Case "%7E"
               Lcdtempzeile = Lcdtempzeile + "~"
            Case "%A7"
               Lcdtempzeile = Lcdtempzeile + "§"
            Case "%B0"
               Lcdtempzeile = Lcdtempzeile + "°"
            Case "%B2"
               Lcdtempzeile = Lcdtempzeile + "²"
            Case "%B3"
               Lcdtempzeile = Lcdtempzeile + "³"
            Case "%80"
               Lcdtempzeile = Lcdtempzeile + "€"
            Case "%C4"
               Lcdtempzeile = Lcdtempzeile + "Ä"
            Case "%D6"
               Lcdtempzeile = Lcdtempzeile + "Ö"
            Case "%DC"
               Lcdtempzeile = Lcdtempzeile + "Ü"
            Case "%E4"
               Lcdtempzeile = Lcdtempzeile + "ä"
            Case "%F6"
               Lcdtempzeile = Lcdtempzeile + "ö"
            Case "%FC"
               Lcdtempzeile = Lcdtempzeile + "ü"
            Case "%DF"
               Lcdtempzeile = Lcdtempzeile + "ß"
            Case Else
               Lcdtempzeile = Lcdtempzeile + Left(cstring , 1)
               Convpostemp = Convpostemp - 2
         End Select
         Incr Anzchars
      Loop Until Convpostemp = Endepos Or Anzchars = 16

      If Len(lcdtempzeile) < 16 Then
         Do
            Lcdtempzeile = Lcdtempzeile + " "
         Loop Until Len(lcdtempzeile) = 16
      End If

      Convert = Lcdtempzeile
   End Function
#endif

'Sekundentakt für die Uhrzeit
Sek_isr:
   Lsec = Syssec()

   Lsec = Lsec + 1

   _sec = Time(lsec)
   _day = Date(lsec)

   #if Uselcd = 1 And Uselcdweb = 0 And Dispclock = 1
      Locate 1 , 3
      Lcd Left(date$ , 6) ; "20" ; Right(date$ , 2)
      Locate 2 , 4
      Lcd Time$
      Locate 1 , 16

      Select Case Heartbeat
         Case 0
            Lcd " "
            Heartbeat = 1
         Case 1
            Lcd "*"
            Heartbeat = 0
      End Select
   #endif

   Timer1 = 3035
Return

'
' Webseiten
'
Index_html:
Data "HTTP/1.0 200 OK" , &H0D , &H0A , &H0D , &H0A
Data "<html><head><meta http-equiv=" , &H22
Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
Data "<title>ENC28J60 I/O Webserver - Startseite</title></head>"
Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , " link=" , &H22 , "#000080" , &H22 , ""
Data " vlink=" , &H22 , "#000080" , &H22 , " alink=" , &H22 , "#000080" , &H22 , ">"
Data "<font face=" , &H22 , "verdana" , &H22 , ">"
Data "<br><br><center><h2><u><b>ENC28J60 I/O-Webserver - Startseite</b></u></h2><br><br><br>"
Data "<br><table bgcolor=" , &H22 , "#D7D5D5" , &H22 , "><tr>"
Data "<td align=" , &H22 , "center" , &H22 , "><br>"
Data "<font color=" , &H22 , "#400000" , &H22 , "><b>Bitte w&auml;hlen:</b></font><hr>"
Data "<a href=" , &H22 , "/daten.html" , &H22 , "><b>Buzzer, Relais und Eing&auml;nge</b></a>"
#if Uselcd = 1 And Uselcdweb = 1
   Data "<br><hr>"
   Data "<a href=" , &H22 , "/lcd.html" , &H22 , "><b>LCD-Display</b></a>"
#endif
Data "<br><hr>"
Data "<a href=" , &H22 , "/stats.html" , &H22 , "><b>System-Informationen</b></a>"
Data "<br><hr>"
Data "<a href=" , &H22 , "/impressum.html" , &H22 , "><b>Impressum</b></a>"
Data "<br><hr>"
Data "sizeused"
Data "<br><hr>"
Data "date    "
Data " - "
Data "time    "
Data "<br><hr>"
Data "copyleft"
Data "<br>&nbsp;</td></tr></table></center></font></body></html>"
Data "endblock"

Daten_html:
Data "HTTP/1.0 200 OK" , &H0D , &H0A , &H0D , &H0A
Data "<html><head><meta http-equiv=" , &H22
Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
Data "<title>ENC28J60 I/O Webserver - Buzzer, Relais und Eing&auml;nge</title></head>"
Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , " link=" , &H22 , ""
Data "#000080" , &H22 , " vlink=" , &H22 , "#000080" , &H22 , " alink=" , &H22 , "#000080" , &H22 , ">"
Data "<font face=" , &H22 , "verdana" , &H22 , ">"
Data "<br><br><center><h2><u><b>"
Data "ENC28J60 I/O-Webserver - Buzzer, Relais und Eing&auml;nge"
Data "</b></u></h2><br><br><table bgcolor=" , &H22 , "#D7D5D5" , &H22 , "><tr>"
Data "<td align=" , &H22 , "center" , &H22 , "><br>"
Data "<a href=" , &H22 , "/index.html" , &H22 , "><b>Zur Startseite</b></a>"
Data "<br><hr>"

#if Usebuzzer = 1
   Data "<u><b>Buzzer</b></u><br><br>"
   Data "--BUZ---"
   Data "<br><hr>"
#endif

#if Userelais = 1
   Data "<u><b>Relais</b></u><br><br>"
   Data "RELAIS1 = "
   Data "--REL1--"
   Data "<br>RELAIS2 = "
   Data "--REL2--"
   Data "<br>RELAIS3 = "
   Data "--REL3--"
   Data "<br>RELAIS4 = "
   Data "--REL4--"
   Data "<br><hr>"
#endif

#if Useinput = 1
   Data "<u><b>Digitale Eing&auml;nge (Optokoppler)</b></u><br><br>"
   Data "EINGANG1 = "
   Data "---OK1--"
   Data "<br>EINGANG2 = "
   Data "---OK2--"
   Data "<br>EINGANG3 = "
   Data "---OK3--"
   Data "<br>EINGANG4 = "
   Data "---OK4--"
   Data "<br><hr>"
#endif

Data "<u><b>Analoge Eing&auml;nge (ADC)</b></u><br><br>"
Data "ADC1 = "
Data "--ADC1--"
Data "<br>ADC2 = "
Data "--ADC2--"
Data "<br>ADC3 = "
Data "--ADC3--"
Data "<br>ADC4 = "
Data "--ADC4--"
Data "<br><hr>"
Data "sizeused"
Data "<br><hr>"
Data "date    "
Data " - "
Data "time    "
Data "<br><hr>"
Data "copyleft"
Data "<br>&nbsp;</td></tr></table></center></font></body></html>"
Data "endblock"

#if Uselcd = 1 And Uselcdweb = 1
   Lcd_html:
   Data "HTTP/1.0 200 OK" , &H0D , &H0A , &H0D , &H0A
   Data "<html><head><meta http-equiv=" , &H22
   Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
   Data "<title>ENC28J60 I/O Webserver - LCD-Modul</title></head>"
   Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , "><br><br>"
   Data "<font face=" , &H22 , "verdana" , &H22 , ">"
   Data "<center><h2><u><b>ENC28J60 I/O-Webserver - LCD-Modul</b></u></h2><br><br>"
   Data "<table bgcolor=" , &H22 , "#D7D5D5" , &H22 , "><tr>"
   Data "<td align=" , &H22 , "center" , &H22 , "><br>"
   Data "<a href=" , &H22 , "/index.html" , &H22 , "><b>Zur Startseite</b></a>"
   Data "<br><hr><table align=" , &H22 , "center" , &H22 , " border=" , &H22 , "1" , &H22 , ">"
   Data "<tr><td align=" , &H22 , "left" , &H22 , "><b>"
   Data "-LCDZ1--"
   Data "<br>"
   Data "-LCDZ2--"
   Data "</b></td></tr></table><hr><br>"
   Data "<form action=" , &H22 , "/" , &H22 , " method=" , &H22 , "GET" , &H22 , ">"
   Data "1. Zeile: <input type=" , &H22 , "text" , &H22 , " name=" , &H22 , "LCD1" , &H22 , "maxlength="
   Data &H22 , "16" , &H22 , " size=" , &H22 , "20" , &H22 , "><br><br>"
   Data "2. Zeile: <input type=" , &H22 , "text" , &H22 , " name=" , &H22 , "LCD2" , &H22 , "maxlength="
   Data &H22 , "16" , &H22 , " size=" , &H22 , "20" , &H22 , "><br><br>"
   Data "<input type=" , &H22 , "submit" , &H22 , " value=" , &H22 , "absenden" , &H22 , "></form>"
   Data "<hr>"
   Data "sizeused"
   Data "<br><hr>"
   Data "date    "
   Data " - "
   Data "time    "
   Data "<br><hr>"
   Data "copyleft"
   Data "<br>&nbsp;</td></tr></table></center></font></body></html>"
   Data "endblock"
#endif

Impressum_html:
Data "HTTP/1.0 200 OK" , &H0D , &H0A , &H0D , &H0A
Data "<html><head><meta http-equiv=" , &H22
Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
Data "<title>ENC28J60 I/O Webserver - Impressum</title></head>"
Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , "><br><br>"
Data "<font face=" , &H22 , "verdana" , &H22 , ">"
Data "<center><h2><u><b>ENC28J60 I/O-Webserver - Impressum</b></u></h2>"
Data "<br><br><table bgcolor=" , &H22 , "#D7D5D5" , &H22 , "><tr>"
Data "<td align=" , &H22 , "center" , &H22 , "><br>"
Data "<a href=" , &H22 , "/index.html" , &H22 , "><b>Zur Startseite</b></a>"
Data "<br><hr><br>"
Data "Diese Webseite, dieser Webserver wird betrieben von:<br><br>"
Data "Thomas Heldt<br>"
Data "Schulstra&szlig;e 13<br>"
Data "D-76307 Karlsbad<br>"
Data "<br>Es handelt sich um eine private Demonstrationsseite."
Data "<br><br><hr>"
Data "sizeused"
Data "<br><hr>"
Data "date    "
Data " - "
Data "time    "
Data "<br><hr>"
Data "copyleft"
Data "<br>&nbsp;</td></tr></table></center></font></body></html>"
Data "endblock"

Stats_html:
Data "HTTP/1.0 200 OK" , &H0D , &H0A , &H0D , &H0A
Data "<html><head><meta http-equiv=" , &H22
Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
Data "<title>ENC28J60 I/O Webserver - System-Informationen</title></head>"
Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , "><br><br>"
Data "<font face=" , &H22 , "verdana" , &H22 , ">"
Data "<center><h2><u><b>ENC28J60 I/O-Webserver - System-Informationen</b></u></h2>"
Data "<br><br><table bgcolor=" , &H22 , "#D7D5D5" , &H22 , "><tr>"
Data "<td align=" , &H22 , "center" , &H22 , "><br>"
Data "<a href=" , &H22 , "/index.html" , &H22 , "><b>Zur Startseite</b></a>"
Data "<br><hr><br>"
Data "<b>Mikrocontroller</b><br><br>"
Data "-MCTYPE-"
Data "<br><br><hr><br>"
Data "<b>Programmversion</b><br><br>"
Data "PVERSION"
Data "<br><br><hr><br><b>Module</b><br><br>"
Data "BUZSTAT?"
Data "<br>"
Data "RELSTAT?"
Data "<br>"
Data "EINSTAT?"
Data "<br>"
Data "BTMSTAT?"
Data "<br>"
Data "LCDSTAT?"
Data "<br><br><hr>"
Data "sizeused"
Data "<br><hr>"
Data "date    "
Data " - "
Data "time    "
Data "<br><hr>"
Data "copyleft"
Data "<br>&nbsp;</td></tr></table></center></font></body></html>"
Data "endblock"

Notfound_page:
Data "HTTP/1.0 404 Not Found" , &H0D , &H0A , &H0D , &H0A
Data "<html><head><meta http-equiv=" , &H22
Data "Pragma" , &H22 , " Content=" , &H22 , "no cache" , &H22 , ">"
Data "<title>ENC28J60 I/O Webserver - Seite nicht vorhanden</title></head>"
Data "<body bgcolor=" , &H22 , "#FBF9F9" , &H22 , "><center><br><br>"
Data "<font face=" , &H22 , "verdana" , &H22 , ">"
Data "<h2><u><b>ENC28J60 I/O-Webserver</b></u></h2><hr>"
Data "<br><b>Die angeforderte Seite ist nicht vorhanden!</b><br><br>"
Data "Klicken sie <a href=" , &H22 , "/index.html" , &H22 , "><b>hier</b></a>"
Data " um auf die Startseite zu gelangen.</center>"
Data "</font></body></html>"
Data "endblock"