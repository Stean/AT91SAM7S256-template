# Connect to gdbserver stub provided by OpenOCD
target extended-remote localhost:3333

# First, we have to halt the processor.
monitor soft_reset_halt

# Next, we identify the ARM core being used
monitor arm core_state arm

#######
# Now we set up the processor’s clocks, etc. using the register settings in the lowlevelinit.c function
# These are OpenOCD memory write commands used to set the various AT91SAM7S256 clock registers
# This guarantees that the processor will be running at full speed when the “continue” command is asserted
#######

# set flash wait state (AT91C_MC_FMR)
monitor mww 0xffffff60 0x00320100

# watchdog disable (AT91C_WDTC_WDMR)
monitor mww 0xfffffd44 0xa0008000

# enable main oscillator (AT91C_PMC_MOR)
monitor mww 0xfffffc20 0xa0000601
monitor wait 100

# set PLL register (AT91C_PMC_PLLR)
monitor mww 0xfffffc2c 0x00480a0e
monitor wait 200

# set master clock to PLL (AT91C_PMC_MCKR)
monitor mww 0xfffffc30 0x7
monitor wait 100

# Enable the Reset button in the AT91SAM7S-EK board.
monitor mww 0xfffffd08 0xa5000401

# increase the GDB packet size to 1024. This will have a slight improvement on FLASH debugging as reads of large data structures, etc. may be speeded up. These are legacy GDB commands.
set remote memory-write-packet-size 1024
set remote memory-write-packet-size fixed
set remote memory-read-packet-size 1024
set remote memory-read-packet-size fixed

# convert all Eclipse breakpoints to “hardware” breakpoints. Remember, we are only allowed two hardware breakpoints – defining more than two will crash the debugger!
#monitor arm7_9 force_hw_bkpts enable
monitor arm7_9 dbgrq enable

# force a peripheral RESET AT91C_RSTC_RCR
# This guarantees that the next command (set MC Remap Control register to 1) starts from a known initial state (MC Remap Control Register is a “toggle” action).
monitor mww 0xfffffd00 0xa5000004

# set the AT91SAM7S256 MC Remap Control register to 1 which toggles the remap state. This action effectively overlays RAM memory on top of low memory at address 0x00000000.
monitor mww 0xffffff00 0x01

# set the PC to 0x00000000
monitor reg pc 0x00000000

set architecture arm
exec-file file main.ram.bin
file main.ram.out

# read the symbol information from main.out
symbol-file main.ram.out

# load the application into RAM
load

## warn user that he only can use hardware breakpoints
#echo #****************************************#\n
#echo # Note: In case of breakpooints use hb   #\n
#echo #       instead of b ( or break)!        #\n
#echo #****************************************#\n

#####
# Finally we emit the legacy GDB command “continue”. The processor was already halted at the Reset vector and will thus start executing until it hits the breakpoint set at main( ).
#####

# resume execution from reset vector - will break at main( )
continue
 
