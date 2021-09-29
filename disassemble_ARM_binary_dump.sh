#!/bin/bash

arm-none-eabi-objdump -m arm -b binary -D $1
