#!/bin/sh


read -r -p "Type username: " USERNAME
read -r -p "Type password: " PASSWORD
read -r -p "Type server-side IP (CIDR): " VPN_IF_IP_SERVER_SIDE
read -r -p "Type server-side TUN interface number: " VPN_IF_NUM_SERVER_SIDE
read -r -p "Type client-side IP (CIDR): " VPN_IF_IP_CLIENT_SIDE
read -r -p "Type client-side TUN interface number: " VPN_IF_NUM_CLIENT_SIDE

echo "Creating configuration for new user: $USERNAME"
USER_DIR="$PWD/../users/$USERNAME"
rm -r $USER_DIR

mkdir $USER_DIR

ssh-keygen -t rsa -P "" -C $USERNAME -f $USER_DIR/key -q

touch $USER_DIR/config
echo "USERNAME=$USERNAME" >> $USER_DIR/config
echo "PASSWORD=$PASSWORD" >> $USER_DIR/config
echo "VPN_IF_IP_SERVER_SIDE=$VPN_IF_IP_SERVER_SIDE" >> $USER_DIR/config
echo "VPN_IF_IP_CLIENT_SIDE=$VPN_IF_IP_CLIENT_SIDE" >> $USER_DIR/config
echo "VPN_IF_NUM_SERVER_SIDE=$VPN_IF_NUM_SERVER_SIDE" >> $USER_DIR/config
echo "VPN_IF_NUM_CLIENT_SIDE=$VPN_IF_NUM_CLIENT_SIDE" >> $USER_DIR/config
