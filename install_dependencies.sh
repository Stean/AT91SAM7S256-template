#!/bin/bash

# root check
if [ $UID != 0 ]; then
	echo "Please run with root privileges!" >&2
	exit 1
fi

apt-get update
apt-get install binutils-arm-none-eabi gcc-arm-none-eabi openocd gdb-multiarch
