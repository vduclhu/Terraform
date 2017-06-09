#!/bin/bash

export eip=$1

# associate Elastic IP
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk '{print $3}' | tr -d \")
aws ec2 attach-network-interface --network-interface-id "${eip}" --instance-id $INSTANCE_ID --device-index 1 --region $REGION
echo "auto eth1" > /etc/network/interfaces.d/eth1.cfg
echo "iface eth1 inet dhcp" >> /etc/network/interfaces.d/eth1.cfg
sudo ifup eth1

set -x

NS="global"
DEV=eth1
VETH="veth1"
ENIADDR="10.200.1.1"

cat << EOF > "/etc/network/interfaces.d/eth1.cfg"
auto eth1
iface eth1 inet static
EOF

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


