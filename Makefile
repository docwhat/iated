### Makefile --- Build the doctor jar and exe.

SOURCE:=$(shell find src -type f)
BUILD_SOURCE:=$(patsubst src/%, build/%, $(SOURCE))

# Downloadables
LAUNCH4J_URL := http://sourceforge.net/projects/launch4j/files/launch4j-3/3.0.2/launch4j-3.0.2-macosx.tgz

# Commands
JRUBY:=jruby $(OPT)
WARBLE:=$(JRUBY) -S warble

.PHONY: all
all: build

## Execute the tool
.PHONY: exec
exec:
	cd src && env RUBYLIB=./lib $(JRUBY) bin/iated --debug

## Execute the tool
.PHONY: test
test:
	$(JRUBY) -S rspec test

## Setup the environment
.PHONY: setup
setup: cache/launch4j/launch4j
	$(JRUBY) -S jbundle

cache/launch4j/launch4j:
	mkdir -p cache
	cd cache && wget -N $(LAUNCH4J_URL)
	cd cache && tar xf $(notdir $(LAUNCH4J_URL))

## Build the tool
.PHONY: build
build: target/iated.jar target/iated.exe

.PHONY: jar
jar: target/iated.jar

.PHONY: exe
exe: target/iated.exe

target/iated.exe: target/iated.jar
	@if [ ! -x cache/launch4j/launch4j ]; then echo "Run 'make setup'"; exit 10; fi
	cd target && env -u OPT ../cache/launch4j/launch4j $$(pwd)/../launch4j-config.xml

target/iated.jar: build/build.jar
	mkdir -p target
	cp -f $< $@

$(BUILD_SOURCE):build/%: src/%
	mkdir -p $(dir $@)
	cp -f $< $@

build/build.jar: $(BUILD_SOURCE)
	cd build && $(WARBLE) jar:clean jar


## Clean
.PHONY: clean
clean:
	rm -rf target build

### Makefile ends here
