#!/bin/sh
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 666 /dev/net/tun

if [ $ENABLE_FIREWALL = 'True' ]; then
    echo "Enabling firewall"
    rc-service nftables start
fi
if [ $STATIC_ROUTES = 'True' ]; then
    echo "Setting up static routes"
    rc-service staticroute start
fi

addgroup vpn-users
echo 'root':$ROOTPASS | chpasswd


### Creating directory for keys
mkdir /root/.ssh/
### Copying the root keys and host key
cp /appdata/config/ssh/server-root-keys/root.pub /root/.ssh/authorized_keys
cp /appdata/config/ssh/server-host-keys/* /etc/ssh/

### Going thru all the users, and creating them inside the "box"
for d in /appdata/users/* ; do
    echo $d/config
    source $d/config
    adduser $USERNAME vpn-users -D
    echo $USERNAME:$PASSWORD | chpasswd
    mkdir /home/$USERNAME/.ssh
    if test -f $d/key.pub; then
        cp $d/key.pub /home/$USERNAME/.ssh/authorized_keys
    fi
    USERID=$(id -u $USERNAME)
    addgroup $USERNAME vpn-users
    chown -R $USERID:vpn-users /home/$USERNAME
    ip tuntap add mode tun user $USERNAME name "tun"$VPN_IF_NUM_SERVER_SIDE
    ip addr add $VPN_IF_IP_SERVER_SIDE dev "tun"$VPN_IF_NUM_SERVER_SIDE
    ip link set "tun"$VPN_IF_NUM_SERVER_SIDE up
done

# /etc/init.d/networking restart
/usr/sbin/sshd -D -e
