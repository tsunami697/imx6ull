#CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= bsp

CC 				:= $(CROSS_COMPILE)gcc
LD				:= $(CROSS_COMPILE)ld
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump

INCDIRS 		:= imx6ul \
				   bsp/clk \
				   bsp/led \
				   bsp/delay 
				   			   
SRCDIRS			:= project \
				   bsp/clk \
				   bsp/led \
				   bsp/delay 
				   
				   
# patsubst 给变量INCDIRS添加一个"-I",指定头文件目录
# INCLUDE		:= -I imx6ul -I bsp/clk/ -I bsp/led/ -I bsp/delay/
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))

# foreach 从SRCDIRS里面跳出所有的.S文件
# SFILES		:= project/start.S
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))

# foreach 从SRCDIRS里面跳出所有的.c文件
# CFILES		:= project/main.c bsp/clk/bsp_clk.c bsp/led/bsp_led.c bsp/delay/bsp_delay.c
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))

# 使用notdir，把SFILES,CFILES路径去掉
# SFILESNDIR	:= start.S
# CFILESNDIR	:= main.c bsp_clk.c bsp_led.c bsp_delay.c
SFILENDIR		:= $(notdir  $(SFILES))
CFILENDIR		:= $(notdir  $(CFILES))

# SOBJS			:= obj/start.o
# COBJS			:= obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o
SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o))
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o))

OBJS			:= $(SOBJS) $(COBJS)

VPATH			:= $(SRCDIRS)

.PHONY: clean
	
$(TARGET).bin : $(OBJS)
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis

#$(SOBJS) : obj/%.o : %.S
$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<

#$(COBJS) : obj/%.o : %.c
$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
