#!/bin/sh

TOP_DIR=$(pwd)
VENDOR=alientek

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
		export ARCH
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
	echo "=========================start building uboot========================="
	cd $TOP_DIR/uboot/${VENDOR}_uboot/
	./build_uboot_emmc.sh
	#cp u-boot.imx $TOP_DIR/output/
	cd -
}

#编译内核
build_kernel()
{
	echo "=========================start building kernel========================="
	cd $TOP_DIR/kernel/${VENDOR}_kernel/
	./build_kernel_emmc.sh
	#cp arch/arm/boot/zImage $TOP_DIR/output/
	#cp arch/arm/boot/dts/imx6ull-alientek-emmc.dtb $TOP_DIR/output/
	cd -
}

#编译rootfs
build_rootfs()
{
	cd $TOP_DIR/rootfs
	rm rootfs-obj -rf

	mkdir rootfs-obj
	cd $TOP_DIR/rootfs/busybox-1.29.0/
	make defconfig
	make -j12
	make install CONFIG_PREFIX=$TOP_DIR/rootfs/rootfs-obj/

	rm $TOP_DIR/output/rootfs-$VENDOR.tar.bz2
	tar -jcvf $TOP_DIR/output/rootfs-$VENDOR.tar.bz2 $TOP_DIR/rootfs/rootfs-obj
	cd -
}

build_package()
{
	echo "=========================start building package========================="
	if [ ! -d "${TOP_DIR}/output/" ]; then
		mkdir $TOP_DIR/output/
	else
		rm $TOP_DIR/output/firmware/* 
	fi

	cp $TOP_DIR/uboot/${VENDOR}_uboot/u-boot.imx $TOP_DIR/output/firmware/
	cp $TOP_DIR/kernel/${VENDOR}_kernel/arch/arm/boot/dts/imx6ull-alientek-emmc.dtb $TOP_DIR/output/firmware/
	cp $TOP_DIR/kernel/${VENDOR}_kernel/arch/arm/boot/zImage $TOP_DIR/output/firmware/

	tar -jcvf $TOP_DIR/output/firmware/rootfs-$VENDOR.tar.bz2 $TOP_DIR/rootfs/rootfs-obj/

	cd $TOP_DIR/output/firmware/
	mv u-boot.imx u-boot-imx6ull14x14evk_emmc.imx
	mv imx6ull-alientek-emmc.dtb zImage-imx6ull-14x14-evk-emmc.dtb
	mv rootfs-$VENDOR.tar.bz2 rootfs_nogpu.tar.bz2
	cd -
}

start()
{
	clone_code
	cross_complie_config

	build_uboot
	build_kernel
	build_rootfs

	build_package
	echo "=========================building done========================="
}

start
# 1. 通用的依赖，gcc g++等
# 2. 交叉编译器等可以配置成用户的环境变量
# 3. 各个子模块的编译命令和配置
