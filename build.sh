#!/bin/bash

# Place kernel zip from https://www.asus.com/ZenWatch/ASUS-ZenWatch-3-WI503Q/HelpDesk_Download/ here.

OMNI_TREE="/home/max/Development/Android/TWRP" # Enter path of your Omni tree with the toolchain here

echo "Welcome!"

##################
# Setup
##################
if [ ! -d kernel ]; then
  echo "Extracting files.."
  unzip "WI503Q_kernel_*.zip"
  tar -xf ASUS_Swift-*-kernel-src.tar
fi

echo "Press any key to continue, Ctrl + C to cancel."
read
##################
# Compile kernel
##################
echo "Compiling kernel"
cd kernel

# Patch Makefile
echo "Trying to patch Makefile.."
patch -N -r /dev/null Makefile ../Patch-Makefile.patch

# Exports
export ARCH=arm
export CROSS_COMPILE=$OMNI_TREE/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-

# Make
echo "Starting compilation.."
make clean
make swift_defconfig
make -j5

