Sharp X68000 playground by gameblabla
======================================

This simply displays a (compressed) image on the screen and exits
if you press a key or a joystick button.

The empty.XDF uses human68k 3.02 but only the two files required for it to boot properly
to the program.

Many thanks to Lydux for coming up with the GCC + Newlib patches for the Sharp X68000 !
https://www.target-earth.net/wiki/doku.php?id=blog:x68_devcode
https://www.target-earth.net/wiki/doku.php?id=blog:x68_devtools#the_Lydux_toolchain_gCC_462

Source code for his toolchain is here :
https://github.com/Lydux/gcc-4.6.2-human68k
https://github.com/Lydux/binutils-2.22-human68k
https://github.com/Lydux/newlib-1.19.0-human68k

You can find a precompiled toolchain here (for glibc AMD64) :
https://www.target-earth.net/wiki/lib/exe/fetch.php?media=blog:x68000_amd64_gcc-4.6.2-with-dos-align-fix.tar.bz2

Make sure to install the toolchain to :
/opt/toolchains/x68k/bin/human68k
On Linux.

On other POSIX-compliant systems, you have to compile. from source.
Download this : https://www.target-earth.net/wiki/lib/exe/fetch.php?media=blog:build_x68_gcc.zip).


===========
Compilation
===========

The instructions below assume that you will use Linux with a terminal such as xterm, lxterminal, sakura etc...

To compile the example, you will need a test image.

Here's how to prepare it.
Make sure it is a BMP 565 image.
You can do so on GIMP by Exporting the image as a BMP and doing the following :
- Untick "Do not write color space information" in Compatibility Options. This is important.
- Advanced Options -> Tick "R5 G6 B5" under 16 bits.

You can then convert your image to SIF format used by the code by compiling the utility in tools/bmp565toSIF.
Compile that utility with:
make

Copy your bmp file to the same directory as the executable and do the following in a terminal :
./convert_tool.elf yourbmp.bmp demo.SIF 512 512 512 512

If you want instead to compress the image with something like FC8 or Aplib, you can do the following instead :
./convert_tool.elf yourbmp.bmp demo.raw 512 512 512 512 noheader
apultra demo.raw demo.ap
./convert_tool.elf demo.ap demo.SIF 512 512 512 512

The file extension is very important for the compressed image !!




Copy the resulting "demo.SIF" to where the project's Makefile is.

Once you have your toolchain installed, just run :
make

to compile it.
Once that's done, make sure to create your final XDF file with :
make tools

and it will create a bootable XDF floppy image with your executable in it.
If you want to add more files other than your executable, make sure to edit FILES_TO_COPY in the Makefile.

You can then run your final executable with :
make run

This will run MAME with your XDF file. Make sure to have the sharp x68000 bios files in the appropriate directly. (rompath in your mame.ini file. On linuxn it's found in ~/.mame)

==========
Thanks
==========

Lydux for the toolchain and his example code. This wouldn't be possible at all without him.
Neko68k for his script to mount X68k XDF floppy images with linux with complete write support. (It needed a minor correction though, '`<.X' instead of '\x60')
Stephane Dallongeville for LZ4W. (Who thrashed Rainbow Trash Adventure huh ? xox)
FC8 by Steve Chamberlin
nrv2s decompressor by Ross of the Amiga scene.
Emmanuel Marty and Franck "hitchhikr" Charlet for the Aplib decoder. (taken from the apultra project. Also available for 8-bits platforms)

Sharp for the X68000 and Human68k. (the license for Human68k is a bit ambigious and completely in japanese but seems to allow limited redistribution)
