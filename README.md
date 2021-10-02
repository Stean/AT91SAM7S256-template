# AT91SAM7S256 template
This repository provides (LED blinking) starter code for the [Olimex AT91SAM7S256 development board](https://www.olimex.com/Products/ARM/Atmel/SAM7-P256/) (which contains a ARM7TDMI-S microcontroller) and some helper scripts for improved developing. The C Code is based on the great tutorial "Using Open Source Tools for AT91SAM7 Cross Development" from Jim Lynch. 

I created it as a base for new embedded projects since the original tutorial code unfortunately didn't work for me anymore in many cases. This is probably because a lot of tools changed since then (OpenOCD for example seemingly changed their syntax).

After spending ~ 3 days of trying out new things, fixings bugs,.... the setup in this repository now works out-of-the box with my current setup (consisting of the mentioned development board and an [Olimex ARM-USB-TINY JTAG Debugger](https://www.olimex.com/Products/ARM/JTAG/ARM-USB-TINY).

# Getting started
0. On a new system execute the script **install_dependencies.sh** to install the development tools (like ARM GCC, OpenOCD,...): `sudo ./install_dependencies.sh`
1. Start coding! (by editing main.c or other files)
2. Power on the board, connect the JTAG Debugger via USB and the JTAG port and test your code by loading it into the RAM and execute it directly from there: `make load`
3. If you're satisfied/finished with the result, flash the program to persist it: `make flash`

If you need to debug your code directly on the board at any point in time, just start the script **start_debugserver.sh** (for starting an OpenOCD listener/GDB Server stub) and then **start-gdb.sh** in another shell window to start GDB with all necessary parameters.

# Further contents
Besides the mentioned code/scripts, there is also the script **disassemble_ARM_binary_dump.sh** which takes a raw ARM binary and tries to disassemble it using objdump (may be useful for debugging/reversing).

