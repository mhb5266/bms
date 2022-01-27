//      EHTERSHIELD_H library for Arduino etherShield
//      Copyright (c) 2008 Xing Yu.  All right reserved. (this is LGPL v2.1)
//      It is however derived from the enc28j60 and ip code (which is GPL v2)
//      Author: Pascal Stang
//      Modified by: Guido Socher
//      DHCP code: Andrew Lindsay
//      Modified and optimized for CodeVisionAVR V3.35+ by:
//      Pavel Haiduc, HP InfoTech S.R.L. http://www.hpinfotech.ro
// License: GPL V2

#ifndef EtherCard_h
#define EtherCard_h

#include <io.h>
#include <stddef.h>
#include <enc28j60.h>
#include <net.h>

// Enable DHCP.
// Setting this to zero disables the use of DHCP; if a program uses DHCP it will
// still compile but the program will not work.
// Saves some RAM and FLASH memory.

#define ETHERCARD_DHCP 1

// Enable client connections.
// Setting this to zero means that the program cannot issue TCP client requests
// anymore. Compilation will still work but the request will never be
// issued. Saves some RAM and FLASH memory.

#define ETHERCARD_TCPCLIENT 1

// Enable TCP server functionality.
// Setting this to zero means that the program will not accept TCP client
// requests. Saves some RAM and FLASH memory.

#define ETHERCARD_TCPSERVER 1

// Enable UDP server functionality.
// If zero UDP server is disabled. It is
// still possible to register callbacks but these will never be called.
// Saves some RAM and FLASH memory.

#define ETHERCARD_UDPSERVER 1

// Enable automatic reply to pings.
// Setting to zero means that the program will not automatically answer to
// PINGs anymore. Also the callback that can be registered to answer incoming
// pings will not be called. Saves some RAM and FLASH memory.

#define ETHERCARD_ICMP 1

// Enable use of stash.
// Setting this to zero means that the stash mechanism cannot be used. Again
// compilation will still work but the program may behave very unexpectedly.
// Saves some RAM and FLASH memory.

#define ETHERCARD_STASH 1

//  This type definition defines the structure of a UDP server event handler callback funtion
typedef void (*UdpServerCallback)(
	uint16_t dest_port, // port the packet was sent to
	uint8_t *src_ip, // pointer to a 4 byte array that holds the IP address of the sender
	uint16_t src_port, // port the packet was sent from
	uint8_t *data, // pointer to a byte array that holds the UDP payload data
	uint16_t len); // length of the payload data

//  This type definition defines the structure of a DHCP Option callback function
typedef void (*DhcpOptionCallback)(
	uint8_t option, // the option number
	uint8_t *data, // pointer to a byte array that will hold the received DHCP option data
	uint8_t len); // length of the received DHCP option data

//  This structure describes the structure of memory used within the ENC28J60 network interface.
typedef struct
{
	uint8_t count; // Number of allocated blocks
	uint8_t first; // First allocated block
	uint8_t last;  // Last allocated block
} StashHeader;

typedef struct
{
	StashHeader;
	uint8_t curr; // Current block
	uint8_t offs; // Current data offset in block
} Stash;

typedef struct
{
	union
	{
		uint8_t bytes[64];
		uint16_t words[32];
		struct
			{
			StashHeader head; // StashHeader is only stored in first block
			uint8_t filler[59];
			uint8_t tail;     // only meaningful if bnum==last; number of bytes in last block
			uint8_t next;     // pointer to next block
			};
	};
	uint8_t bnum;
} StashBlock;

#define WRITEBUF 0 // Write buffer
#define READBUF  1 // Read buffer
#define BUFCOUNT 2 // # of buffers

extern StashBlock stash_bufs[BUFCOUNT];

// These functions provide access to the memory within the ENC28J60 network interface.

//*****************************************************************************
// Initializes the stash allocation map.
// Block 0 is special, so it's always occupied
//*****************************************************************************
void stash_initMap(void);

//*****************************************************************************
// Loads a block either into the write or into the read buffer.
// idx - specifies the buffer into which the block will be loaded:
//       = WRITEBUF (0) - write buffer
//       = READBUF (1) - read buffer
// blk - block number
//*****************************************************************************
void stash_load(uint8_t idx, uint8_t blk);

//*****************************************************************************
// Returns the number of free blocks in the stash map.
//*****************************************************************************
uint8_t stash_freeCount(void);

//*****************************************************************************
// Creates a new stash, making it the active stash.
// stash - pointer to a Stash structure that will hold the information
// for the stash to be created in the ENC28J60 buffer.
// Returns the first block as a handle - stash descriptor.
//*****************************************************************************
uint8_t stash_create(Stash *stash);

//*****************************************************************************
// Opens an existing stash, created with stash_create
// blk - stash descriptor previously returned by stash_create
// Copies the stash data from blk to a Stash structure, pointed by stash.
// Makes blk the current block.
// The StashHeader part of the structure only contains reasonable data
// for the first block (blk=0).
// Returns the current block.
//*****************************************************************************
uint8_t stash_open(Stash *stash, uint8_t blk);

//*****************************************************************************
// Saves the metadata of the current block into the first block 0.
// stash - pointer to a Stash structure that holds the information
// for the stash.
//*****************************************************************************
void stash_save(Stash *stash);

//*****************************************************************************
// Releases memory from the pool in the ENC28J60 buffer by following the
// linked list of stash  blocks and freeing each one of them.
// stash - pointer to a Stash structure that holds the information
// for the stash to be freed.
//*****************************************************************************
void stash_release(Stash *stash);

//*****************************************************************************
// Reads a byte from the stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash from which the data will be read.
// Returns non-zero data byte or 0 if there is no more data to be read.
//*****************************************************************************
uint8_t stash_get(Stash *stash);

//*****************************************************************************
// Writes a byte to the stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information 
// for the stash to which the data will be written
// c - data byte to be written to the stash memory pool.
//*****************************************************************************
void stash_put(Stash *stash, uint8_t c);
#define stash_write(stash,c) stash_put(stash,c)

//*****************************************************************************
// Writes a NULL terminated literal char string located in RAM to the
// stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
// str - pointer to the literal char string.
//*****************************************************************************
void stash_print(Stash *stash, uint8_t *str);

//*****************************************************************************
// Writes a NULL terminated literal char string located in FLASH to the
// stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
// str - pointer to the literal char string.
//*****************************************************************************
void stash_print_p(Stash *stash, flash uint8_t *str);

//*****************************************************************************
// Writes a NULL terminated literal char string located in RAM to the
// stash memory pool in the ENC28J60 buffer, appending CR/LF at the end.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
// str - pointer to the literal char string.
//*****************************************************************************
void stash_println(Stash *stash, uint8_t *str);

//*****************************************************************************
// Writes a NULL terminated literal char string located in FLASH to the
// stash memory pool in the ENC28J60 buffer, appending CR/LF at the end.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
// str - pointer to the literal char string.
//*****************************************************************************
void stash_println_p(Stash *stash, flash uint8_t *str);

//*****************************************************************************
// Writes a signed int value in decimal format as a NULL terminated char string
// to the stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
//*****************************************************************************
void stash_printInt(Stash *stash, int16_t value);

//*****************************************************************************
// Writes an unsigned int value in decimal format as a NULL terminated
// char string to the stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
//*****************************************************************************
void stash_printUInt(Stash *stash, uint16_t value);

//*****************************************************************************
// Writes a floating point value as a NULL terminated  char string to the
// stash memory pool in the ENC28J60 buffer.
// stash - pointer to a Stash structure that holds the information
// for the stash to which the data will be written.
// decimals - specifies the # of decimal digits after the '.'.
//*****************************************************************************
void stash_printFloat(Stash *stash, float value, uint8_t decimals);

//*****************************************************************************
// Writes the information contained in the fmt string and the arguments into 
// the special block 0.
// Block 0 is initially marked as allocated and never returned by stash_allocBlock

// fmt - pointer to the format literal char string located in FLASH.
// The followring format specifiers are supported:
//   $D - unsigned int
//   $S - char literal string located in RAM
//   $F - char literal string located in FLASH
//   $E - char literal string located in EEPROM
//   $H - stash descriptor returned from calling stash_create.
//*****************************************************************************
void stash_prepare(flash uint8_t *fmt, ...);

//*****************************************************************************
// Returns the size in bytes of the data stored in the stash memory pool
// in the ENC28J60 buffer, for the Stash pointed by the stash pointer.
//*****************************************************************************
uint16_t stash_size(Stash *stash);

//*****************************************************************************
// Returns the size in bytes of the current stash data stored in stash 
// memory pool in the ENC28J60 buffer after the stash_prepare function was 
// called.
//*****************************************************************************
uint16_t stash_length(void);

//*****************************************************************************
// Frees memory in the stash memory pool in the ENC28J60 buffer,
// which was allocated when the stash_prepare function was called.
//*****************************************************************************
void stash_cleanup(void);

//*****************************************************************************
// Reads current stash data stored in the stash memory pool in the ENC28J60 
// buffer by the stash_prepare function.
// offset - relative position to the start of stash data
// count - number of bytes to read
// buf - pointer to the buffer where the read data must be stored.
//*****************************************************************************
void stash_extract(uint16_t offset, uint16_t count, void *buf);

//*****************************************************************************
// These functions provide the main interface to a ENC28J60 based NIC.
// Note: All TCP/IP client (outgoing) connections are made from source
// port in range 2816-3071. Do not use these source ports for other purposes.
//*****************************************************************************
typedef struct
{
	uint8_t mymac[ETH_LEN];  // MAC address
	uint8_t myip[IP_LEN];    // IP address
	uint8_t netmask[IP_LEN]; // Netmask
	uint8_t broadcastip[IP_LEN]; // Subnet broadcast address
	uint8_t gwip[IP_LEN];   // Gateway
	uint8_t dhcpip[IP_LEN]; // DHCP server IP address
	uint8_t dnsip[IP_LEN];  // DNS server IP address
	uint8_t hisip[IP_LEN];  // DNS lookup result
	uint16_t hisport;  // TCP port to connect to (default 80)
	uint16_t delaycnt; // Counts number of cycles of ether_packetLoop when no packet received - used to trigger periodic gateway ARP request
	uint8_t using_dhcp: 1;  // True if using DHCP
	uint8_t persist_tcp_connection: 1; // False to break connections on first packet received
} EtherCard;

extern EtherCard ether;
extern volatile uint32_t _millis;

#define ether_buffer enc28j60_buffer

//*****************************************************************************
// Returns the number of ms elapsed since reset.
//*****************************************************************************
uint32_t ether_millis(void);

//*****************************************************************************
// This function must be called every 10ms by a timer overflow interrupt.
//*****************************************************************************
inline void ether_timerproc(void) {_millis += 10;}

//*****************************************************************************
// Initializes the network interface
// size - size of data buffer
// macaddr - pointer to a 6 byte array that holds the hardware address to
// be assigned to the network interface
// Returns: byte firmware version or zero on failure.
//*****************************************************************************
uint8_t ether_begin(uint16_t size, uint8_t *macaddr);

//*****************************************************************************
// Configures the network interface with IP
// my_ip - pointer to 4 byte array that holds the IP address. 0 for no change.
// gw_ip - pointer to 4 byte array that holds the gateway address. 0 for no change.
// dns_ip - pointer to 4 byte array that holds the DNS address. 0 for no change.
// mask - pointer to 4 byte array that holds the subnet mask. 0 for no change.
// Returns: bool true on success
//*****************************************************************************
bool ether_staticSetup(uint8_t *my_ip, uint8_t *gw_ip, uint8_t *dns_ip, uint8_t *mask);

// file: tcpip.lib

//*****************************************************************************
// Parses the received data
// plen - size of data to parse (e.g. return value of enc28j60_packetReceive()).
// Returns: unsigned int offset of TCP payload data in data buffer or zero
// if packet processed
// Note: Data buffer is shared by receive and transmit functions
// Note: Only handles ARP and IP
//*****************************************************************************
uint16_t ether_packetLoop(uint16_t plen);

//*****************************************************************************
// Returns a pointer to the start of the TCP payload
//*****************************************************************************
#define ether_tcpOffset() (enc28j60_buffer + 0x36)

//*****************************************************************************
// Accepts a TCP/IP connection
// port - IP port to accept on - does nothing if wrong port
// plen - number of bytes in packet
// Returns: unsigned int offset within packet of the TCP payload.
// Zero for no data.
//*****************************************************************************
uint16_t ether_accept(uint16_t port, uint16_t plen);

//*****************************************************************************
// Sends an UDP packet to the IP address of last processed received packet
// data - pointer to data payload
// datalen - size of data payload (max 508 bytes)
// port - source IP port
//*****************************************************************************
void ether_makeUdpReply(uint8_t *data, uint8_t datalen, uint16_t port);

//*****************************************************************************
// Sends a response to a HTTP request
// dlen - size of the HTTP (TCP) payload
//*****************************************************************************
void ether_httpServerReply (uint16_t dlen);

//*****************************************************************************
// Sends a response to a HTTP request with additional TCP flags
// dlen - size of the HTTP (TCP) payload
// flags - TCP flags (see net.h)
//*****************************************************************************
void ether_httpServerReply_with_flags(uint16_t dlen , uint8_t flags);

//*****************************************************************************
// Acknowledges a TCP message
//*****************************************************************************
void ether_httpServerReplyAck(void);

//*****************************************************************************
// Sets the gateway address
// gwipaddr - pointer to a 4 byte array that holds the gateway address
//*****************************************************************************
void ether_setGwIp (uint8_t *gwipaddr);

//*****************************************************************************
// Updates the broadcast address based on current IP address and subnet mask
//*****************************************************************************
void ether_updateBroadcastAddress(void);

//*****************************************************************************
// Checks if we got a gateway hardware address (ARP lookup)
// Returns: true if gateway found
//*****************************************************************************
bool ether_clientWaitingGw(void);

//*****************************************************************************
// Checks if we a got gateway DNS address (ARP lookup)
// Returns: true if DNS found
//*****************************************************************************
bool ether_clientWaitingDns(void);

//*****************************************************************************
// Prepares a TCP request
// result_cb - pointer to the callback function that handles the TCP result
// datafill_cb - pointer to the callback function that handles the data
// payload in response to the current TCP/IP request
// port - remote TCP/IP port to connect to
// Returns: byte ID of TCP/IP session (0-7)
// Note: The return value provides the id of the request,
// thus allowing up to 7 concurrent requests.
//*****************************************************************************
uint8_t ether_clientTcpReq(bool (*result_cb)(uint8_t, uint8_t, uint16_t, uint16_t),
						   uint16_t (*datafill_cb)(uint8_t), uint16_t port);

//*****************************************************************************
// Sends a TCP request
// Returns: byte ID of TCP/IP session (0-7)
// Note: The TCP payload must be prepared using the Stash functions.
//*****************************************************************************
uint8_t ether_tcpSend(void);

//*****************************************************************************
// Gets TCP reply
// session_id - byte ID of TCP/IP session (0-7)
// Returns: byte pointer to TCP reply payload. NULL if no data.
//*****************************************************************************
uint8_t *ether_tcpReply(uint8_t session_id);

//*****************************************************************************
// Configures TCP connections to be persistent or not
// persist - true to maintain TCP connection.
// false to finish TCP connection after first packet.
//*****************************************************************************
void ether_persistTcpConnection(bool persist);

//*****************************************************************************
// Returns the sequence number of the current TCP package
//*****************************************************************************
uint32_t ether_getSequenceNumber(void);

//*****************************************************************************
// Returns the payload length of the current TCP package
//*****************************************************************************
uint16_t ether_getTcpPayloadLength(void);

//*****************************************************************************
// Prepares a HTTP request
// urlbuf - pointer to null terminated literal char string that holds the URL folder
// urlbuf_varpart - pointer to null terminated literal char string that holds the URL file
// hoststr - pointer to null terminated literal char string that holds the hostname
// additionalheaderline - pointer to null terminated literal char string,
// located in FLASH, that holds the additional HTTP header information
// callback - pointer to the callback function that will handle the result
// (response) of the current request
// Note: Request sent in main packetloop
//*****************************************************************************
void ether_browseUrl(uint8_t *urlbuf, uint8_t *urlbuf_varpart, uint8_t *hoststr,
					 flash uint8_t *additionalheaderline,
					 void (*callback)(uint8_t, uint16_t, uint16_t));

//*****************************************************************************
// Prepares a HTTP post message
// urlbuf - pointer to null terminated literal char string that holds the URL folder
// hoststr - pointer to null terminated literal char string that holds the hostname
// additionalheaderline - pointer to null terminated literal char string,
// located in FLASH, that holds the additional HTTP header information
// postval - pointer to null terminated literal char string that holds
// the HTML Post value
// callback - pointer to the callback function that will handle the response
// Note: Request sent in main packetloop
//*****************************************************************************
void ether_httpPost(uint8_t *urlbuf, uint8_t *hoststr,
					flash uint8_t *additionalheaderline,
					uint8_t *postval,
					void (*callback)(uint8_t, uint16_t, uint16_t));

//*****************************************************************************
// Sends a network time protocol request
// ntpip - pointer to a 4 byte array that holds the IP address of the NTP server
// srcport - IP port to send from
//*****************************************************************************
void ether_ntpRequest(uint8_t *ntpip, uint8_t srcport);

//*****************************************************************************
// Processes a network time protocol response
// time - pointer to the unsigned long int variable that will hold the result
// dstport - destination port to expect response.
// Set to zero to accept on any port
// Returns: true on success
//*****************************************************************************
bool ether_ntpProcessAnswer(uint32_t *time, uint8_t dstport);

//*****************************************************************************
// Prepares an UDP message for transmission
// srcport - source port
// dip - pointer to a 4 byte array that holds the destination IP address
// dstport - destination port
//*****************************************************************************
void ether_udpPrepare(uint16_t srcport, uint8_t *dstip, uint16_t dstport);

//*****************************************************************************
// Transmits an UDP packet
// datalen - size of payload
//*****************************************************************************
void ether_udpTransmit(uint16_t datalen);

//*****************************************************************************
// Prepares an UDP message for transmission and sends it
// data - pointer to the byte array that holds the data to be sent
// datalen - size of payload (maximum 508 bytes)
// srcport - source port
// dstip - pointer to 4 byte array that holds the destination IP address
// dstport - destination port
//*****************************************************************************
void ether_sendUdp(uint8_t *data, uint8_t datalen, uint16_t srcport, uint8_t *dstip, uint16_t dstport);

//*****************************************************************************
// Registers the callback function to handle Ping events
// callback - pointer to the callback function for ICMP ECHO response handler
// (triggers when local host receives Ping response (pong))
//*****************************************************************************
void ether_registerPingCallback(void (*callback)(uint8_t *srcip));

//*****************************************************************************
// Sends a Ping
// dstip - pointer to 4 byte array that holds the destination IP address
//*****************************************************************************
void ether_clientIcmpRequest(uint8_t *dstip);

//*****************************************************************************
// Checks for Ping response
// ip_monitoredhost - pointer to a 4 byte array that holds the IP address of
// host to check
// Returns: true if we have a Ping response from the specified host
//*****************************************************************************
bool ether_packetLoopIcmpCheckReply(uint8_t *ip_monitoredhost);

//*****************************************************************************
// Sends a Wake On LAN message
// wolmac - pointer to a 6 byte array that holds the hardware (MAC) address
// of the host to send message to
//*****************************************************************************
void ether_sendWol(uint8_t *wolmac);

// file: udpserver.lib

//*****************************************************************************
// Registers the callback function used to handle incoming UDP events
// callback - pointer the function used to handle events
// port - port to listen on
//*****************************************************************************
void ether_udpServerListenOnPort(UdpServerCallback callback, uint16_t port);

//*****************************************************************************
// Pauses listening on UDP port
// port - port to pause listening
//*****************************************************************************
void ether_udpServerPauseListenOnPort(uint16_t port);

//*****************************************************************************
// Resumes listening on UDP port
// port - port to resume listening
//*****************************************************************************
void ether_udpServerResumeListenOnPort(uint16_t port);

//*****************************************************************************
// Checks if the UDP server is listening on any ports
// Returns: bool true if listening on any ports
// Note: called by TCP/IP, in ether_packetLoop
//*****************************************************************************
bool ether_udpServerListening(void);

//*****************************************************************************
// Passes a packet to the UDP Server
// Returns: true if the packet was processed
// Note: called by TCP/IP, in ether_packetLoop
//*****************************************************************************
bool ether_udpServerHasProcessedPacket(void);

// file: dhcp.lib

//*****************************************************************************
// Updates the DHCP state
// len - length of the received data packet
//*****************************************************************************
void ether_DhcpStateMachine(uint16_t len);

//*****************************************************************************
// Configures the network interface with DHCP
// hname - null terminated char string that holds the hostname to pass to
// the DHCP server
// Returns: true if DHCP successful
// Note: Blocks execution until DHCP is complete or timeouts after 60 seconds
//*****************************************************************************
bool ether_dhcpSetup(uint8_t *hname);

//*****************************************************************************
// Registers a callback function to be called when a specific DHCP option
// number is received from the DHCP server.
// option - the option number to request from the DHCP server
// callback - the function to be called when the option is received
//*****************************************************************************
void ether_dhcpAddOptionCallback(uint8_t option, DhcpOptionCallback callback);

// file: dns.lib

//*****************************************************************************
// Performs DNS lookup
// name - pointer to the null terminated char string that holds the host name
// to lookup
// Returns: true on success.
// Note: The result is stored in hisip member of the ether structure
//*****************************************************************************
bool ether_dnsLookup(uint8_t *name);

// file: webutil.lib

uint8_t toAsciiHex(uint8_t b);

//*****************************************************************************
// Copies an IP address
// dst - pointer to the 4 byte array that will hold the destination IP
// src - pointer to the 4 byte array that holds the source IP
// Note: There is no check of source or destination size.
// Ensure both are 4 bytes.
//*****************************************************************************
void ether_copyIp(uint8_t *dst, uint8_t *src);

//*****************************************************************************
// Copies a hardware MAC address
// dst - pointer to the 6 byte array that will hold the destination MAC address
// src - pointer to the 6 byte array that holds the source MAC address
// Note: There is no check of source or destination size.
// Ensure both are 6 bytes.
//*****************************************************************************
void ether_copyMac(uint8_t *dst, uint8_t *src);

//*****************************************************************************
// Outputs to the USART the IP address in dotted decimal format
// buf - pointer to 4 byte array that holds the IP address
// Note: Before calling this function, the USART must properly
// initialized for the desired communication parameters.
//*****************************************************************************
void ether_printIp(uint8_t *buf);

//*****************************************************************************
// Searches for a string of the form "key=value" in
// a string that looks like "q?xyz=abc&uvw=defgh HTTP/1.1\r\n".
// strbuf - pointer to the char buffer that will hold the returned value,
// null terminated
// str - pointer to the null terminated char string where the search
// will be performed
// maxlen - the declared size in bytes of strbuf
// key - pointer to the null terminated char string that contains the key
// to be searched.
// Returns: the length of the found value, excluding the null terminator,
// or 0 if not found.
//*****************************************************************************
uint8_t ether_findKeyVal(uint8_t *str, uint8_t *strbuf, uint8_t maxlen, uint8_t *key);

//*****************************************************************************
// Decodes an URL string
// e.g "hello%20joe" or "hello+joe" becomes "hello joe"
// urlbuf - pointer to the null terminated char string that holds the URL
// Note: urlbuf is modified
//*****************************************************************************
void ether_urlDecode(uint8_t *urlbuf);

//*****************************************************************************
// Encodes an URL, replacing illegal characters like ' '.
// str - pointer to the null terminated char string to encode
// urlbuf - pointer to a buffer that will contain the null terminated
// encoded URL char string.
// Note: There must be enough space in urlbuf.
// In the worst case it is 3 times the length of str.
//*****************************************************************************
void ether_urlEncode(uint8_t *str, uint8_t *urlbuf);

//*****************************************************************************
// Converts an IP address from dotted decimal formatted string to 4 bytes.
// bytestr - pointer to the 4 bytes array that will hold the IP address
// str - pointer to the null terminated char string to be parsed.
// Returns: byte 0 on success.
//*****************************************************************************
uint8_t ether_parseIp(uint8_t *bytestr, uint8_t *str);

//*****************************************************************************
// Converts a byte array to a human readable display string
// resultstr - pointer to a buffer that will hold the resulting null
// terminated char string
// bytestr - pointer to the byte array containing the address to convert
// len - length of the array (4 for IP address, 6 for hardware MAC address)
// separator - delimiter character (typically '.' for IP address and
// ':' for hardware MAC address)
// base - base for numerical representation (typically 10 for IP address and
// 16 for hardware MAC address).
//*****************************************************************************
void ether_makeNetStr(uint8_t *resultstr, uint8_t *bytestr, uint8_t len,
					  uint8_t separator, uint8_t base);

#pragma library ethercard.lib
#pragma library webutil.lib
#pragma library dhcp.lib
#pragma library tcpip.lib
#pragma library udpserver.lib
#pragma library dns.lib

#endif
