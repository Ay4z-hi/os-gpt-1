SHELL := /bin/sh
.PHONY: config build clean check
config:
	chmod +x auto/config
	./auto/config
build:
	sudo lb build
clean:
	sudo lb clean --purge
check:
	sh -n auto/config
	sh -n scripts/ahian
	sh -n scripts/smth-install
