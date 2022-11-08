SECTIONS{
	/* . 叫做定位计数器，默认为0; imx6ull drm开始地址是0x87800000 */
	. = 0X87800000;

	/* 大括号里填上要链接到.text这个段里面的所有文件; *(.text) *是通配符，表示所有输入文件的.text段都放到.text中 */
	.text :
	{
	/* 如果文件在不同目录，加上路径 */
		start.o
		main.o
		*(.text)
	}

	/* ALIGN(4)表示4字节对齐 */
	.rodata ALIGN(4) : {*(.rodata*)}
	.data ALIGN(4)   : { *(.data) }

	/* bss 定义但没初始化的变量 */
	/* 定义了__bss_start和__bss_end两个符号，使用=号给他俩赋值,可以直接在汇编文件或C文件使用 */
	__bss_start = .;
	.bss ALIGN(4)  : { *(.bss)  *(COMMON) }
	__bss_end = .;
}
