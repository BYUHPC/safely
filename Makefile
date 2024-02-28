PREFIX := /usr

all: # don't do anything unless install is explicitly specified

install:
	@mkdir -p "$(PREFIX)/bin"
	@install -m 755 safely "$(PREFIX)/bin/safely"

check:
	@bats test.bats

.PHONY: all install check
