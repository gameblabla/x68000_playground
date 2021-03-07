#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>

#include <SDL/SDL.h>
#include "bmp.h"
#include "rgb.h"

#ifndef SDL_TRIPLEBUF
#define SDL_TRIPLEBUF SDL_DOUBLEBUF
#endif

SDL_Surface* sdl_screen;
SDL_Surface* backbuffer;
SDL_Surface* tmp;
uint32_t key_pressed = 0;
uint8_t str[64];
uint8_t tmp_str[64];

int spr = 0;

typedef enum {
    STR2INT_SUCCESS,
    STR2INT_OVERFLOW,
    STR2INT_UNDERFLOW,
    STR2INT_INCONVERTIBLE
} str2int_errno;

str2int_errno str2int(int *out, char *s, int base) {
    char *end;
    if (s[0] == '\0' || isspace(s[0]))
        return STR2INT_INCONVERTIBLE;
    errno = 0;
    long l = strtol(s, &end, base);
    /* Both checks are needed because INT_MAX == LONG_MAX is possible. */
    if (l > INT_MAX || (errno == ERANGE && l == LONG_MAX))
        return STR2INT_OVERFLOW;
    if (l < INT_MIN || (errno == ERANGE && l == LONG_MIN))
        return STR2INT_UNDERFLOW;
    if (*end != '\0')
        return STR2INT_INCONVERTIBLE;
    *out = l;
    return STR2INT_SUCCESS;
}

int main (int argc, char *argv[]) 
{
	FILE *fp;
	
	bmpdata_t* bmp = NULL;
	int noheader = 0;
	int lSize;
	int compressed = 0;
	uint16_t temp_w, temp_spr_w;
	uint16_t temp_h, temp_spr_h;
	uint16_t spr_w;
	uint16_t spr_h;
	uint8_t encoding = 0;
	
	uint8_t stub = 0;
	
	char * pch;
	char * pch2;
	
	if (argc < 7)
	{
		printf("BMP/Compressed RGB565 to GRB555 raw or SIF\nThis is useful for converting BMPs or FC8/LZ4W/NRV2 to\na custom GRB555 image with a custom header for the Sharp X68000\n");
		printf("bmptogrb in.bmp/in.fc8 out.raw bitmap_width bitmap_height sprite_width sprite_height noheader\n");
		
		printf("\nFor background images, just enter the same value for sprite_width and bitmap_width and so on.\n");
		
		return 0;
	}

	str2int(&spr_w, argv[5], 10);
	str2int(&spr_h, argv[6], 10);
	printf("Sprite width : %d pixels\n", spr_w);
	printf("Sprite height : %d pixels\n", spr_h);
	
	if (argc == 8)
	{
		if (strstr (argv[7],"noheader"))
		{
			printf("No header mode, output as a RAW Big-Endian GRB555 format.");
			noheader = 1;
		}
	}
	
	pch = strstr (argv[1],".bmp");
	bmp = (bmpdata_t *) malloc(sizeof(bmpdata_t));
	bmp->pixels = NULL;
	if (pch != NULL)
	{
		printf("This is a BMP format, use built-in converter\n");
		
		fp = fopen(argv[1], "rb");
		if (!fp) 
		{
			printf("Input file does not even exist (or cannot be opened)\n");
			return 1;
		}
		bmp_ReadImage(fp, bmp, 1, 1);
		fclose(fp);
	}
	else
	{
		str2int(&bmp->width, argv[3], 10);
		str2int(&bmp->height, argv[4], 10);
		compressed = 1;
		if (strstr (argv[1],".fc8"))
		{
			printf("Custom binary format is FC8\n");
			encoding = 1;
		}
		else if (strstr (argv[1],".lzw"))
		{
			printf("Custom binary format is LZ4W (by Stephane)\n");
			encoding = 2;
		}
		else if (strstr (argv[1],".nv"))
		{
			printf("Custom binary format is nrv2s\n");
			encoding = 3;
		}
		else if (strstr (argv[1],".lz4"))
		{
			printf("Custom binary format is LZ4\n");
			encoding = 4;
		}
		else if (strstr (argv[1],".lz"))
		{
			printf("Custom binary format is zlib/inflate\n");
			encoding = 5;
		}
		else if (strstr (argv[1],".ap"))
		{
			printf("Custom binary format is APLIB\n");
			encoding = 6;
		}
		else if (strstr (argv[1],".pcf"))
		{
			printf("Custom binary format is PackFire\n");
			encoding = 7;
		}
		else
		{
			printf("Unknown format. Make sure that the file extension is set appropriately.\n");
			if (bmp) free(bmp);
			return -1;
		}
		
		printf("We will just append a header to it.\n(using the info provided through the command line)\n");
		
		fp = fopen(argv[1], "rb");
		fseek (fp , 0 , SEEK_END);
		lSize = ftell (fp);
		fseek (fp , 0 , SEEK_SET);

		// allocate memory to contain the whole file:
		bmp->pixels = (char*) malloc (sizeof(char)*lSize);
		
		// Assume that bitdepth is 16bpp
		bmp->bytespp = 2;
		
		// copy the file into the buffer:
		fread (bmp->pixels,1,lSize,fp);
		
		fclose(fp);
	}
	
	fp = fopen(argv[2], "wb");
	if (!fp) 
	{
		printf("Cannot write to output file (read-only filesystem or lack of free space perhaps ?)\n");
		return 1;
	}
	
	if (noheader == 0)
	{
		temp_w = __builtin_bswap16(bmp->width);
		temp_h = __builtin_bswap16(bmp->height);
		temp_spr_w = __builtin_bswap16(spr_w);
		temp_spr_h = __builtin_bswap16(spr_h);
		
		fwrite (&temp_w, sizeof(char), sizeof(bmp->width), fp);
		fwrite (&temp_h, sizeof(char), sizeof(bmp->height), fp);
		fwrite (&temp_spr_w, sizeof(char), sizeof(bmp->width), fp);
		fwrite (&temp_spr_h, sizeof(char), sizeof(bmp->height), fp);
		fwrite (&bmp->bytespp, sizeof(char), sizeof(bmp->bytespp), fp);
		fwrite (&encoding, sizeof(char), sizeof(bmp->height), fp);
		
		// These stubs are required or else it will be misaligned on the Sharp X68000 and result into glitches
		fwrite (&stub, sizeof(char), sizeof(stub), fp);
		fwrite (&stub, sizeof(char), sizeof(stub), fp);
		fwrite (&stub, sizeof(char), sizeof(stub), fp);
		fwrite (&stub, sizeof(char), sizeof(stub), fp);
		fwrite (&stub, sizeof(char), sizeof(stub), fp);
	}
	
	if (compressed == 0)
	{
		fwrite (bmp->pixels , sizeof(char), (bmp->width * bmp->height)*bmp->bytespp, fp);
	}
	else
	{
		fwrite (bmp->pixels , sizeof(char), lSize, fp);
	}
	
	fclose(fp);
	
	bmp_Destroy(bmp);
	
	return 0;
}
