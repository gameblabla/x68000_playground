/* gfx.h, GVRAM Graphical function prototypes for the x68Launcher.
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
*/

#include <stdint.h>

#define GFX_PAGE		0				// Active GVRAM page (only one page in 16bit colour mode)

#ifdef LOW_RESOLUTION

#define GFX_CRT_MODE 	14				// 256x256 65535 colour

#define GFX_ROWS		256				// NUmbe of pixels in a row
#define GFX_COLS		256				// Number of pixels in a column
#define GFX_ROW_SIZE	(GFX_COLS << 1)	// NUmber of bytes in a row (pixels per row * 2)
#define GFX_COL_SIZE 	(GFX_ROWS << 1)  // NUmber of bytes in a column
#define GFX_PIXEL_SIZE	2				// 2 bytes per pixel

#else

#define GFX_CRT_MODE 	12				// 512x512 65535 colour

#define GFX_ROWS		512				// NUmbe of pixels in a row
#define GFX_COLS		512				// Number of pixels in a column
#define GFX_ROW_SIZE	(GFX_COLS << 1)	// NUmber of bytes in a row (pixels per row * 2)
#define GFX_COL_SIZE 	(GFX_ROWS << 1)  // NUmber of bytes in a column
#define GFX_PIXEL_SIZE	2				// 2 bytes per pixel

#endif

#define GVRAM_START	0xC00000		// Start of graphics vram
#define GVRAM_END		0xC7FFFF		// End of graphics vram

#define RGB_BLACK		0x0000			// Simple RGB definition for a black 16bit pixel (5551 representation?)
#define RGB_WHITE		0xFFFF			// Simple RGB definition for a white 16bit pixel (5551 representation?)

uint16_t	*gvram;							// Pointer to a GVRAM location (which is always as wide as a 16bit word)
int crt_last_mode;							// Store last active mode before this application runs

#define BITMAP_HEADER_SIZE 16

typedef struct tagBITMAP              /* the structure for a bitmap. */
{
	uint16_t width;
	uint16_t height;
	uint16_t sprite_width;
	uint16_t sprite_height;
	uint8_t encoding;
	int totalsize_pixel;
	int totalfilesz;
	char bytespp;
	char *pixels;
} BITMAP;


BITMAP bitmap_load(const char* path);
void bitmap_load_directly(const char* path);

/* **************************** */
/* Function prototypes */
/* **************************** */
uint8_t		gfx_init();
uint8_t		gfx_close();
void	gfx_Clear();
uint8_t gvramBitmap(short x, short y, BITMAP *bmpdata);
uint8_t gvramBox(short x1, short y1, short x2, short y2, uint16_t grbi);
uint8_t gvramBoxFill(short x1, short y1, short x2, short y2, uint16_t grbi);
uint32_t		gvramGetXYaddr(short x, short y);
uint8_t gvramPoint(short x, short y, uint16_t grbi);
uint8_t gvramScreenFill(uint16_t rgb);
uint8_t gvramScreenCopy(short x1, short y1, short x2, short y2, short x3, short y3);
