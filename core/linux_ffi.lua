--linux_ffi.lua
--linux.lua
--[[
	ffi routines for Linux.  
	To get full *nix support, we should use ljsyscall as that 
	has already worked out all the cross platform details.
	For now, we just want to get a minimum ste of routines
	that will work with x86_64 Linux

	As soon as this file becomes a few hundred lines, it's time
	to abandon it and switch to ljsyscall
--]]
local ffi = require("ffi")

local exports = {}
local C = {}	-- C interop, or syscall


-- mostly from time.h
ffi.cdef[[
typedef int32_t       clockid_t;
typedef long          time_t;

struct timespec {
  time_t tv_sec;
  long   tv_nsec;
};

int clock_getres(clockid_t clk_id, struct timespec *res);
int clock_gettime(clockid_t clk_id, struct timespec *tp);
int clock_settime(clockid_t clk_id, const struct timespec *tp);
int clock_nanosleep(clockid_t clock_id, int flags, const struct timespec *request, struct timespec *remain);

static const int CLOCK_REALTIME			= 0;
static const int CLOCK_MONOTONIC			= 1;
static const int CLOCK_PROCESS_CPUTIME_ID	= 2;
static const int CLOCK_THREAD_CPUTIME_ID	= 3;
static const int CLOCK_MONOTONIC_RAW		= 4;
static const int CLOCK_REALTIME_COARSE		= 5;
static const int CLOCK_MONOTONIC_COARSE	= 6;
static const int CLOCK_BOOTTIME			= 7;
static const int CLOCK_REALTIME_ALARM		= 8;
static const int CLOCK_BOOTTIME_ALARM		= 9;
static const int CLOCK_SGI_CYCLE			= 10;	// Hardware specific 
static const int CLOCK_TAI					= 11;

]]


ffi.cdef[[
/* Flags to be passed to epoll_create1.  */
enum
  {
    EPOLL_CLOEXEC = 02000000
  };
]]

ffi.cdef[[
typedef union epoll_data {
  void *ptr;
  int fd;
  uint32_t u32;
  uint64_t u64;
} epoll_data_t;
]]


ffi.cdef([[
struct epoll_event {
int32_t events;
epoll_data_t data;
}]]..(ffi.arch == "x64" and [[__attribute__((__packed__));]] or [[;]]))



ffi.cdef[[
int epoll_create (int __size) ;
int epoll_create1 (int __flags) ;
int epoll_ctl (int __epfd, int __op, int __fd, struct epoll_event *__event) ;
int epoll_wait (int __epfd, struct epoll_event *__events, int __maxevents, int __timeout);

//int epoll_pwait (int __epfd, struct epoll_event *__events,
//			int __maxevents, int __timeout,
//			const __sigset_t *__ss);
]]



return exports


