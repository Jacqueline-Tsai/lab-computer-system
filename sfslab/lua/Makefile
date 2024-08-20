# Makefile for building Lua
# Specialized for building the Lua library in the context of sfslab

CC       = gcc
AR       = ar rcDs

CFLAGS   = -std=gnu11  -g -O2 -Wall
CPPFLAGS = -D_FORTIFY_SOURCE=2
LDFLAGS  = $(CFLAGS) -Wl,--as-needed
LIBS     = -lm

ALL      = liblua.a #lua  luac
CORE_O   = \
    lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o \
    llex.o lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o \
    ltable.o ltm.o lundump.o lvm.o lzio.o
LIB_O    = \
    lauxlib.o lbaselib.o ldblib.o liolib.o lmathlib.o \
    loslib.o lstrlib.o ltablib.o lutf8lib.o linit.o
LANES_O  = \
    lanes/cancel.o lanes/compat.o lanes/deep.o lanes/keeper.o lanes/lanes.o \
    lanes/linda.o lanes/state.o lanes/threading.o lanes/tools.o lanes/universe.o \
    lanes/lanes-lua.o

# Lua core is -Wextra clean, Lanes isn't.
$(CORE_O) $(LIB_O): CFLAGS += -Wextra

# Lanes needs to be able to find headers in the parent directory.
$(LANES_O) lua.o: CPPFLAGS += -I.

all: $(ALL)

liblua.a: $(CORE_O) $(LIB_O) $(LANES_O)
	$(AR) $@ $^

lua: LIBS += -lreadline
lua: lua.o liblua.a
	$(CC) -o $@ $(LDFLAGS) $^ $(LIBS)

# We need luac in order to byte-compile lanes.lua and then embed it in
# liblua.a, so luac cannot itself depend on liblua.a.
luac: luac.o $(CORE_O) lauxlib.o
	$(CC) -o $@ $(LDFLAGS) $^ $(LIBS)

# lanes.lua is byte-compiled and then .incbin'ed into lanes-lua.o.
lanes/lanes.luac: lanes/lanes.lua luac
	./luac -o $@ $<

# lanes-lua.c needs -Ilanes passed to the assembler as well as the
# compiler proper.  The dependency on lanes/lanes.luac is not visible
# to cc -MM.
lanes/lanes-lua.o: lanes/lanes.luac
lanes/lanes-lua.o: CFLAGS += -Wa,-Ilanes

clean:
	-rm -f *.o lanes/*.o *.luac lanes/*.luac $(ALL)

regen-deps:
	(sed -ne '1,/^## cut here ##$$/p' Makefile && \
	 $(CC) $(CPPFLAGS) -MM $(CORE_O:.o=.c) $(LIB_O:.o=.c) lua.c luac.c && \
	 $(CC) $(CPPFLAGS) -MM -I. $(LANES_O:.o=.c) | sed 's!^[^ ]!lanes/&!' \
	) > Makefile.n
	mv -f Makefile.n Makefile

# Targets that do not create files
.PHONY: all clean regen-deps

# Automatically generated .o: .[ch] dependency lists.
# Do not edit below this point; use 'make regen-deps' instead.
## cut here ##
lapi.o: lapi.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lstring.h \
 ltable.h lundump.h lvm.h
lcode.o: lcode.c lprefix.h lua.h luaconf.h lcode.h llex.h lobject.h \
 llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
 ldo.h lgc.h lstring.h ltable.h lvm.h
lctype.o: lctype.c lprefix.h lctype.h lua.h luaconf.h llimits.h
ldebug.o: ldebug.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h lcode.h llex.h lopcodes.h lparser.h \
 ldebug.h ldo.h lfunc.h lstring.h lgc.h ltable.h lvm.h
ldo.o: ldo.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lopcodes.h \
 lparser.h lstring.h ltable.h lundump.h lvm.h
ldump.o: ldump.c lprefix.h lua.h luaconf.h lobject.h llimits.h lstate.h \
 ltm.h lzio.h lmem.h lundump.h
lfunc.o: lfunc.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h
lgc.o: lgc.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h lstring.h ltable.h
llex.o: llex.c lprefix.h lua.h luaconf.h lctype.h llimits.h ldebug.h \
 lstate.h lobject.h ltm.h lzio.h lmem.h ldo.h lgc.h llex.h lparser.h \
 lstring.h ltable.h
lmem.o: lmem.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h
lobject.o: lobject.c lprefix.h lua.h luaconf.h lctype.h llimits.h \
 ldebug.h lstate.h lobject.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h \
 lvm.h
lopcodes.o: lopcodes.c lprefix.h lopcodes.h llimits.h lua.h luaconf.h
lparser.o: lparser.c lprefix.h lua.h luaconf.h lcode.h llex.h lobject.h \
 llimits.h lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h \
 ldo.h lfunc.h lstring.h lgc.h ltable.h
lstate.o: lstate.c lprefix.h lua.h luaconf.h lapi.h llimits.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h llex.h \
 lstring.h ltable.h
lstring.o: lstring.c lprefix.h lua.h luaconf.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h
ltable.o: ltable.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
ltm.o: ltm.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
lundump.o: lundump.c lprefix.h lua.h luaconf.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lstring.h lgc.h \
 lundump.h
lvm.o: lvm.c lprefix.h lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lgc.h lopcodes.h lstring.h \
 ltable.h lvm.h ljumptab.h
lzio.o: lzio.c lprefix.h lua.h luaconf.h llimits.h lmem.h lstate.h \
 lobject.h ltm.h lzio.h
lauxlib.o: lauxlib.c lprefix.h lua.h luaconf.h lauxlib.h
lbaselib.o: lbaselib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
ldblib.o: ldblib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
liolib.o: liolib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lmathlib.o: lmathlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
loslib.o: loslib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lstrlib.o: lstrlib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
ltablib.o: ltablib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
lutf8lib.o: lutf8lib.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h
linit.o: linit.c lprefix.h lua.h luaconf.h lualib.h lauxlib.h
lua.o: lua.c lprefix.h lua.h luaconf.h lauxlib.h lualib.h lanes/lanes.h \
 lanes/platform.h
luac.o: luac.c lprefix.h lua.h luaconf.h lauxlib.h ldebug.h lstate.h \
 lobject.h llimits.h ltm.h lzio.h lmem.h lopcodes.h lopnames.h lundump.h
lanes/cancel.o: lanes/cancel.c lanes/threading.h lanes/platform.h \
 lanes/cancel.h lua.h luaconf.h lualib.h lua.h lauxlib.h \
 lanes/uniquekey.h lanes/macros_and_utils.h lanes/tools.h lanes/deep.h \
 lanes/lanes_private.h
lanes/compat.o: lanes/compat.c lanes/compat.h lua.h luaconf.h lualib.h lua.h \
 lauxlib.h lanes/macros_and_utils.h
lanes/deep.o: lanes/deep.c lanes/compat.h lua.h luaconf.h lualib.h lua.h \
 lauxlib.h lanes/deep.h lanes/platform.h lanes/uniquekey.h \
 lanes/macros_and_utils.h lanes/tools.h lanes/threading.h \
 lanes/universe.h
lanes/keeper.o: lanes/keeper.c lanes/keeper.h lua.h luaconf.h lanes/threading.h \
 lanes/platform.h lanes/uniquekey.h lanes/macros_and_utils.h lualib.h \
 lua.h lanes/compat.h lauxlib.h lanes/tools.h lanes/deep.h lanes/state.h \
 lanes/universe.h
lanes/lanes.o: lanes/lanes.c lanes/lanes.h lua.h luaconf.h lanes/platform.h \
 lanes/threading.h lanes/compat.h lualib.h lua.h lauxlib.h lanes/tools.h \
 lanes/deep.h lanes/uniquekey.h lanes/macros_and_utils.h lanes/state.h \
 lanes/universe.h lanes/keeper.h lanes/lanes_private.h lanes/cancel.h
lanes/linda.o: lanes/linda.c lanes/threading.h lanes/platform.h lanes/compat.h \
 lua.h luaconf.h lualib.h lua.h lauxlib.h lanes/tools.h lanes/deep.h \
 lanes/uniquekey.h lanes/macros_and_utils.h lanes/universe.h \
 lanes/keeper.h lanes/lanes_private.h lanes/cancel.h
lanes/state.o: lanes/state.c lanes/compat.h lua.h luaconf.h lualib.h lua.h \
 lauxlib.h lanes/universe.h lanes/threading.h lanes/platform.h \
 lanes/tools.h lanes/deep.h lanes/uniquekey.h lanes/macros_and_utils.h \
 lanes/lanes.h
lanes/threading.o: lanes/threading.c lanes/threading.h lanes/platform.h
lanes/tools.o: lanes/tools.c lanes/tools.h lanes/threading.h lanes/platform.h \
 lanes/deep.h lua.h luaconf.h lanes/uniquekey.h lanes/macros_and_utils.h \
 lualib.h lua.h lanes/compat.h lauxlib.h lanes/universe.h lanes/keeper.h \
 lanes/lanes.h
lanes/universe.o: lanes/universe.c lanes/universe.h lua.h luaconf.h \
 lanes/threading.h lanes/platform.h lanes/compat.h lualib.h lua.h \
 lauxlib.h lanes/macros_and_utils.h lanes/uniquekey.h
lanes/lanes-lua.o: lanes/lanes-lua.c lua.h luaconf.h lauxlib.h lua.h \
 lanes/lanes.h lanes/platform.h
