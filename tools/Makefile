CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

led.bin:led.s
	$(CC) -g -c led.s -o led.o
	$(LD) -Ttext 0X87800000 led.o -o led.elf
	$(OBJCOPY) -O binary -S -g led.elf led.bin
	$(OBJDUMP) -D led.elf > led.dis
clean:
	rm -rf *.o led.bin led.elf led.dis
	
	
