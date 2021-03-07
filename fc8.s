|
| FC8 compression by Steve Chamberlin, 2016
| Some concepts and code derived from liblzg by Marcus Geelnard, 2010
| 
| This software is provided 'as-is', without any express or implied
| warranty. In no event will the authors be held liable for any damages
| arising from the use of this software.
| 
| Permission is granted to anyone to use this software for any purpose,
| including commercial applications, and to alter it and redistribute it
| freely, subject to the following restrictions:
| 
| 1. The origin of this software must not be misrepresented; you must not
|    claim that you wrote the original software. If you use this software
|    in a product, an acknowledgment in the product documentation would
|    be appreciated but is not required.
| 
| 2. Altered source versions must be plainly marked as such, and must not
|    be misrepresented as being the original software.
| 
| 3. This notice may not be removed or altered from any source
|    distribution.

.global fc8_unpack

.set FC8_HEADER_SIZE, 8
.set FC8_DECODED_SIZE_OFFSET, 4

fc8_unpack:
	movem.l 4(%a7),%a0-%a1

	movem.l	d1-d7/a0-a6,-(sp)
	bra 	_Init_Decode

| lookup table for decoding the copy length-1 parameter
_FC8_LENGTH_DECODE_LUT:
	dc.b	2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
	dc.b	18,19,20,21,22,23,24,25,26,27,28,34,47,71,127,255

|-------------------------------------------------------------------------------
| _GetUINT32 - alignment independent reader for 32-bit integers
| a0 = in
| d6 = offset
| d7 = result
|-------------------------------------------------------------------------------
_GetUINT32:
	move.b	(a0,d6.w),d7
	asl.w	#8,d7
	move.b	1(a0,d6.w),d7
	swap	d7
	move.b	2(a0,d6.w),d7
	asl.w	#8,d7
	move.b	3(a0,d6.w),d7
	rts
	
_Init_Decode:
	| check magic ID
	cmp.b	#'F',(a0)
	bne	_fail
	cmp.b	#'C',1(a0)
	bne	_fail
	cmp.b	#'8',2(a0)
	bne	_fail
	cmp.b	#'_',3(a0)
	bne	_fail
	
	| check decoded size - enough space in the output buffer?
	moveq	#FC8_DECODED_SIZE_OFFSET,d6
	bsr.s	_GetUINT32
	cmp.l	d7,d1				
	bhi	_fail

	| advance a0 to start of compressed data
	lea		FC8_HEADER_SIZE(a0), a0

	| a5 = base of length decode lookup table
	|lea		_FC8_LENGTH_DECODE_LUT(pc),a5
	lea		-110(pc),a5	| fix PC offset manually after assembly
	
	| helpful constants
	move.l	#0x0000001F, d1
	move.l	#0x00000007, d2
	move.l	#0x00000001, d3
	move.l	#0x0000003F, d4	
	
	| Main decompression loop
_mainloop:
	move.b	(a0)+,d6			| d6 = next token
	bmi.s	_BR1_BR2			| BR1 and BR2 tokens have the high bit set
	
	btst	#6,d6				| check bit 6 to see if this is a BR0 or LIT token
	bne.s	_BR0

| LIT 00aaaaaa - copy literal string of aaaaaa+1 bytes from input to output	
_LIT:							
	move.l	a0,a4				| a4 = source ptr for copy
	and.w 	d4,d6				| AND with 0x3F, d6 = length-1 word for copy
	lea		1(a0,d6.w),a0		| advance a0 to the end of the literal string
	bra.s 	_nearLoop
	
| BR0 01baaaaa - copy b+3 bytes from output backref aaaaa to output
_BR0:								
	move.b	d6,d5
	and.l	d1,d5				| AND with 0x1F, d5 = offset for copy = (long)(t0 & 0x1F)
	beq		_done				| BR0 with 0 offset means EOF
	
	move.l	a1,a4
	sub.l	d5,a4				| a4 = source ptr for copy
	
	move.b	(a4)+,(a1)+		| copy 3 bytes, can't use move.w. or move.l because src and dest may overlap
	move.b	(a4)+,(a1)+
	move.b	(a4)+,(a1)+
	btst	#5,d6				| check b bit
	beq.s	_mainloop
	move.b	(a4)+,(a1)+		| copy 1 more byte
	bra.s	_mainloop
	
_BR1_BR2:
	btst	#6,d6				| check bit 6 to see if this is a BR1 or BR2 token
	bne.s	_BR2

| BR1 10bbbaaa'aaaaaaaa - copy bbb+3 bytes from output backref aaa'aaaaaaaa to output
_BR1:							
	move.b	d6,d5
	and.l	d2,d5				| AND with 0x07 
	lsl.l	#8,d5
	move.b	(a0)+,d5			| d5 = offset for copy = ((long)(t0 & 0x07) << 8) | t1
	lsr.b	#3,d6
	and.w	d2,d6				| AND with 0x07
	addq.w	#2,d6				| d6 = length-1 word for copy = ((word)(t0 >> 3) & 0x7) + 1
	bra.s 	_copyBackref

| BR2 11bbbbba'aaaaaaaa'aaaaaaaa - copy lookup_table[bbbbb] bytes from output backref a'aaaaaaaa'aaaaaaaa to output
_BR2:	
	move.b	d6,d5
	and.w	d3,d5				| AND with 0x01
	swap	d5
	move.w #0,d7
	move.w #0,d5
	move.b	(a0)+,d5			| d5 = offset for copy = ((long)(t0 & 0x01) << 16) | (t1 << 8) | t2
	move.b	(a0)+,d7			| d5 = offset for copy = ((long)(t0 & 0x01) << 16) | (t1 << 8) | t2
	
	lsl.w   #8,d5
	or.w    d7,d5
	lsr.b	#1,d6
	and.w	d1,d6				| AND with 0x1F
	move.b	(a5,d6.w),d6		| d6 = length-1 word for copy = ((word)(t0 >> 3) & 0x7) + 1

_copyBackref:
	move.l	a1,a4
	sub.l	d5,a4 		

_nearLoop:
	    move.b 	(a4)+,(a1)+
	    dbf 	d6,_nearLoop
	    bra		_mainloop

_fail:
	moveq	#0,d0				| result = 0
	bra		_exit	
	
_done:
	moveq	#1,d0				| result = 1
	
_exit:	
	movem.l	(sp)+,d1-d7/a0-a6
	rts
