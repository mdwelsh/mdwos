
all:
	mkdir -p build
	ca65 -t apple2 hello.s -o build/hello.o
	ld65 -o build/hello.bin build/hello.o -C apple2.cfg
	cp empty.dsk hello.dsk
	tokenize_asoft < loader.txt > build/apple_loader
	dos33 hello.dsk SAVE A build/apple_loader HELLO
	applecommander -cc65 hello.dsk BIN B < build/hello.bin

clean:
	rm -f build/* hello.dsk
