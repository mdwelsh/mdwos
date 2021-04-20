
all:
	mkdir -p build
	ca65 -t apple2 mdwos.s -o build/mdw.o
#	ca65 -t apple2 hkimg.s -o build/hkimg.o
#	ld65 -o build/mdwos.bin build/mdw.o build/hkimg.o -C apple2.cfg
	ld65 -o build/mdwos.bin build/mdw.o -C apple2.cfg
	cp empty.dsk mdwos.dsk
	tokenize_asoft < loader.txt > build/apple_loader
	dos33 mdwos.dsk SAVE A build/apple_loader HELLO
	applecommander -cc65 mdwos.dsk BIN B < build/mdwos.bin

clean:
	rm -f build/* mdwos.dsk
