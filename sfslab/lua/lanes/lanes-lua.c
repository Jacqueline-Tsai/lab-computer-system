// Wrapper to embed the byte-compiled lanes.lua in the library.

#include "lua.h"
#include "lauxlib.h"
#include "lanes/lanes.h"

// These "extern" declarations are actually satisfied by the assembly
// insert immediately below.  It would be more accurate (and generate
// tighter machine code) if they could be "static", but then the
// compiler would emit definitions for them, conflicting with the
// definitions coming from the assembly insert.

extern const char lanes_lua_compiled[];
extern const size_t lanes_lua_compiled_size;

// The easiest way to read the contents of a file into a const
// variable is with the .incbin assembly directive.  C2023 offers
// #embed, which would be cleaner (in particular, lanes_lua_compiled
// *could* be static, and we would not need lanes_lua_compiled_size),
// but as far as I can tell neither GCC nor Clang support it yet.
__asm__(".section .rodata,\"a\",@progbits\n"
        "\t.p2align 4\n"
        "\t.type lanes_lua_compiled,@object\n"
        "lanes_lua_compiled:\n"
        "\t.incbin \"lanes.luac\"\n"
        "0:\n"
        "\t.size lanes_lua_compiled, 0b - lanes_lua_compiled\n"
        "\t.p2align 3\n"
        "\t.type lanes_lua_compiled_size,@object\n"
        "lanes_lua_compiled_size:\n"
        "\t.quad 0b - lanes_lua_compiled\n"
        "\t.size lanes_lua_compiled_size, 8");

int LANES_API luaopen_lanes_lua(lua_State *L) {
    int status = luaL_loadbufferx(L, lanes_lua_compiled, lanes_lua_compiled_size,
                                  "lanes.lua", "b");
    if (__builtin_expect(status, LUA_OK) != LUA_OK) {
        lua_error(L);
        return 0;
    }
    lua_call(L, 0, 1);
    return 1;
}

int LANES_API luaopen_lanes(lua_State *L) {
    luaL_requiref(L, "lanes.core", luaopen_lanes_core, 0);
    lua_pop(L, 1);
    luaL_requiref(L, "lanes", luaopen_lanes_lua, 1);
    return 1;
}
