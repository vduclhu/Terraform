#!/usr/bin/env bash

set -x

NS="global"
DEV=eth1
VETH="veth1"
ENIADDR="10.200.1.1"

# Remove namespace if it exists.
ip netns del $NS &>/dev/null

# Create namespace
ip netns add $NS

# Create veth link.
ip link add ${VETH} type veth peer name ${DEV}

# Add peer-1 to NS.
ip link set ${DEV} netns $NS

# Setup IP ${VPEER}.
ip netns exec $NS ip addr add ${ENIADDR}/24 dev ${DEV}
ip netns exec $NS ip link set ${DEV} up
ip netns exec $NS ip link set lo up

# Enable IP-forwarding.
echo 1 > /proc/sys/net/ipv4/ip_forward