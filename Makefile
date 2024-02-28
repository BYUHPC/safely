PREFIX := /usr

all: # don't do anything unless install is explicitly specified

install:
	@mkdir -p "$(PREFIX)/bin"
	@install -m 755 safely "$(PREFIX)/bin/safely"

.PHONY: all install
