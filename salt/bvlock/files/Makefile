# bvlock - simple screen locker
# See LICENSE file for copyright and license details.

include config.mk

SRC = bvlock.c ${COMPATSRC}
OBJ = ${SRC:.c=.o}

all: options bvlock

options:
	@echo bvlock build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk arg.h util.h

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

bvlock: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f bvlock ${OBJ} bvlock-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p bvlock-${VERSION}
	@cp -R LICENSE Makefile README bvlock.1 config.mk \
		${SRC} explicit_bzero.c config.def.h arg.h util.h bvlock-${VERSION}
	@tar -cf bvlock-${VERSION}.tar bvlock-${VERSION}
	@gzip bvlock-${VERSION}.tar
	@rm -rf bvlock-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f bvlock ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/bvlock
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" <bvlock.1 >${DESTDIR}${MANPREFIX}/man1/bvlock.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/bvlock.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/bvlock
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/bvlock.1

.PHONY: all options clean dist install uninstall
