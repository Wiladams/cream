local ffi = require("ffi")



-- Utilities for command-line parsing.

require ("ovs.lib.compiler")

ffi.cdef[[
struct option;

/* Command handler context */
struct ovs_cmdl_context {
    /* number of command line arguments */
    int argc;
    /* array of command line arguments */
    char **argv;
    /* private context data defined by the API user */
    void *pvt;
};

typedef void (*ovs_cmdl_handler)(struct ovs_cmdl_context *);

struct ovs_cmdl_command {
    const char *name;
    const char *usage;
    int min_args;
    int max_args;
    ovs_cmdl_handler handler;
};
]]

ffi.cdef[[
char *ovs_cmdl_long_options_to_short_options(const struct option *options);
void ovs_cmdl_print_options(const struct option *options);
void ovs_cmdl_print_commands(const struct ovs_cmdl_command *commands);
void ovs_cmdl_run_command(struct ovs_cmdl_context *, const struct ovs_cmdl_command[]);

void ovs_cmdl_proctitle_init(int argc, char **argv);
void ovs_cmdl_proctitle_restore(void);
]]

if ffi.os() == "freebsd" or ffi.os() == "netbsd" then
--#define ovs_cmdl_proctitle_set setproctitle
else
--void ovs_cmdl_proctitle_set(const char *, ...)
--    OVS_PRINTF_FORMAT(1, 2);
end


