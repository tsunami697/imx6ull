#!/bin/sh

# 安装基础依赖
function install_packege()
{
	sudo apt install vim git git-lfs openssh-server openssh-client terminator open-vm-tools libncurses5-dev make gcc g++
	git lfs install
}

# 自动挂载windows目录
mount_windows()
{
	home=$HOME
	echo $home
	mkdir /home/ljq/hgfs
	vmhgfs-fuse .host:/E /home/ljq/hgfs
	sudo echo ".host:/E $home/hgfs fuse.vmhgfs-fuse allow_other,defaults 0 0" >> /etc/fstab
	#mount -a
	#umount /home/ljq/hgfs
}

# 配置代理
set_proxy()
{
	tar -zxvf qv2ray.tar.gz
}

install_packege
