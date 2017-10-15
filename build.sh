#!/bin/bash

# Place kernel zip from https://www.asus.com/ZenWatch/ASUS-ZenWatch-3-WI503Q/HelpDesk_Download/ here.

OMNI_TREE="$PWD/../TWRP" # Enter path of your Omni tree with the toolchain here

function log() {
    echo -e "\e[1;93m$1\e[0m"
}

##################
# Setup
##################
if [ ! -e msm ]; then
    log "> Cloning kernel repository.."
    git clone https://android.googlesource.com/kernel/msm.git -b android-msm-swift-3.18-nougat-dr-release
    echo -e "\n"
fi
cd msm
log "> Pulling latest commits if necessary."
git pull

log "\n> Done, do you want to compile now? (Press Ctrl+C to cancel.)"
read

##################
# Compile kernel
##################
# Patch Makefile
log "> Ok. Trying to patch Makefile."
patch -N -r /dev/null Makefile ../Patch-Makefile.patch

# Exports
export ARCH=arm
export CROSS_COMPILE=$OMNI_TREE/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-

# Make
log "\n> Starting compilation.."
build_start_time=`date +%s`
make clean
make swift_defconfig
make -j18
# Copy kernel
if [ $? -eq 0 ]; then
    cp "arch/arm/boot/zImage-dtb" ../zImage-dtb
    echo "Copied to ./zImage-dtb"
fi
build_end_time=`date +%s`

echo -e "\n\e[1;92m> Done.\n> Compilation took \e[1;31m$((build_end_time-build_start_time))\e[1;92m seconds."
cd ..

