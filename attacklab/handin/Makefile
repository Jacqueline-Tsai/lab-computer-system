# -*- Makefile -*- distributed to students.
# It is automatically invoked by ctarget and rtarget when appropriate,
# and should not be necessary to use manually.

AUTOLAB = autolab

include .labname.mk

SOLUTIONS := $(wildcard [cr]target.l?)

all: handin.tar

submit: handin.tar
	$(AUTOLAB) submit $(COURSECODE):$(LAB) $<

handin.tar: $(SOLUTIONS) target-id.txt
	tar cf $@.T $^
	mv -f $@.T $@

.PHONY: all submit
