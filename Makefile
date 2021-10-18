PREFIX?=/usr/local

build:
	swift build -c release --disable-sandbox

test:
	swift test --enable-test-discovery

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/xcbuildlogcollect" "$(PREFIX)/bin/xcbuildlogcollect"

uninstall: 
	rm "$(PREFIX)/bin/xcbuildlogcollect"

.PHONY: build test install uninstall
