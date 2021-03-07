/* gfx.c, GVRAM Graphical functions for drawing the main screen for the x68Launcher.
 Copyright (C) 2020  John Snowdon
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 7 march 2021 : gameblabla
 * - Added a few functions to deal with image loading with my own custom format (SIF, Simple Image Format).
 * - Changed the other functions as to be compatible with my image loader functions
*/

#include <dos.h>
#include <iocs.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>

#include "gfx.h"
#include "rgb.h"
#include "compression.h"

static int status, super;

uint8_t gfx_init(){
	// Initialise graphics to a set of configured defaults
	
	super = _dos_super(0);

	crt_last_mode = _iocs_crtmod(-1);
	
	_iocs_crtmod(GFX_CRT_MODE);
	
	_iocs_vpage(GFX_PAGE);
	
	_iocs_b_curoff();
	
	_iocs_g_clr_on();
	
	return 0;
}

uint8_t gfx_close(){
	// Release supervisor mode
	// return previous mode??
	
	// Release supervisor mode
	_dos_super(super);
	
	/* Restore original screen mode */
	_iocs_crtmod(crt_last_mode);
	
	/* Enable text cursor */
	_iocs_b_curon();
	return 0;
}

void gfx_Clear(){
	_iocs_b_curoff();
	_iocs_g_clr_on();
}



/* This is implemented in a way that doesn't require newlib as it can increase the executable size by 50kb ! */
BITMAP bitmap_load(const char* path)
{
	BITMAP bmp;
	int fd;
	char* mem = NULL;
	uint32_t fsz;
	
	fd = _dos_open (path, 0);
	
	// We determine the filesize this way by using the return value of _dos_seek
	fsz = _dos_seek (fd, 0, SEEK_END);
	
	_dos_seek (fd, 0, SEEK_SET);
	_dos_read (fd, (char*)&bmp.width, sizeof(uint16_t));
	_dos_read (fd, (char*)&bmp.height, sizeof(uint16_t));
	_dos_read (fd, (char*)&bmp.sprite_width, sizeof(uint16_t));
	_dos_read (fd, (char*)&bmp.sprite_height, sizeof(uint16_t));
	_dos_read (fd, (char*)&bmp.bytespp, sizeof(uint8_t));
	_dos_read (fd, (char*)&bmp.encoding, sizeof(uint8_t));
	
	// Jump right after the end of the header
	_dos_seek (fd, BITMAP_HEADER_SIZE, SEEK_SET);
	
	bmp.totalsize_pixel = (bmp.width * bmp.height) * bmp.bytespp;
	bmp.totalfilesz = fsz - BITMAP_HEADER_SIZE;
	
	switch(bmp.encoding)
	{
		default:
			bmp.pixels = malloc(bmp.totalfilesz);
			_dos_read (fd, (char*)bmp.pixels, bmp.totalsize_pixel);
		break;
		case 1:
			mem = malloc(bmp.totalfilesz);
			bmp.pixels = malloc(bmp.totalsize_pixel);
			_dos_read (fd, mem, bmp.totalfilesz);
			fc8_unpack(mem, bmp.pixels);
		break;
		case 2:
			mem = malloc(bmp.totalfilesz);
			bmp.pixels = malloc(bmp.totalsize_pixel);
			_dos_read (fd, mem, bmp.totalfilesz);
			lz4w_unpack(mem, bmp.pixels);
		break;
		case 3:
			mem = malloc(bmp.totalfilesz);
			bmp.pixels = malloc(bmp.totalsize_pixel);
			_dos_read (fd, mem, bmp.totalfilesz);
			nrv2s_unpack(mem, bmp.pixels);
		break;
			mem = malloc(bmp.totalfilesz);
			bmp.pixels = malloc(bmp.totalsize_pixel);
			_dos_read (fd, mem, bmp.totalfilesz);
			apl_unpack(mem, bmp.pixels);
		break;
	}
	
	if (mem)
	{
		free(mem);
	}

	_dos_close (fd);
	
	return bmp;
}


/* Load Picture directly to Video memory as to avoid copying twice */
void bitmap_load_directly(const char* path)
{
	BITMAP bmp;
	int fd;
	char* mem = NULL;
	uint32_t fsz;
	
	fd = _dos_open (path, 0);
	
	// We determine the filesize this way by using the return value of _dos_seek
	fsz = _dos_seek (fd, 0, SEEK_END);
	
	// Only get what we need and skip right to the end of the header after
	_dos_seek (fd, 9, SEEK_SET);
	_dos_read (fd, (char*)&bmp.encoding, sizeof(uint8_t));
	
	_dos_seek (fd, BITMAP_HEADER_SIZE, SEEK_SET);
	
	bmp.totalfilesz = fsz - BITMAP_HEADER_SIZE;
	
	switch(bmp.encoding)
	{
		default:
			_dos_read (fd, (char*)gvram, bmp.totalfilesz);
		break;
		case 1:
			mem = malloc(bmp.totalfilesz);
			_dos_read (fd, mem, bmp.totalfilesz);
			fc8_unpack(mem, gvram);
		break;
		case 2:
			mem = malloc(bmp.totalfilesz);
			_dos_read (fd, mem, bmp.totalfilesz);
			lz4w_unpack(mem, gvram);
		break;
		case 3:
			mem = malloc(bmp.totalfilesz);
			_dos_read (fd, mem, bmp.totalfilesz);
			nrv2s_unpack(mem, gvram);
		break;
			mem = malloc(bmp.totalfilesz);
			_dos_read (fd, mem, bmp.totalfilesz);
			apl_unpack(mem, gvram);
		break;
	}
	
	if (mem)
	{
		free(mem);
	}

	_dos_close (fd);
}

uint8_t gvramBitmap(short x, short y, BITMAP *bmpdata){
	// Load bitmap data into gvram at coords x,y
	// X or Y can be negative which starts the first X or Y
	// rows or columns of the bitmap offscreen - i.e. they are clipped
	//
	// Bitmaps wider or taller than the screen are UNSUPPORTED
	
	short row, col;			//  x and y position counters
	uint32_t start_addr;		// The first pixel
	short width_bytes;		// Number of bytes in one row of the image
	short skip_cols;			// Skip first or last pixels of a row if the image is partially offscreen
	short skip_bytes;
	short skip_rows;		// Skip this number of rows if the image is patially offscreen
	short total_rows	;		// Total number of rows to read in clip mode
	uint16_t *ptr;			// Pointer to current location in pixel buffer - 16bit aligned so we always start at a pixel, and not half a byte of the last one
	
	if (x < 0){
		// Negative values start offscreen at the left
		skip_cols = x;
	} else {
		if ((x + bmpdata->width) > GFX_COLS){
			// Positive values get clipped at the right
			skip_cols = x + bmpdata->width - GFX_COLS;
		} else {
			// Full width can fit on screen
			skip_cols = 0;
		}
	}
	
	if (y < 0){
		// Negative values start off the top of the screen
		skip_rows = y;
	} else {
		if ((y + bmpdata->height) > GFX_ROWS){
			// Positive values get clipped at the bottom of the screen
			skip_rows = y + bmpdata->height - GFX_ROWS;
		} else {
			// Full height can fit on screen
			skip_rows = 0;
		}
	}
	
	if ((skip_cols == 0) && (skip_rows == 0)){
		// Case 1 - bitmap fits entirely onscreen
		width_bytes = bmpdata->width * bmpdata->bytespp;
		
		// Get starting pixel address
		start_addr = gvramGetXYaddr(x, y);
		if (start_addr < 0){
			return -1;
		}
		// Set starting pixel address
		gvram = (uint16_t*) start_addr;
		
		// memcpy entire rows at a time
		ptr = (uint16_t*) bmpdata->pixels; // cast to 16bit 
		for(row = 0; row < bmpdata->height; row++){
			memcpy(gvram, ptr, width_bytes);
			
			// Go to next row in vram
			gvram += GFX_COLS;
			
			// Increment point
			ptr += bmpdata->width;
		}
		return 0;
		
	} else {
		
		// Case 2 - image is either vertically or horizontally partially offscreen		
		if (skip_cols < 0){
			x = x + abs(skip_cols);
		}
		if (skip_rows < 0){
			y = y + abs(skip_rows);
		}
		
		// Get starting pixel address - at the new coordinates
		start_addr = gvramGetXYaddr(x, y);
		if (start_addr < 0){
			return -1;
		}
		// Set starting pixel address
		gvram = (uint16_t*) start_addr;
		
		// Set starting point in pixel buffer
		ptr = (uint16_t*) bmpdata->pixels; // cast to 16bit
		
		// Default to writing a full row of pixels, unless....
		width_bytes = (bmpdata->width * bmpdata->bytespp) ;
		
		// Default to writing all rows, unless....
		total_rows = bmpdata->height;
		
		// If we are starting offscreen at the y axis, jump that many rows into the data
		if (skip_rows < 0){
			ptr += abs(skip_rows) * bmpdata->width;// * bmpdata->bytespp;
			total_rows = bmpdata->height - abs(skip_rows);
		}
		if (skip_rows > 0){
			total_rows = bmpdata->height - abs(skip_rows);
		}
	
		if (skip_cols != 0){
			width_bytes = (bmpdata->width * bmpdata->bytespp) - (abs(skip_cols) * bmpdata->bytespp);
		}
		
		// memcpy entire rows at a time, subject to clipping sizes
		for(row = 0; row < total_rows; row++){
			if (skip_cols < 0){
				memcpy(gvram, ptr + abs(skip_cols), width_bytes);
			} else {
				memcpy(gvram, ptr, width_bytes);
			}
			// Go to next row in vram
			gvram += GFX_COLS;
			// Increment pointer to next row in pixel buffer
			ptr += bmpdata->width;
		}
		return 0;
	}
	
	return -1;
} 

uint8_t gvramBox(short x1, short y1, short x2, short y2, uint16_t grbi){
	// Draw a box outline with a given grbi colour
	short row, col;		//  x and y position counters
	uint32_t start_addr;	// The first pixel, at x1,y1
	short temp;		// Holds either x or y, if we need to flip them
	short step;
	
	// Flip y, if it is supplied reversed
	if (y1>y2){
		temp=y1;
		y1=y2;
		y2=temp;
	}
	// Flip x, if it is supplied reversed
	if (x1>x2){
		temp=x1;
		x1=x2;
		x2=temp;
	}
	// Clip the x range to the edge of the screen
	if (x2>GFX_COLS){
		x2 = GFX_COLS - 1;
	}
	// Clip the y range to the bottom of the screen
	if (y2>GFX_ROWS){
		y2 = GFX_ROWS - 1;
	}
	// Get starting pixel address
	start_addr = gvramGetXYaddr(x1, y1);
	if (start_addr < 0){
		return -1;
	}
	// Set starting pixel address
	gvram = (uint16_t*) start_addr;
	
	// Step to next row in vram
	step = (GFX_COLS - x2) + x1;
	
	// Draw top
	for(col = x1; col <= x2; col++){
		*gvram = grbi;
		// Move to next pixel in line
		gvram++;
	}
	// Jump to next line down and start of left side
	gvram += (GFX_COLS - x2) + (x1 - 1);
	
	// Draw sides
	for(row = y1; row < (y2-1); row++){	
		*gvram = grbi;
		gvram += (x2 - x1);
		*gvram = grbi;
		gvram += step;
	}
	
	// Draw bottom
	for(col = x1; col <= x2; col++){
		*gvram = grbi;
		// Move to next pixel in line
		gvram++;
	}
	
	return 0;
}

uint8_t gvramBoxFill(short x1, short y1, short x2, short y2, uint16_t grbi){
	// Draw a box, fill it with a given grbi colour
	short row, col;		//  x and y position counters
	uint32_t start_addr;	// The first pixel, at x1,y1
	short temp;		// Holds either x or y, if we need to flip them
	short step;
	
	// Flip y, if it is supplied reversed
	if (y1>y2){
		temp=y1;
		y1=y2;
		y2=temp;
	}
	// Flip x, if it is supplied reversed
	if (x1>x2){
		temp=x1;
		x1=x2;
		x2=temp;
	}
	// Clip the x range to the edge of the screen
	if (x2>GFX_COLS){
		x2 = GFX_COLS - 1;
	}
	// Clip the y range to the bottom of the screen
	if (y2>GFX_ROWS){
		y2 = GFX_ROWS - 1;
	}
	// Get starting pixel address
	start_addr = gvramGetXYaddr(x1, y1);
	if (start_addr < 0){
		return -1;
	}
	// Set starting pixel address
	gvram = (uint16_t*) start_addr;
	
	// Step to next row in vram
	step = (GFX_COLS - x2) + (x1 - 1);
	
	// Starting from the first row (y1)
	for(row = y1; row <= y2; row++){
		// Starting from the first column (x1)
		for(col = x1; col <= x2; col++){
			*gvram = grbi;
			gvram++;
		}
		gvram += step;
	}
	return 0;
}

uint32_t gvramGetXYaddr(short x, short y){
	// Return the memory address of an X,Y screen coordinate based on the GFX_COLS and GFX_ROWS
	// as defined in gfx.h - if you define a different screen mode dynamically, this WILL NOT WORK
	
	uint32_t addr;
	uint16_t row;
	
	addr = GVRAM_START;
	addr += GFX_ROW_SIZE * y;
	addr += (x * GFX_PIXEL_SIZE);
	
	if (addr>GVRAM_END){
		return -1;
	}
	return addr;
}

uint8_t gvramPoint(short x, short y, uint16_t grbi){
	// Draw a single pixel, in a given colour at the point x,y	
	
	// Get starting pixel address
	gvram = (uint16_t*) gvramGetXYaddr(x, y);
	if (gvram < 0){
		return -1;
	}
	*gvram = grbi;
	return 0;
}

uint8_t gvramScreenCopy(short x1, short y1, short x2, short y2, short x3, short y3){
	// Copy a block of GVRAM to another area of the screen
	// x1,y1, x2,x2	source bounding box
	// x3,y3			destination coordinates
	
	uint16_t	row;			// Row counter
	uint16_t	col;			// Column counter
	uint16_t	n_cols;		// Width of source area, in pixels
	uint16_t	n_rows;		// Height of source area, in pixels
	uint16_t *gvram_dest;	// Destination GVRAM pointer
	uint16_t	width_bytes;	// Row size, in bytes
	uint32_t start_addr;		// The first pixel in source
	uint32_t dest_addr;		// The first pixel in destination
	
	n_cols = x2 - x1;
	if (n_cols < 1){
		return -1;
	}
	
	n_rows = x2 - x1;
	if (n_rows < 1){
		return -1;
	}
	
	// Get starting pixel address
	start_addr = gvramGetXYaddr(x1, y1);
	if (start_addr < 0){
		return -1;
	}
	gvram = (uint16_t*) start_addr;
	
	dest_addr = gvramGetXYaddr(x3, y3);
	if (dest_addr < 0){
		return -1;
	}
	gvram_dest = (uint16_t*) dest_addr;
	
	// Calculate size of copy
	width_bytes = n_cols * GFX_PIXEL_SIZE;
	
	// memcpy entire rows at a time
	for(row = 0; row < n_rows; row++){
		memcpy(gvram_dest, gvram, width_bytes);
		
		// Go to next row in vram
		gvram += GFX_COLS;
		gvram_dest += GFX_COLS;
	}
	
	return 0;
}

uint8_t gvramScreenFill(uint16_t rgb){
	// Set the entire gvram screen space to a specific rgb colour
	uint32_t c;
	uint16_t super;
	gvram = (uint16_t*) GVRAM_START;
	
	for(c = GVRAM_START; c < GVRAM_END; c++){
		*gvram = rgb;
		gvram++;
	}
	return 0;
}
