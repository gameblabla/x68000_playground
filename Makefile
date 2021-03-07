# Names of the compiler and friends
APP_BASE = /opt/toolchains/x68k/bin/human68k
AS 		= $(APP_BASE)-as
CC 		= $(APP_BASE)-gcc
LD 		= $(APP_BASE)-ld
OBJCOPY 	= $(APP_BASE)-objcopy
STRIP 		= $(APP_BASE)-strip

# libraries and paths
LIBS	 	= -ldos
#-liocs -lm
INCLUDES 	=          

# Compiler flags
ASM_FLAGS 	= -m68000 --register-prefix-optional -S
LDFLAGS 	=  -lc -flto -Wl,--as-needed -Wl,--gc-sections -flto
CFLAGS 		= -m68000 -std=gnu99 -fomit-frame-pointer -Wall -Wno-unused-function -Wno-unused-variable -Ofast -flto -fno-PIC -mno-xgot -fdata-sections -ffunction-sections 
LDSCRIPT 	=
OCFLAGS		= -O xfile

# What our application is named
FILENAME_EXE = MAIN
TARGET	= $(FILENAME_EXE).ELF
EXE	= $(FILENAME_EXE).X

FOLDER_XDF = xdf
FILES_TO_COPY = demo.SIF

all: asm $(EXE)

OBJFILES = main.o gfx.o input.o

asm:
	$(AS) $(ASM_FLAGS) lz4w.s -o lz4w.o
	$(AS) $(ASM_FLAGS) aplib.s -o aplib.o
	$(AS) $(ASM_FLAGS) nv.s -o nv.o
	$(AS) $(ASM_FLAGS) fc8.s -o fc8.o
	
$(EXE):  $(OBJFILES)
	$(CC) $(LDFLAGS) $(OBJFILES) lz4w.o aplib.o nv.o fc8.o $(LIBS) -o $(TARGET)
	$(OBJCOPY) $(OCFLAGS) $(TARGET) $(EXE)
	
clean:
	rm -f *.o $(EXE) $(TARGET)
	
definal:
	sudo umount ./$(FOLDER_XDF)
	sudo rm -r ./$(FOLDER_XDF)
	sudo losetup -d /dev/loop0

final:
	cp empty.XDF game.xdf
	printf '\xEB' | dd conv=notrunc of=game.xdf bs=1 seek=0
	sudo losetup /dev/loop0 game.xdf
	mkdir -p ./$(FOLDER_XDF)
	sudo mount /dev/loop0 ./$(FOLDER_XDF) -t msdos -o "fat=12"
	sudo cp $(EXE) $(FILES_TO_COPY) ./$(FOLDER_XDF)
	sudo umount ./$(FOLDER_XDF)
	sudo losetup -d /dev/loop0
	sudo rm -r ./$(FOLDER_XDF)
	printf '`<.X' | dd conv=notrunc of=game.xdf bs=1 seek=0

run:
	mame x68000 -flop1 $(shell pwd)/game.xdf
