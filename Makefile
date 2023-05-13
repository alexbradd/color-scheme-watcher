RELEASE_MAJOR := 1
RELEASE_MINOR := 0
RELEASE_PATCH := 0
RELEASE := $(RELEASE_MAJOR).$(RELEASE_MINOR).$(RELEASE_MICRO)
SHELL = bash

BIN = $(DESTDIR)/.local/bin
SYSTEMD = $(DESTDIR)/.config/systemd/user

all: clean color-scheme-watcher.sh color-scheme-watcher.service

clean:
	-rm -rf color-scheme-watcher.sh
	-rm -rf color-scheme-watcher.service

color-scheme-watcher.sh: color-scheme-watcher.sh.in
	sed -e 's/@VERSION@/$(RELEASE)/' $^ > $@

color-scheme-watcher.service: color-scheme-watcher.service.in
	sed -e 's/@PATH_TO_SCRIPT@/$(subst /,\/,$(BIN))/' $^ > $@

install: color-scheme-watcher.sh
	install -D -m 0755 color-scheme-watcher.sh $(BIN)/color-scheme-watcher.sh

systemd-install: color-scheme-watcher.service
	install -D -m 0755 color-scheme-watcher.service $(SYSTEMD)/color-scheme-watcher.service

uninstall:
	-rm -rf $(BIN)/color-scheme-watcher.sh
	-rm -rf $(SYSTEMD)/color-scheme-watcher.service
