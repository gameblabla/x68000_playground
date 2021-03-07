/*
MIT License - Copyright (c) 2021 Gameblabla

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dos.h>
#include <iocs.h>

#include "rgb.h"
#include "gfx.h"
#include "input.h"
#include "compression.h"

BITMAP image;


int main() {
	uint16_t x, y, grbi;
	char* mem;
	int fsz, fd;
	uint16_t done = 1;
	
	// Initialise graphics screen mode
	gfx_init();

	//_iocs_g_clr_on();
	//_iocs_wipe();
	
	// ==============================
	//
	// Bitmap display
	//
	// ==============================
	
	/*fd = _dos_open ("demo.sif", 0);
	fsz = _dos_seek (fd, 0, SEEK_END);
	mem = malloc(fsz);
	_dos_seek (fd, 0, SEEK_SET);
	_dos_read (fd, mem, fsz);
	_dos_close (fd);*/
	
	gvram = (uint16_t*) GVRAM_START;
	
	//image = bitmap_load("demo.SIF");
	//memcpy(gvram, image.pixels, image.totalsize_pixel);
	
	bitmap_load_directly("demo.SIF");
	
	while(done)
	{
		if (input_get() == input_cancel)
		{
			done = 0;
		}
	}

	// Restore previous graphics mode
	gfx_close();

	return 0;
}
