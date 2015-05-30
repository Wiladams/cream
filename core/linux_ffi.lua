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


ffi.cdef[[
typedef long ssize_t;

typedef uint32_t in_addr_t;

typedef uint16_t in_port_t;

typedef unsigned short int sa_family_t;
typedef unsigned int socklen_t;

]]

ffi.cdef[[
struct in_addr {
    in_addr_t       s_addr;
};

struct in6_addr {
  unsigned char  s6_addr[16];
};
]]

ffi.cdef[[
/* Structure describing a generic socket address.  */
struct sockaddr {
  sa_family_t   sa_family;
  char          sa_data[14];
};
]]

ffi.cdef[[
struct sockaddr_in {
  sa_family_t     sin_family;
  in_port_t       sin_port;
  struct in_addr  sin_addr;
    unsigned char sin_zero[sizeof (struct sockaddr) -
      (sizeof (unsigned short int)) -
      sizeof (in_port_t) -
      sizeof (struct in_addr)];
};
]]


local sockaddr_in = ffi.typeof("struct sockaddr_in");
local sockaddr_in_mt = {
  __new = function(ct, address, port, family)
      family = family or exports.AF_INET;

      local sa = ffi.new(ct)
      sa.sin_family = family;
      sa.sin_port = exports.htons(port)
      if type(address) == "number" then
        addr.sin_addr.s_addr = address;
      elseif type(address) == "string" then
        local inp = ffi.new("struct in_addr")
        local ret = ffi.C.inet_aton (address, inp);
        sa.sin_addr.s_addr = inp.s_addr;
      end

      return sa;
  end;

  __index = {
    setPort = function(self, port)
      self.sin_port = exports.htons(port);
      return self;
    end,
  },

}
ffi.metatype(sockaddr_in, sockaddr_in_mt);
exports.sockaddr_in = sockaddr_in;

ffi.cdef[[
struct sockaddr_in6 {
  uint8_t         sin6_len;
  sa_family_t     sin6_family;
  in_port_t       sin6_port;
  uint32_t        sin6_flowinfo;
  struct in6_addr sin6_addr;
  uint32_t        sin6_scope_id;
};

struct sockaddr_un
{
    sa_family_t sun_family;
    char sun_path[108];
};

struct sockaddr_storage {
//  uint8_t       ss_len;
  sa_family_t   ss_family;
  char          __ss_pad1[6];
  int64_t       __ss_align;
  char          __ss_pad2[128 - 2 - 8 - 6];
};



/* Structure used to manipulate the SO_LINGER option.  */
struct linger
  {
    int l_onoff;    /* Nonzero to linger on close.  */
    int l_linger;   /* Time to linger.  */
  };

struct ethhdr {
  unsigned char   h_dest[6];
  unsigned char   h_source[6];
  unsigned short  h_proto; /* __be16 */
} __attribute__((packed));

struct udphdr {
  uint16_t source;
  uint16_t dest;
  uint16_t len;
  uint16_t check;
};

]]

ffi.cdef[[
int close(int fd);
int fcntl (int __fd, int __cmd, ...);
int ioctl (int __fd, unsigned long int __request, ...);

ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);
]]

ffi.cdef[[
int inet_aton (__const char *__cp, struct in_addr *__inp);
char *inet_ntoa (struct in_addr __in);
]]



ffi.cdef[[
int socket(int domain, int type, int protocol);
int socketpair(int domain, int type, int protocol, int sv[2]);
ssize_t recv(int sockfd, void *buf, size_t len, int flags);
ssize_t send(int sockfd, const void *buf, size_t len, int flags);
ssize_t sendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen);
ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen);
ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);
int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen);
int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen);
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
int listen(int sockfd, int backlog);
int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
int accept4(int sockfd, void *addr, socklen_t *addrlen, int flags);
int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
int shutdown(int sockfd, int how);
int sendmmsg(int sockfd, struct mmsghdr *msgvec, unsigned int vlen, unsigned int flags);
int recvmmsg(int sockfd, struct mmsghdr *msgvec, unsigned int vlen, unsigned int flags, struct timespec *timeout);
]]



ffi.cdef[[
struct addrinfo {
  int     ai_flags;          // AI_PASSIVE, AI_CANONNAME, ...
  int     ai_family;         // AF_xxx
  int     ai_socktype;       // SOCK_xxx
  int     ai_protocol;       // 0 (auto) or IPPROTO_TCP, IPPROTO_UDP 

  socklen_t  ai_addrlen;     // length of ai_addr
  struct sockaddr  *ai_addr; // binary address
  char   *ai_canonname;      // canonical name for nodename
  struct addrinfo  *ai_next; // next structure in linked list
};

int getaddrinfo(const char *nodename, const char *servname,
                const struct addrinfo *hints, struct addrinfo **res);

void freeaddrinfo(struct addrinfo *ai);
]]


return exports


