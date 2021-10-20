
# Install Cobalt Strike preresquites
apt-get -y install openjdk-8-jdk
# Debian 10:
#apt-get -y install openjdk-11-jdk

# Untar cobaltstrike archive, update if not already updated
tar -xvf cobaltstrike.tgz
cd /root/cobaltstrike
[ -f /root/cobaltstrike/cobaltstrike.auth ] || ./update

# Start cobaltstrike and enable auto-start after a reboot
chmod u+x /root/start-cobaltstrike.sh
systemctl start cobaltstrike
systemctl enable cobaltstrike
