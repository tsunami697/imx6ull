#!/bin/sh

TOP_DIR=$(pwd)

CROSS_COMPILE_DIR=$TOP_DIR/../../../../tools/
CROSS_COMPILE_BIN_DIR=gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
CROSS_COMPILE=$CROSS_COMPILE_DIR$CROSS_COMPILE_BIN_DIR

make clean
make CROSS_COMPILE=$CROSS_COMPILE
