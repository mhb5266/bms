' ENC28J60 Control Registers
' Control register definitions are a combination of address,
' bank number, and Ethernet/MAC/PHY indicator bits.
' - Register address (bits 0-4)
' - Bank number  (bits 7-6)
' - MAC/PHY indicator (bit 5)

'All-bank registers
Const Eie = &H1B
Const Eir = &H1C
Const Estat = &H1D
Const Econ2 = &H1E
Const Econ1 = &H1F

'for bank selection
Const Bank0 = &B00_000000
Const Bank1 = &B01_000000
Const Bank2 = &B10_000000
Const Bank3 = &B11_000000

'MAC/PHY indicator
Const Macphy = &B00_1_00000

'Bank 0 registers
Const Erdptl = &H00 Or Bank0
Const Erdpth = &H01 Or Bank0
Const Ewrptl = &H02 Or Bank0
Const Ewrpth = &H03 Or Bank0
Const Etxstl = &H04 Or Bank0
Const Etxsth = &H05 Or Bank0
Const Etxndl = &H06 Or Bank0
Const Etxndh = &H07 Or Bank0
Const Erxstl = &H08 Or Bank0
Const Erxsth = &H09 Or Bank0
Const Erxndl = &H0A Or Bank0
Const Erxndh = &H0B Or Bank0
Const Erxrdptl = &H0C Or Bank0
Const Erxrdpth = &H0D Or Bank0
Const Erxwrptl = &H0E Or Bank0
Const Erxwrpth = &H0F Or Bank0
Const Edmastl = &H10 Or Bank0
Const Edmasth = &H11 Or Bank0
Const Edmandl = &H12 Or Bank0
Const Edmandh = &H13 Or Bank0
Const Edmadstl = &H14 Or Bank0
Const Edmadsth = &H15 Or Bank0
Const Edmacsl = &H16 Or Bank0
Const Edmacsh = &H17 Or Bank0

' Bank 1 registers
Const Eht0 = &H00 Or Bank1
Const Eht1 = &H01 Or Bank1
Const Eht2 = &H02 Or Bank1
Const Eht3 = &H03 Or Bank1
Const Eht4 = &H04 Or Bank1
Const Eht5 = &H05 Or Bank1
Const Eht6 = &H06 Or Bank1
Const Eht7 = &H07 Or Bank1
Const Epmm0 = &H08 Or Bank1
Const Epmm1 = &H09 Or Bank1
Const Epmm2 = &H0A Or Bank1
Const Epmm3 = &H0B Or Bank1
Const Epmm4 = &H0C Or Bank1
Const Epmm5 = &H0D Or Bank1
Const Epmm6 = &H0E Or Bank1
Const Epmm7 = &H0F Or Bank1
Const Epmcsl = &H10 Or Bank1
Const Epmcsh = &H11 Or Bank1
Const Epmol = &H14 Or Bank1
Const Epmoh = &H15 Or Bank1
Const Ewolie = &H16 Or Bank1
Const Ewolir = &H17 Or Bank1
Const Erxfcon = &H18 Or Bank1
Const Epktcnt = &H19 Or Bank1

' Bank 2 registers
Const Macon1 = &H00 Or Bank2 Or Macphy
Const Macon2 = &H01 Or Bank2 Or Macphy
Const Macon3 = &H02 Or Bank2 Or Macphy
Const Macon4 = &H03 Or Bank2 Or Macphy
Const Mabbipg = &H04 Or Bank2 Or Macphy
Const Maipgl = &H06 Or Bank2 Or Macphy
Const Maipgh = &H07 Or Bank2 Or Macphy
Const Maclcon1 = &H08 Or Bank2 Or Macphy
Const Maclcon2 = &H09 Or Bank2 Or Macphy
Const Mamxfll = &H0A Or Bank2 Or Macphy
Const Mamxflh = &H0B Or Bank2 Or Macphy
Const Maphsup = &H0D Or Bank2 Or Macphy
Const Micon = &H11 Or Bank2 Or Macphy
Const Micmd = &H12 Or Bank2 Or Macphy
Const Miregadr = &H14 Or Bank2 Or Macphy
Const Miwrl = &H16 Or Bank2 Or Macphy
Const Miwrh = &H17 Or Bank2 Or Macphy
Const Mirdl = &H18 Or Bank2 Or Macphy
Const Mirdh = &H19 Or Bank2 Or Macphy

' Bank 3 registers
Const Maadr1 = &H00 Or Bank3 Or Macphy
Const Maadr0 = &H01 Or Bank3 Or Macphy
Const Maadr3 = &H02 Or Bank3 Or Macphy
Const Maadr2 = &H03 Or Bank3 Or Macphy
Const Maadr5 = &H04 Or Bank3 Or Macphy
Const Maadr4 = &H05 Or Bank3 Or Macphy
Const Ebstsd = &H06 Or Bank3
Const Ebstcon = &H07 Or Bank3
Const Ebstcsl = &H08 Or Bank3
Const Ebstcsh = &H09 Or Bank3
Const Mistat = &H0A Or Bank3 Or Macphy                      'checken of goed is
Const Erevid = &H12 Or Bank3
Const Ecocon = &H15 Or Bank3
Const Eflocon = &H17 Or Bank3
Const Epausl = &H18 Or Bank3
Const Epaush = &H19 Or Bank3

' PHY registers
Const Phcon1 = &H00
Const Phstat1 = &H01
Const Phhid1 = &H02
Const Phhid2 = &H03
Const Phcon2 = &H10
Const Phstat2 = &H11
Const Phie = &H12
Const Phir = &H13
Const Phlcon = &H14


' ENC28J60 EIR Register Bit Definitions
'--
Const Eir_pktif = 6
Const Eir_dmaif = 5
Const Eir_linkif = 4
Const Eir_txif = 3
Const Eir_wolif = 2
Const Eir_txerif = 1
Const Eir_rxerif = 0

' ENC28J60 ESTAT Register Bit Definitions
Const Estat_int = 7
'Const Estat_bufer = 6
'--
Const Estat_latecol = 4
'--
Const Estat_rxbusy = 2
Const Estat_txabrt = 1
Const Estat_clkrdy = 0


' ENC28J60 EIE Register Bit Definitions
Const Eie_intie = 7
Const Eie_pktie = 6
Const Eie_dmaie = 5
Const Eie_linkie = 4
Const Eie_txie = 3
Const Eie_wolie = 2
Const Eie_txerie = 1
Const Eie_rxerie = 0


' ENC28J60 ECON2 Register Bit Definitions
Const Econ2_autoinc = 7
Const Econ2_pktdec = 6
Const Econ2_pwrsv = 5
'--
Const Econ2_vrps = 3
'--
'--
'--

' ENC28J60 ECON1 Register Bit Definitions
Const Econ1_txrst = 7
Const Econ1_rxrst = 6
Const Econ1_dmast = 5
Const Econ1_csumen = 4
Const Econ1_txrts = 3
Const Econ1_rxen = 2
Const Econ1_bsel1 = 1
Const Econ1_bsel0 = 0

' ENC28J60 MACON1 Register Bit Definitions
Const Macon1_loopbk = 4                                     '?? reserved (&H10)
Const Macon1_txpaus = 3
Const Macon1_rxpaus = 2
Const Macon1_passall = 1
Const Macon1_marxen = 0

' ENC28J60 MACON2 Register Bit Definitions
Const Macon2_marst = 7
Const Macon2_rndrst = 6
'--
'--
Const Macon2_marxrst = 4
Const Macon2_rfunrst = 2
Const Macon2_matxrst = 1
Const Macon2_tfunrst = 0

' ENC28J60 MACON3 Register Bit Definitions
Const Macon3_padcfg2 = 7
Const Macon3_padcfg1 = 6
Const Macon3_padcfg0 = 5
Const Macon3_txcrcen = 4
Const Macon3_phdrlen = 3
Const Macon3_hfrmlen = 2
Const Macon3_frmlnen = 1
Const Macon3_fuldpx = 0

' ENC28J60 MICMD Register Bit Definitions
Const Micmd_miiscan = 1
Const Micmd_miird = 0

' ENC28J60 MISTAT Register Bit Definitions
Const Mistat_nvalid = 2
Const Mistat_scan = 1
Const Mistat_busy = 0

' ENC28J60 PHY PHCON1 Register Bit Definitions
Const Phcon1_prst = &H8000
Const Phcon1_ploopbk = &H4000
Const Phcon1_ppwrsv = &H0800
Const Phcon1_pdpxmd = &H0100

' ENC28J60 PHY PHSTAT1 Register Bit Definitions
Const Phstat1_pfdpx = &H1000
Const Phstat1_phdpx = &H0800
Const Phstat1_llstat = &H0004
Const Phstat1_jbstat = &H0002

' ENC28J60 PHY PHCON2 Register Bit Definitions
Const Phcon2_frclink = &H4000
Const Phcon2_txdis = &H2000
Const Phcon2_jabber = &H0400
Const Phcon2_hdldis = &H0100

' ENC28J60 Packet Control Byte Bit Definitions
Const Pktctrl_phugeen = 3
Const Pktctrl_ppaden = 2
Const Pktctrl_pcrcen = 1
Const Pktctrl_poverride = 0

' SPI operation codes
'Const Enc28j60_read_ctrl_reg = &H00
Const Enc28j60_read_buf_mem = &H3A
'Const Enc28j60_write_ctrl_reg = &H40
Const Enc28j60_write_buf_mem = &H7A
'Const Enc28j60_bit_field_set = &H80
'Const Enc28j60_bit_field_clr = &HA0
Const Enc28j60_soft_reset = &HFF

' buffer boundaries applied to internal 8K ram
' entire available packet buffer space is allocated

Const Txstart_init = &H0000                                 ' start TX buffer at 0
Const Rxstart_init = &H1A19                                 ' give TX buffer space for one full ethernet frame (~1500 bytes)

Const Rxstop_init = &H1FF0                                  ' receive buffer gets the rest

'ENC28J60 ETHERNET RECEIVE FILTER CONTROL REGISTER

Const Erxfcon_ucen = 7                                      'default 1 - Unicast Filter Enable bit
Const Erxfcon_andor = 6                                     'default 0
Const Erxfcon_crcen = 5                                     'default 1
Const Erxfcon_pmen = 4                                      'default 0 - Pattern Match Filter Enable bit
Const Erxfcon_mpen = 3                                      'default 0 - Magic Packet Filter Enable bit
Const Erxfcon_hten = 2                                      'default 0 - Hash Table Filter Enable bit
Const Erxfcon_mcen = 1                                      'default 0 - Multicast Filter Enable bit
Const Erxfcon_bcen = 0                                      'default 1 - Broadcast Filter Enable bit
