#!/bin/sh

TOP_DIR=`pwd`
# 安装打包
MFG_TOOLS=L4.1.15_2.0.0-ga_mfg-tools
MFG_TOOLS_WITH_ROOTFS=mfgtools-with-rootfs

#解压下载工具
tar -zxvf $TOP_DIR/package/05_Tools/03、NXP官方原版MFG_TOOL烧写工具/${MFG_TOOLS}.tar.gz -C $TOP_DIR/output/

#解压子压缩包
cd $TOP_DIR/output/${MFG_TOOLS} && tar -zxvf ${MFG_TOOLS_WITH_ROOTFS}.tar.gz -C ./ && cd -

cd $TOP_DIR/output/firmware/
cp u-boot-imx6ull14x14evk_emmc.imx zImage zImage-imx6ull-14x14-evk-emmc.dtb 					  $TOP_DIR/output/$MFG_TOOLS/${MFG_TOOLS_WITH_ROOTFS}/mfgtools/Profiles/Linux/OS\ Firmware/firmware/
cp u-boot-imx6ull14x14evk_emmc.imx zImage zImage-imx6ull-14x14-evk-emmc.dtb rootfs_nogpu.tar.bz2  $TOP_DIR/output/$MFG_TOOLS/${MFG_TOOLS_WITH_ROOTFS}/mfgtools/Profiles/Linux/OS\ Firmware/files/
cd -

# mfgtool2-yocto-mx-evk-emmc.vbs
