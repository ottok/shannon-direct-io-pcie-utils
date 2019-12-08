# Vendor: Shannon Systems (Shanghai), 2012
# Author: gaoyan@shannon-data.com
#
PIC_FLAG_HOST=0
CUSTOMUSE_FLAG=1
CC=gcc -m64
ifeq (${CUSTOMUSE_FLAG},1)
para1=$(shell gcc -posix -E -dM - </dev/null |grep pic)

PIC_FLAG_CUSTOM=$(shell if [ ! "$(para1)" ]; then echo 0; else echo 1;fi)
CFLAGS=$(shell if [ "$(PIC_FLAG_CUSTOM)" -gt "$(PIC_FLAG_HOST)" ]; then echo "-no-pie"; fi)
CC+=$(CFLAGS)
endif

TARGETS=shannon-format shannon-beacon shannon-attach shannon-detach shannon-status shannon-firmwareupdate\
	shannon-pool shannon-cps-op shannon-phy-op
TARGETS_DEBUG+=shannon-unload
OBJFORMAT=format.o common.o
OBJATTACH=attach.o common.o
OBJDETACH=detach.o common.o
OBJSTATUS=status.o common.o
OBJBEACON=beacon.o common.o
OBJUPDATE=update.o common.o md5.o
OBJPOOL=pool.o common.o
OBJREGSOP=regs-op.o common.o
OBJCPSOP=cps-op.o common.o
OBJUNLOAD=unload.o common.o
OBJPHY=phy-op.o common.o

.PHONY: all install clean uninstall

ifeq (${DEBUG},1)
all: $(TARGETS) $(TARGETS_DEBUG)
else
all: $(TARGETS)
endif



shannon-firmwareupdate: $(OBJUPDATE)
	$(CC) -o shannon-firmwareupdate $(OBJUPDATE)
shannon-format: $(OBJFORMAT)
	$(CC) -o shannon-format $(OBJFORMAT) -lpthread
shannon-beacon: $(OBJBEACON)
	$(CC) -o shannon-beacon $(OBJBEACON)
shannon-attach: $(OBJATTACH)
	$(CC) -o shannon-attach $(OBJATTACH)
shannon-detach: $(OBJDETACH)
	$(CC) -o shannon-detach $(OBJDETACH)
shannon-status: $(OBJSTATUS)
	$(CC) -o shannon-status $(OBJSTATUS) -lncurses
shannon-pool: $(OBJPOOL)
	$(CC) -o shannon-pool $(OBJPOOL)
shannon-regs-op: $(OBJREGSOP)
	$(CC) -o shannon-regs-op $(OBJREGSOP)
shannon-cps-op: $(OBJCPSOP)
	$(CC) -o shannon-cps-op $(OBJCPSOP)
shannon-unload: $(OBJUNLOAD)
	$(CC) -o shannon-unload $(OBJUNLOAD)
shannon-phy-op: $(OBJPHY)
	$(CC) -o shannon-phy-op $(OBJPHY)


install: $(TARGETS)
	install -d $(DESTDIR)/usr/bin/ $(DESTDIR)/lib/udev/rules.d/
	install $(TARGETS) $(DESTDIR)/usr/bin/
	install shannon-bugreport $(DESTDIR)/usr/bin/
	install shannon-eject $(DESTDIR)/usr/bin/
	install shannon-irqbind $(DESTDIR)/usr/bin/
	install -m 644 60-persistent-storage-shannon.rules $(DESTDIR)/lib/udev/rules.d/
uninstall:
	rm -rf $(DESTDIR)/usr/bin/shannon-format
	rm -rf $(DESTDIR)/usr/bin/shannon-beacon
	rm -rf $(DESTDIR)/usr/bin/shannon-attach
	rm -rf $(DESTDIR)/usr/bin/shannon-detach
	rm -rf $(DESTDIR)/usr/bin/shannon-status
	rm -rf $(DESTDIR)/usr/bin/shannon-pool
	rm -rf $(DESTDIR)/usr/bin/shannon-regs-op
	rm -rf $(DESTDIR)/usr/bin/shannon-cps-op
	rm -rf $(DESTDIR)/usr/bin/shannon-phy-op
	rm -rf $(DESTDIR)/usr/bin/shannon-bugreport
	rm -rf $(DESTDIR)/usr/bin/shannon-eject
	rm -rf $(DESTDIR)/usr/bin/shannon-firmwareupdate
	rm -rf $(DESTDIR)/usr/bin/shannon-irqbind
	rm -rf $(DESTDIR)/lib/udev/rules.d/60-persistent-storage-shannon.rules

clean:
	rm -rf $(TARGETS) $(TARGETS_DEBUG)
purge:
	rm -rf $(TARGETS)
	rm -rf *.o
