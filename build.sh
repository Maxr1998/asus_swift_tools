#!/bin/bash

# Place kernel zip from https://www.asus.com/ZenWatch/ASUS-ZenWatch-3-WI503Q/HelpDesk_Download/ here.

OMNI_TREE="$PWD/../TWRP" # Enter path of your Omni tree with the toolchain here

##################
# Setup
##################
if [ ! -e msm ]; then
    echo "Cloning kernel repository.."
    git clone https://android.googlesource.com/kernel/msm.git -b android-msm-swift-3.18-nougat-dr-release
fi
cd msm
echo "Pulling latest commits if necessary."
git pull

echo "Done, do you want to compile now? (Press Ctrl+C to cancel.)"
read
##################
# Compile kernel
##################
# Patch Makefile
echo "Ok. Trying to patch Makefile."
patch -N -r /dev/null Makefile ../Patch-Makefile.patch

# Exports
export ARCH=arm
export CROSS_COMPILE=$OMNI_TREE/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-

# Make
echo "Starting compilation.."
make clean
make swift_defconfig
make -j18
# Copy kernel
if [ $? -eq 0 ]; then
    echo "Copying"
    cp "arch/arm/boot/zImage-dtb" ../zImage-dtb   
fi

