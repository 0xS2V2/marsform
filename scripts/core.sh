
# Install common packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ferm curl tmux git socat netcat dnsutils build-essential

# Configure Ferm
mkdir -p /etc/ferm/ferm.d
cat << 'EOF' > /etc/ferm/ferm.conf
# Custom configuration file for ferm.

@include 'ferm.d/';

table filter {
    chain INPUT {
        policy DROP;
        mod state state INVALID DROP;
        mod state state (ESTABLISHED RELATED) ACCEPT;
        interface lo ACCEPT;
    }
    chain OUTPUT {
        policy ACCEPT;
        mod state state (ESTABLISHED RELATED) ACCEPT;
    }
    chain FORWARD {
        policy DROP;
        mod state state INVALID DROP;
        mod state state (ESTABLISHED RELATED) ACCEPT;
    }
}
EOF
systemctl reload ferm

# Adjust Timezone
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime

# Add swapfile
fallocate -l 1G /swapfile
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -q swapfile /etc/fstab || echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
sudo swapon --show

# End
touch /tmp/core.sh.done