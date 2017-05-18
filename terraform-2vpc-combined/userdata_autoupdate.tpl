#!/bin/bash -v

export ETCDCTL_PEERS=https://${USERNAME}:${PASSWORD}@$(dig +noall +answer ${ETCD_DISCOVER} srv | awk '{print $8 ":" $7}')

#Add vRouter metadata to etcd for consumption
export MAC=$(curl -s http://169.254.169.254/latest/meta-data/mac)
export CIDR=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$$MAC/vpc-ipv4-cidr-block)
export PUBLIC_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
export LOCAL_HOSTNAME="$(hostname)"
export SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$$MAC/subnet-id)
export SECURITY_GROUP_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$$MAC/security-group-ids)
export INTERFACE_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$$MAC/interface-id)
export VPC_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$$MAC/vpc-id)
export AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
export LOCAL_IP="$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/publichostname" -d value=$$PUBLIC_HOSTNAME
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/localhostname" -d value=$$LOCAL_HOSTNAME
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/publicip" -d value=$$PUBLIC_IP
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/eth0mac" -d value=$$MAC
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/vpccidr" -d value=$$CIDR
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/vpcid" -d value=$$VPC_ID
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/subnetid" -d value=$$SUBNET_ID
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/securitygroupid" -d value=$$SECURITY_GROUP_ID
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/interfaceid" -d value=$$INTERFACE_ID
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/availabilityzone" -d value=$$AVAILABILITY_ZONE
curl -Ss -XPUT "$${ETCDCTL_PEERS}/v2/keys/vrouters/$${VPC_ID}/localip" -d value=$$LOCAL_IP



monitor () {
  while true; do
    curl -Ss "${ETCDCTL_PEERS}/v2/keys/tinc-vpn.org/peers/?wait=true&recursive=true"

    # Don't fetch peers if curl returns an error
    if [ $? -ne 0 ]; then
      sleep 1m
      continue
    fi

    updatePeers
    killall -HUP tincd
  done
}
