// Microchip ENC28J60 Ethernet Interface Driver
// Author: Pascal Stang
// Modified by: Guido Socher
// Modified and optimized for CodeVisionAVR V3.35+ by:
// Pavel Haiduc, HP InfoTech S.R.L. http://www.hpinfotech.ro
// License: GPL V2
//
// This driver provides initialization and transmit/receive
// functions for the Microchip ENC28J60 10Mb Ethernet Controller and PHY.
// This chip is novel in that it is a full MAC+PHY interface all in a 28-pin
// chip, using an SPI interface to the host processor.

#ifndef ENC28J60_H
#define ENC28J60_H

#include <stdint.h>
#include <stdbool.h>

// Buffer boundaries applied to internal 8K ram
// The entire available packet buffer space is allocated

#define RXSTART_INIT        0x0000  // start of RX buffer, (must be zero, Rev. B4 Errata point 5)
#define RXSTOP_INIT         0x0BFF  // end of RX buffer, room for 2 packets
 
#define TXSTART_INIT        0x0C00  // start of TX buffer, room for 1 packet
#define TXSTOP_INIT         0x11FF  // end of TX buffer

#define SCRATCH_START       0x1200  // start of scratch area
#define SCRATCH_LIMIT       0x2000  // past end of area, i.e. 3 Kb
#define SCRATCH_PAGE_SHIFT  6       // addressing is in pages of 64 bytes
#define SCRATCH_PAGE_SIZE   (1 << SCRATCH_PAGE_SHIFT)
#define SCRATCH_PAGE_NUM    ((SCRATCH_LIMIT-SCRATCH_START) >> SCRATCH_PAGE_SHIFT)
#define SCRATCH_MAP_SIZE    (((SCRATCH_PAGE_NUM % 8) == 0) ? (SCRATCH_PAGE_NUM / 8) : (SCRATCH_PAGE_NUM/8+1))

// Area in the ENC28J60 memory that can be used via enc_malloc; 
// by default 0 bytes; decrease SCRATCH_LIMIT in order
// to use this functionality
#define ENC_HEAP_START      SCRATCH_LIMIT
#define ENC_HEAP_END        0x2000

extern uint8_t enc28j60_buffer[]; // Data buffer (shared by recieve and transmit)

// These functions provide low-level interfacing with the ENC28J60 network interface. This is used by the EtherCard class and not intended for use by (normal) end users.
// pointer to the start of TCP payload
#define enc28j60_tcpOffset() (enc28j60_buffer + 0x36)

//*****************************************************************************
// Initializes the SPI interface
//*****************************************************************************
void enc28j60_initSPI(void);

//*****************************************************************************
// Initializes the network interface
// size - size of data buffer
// macaddr - pointer to 6 byte hardware (MAC) address
// Returns: ENC28J60 firmware version or zero on failure.
//*****************************************************************************
uint8_t enc28j60_init(uint16_t size, uint8_t* macaddr);

//*****************************************************************************
// Resets and fully initializes the ENC28J60
// Returns: byte 0 on failure, 1 on success.
//*****************************************************************************
uint8_t enc28j60_doBIST(void);

//*****************************************************************************
// Reserves a block of RAM in the memory of the ENC28J60 chip
// size - number of bytes to reserve
// Returns: unsigned int start address of the block within the ENC28J60 memory. 
// 0 if the remaining memory for the allocation operation is less than size.   
// Note: There is no enc_free(), i.e., reserved blocks stay reserved for the duration of the program. 
// Note: The total memory available for malloc-operations is determined by 
// ENC_HEAP_END-ENC_HEAP_START, defined in enc28j60.h
//*****************************************************************************
uint16_t enc28j60_memAlloc(uint16_t size);

//*****************************************************************************
// Returns the amount of memory [bytes] within the ENC28J60 chip 
// that is still available for enc28j60_memAlloc.
//*****************************************************************************
uint16_t enc28j60_freeMem(void);

//*****************************************************************************
// Copies a block of data from RAM to the ENC28J60 memory
// dest -  destination address within ENC28J60 memory
// source - source pointer to a block of RAM
// num - number of bytes to copy
//*****************************************************************************
void enc28j60_memCopyTo(uint16_t dest, void *source, int16_t num);

//*****************************************************************************
// Copies a block of data from the ENC28J60 memory to RAM
// dest - destination address within RAM
// source - source address within ENC28J60 memory
// num - number of bytes to copy
//*****************************************************************************
void enc28j60_memCopyFrom(void *dest, uint16_t source, int16_t num);

//*****************************************************************************
// Copies data from the ENC28J60 memory
// page - data page of memory
// data - pointer to buffer to copy data to
//*****************************************************************************
void enc28j60_copyOut(uint8_t page, uint8_t *data);

//*****************************************************************************
// Copies data to the ENC28J60 memory
// page - data page of memory
// data - pointer to buffer to copy data from
//*****************************************************************************
void enc28j60_copyIn(uint8_t page, uint8_t *data);

//*****************************************************************************
// Reads a single byte of data from ENC28J60 memory
// page - data page of memory
// off - offset of data within page
// Returns: data value
//*****************************************************************************
uint8_t enc28j60_peekIn(uint8_t page, uint8_t off);

//*****************************************************************************
// Checks if the network link is connected
// Returns: bool true if link is up
//*****************************************************************************
bool enc28j60_isLinkUp(void);

//*****************************************************************************
// Puts the ENC28J60 in sleep mode
//*****************************************************************************
void enc28j60_powerDown(void);  // contrib by Alex M.

//*****************************************************************************
// Wakes the ENC28J60 from sleep mode
//*****************************************************************************
void enc28j60_powerUp(void);    // contrib by Alex M.

//*****************************************************************************
// Sends data to the network interface
// len - size of data to send
// Note: Data buffer is shared by receive and transmit functions
//*****************************************************************************
void enc28j60_packetSend(uint16_t len);

//*****************************************************************************
// Copies received packets to the data buffer
// Returns: unsigned int size of received data
// Note: The data buffer is shared by the receive and transmit functions
//*****************************************************************************
uint16_t enc28j60_packetReceive(void);

//*****************************************************************************
// Copies a slice from the current packet to RAM
// dest - pointer in RAM where the data is copied to
// maxLength - how many bytes to copy 
// packetOffset - where within the packet to start; 
// Returns: unsigned int the number of bytes that have been read
// Note: At the destination at least maxLength+1 bytes should be reserved 
// because the copied content will be 0-terminated. 
// Note: If less than maxLength bytes are available only the remaining 
// bytes are copied.
//****************************************************************************//                 
uint16_t enc28j60_readPacketSlice(char *dest, int16_t maxLength, int16_t packetOffset);

//*****************************************************************************
// Enables the reception of broadcast messages
// temporary - set true to temporarily enable broadcast
// Note: This will increase load on received data handling
//*****************************************************************************
void enc28j60_enableBroadcast(bool temporary);

//*****************************************************************************
// Disables the reception of broadcast messages
// temporary - set true to only disable if temporarily enabled
// Note: This will reduce load on received data handling
//*****************************************************************************
void enc28j60_disableBroadcast(bool temporary);

//*****************************************************************************
// Enables the reception of multicast messages
// Note: This will increase load on received data handling
//*****************************************************************************
void enc28j60_enableMulticast(void);
    
//*****************************************************************************
// Disables the reception of mulitcast messages
// Note: This will reduce load on received data handling
//*****************************************************************************
void enc28j60_disableMulticast(void);

//*****************************************************************************
// Enables the reception of all messages
// temporary - set true to temporarily enable promiscuous
// Note: This will significantly increase the load on received data handling
// Note: All messages will be accepted, even messages with destination MAC other than own
// Note: Messages with invalid CRC checksum will still be rejected
//*****************************************************************************
void enc28j60_enablePromiscuous(bool temporary);
    
//*****************************************************************************
// Disables the reception of all messages and goes back to default mode
// temporary - set true to only disable if temporarily enabled
// Note: This will reduce the load on received data handling
// Note: In this mode only unicast and broadcast messages will be received
//*****************************************************************************
void enc28j60_disablePromiscuous(bool temporary);


// Workaround for Errata 13.
// The transmission hardware may drop some packets because it thinks a late collision
// occurred (which should never happen if all cable length etc. are ok). If setting
// this to 1 these packages will be retried a fixed number of times. Costs about 150bytes
// of flash.
#define ETHERCARD_RETRY_LATECOLLISIONS 0

// Enable pipelining of packet transmissions.
// If enabled the packetSend function will not block/wait until the packet is actually
// transmitted; but instead this wait is shifted to the next time that packetSend is
// called. This gives higher performance; however in combination with 
// ETHERCARD_RETRY_LATECOLLISIONS this may lead to problems because a packet whose
// transmission fails because the ENC28J60 chip thinks that it is a late collision will
// not be retried until the next call to packetSend.
#define ETHERCARD_SEND_PIPELINING 0

#pragma library enc28j60.lib

#endif
