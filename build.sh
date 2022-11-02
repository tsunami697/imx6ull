#!/bin/sh

TOP_DIR=$(pwd)

CROSS_COMPILE_GLOBAL_FLAG=

CROSS_COMPILE_PACKEGE=$TOP_DIR/package/05_Tools/01、交叉编译器/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
CROSS_COMPILE_PACKEGE_DIR=gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf

# 配置交叉编译器
cross_complie_config()
{
	if [ -z $CROSS_COMPILE_GLOBAL_FLAG ]; then
		# 配置局部交叉编译器
		CROSS_COMPILE_DIR=$TOP_DIR/tools/
		if [ ! -e $CROSS_COMPILE_DIR/$CROSS_COMPILE_PACKEGE_DIR ]; then
			mkdir $CROSS_COMPILE_DIR
			tar -xvf $CROSS_COMPILE_PACKEGE -C $CROSS_COMPILE_DIR
		fi
		CROSS_COMPILE_BIN_DIR=gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

		ARCH=arm
		CROSS_COMPILE=$CROSS_COMPILE_DIR$CROSS_COMPILE_BIN_DIR
		export CROSS_COMPILE
	else
		# 配置局部交叉编译器
		CROSS_COMPILE_DIR=/usr/local/arm/
		sudo rm $CROSS_COMPILE_DIR -rf

		if [ ! -d "$CROSS_COMPILE_DIR" ]; then
			sudo mkdir $CROSS_COMPILE_DIR

			sudo cp tools/$CROSS_COMPILE_PACKEGE $CROSS_COMPILE_DIR
			cd $CROSS_COMPILE_DIR
			sudo tar -xf $CROSS_COMPILE_PACKEGE
			sudo rm $CROSS_COMPILE_PACKEGE

			sudo chown $(whoami) /etc/profile
			sudo echo "export PATH=\$PATH:$CROSS_COMPILE_DIR$CROSS_COMPILE_PACKEGE_DIR/bin" >> /etc/profile
			sudo chown root /etc/profile
			. /etc/profile
			cd -
		fi
	fi	
}

# 从正点原子官方仓库下载源码
# https://atk-imx6ull.coding.net/public
clone_code()
{
	if [ ! -e package ]; then
		mkdir package
	fi
	cd package

	# 下载源代码
	if [ ! -e 01_Source_Code ]; then
		git clone https://e.coding.net/atk-imx6ull/imx6ull/01_Source_Code.git
	fi

	# 下载工具
	if [ ! -e 05_Tools ]; then
		git clone https://e.coding.net/atk-imx6ull/imx6ull/05_Tools.git
	fi

	cd -
}

# 编译uboot
build_uboot()
{
	cd $TOP_DIR/uboot/alientek_uboot/
	./build_uboot_emmc.sh
	cd -
}

#编译内核
build_kernel()
{
	cd $TOP_DIR/kernel/alientek_kernel/
	./build_kernel_emmc.sh
	cd -
}

start()
{
	clone_code
	cross_complie_config
	build_uboot
	bulld_kernel
}

start
# 1. 通用的依赖，gcc g++等
# 2. 交叉编译器等可以配置成用户的环境变量
# 3. 各个子模块的编译命令和配置
