all: index.html dist css img json

index.html:
	cp ../apple2js/index.html .

../apple2js/dist: ../apple2js/dist/main2e.js
	cd ../apple2js && npm install && npm run build

dist: ../apple2js/dist/main2e.js
	cp -r ../apple2js/dist .

css:
	cp -r ../apple2js/css .

img:
	cp -r ../apple2js/img .

json:
	cp -r ../apple2js/json .
