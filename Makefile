
DEPS ?= $(shell ls -d deps/*)

all: build test

.PHONY: deps
deps: $(DEPS)

deps/gyp:
	git clone --depth 1 https://chromium.googlesource.com/external/gyp.git ./deps/gyp

deps/http-parser:
	git clone --depth 1 git://github.com/joyent/http-parser.git ./deps/http-parser

deps/libuv:
	git clone --depth 1 git://github.com/joyent/libuv.git ./deps/libuv

build: $(DEPS)
	deps/gyp/gyp --depth=. -Goutput_dir=./out -Icommon.gypi --generator-output=./build -Dlibrary=static_library -Duv_library=static_library -f make -debug

.PHONY: test
test: test.cc
	make -C ./build/ test
	cp ./build/out/Release/test ./test

distclean:
	make clean
	rm -rf ./build

clean:
	rm -rf ./build/out/Release/obj.target/server/
	rm -f ./build/out/Release/server

