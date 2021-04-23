
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
	applecommander -p mdwos.dsk MDWIMG B < mdw.bin
	applecommander -p mdwos.dsk SPLASH B < mdw.bin
	../apple2js/bin/dsk2json -c mdw -n mdwOS mdwos.dsk > ../apple2js/json/disks/mdwos.json
	cd ../apple2js && ./bin/index

clean:
	rm -f build/* mdwos.dsk
