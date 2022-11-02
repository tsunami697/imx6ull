#!/bin/sh

#ARCH=arm
#CROSS_COMPILE=/home/ljq/imx6ul/tools/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
#export CROSS_COMPILE

make distclean
make imx_v7_defconfig
make menuconfig
make all -j16
