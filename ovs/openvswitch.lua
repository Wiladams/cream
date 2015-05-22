
--#include <linux/types.h>

local ffi = require("ffi")

require("if_ether");

local exports = {}

ffi.cdef[[
typedef uint8_t		__u8;
typedef uint32_t 	__u32;
typedef uint64_t 	__u64;

typedef int16_t		__be16;
typedef int32_t		__be32;
]]

local __u32 = ffi.typeof("uint32_t");
local __u64 = ffi.typeof("uint64_t");

ffi.cdef[[
struct ovs_header {
	int dp_ifindex;
};
]]


exports.OVS_DATAPATH_FAMILY  = "ovs_datapath";
exports.OVS_DATAPATH_MCGROUP = "ovs_datapath";
exports.OVS_DATAPATH_VERSION = 0x1;

ffi.cdef[[
enum ovs_datapath_cmd {
	OVS_DP_CMD_UNSPEC,
	OVS_DP_CMD_NEW,
	OVS_DP_CMD_DEL,
	OVS_DP_CMD_GET,
	OVS_DP_CMD_SET
};
]]

ffi.cdef[[
enum ovs_datapath_attr {
	OVS_DP_ATTR_UNSPEC,
	OVS_DP_ATTR_NAME,		/* name of dp_ifindex netdev */
	OVS_DP_ATTR_UPCALL_PID,		/* Netlink PID to receive upcalls */
	OVS_DP_ATTR_STATS,		/* struct ovs_dp_stats */
	OVS_DP_ATTR_MEGAFLOW_STATS,	/* struct ovs_dp_megaflow_stats */
	__OVS_DP_ATTR_MAX
};
]]

exports.OVS_DP_ATTR_MAX = ffi.C.__OVS_DP_ATTR_MAX - 1;

ffi.cdef[[
struct ovs_dp_stats {
	__u64 n_hit;             /* Number of flow table matches. */
	__u64 n_missed;          /* Number of flow table misses. */
	__u64 n_lost;            /* Number of misses not sent to userspace. */
	__u64 n_flows;           /* Number of flows present */
};

struct ovs_dp_megaflow_stats {
	__u64 n_mask_hit;	 /* Number of masks used for flow lookups. */
	__u32 n_masks;		 /* Number of masks for the datapath. */
	__u32 pad0;		 /* Pad for future expension. */
	__u64 pad1;		 /* Pad for future expension. */
	__u64 pad2;		 /* Pad for future expension. */
};

struct ovs_vport_stats {
	__u64   rx_packets;		/* total packets received       */
	__u64   tx_packets;		/* total packets transmitted    */
	__u64   rx_bytes;		/* total bytes received         */
	__u64   tx_bytes;		/* total bytes transmitted      */
	__u64   rx_errors;		/* bad packets received         */
	__u64   tx_errors;		/* packet transmit problems     */
	__u64   rx_dropped;		/* no space in linux buffers    */
	__u64   tx_dropped;		/* no space available in linux  */
};
]]


exports.OVSP_LOCAL =  __u32(0);


exports.OVS_PACKET_FAMILY  = "ovs_packet";
exports.OVS_PACKET_VERSION = 0x1;

ffi.cdef[[
enum ovs_packet_cmd {
	OVS_PACKET_CMD_UNSPEC,

	/* Kernel-to-user notifications. */
	OVS_PACKET_CMD_MISS,    /* Flow table miss. */
	OVS_PACKET_CMD_ACTION,  /* OVS_ACTION_ATTR_USERSPACE action. */

	/* Userspace commands. */
	OVS_PACKET_CMD_EXECUTE  /* Apply actions to a packet. */
};
]]

ffi.cdef[[
enum ovs_packet_attr {
	OVS_PACKET_ATTR_UNSPEC,
	OVS_PACKET_ATTR_PACKET,      /* Packet data. */
	OVS_PACKET_ATTR_KEY,         /* Nested OVS_KEY_ATTR_* attributes. */
	OVS_PACKET_ATTR_ACTIONS,     /* Nested OVS_ACTION_ATTR_* attributes. */
	OVS_PACKET_ATTR_USERDATA,    /* OVS_ACTION_ATTR_USERSPACE arg. */
	__OVS_PACKET_ATTR_MAX
};
]]

exports.OVS_PACKET_ATTR_MAX = ffi.C.__OVS_PACKET_ATTR_MAX - 1;


exports.OVS_VPORT_FAMILY  = "ovs_vport";
exports.OVS_VPORT_MCGROUP = "ovs_vport";
exports.OVS_VPORT_VERSION = 0x1;

ffi.cdef[[
enum ovs_vport_cmd {
	OVS_VPORT_CMD_UNSPEC,
	OVS_VPORT_CMD_NEW,
	OVS_VPORT_CMD_DEL,
	OVS_VPORT_CMD_GET,
	OVS_VPORT_CMD_SET
};

enum ovs_vport_type {
	OVS_VPORT_TYPE_UNSPEC,
	OVS_VPORT_TYPE_NETDEV,   /* network device */
	OVS_VPORT_TYPE_INTERNAL, /* network device implemented by datapath */
	OVS_VPORT_TYPE_GRE,      /* GRE tunnel. */
	OVS_VPORT_TYPE_VXLAN,	 /* VXLAN tunnel. */
	__OVS_VPORT_TYPE_MAX
};
]]

exports.OVS_VPORT_TYPE_MAX = ffi.C.__OVS_VPORT_TYPE_MAX - 1;

ffi.cdef[[
enum ovs_vport_attr {
	OVS_VPORT_ATTR_UNSPEC,
	OVS_VPORT_ATTR_PORT_NO,	/* u32 port number within datapath */
	OVS_VPORT_ATTR_TYPE,	/* u32 OVS_VPORT_TYPE_* constant. */
	OVS_VPORT_ATTR_NAME,	/* string name, up to IFNAMSIZ bytes long */
	OVS_VPORT_ATTR_OPTIONS, /* nested attributes, varies by vport type */
	OVS_VPORT_ATTR_UPCALL_PID, /* u32 Netlink PID to receive upcalls */
	OVS_VPORT_ATTR_STATS,	/* struct ovs_vport_stats */
	__OVS_VPORT_ATTR_MAX
};
]]

exports.OVS_VPORT_ATTR_MAX = ffi.C.__OVS_VPORT_ATTR_MAX - 1;

ffi.cdef[[
enum {
	OVS_TUNNEL_ATTR_UNSPEC,
	OVS_TUNNEL_ATTR_DST_PORT, /* 16-bit UDP port, used by L4 tunnels. */
	__OVS_TUNNEL_ATTR_MAX
};
]]

exports.OVS_TUNNEL_ATTR_MAX = ffi.C.__OVS_TUNNEL_ATTR_MAX - 1;


exports.OVS_FLOW_FAMILY  = "ovs_flow";
exports.OVS_FLOW_MCGROUP = "ovs_flow";
exports.OVS_FLOW_VERSION = 0x1;

ffi.cdef[[
enum ovs_flow_cmd {
	OVS_FLOW_CMD_UNSPEC,
	OVS_FLOW_CMD_NEW,
	OVS_FLOW_CMD_DEL,
	OVS_FLOW_CMD_GET,
	OVS_FLOW_CMD_SET
};
]]

ffi.cdef[[
struct ovs_flow_stats {
	__u64 n_packets;         /* Number of matched packets. */
	__u64 n_bytes;           /* Number of matched bytes. */
};
]]

ffi.cdef[[
enum ovs_key_attr {
	OVS_KEY_ATTR_UNSPEC,
	OVS_KEY_ATTR_ENCAP,	/* Nested set of encapsulated attributes. */
	OVS_KEY_ATTR_PRIORITY,  /* u32 skb->priority */
	OVS_KEY_ATTR_IN_PORT,   /* u32 OVS dp port number */
	OVS_KEY_ATTR_ETHERNET,  /* struct ovs_key_ethernet */
	OVS_KEY_ATTR_VLAN,	/* be16 VLAN TCI */
	OVS_KEY_ATTR_ETHERTYPE,	/* be16 Ethernet type */
	OVS_KEY_ATTR_IPV4,      /* struct ovs_key_ipv4 */
	OVS_KEY_ATTR_IPV6,      /* struct ovs_key_ipv6 */
	OVS_KEY_ATTR_TCP,       /* struct ovs_key_tcp */
	OVS_KEY_ATTR_UDP,       /* struct ovs_key_udp */
	OVS_KEY_ATTR_ICMP,      /* struct ovs_key_icmp */
	OVS_KEY_ATTR_ICMPV6,    /* struct ovs_key_icmpv6 */
	OVS_KEY_ATTR_ARP,       /* struct ovs_key_arp */
	OVS_KEY_ATTR_ND,        /* struct ovs_key_nd */
	OVS_KEY_ATTR_SKB_MARK,  /* u32 skb mark */
	OVS_KEY_ATTR_TUNNEL,    /* Nested set of ovs_tunnel attributes */
	OVS_KEY_ATTR_SCTP,      /* struct ovs_key_sctp */
	OVS_KEY_ATTR_TCP_FLAGS,	/* be16 TCP flags. */

	__OVS_KEY_ATTR_MAX
};
]]


exports.OVS_KEY_ATTR_MAX = ffi.C.__OVS_KEY_ATTR_MAX - 1;

ffi.cdef[[
enum ovs_tunnel_key_attr {
	OVS_TUNNEL_KEY_ATTR_ID,                 /* be64 Tunnel ID */
	OVS_TUNNEL_KEY_ATTR_IPV4_SRC,           /* be32 src IP address. */
	OVS_TUNNEL_KEY_ATTR_IPV4_DST,           /* be32 dst IP address. */
	OVS_TUNNEL_KEY_ATTR_TOS,                /* u8 Tunnel IP ToS. */
	OVS_TUNNEL_KEY_ATTR_TTL,                /* u8 Tunnel IP TTL. */
	OVS_TUNNEL_KEY_ATTR_DONT_FRAGMENT,      /* No argument, set DF. */
	OVS_TUNNEL_KEY_ATTR_CSUM,               /* No argument. CSUM packet. */
	__OVS_TUNNEL_KEY_ATTR_MAX
};
]]

exports.OVS_TUNNEL_KEY_ATTR_MAX = ffi.C.__OVS_TUNNEL_KEY_ATTR_MAX - 1;


ffi.cdef[[
enum ovs_frag_type {
	OVS_FRAG_TYPE_NONE,
	OVS_FRAG_TYPE_FIRST,
	OVS_FRAG_TYPE_LATER,
	__OVS_FRAG_TYPE_MAX
};
]]

--#define OVS_FRAG_TYPE_MAX (__OVS_FRAG_TYPE_MAX - 1)

ffi.cdef[[
struct ovs_key_ethernet {
	__u8	 eth_src[ETH_ALEN];
	__u8	 eth_dst[ETH_ALEN];
};

struct ovs_key_ipv4 {
	__be32 ipv4_src;
	__be32 ipv4_dst;
	__u8   ipv4_proto;
	__u8   ipv4_tos;
	__u8   ipv4_ttl;
	__u8   ipv4_frag;	/* One of OVS_FRAG_TYPE_*. */
};

struct ovs_key_ipv6 {
	__be32 ipv6_src[4];
	__be32 ipv6_dst[4];
	__be32 ipv6_label;	/* 20-bits in least-significant bits. */
	__u8   ipv6_proto;
	__u8   ipv6_tclass;
	__u8   ipv6_hlimit;
	__u8   ipv6_frag;	/* One of OVS_FRAG_TYPE_*. */
};

struct ovs_key_tcp {
	__be16 tcp_src;
	__be16 tcp_dst;
};

struct ovs_key_udp {
	__be16 udp_src;
	__be16 udp_dst;
};

struct ovs_key_sctp {
	__be16 sctp_src;
	__be16 sctp_dst;
};

struct ovs_key_icmp {
	__u8 icmp_type;
	__u8 icmp_code;
};

struct ovs_key_icmpv6 {
	__u8 icmpv6_type;
	__u8 icmpv6_code;
};

struct ovs_key_arp {
	__be32 arp_sip;
	__be32 arp_tip;
	__be16 arp_op;
	__u8   arp_sha[ETH_ALEN];
	__u8   arp_tha[ETH_ALEN];
};

struct ovs_key_nd {
	__u32 nd_target[4];
	__u8  nd_sll[ETH_ALEN];
	__u8  nd_tll[ETH_ALEN];
};
]]


ffi.cdef[[
enum ovs_flow_attr {
	OVS_FLOW_ATTR_UNSPEC,
	OVS_FLOW_ATTR_KEY,       /* Sequence of OVS_KEY_ATTR_* attributes. */
	OVS_FLOW_ATTR_ACTIONS,   /* Nested OVS_ACTION_ATTR_* attributes. */
	OVS_FLOW_ATTR_STATS,     /* struct ovs_flow_stats. */
	OVS_FLOW_ATTR_TCP_FLAGS, /* 8-bit OR'd TCP flags. */
	OVS_FLOW_ATTR_USED,      /* u64 msecs last used in monotonic time. */
	OVS_FLOW_ATTR_CLEAR,     /* Flag to clear stats, tcp_flags, used. */
	OVS_FLOW_ATTR_MASK,      /* Sequence of OVS_KEY_ATTR_* attributes. */
	__OVS_FLOW_ATTR_MAX
};
]]

exports.OVS_FLOW_ATTR_MAX = ffi.C.__OVS_FLOW_ATTR_MAX - 1;

ffi.cdef[[
enum ovs_sample_attr {
	OVS_SAMPLE_ATTR_UNSPEC,
	OVS_SAMPLE_ATTR_PROBABILITY, /* u32 number */
	OVS_SAMPLE_ATTR_ACTIONS,     /* Nested OVS_ACTION_ATTR_* attributes. */
	__OVS_SAMPLE_ATTR_MAX,
};
]]


exports.OVS_SAMPLE_ATTR_MAX = ffi.C.__OVS_SAMPLE_ATTR_MAX - 1;

ffi.cdef[[
enum ovs_userspace_attr {
	OVS_USERSPACE_ATTR_UNSPEC,
	OVS_USERSPACE_ATTR_PID,	      /* u32 Netlink PID to receive upcalls. */
	OVS_USERSPACE_ATTR_USERDATA,  /* Optional user-specified cookie. */
	__OVS_USERSPACE_ATTR_MAX
};
]]

exports.OVS_USERSPACE_ATTR_MAX = ffi.C.__OVS_USERSPACE_ATTR_MAX - 1;

ffi.cdef[[
struct ovs_action_push_vlan {
	__be16 vlan_tpid;	/* 802.1Q TPID. */
	__be16 vlan_tci;	/* 802.1Q TCI (VLAN ID and priority). */
};
]]

ffi.cdef[[
enum ovs_action_attr {
	OVS_ACTION_ATTR_UNSPEC,
	OVS_ACTION_ATTR_OUTPUT,	      /* u32 port number. */
	OVS_ACTION_ATTR_USERSPACE,    /* Nested OVS_USERSPACE_ATTR_*. */
	OVS_ACTION_ATTR_SET,          /* One nested OVS_KEY_ATTR_*. */
	OVS_ACTION_ATTR_PUSH_VLAN,    /* struct ovs_action_push_vlan. */
	OVS_ACTION_ATTR_POP_VLAN,     /* No argument. */
	OVS_ACTION_ATTR_SAMPLE,       /* Nested OVS_SAMPLE_ATTR_*. */
	__OVS_ACTION_ATTR_MAX
};
]]

exports.OVS_ACTION_ATTR_MAX = ffi.C.__OVS_ACTION_ATTR_MAX - 1;

