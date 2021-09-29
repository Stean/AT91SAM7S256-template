# ***************************************************************
# *     Makefile for Atmel AT91SAM7S64 - flash execution        *
# *                                                             *
# *                                                             *
# *   James P Lynch  May 12, 2007                               *
# ***************************************************************

NAME = demo_at91sam7_p64_blink_flash

# variables 
CC      = arm-none-eabi-gcc
LD      = arm-none-eabi-ld -v
AR      = arm-none-eabi-ar
AS      = arm-none-eabi-as
CP      = arm-none-eabi-objcopy
OD		= arm-none-eabi-objdump

CFLAGS  = -I./ -c -fno-common -O0 -g
AFLAGS  = -ahls -mapcs-32 -o crt.o
LFLAGS_flash =  -Map main.flash.map -Tdemo_at91sam7_p64_blink_flash.cmd
LFLAGS_ram   =  -Map main.ram.map -Tdemo_at91sam7_p64_blink_ram.cmd
CPFLAGS = --output-target=binary
ODFLAGS	= -x --syms

OBJECTS = crt.o	main.o timerisr.o timersetup.o isrsupport.o lowlevelinit.o blinker.o


# make target called by Eclipse (Project -> Clean ...)
clean:
	-rm $(OBJECTS) crt.lst main.lst main.*.out main.*.bin main.hex main.*.map main.*.dmp

         
#make target called by Eclipse  (Project -> Build Project)
all: main.flash.bin main.ram.bin
	@ echo "...copying"

main.flash.bin: main.flash.out
	@ echo "...copying flash version"
	$(CP) $(CPFLAGS) main.flash.out main.flash.bin
	$(OD) $(ODFLAGS) main.flash.out > main.flash.dmp

main.ram.bin: main.ram.out
	@ echo "...copying ram version"
	$(CP) $(CPFLAGS) main.ram.out main.ram.bin
	$(OD) $(ODFLAGS) main.ram.out > main.ram.dmp

main.flash.out: $(OBJECTS) demo_at91sam7_p64_blink_flash.cmd 
	@ echo "..linking flash version"
	$(LD) $(LFLAGS_flash) -o main.flash.out $(OBJECTS) libc.a libm.a libgcc.a 

main.ram.out: $(OBJECTS) demo_at91sam7_p64_blink_flash.cmd 
	@ echo "..linking ram version"
	$(LD) $(LFLAGS_ram) -o main.ram.out $(OBJECTS) libc.a libm.a libgcc.a 

crt.o: crt.s
	@ echo ".assembling"
	$(AS) $(AFLAGS) crt.s > crt.lst

main.o: main.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) main.c
	
timerisr.o: timerisr.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) timerisr.c
	
lowlevelinit.o: lowlevelinit.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) lowlevelinit.c
	
timersetup.o: timersetup.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) timersetup.c
	
isrsupport.o: isrsupport.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) isrsupport.c

blinker.o: blinker.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) blinker.c
	

# **********************************************************************************************
#                            FLASH PROGRAMMING                                         
#
# Alternate make target for flash programming only
#
# You must create a special Eclipse make target (program) to run this part of the makefile 
# (Project -> Create Make Target...  then set the Target Name and Make Target to "program")
#
# OpenOCD is run in "batch" mode with a special configuration file and a script file containing
# the flash commands. When flash programming completes, OpenOCD terminates.
#
# Note that the script file of flash commands (script.ocd) is part of the project
#
# Programmers: Martin Thomas, Joseph M Dupre, James P Lynch
# **********************************************************************************************

# specify output filename here (must be *.bin file)
TARGET_FLASH = main.flash.bin

# specify the directory where openocd executable and configuration files reside (note: use forward slashes /)
OPENOCD_DIR = /usr/bin/

# specify OpenOCD executable (pp is for the wiggler, ftd2xx is for the USB debuggers)
#OPENOCD = $(OPENOCD_DIR)openocd-pp.exe
OPENOCD = $(OPENOCD_DIR)openocd

# specify OpenOCD configuration file (pick the one for your device)
#OPENOCD_CFG = $(OPENOCD_DIR)at91sam7s256-wiggler-flash-program.cfg
#OPENOCD_CFG = $(OPENOCD_DIR)at91sam7s256-jtagkey-flash-program.cfg
OPENOCD_FLAGS = --file script.ocd -c "flash_myfile $(TARGET_FLASH)"

# program the AT91SAM7S256 internal flash memory
flash: $(TARGET_FLASH)
	@echo "Flash Programming with OpenOCD..."			# display a message on the console
	$(OPENOCD) --file script.ocd -c "flash_program $(TARGET_FLASH)" 	# program the onchip FLASH here
	@echo "Flash Programming Finished."					# display a message on the console


# *******************************************************
# 					RAM LOADING 
# *******************************************************

# specify output filename here (must be *.bin file)
TARGET_RAM = main.ram.bin

load: $(TARGET_RAM)
	@echo "Loading file into RAM with OpenOCD..."           # display a message on the console
	$(OPENOCD) --file script.ocd -c "load_ram_program $(TARGET_RAM)"
	@echo "Loading into RAM finished"
