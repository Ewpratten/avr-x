baud=115200
avrType=atmega328p
avrFreq=16000000 # 16 Mhz
programmerDev=/dev/ttyACM1
programmerType=arduino

cflags=-DF_CPU=$(avrFreq) -mmcu=$(avrType) -Wall -Werror -Wextra -Os -Wno-incompatible-pointer-types
objects=$(patsubst %.c,%.o,$(wildcard *.c)) io/*.c


.PHONY: flash clean

all: main.hex

%.o: %.c
	avr-gcc $(cflags) -c $< -o $@

main.elf: $(objects)
	avr-gcc $(cflags) -o $@ $^

main.hex: main.elf
	avr-objcopy -j .text -j .data -O ihex $^ $@

flash: main.hex
	avrdude -p$(avrType) -c$(programmerType) -P$(programmerDev) -b$(baud) -v -U flash:w:$<

clean:
	rm -f main.hex main.elf main.o
	#$(objects)