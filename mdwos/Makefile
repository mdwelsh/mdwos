
splash.bin: ../graphics/splash.png
	../img2hgr/img2hgr.py $< $@

mdw.bin: ../graphics/mdw-scaled-dither-text.png
	../img2hgr/img2hgr.py $< $@


build/apple_loader: loader.txt
	mkdir -p build
	tokenize_asoft < loader.txt > build/apple_loader

mdwos.dsk: build/apple_loader build/mdwos.bin splash.bin mdw.bin
	cp empty.dsk mdwos.dsk
	dos33 mdwos.dsk SAVE A build/apple_loader HELLO
	applecommander -cc65 mdwos.dsk BIN B < build/mdwos.bin
	applecommander -p mdwos.dsk MDWIMG B < mdw.bin
	applecommander -p mdwos.dsk SPLASH B < splash.bin

build/mdwos.bin: build/mdw.o
	mkdir -p build
	ld65 -o build/mdwos.bin build/mdw.o -C apple2.cfg

build/mdw.o: mdw.s
	mkdir -p build
	ca65 -t apple2 mdwos.s -o build/mdw.o

all: mdwos.dsk ../apple2js/json/disks/mdwos.json

../apple2js/json/disks/mdwos.json: mdwos.dsk
	../apple2js/bin/dsk2json -c mdw -n mdwOS mdwos.dsk > ../apple2js/json/disks/mdwos.json
	cd ../apple2js && ./bin/index

clean:
	rm -f build/* mdwos.dsk
