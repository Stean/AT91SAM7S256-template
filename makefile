# ***************************************************************
# *     Makefile for Atmel AT91SAM7S64 - flash execution        *
# *                                                             *
# *                                                             *
# *   James P Lynch  May 12, 2007                               *
# ***************************************************************

NAME = demo_at91sam7_p64_blink_flash

# variables 
CC      = arm-elf-gcc
LD      = arm-elf-ld -v
AR      = arm-elf-ar
AS      = arm-elf-as
CP      = arm-elf-objcopy
OD		= arm-elf-objdump

CFLAGS  = -I./ -c -fno-common -O0 -g
AFLAGS  = -ahls -mapcs-32 -o crt.o
LFLAGS  =  -Map main.map -Tdemo_at91sam7_p64_blink_flash.cmd
CPFLAGS = --output-target=binary
ODFLAGS	= -x --syms

OBJECTS = crt.o	main.o timerisr.o timersetup.o isrsupport.o lowlevelinit.o blinker.o


# make target called by Eclipse (Project -> Clean ...)
clean:
	-rm $(OBJECTS) crt.lst main.lst main.out main.bin main.hex main.map main.dmp

         
#make target called by Eclipse  (Project -> Build Project)
all:  main.out
	@ echo "...copying"
	$(CP) $(CPFLAGS) main.out main.bin
	$(OD) $(ODFLAGS) main.out > main.dmp

main.out: $(OBJECTS) demo_at91sam7_p64_blink_flash.cmd 
	@ echo "..linking"
	$(LD) $(LFLAGS) -o main.out $(OBJECTS) libc.a libm.a libgcc.a 

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
TARGET = main.bin

# specify the directory where openocd executable and configuration files reside (note: use forward slashes /)
OPENOCD_DIR = 'c:/Program Files/openocd-2007re141/bin/'

# specify OpenOCD executable (pp is for the wiggler, ftd2xx is for the USB debuggers)
#OPENOCD = $(OPENOCD_DIR)openocd-pp.exe
OPENOCD = $(OPENOCD_DIR)openocd-ftd2xx.exe

# specify OpenOCD configuration file (pick the one for your device)
#OPENOCD_CFG = $(OPENOCD_DIR)at91sam7s256-wiggler-flash-program.cfg
#OPENOCD_CFG = $(OPENOCD_DIR)at91sam7s256-jtagkey-flash-program.cfg
OPENOCD_CFG = $(OPENOCD_DIR)at91sam7s256-armusbocd-flash-program.cfg

# program the AT91SAM7S256 internal flash memory
program: $(TARGET)
	@echo "Flash Programming with OpenOCD..."			# display a message on the console
	$(OPENOCD) -f $(OPENOCD_CFG)						# program the onchip FLASH here
	@echo "Flash Programming Finished."					# display a message on the console

