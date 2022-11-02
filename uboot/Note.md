# armv7
1. 协处理器
https://baike.baidu.com/item/%E5%8D%8F%E5%A4%84%E7%90%86%E5%99%A8/7361259#:~:text=%E5%A4%84%E7%90%86%E5%99%A8%E4%BA%86%E3%80%82-,ARM%20%E5%BE%AE%E5%A4%84%E7%90%86%E5%99%A8,%E7%9A%84%E6%95%B0%E6%8D%AE%E4%BC%A0%E9%80%81%E6%8C%87%E4%BB%A4%0A%5B3%5D%C2%A0%0A%E3%80%82,-%E8%AF%8D%E6%9D%A1%E5%9B%BE%E5%86%8C

## 中断
1. 中断向量
	中断服务函数地址

2. 中断向量表
	1. 中断向量组成的表
	2. 中断向量表是有芯片厂商提供，是固定的

3. 中断向量控制器
	stm32中断控制器：NVIC
	cortex-a7: GIC

4. stm32中断
	1. 中断向量表
	2. 初始化
	3. 填充中断服务函数
5. cortex-a7

# uboot

## 配置和使用

1. 配置文件目录：uboot/configs

2. 镜像：编译后 u-boot.imx 文件是添加头部以后的 u-boot.bin，u-boot.imx 就是我们最终要烧写到开发板中的 uboot 镜像文件。
3. 烧写：将 uboot 烧写到 SD 卡中，然后通过 SD 卡来启动来运行 uboot。使用 imxdownload 软件烧写

```shell
$ sudo imxdownload u-boot.bin /dev/sdd # 烧写到 SD 卡，不能烧写到/dev/sda 或 sda1 设备里面！
```

4. 启动输出信息
5. uboot命令

## Makefile
1. 定义了很多变量;
	有的使用export传给子Makefile;
	变量有的在Makefile中定义，有的通过命令行变量指定

## uboot启动流程
1. 通过uboot.lds找到uboot的入口,通过搜索只有两处
```shell
$ _start,通过grep -wnR "_start:" ./		#一定要加个分号，寻找定义的地方
./alientek_uboot/arch/arm/cpu/armv8/start.S:21:_start:
./alientek_uboot/arch/arm/lib/vectors.S:48:_start:
```
imx6ul是armv7架构,所以是vectors.S文件

2. uboot程序执行
	格式：文件
			函数
			代码
	uboot.img
	|
	|-->uboot/arch/arm/lib/vectors.S
	|	_start:
	|		b save_boot_params |--> uboot/arch/arm/cpu/armv7/start.s
	|						   |		save_boot_para:
	|						   |			b save_boot_params_ret
	|
	|
	|
	|
	|
	|
	|
	|
	|
