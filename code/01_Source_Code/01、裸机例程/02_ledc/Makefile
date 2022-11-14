CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

objs := start.o main.o

# 自动化变量 $^:所有依赖，这里指start.o main.o
# 自动化变量 $@:所有目标，这里指ledc.bin
# objcopy 把elf文件转换为二进制,不使用 -o指定目标
ledc.bin:$(objs)
	$(LD) -Timx6ul.lds -o ledc.elf $^
	$(OBJCOPY) -O binary -S ledc.elf $@
	$(OBJDUMP) -D -m arm ledc.elf > ledc.dis
	
# 自动化变量 $<:依赖集合中的第一个
%.o:%.s
	$(CC) -Wall -nostdlib -c -O2 -o $@ $<
	
%.o:%.S
	$(CC) -Wall -nostdlib -c -O2 -o $@ $<
	
%.o:%.c
	$(CC) -Wall -nostdlib -c -O2 -o $@ $<
	
clean:
	rm -rf *.o ledc.bin ledc.elf ledc.dis *.imx
	
	
