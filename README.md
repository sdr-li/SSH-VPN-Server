# SSH-VPN-Server

### Introduction

SSH-VPN-Server is a docker container with OpenSSH server, which works as a VPN server. External peers are connecting using SSH protocol, which makes a risk of VPN connection detection smaller. SSH provides L3 tunneling (not the L4, which is usually mentioned in OpenSSH tunneling context) - which is non-so-well-known functionality provided by OpenSSH. This tool is docker image - designed to be the most lightweight - so uses Alpine Linux.

### Users

Users can be added to the SSH Server with a script - `ssh-vpn-server-files/scripts/create_user.sh`. After establishment of SSH connection, a Point2Point network (in sample config, with /30 prefix) will be used for communication between VPN server and client. On the server end, TUN interface will be created, dedicated for handling encapsulated network traffic from and to the user.

The examples can ilustrate how users should be configured.

### Routing

VPN Server can handle custom static routing - enabled with `STATIC_ROUTES=True` environmental in docker-compose.
Static routing should be defined in a `ssh-vpn-server-files/config/route` - there are already an examples.

### Firewall

VPN Server has also NFTables firewall - enabled with `ENABLE_FIREWALL=True` environmental in docker-compose.
Firewall configuration file should be located in `ssh-vpn-server-files/config/nftables.nft` - no example configuration is provided(YET!).

### Quick howto

0. Build Docker Image - `ssh-vpn-server-image/build.sh`
1. Generate servers SSH host keys - `ssh-vpn-server-files/scripts/generate_server_host_keys.sh` - the keys that identify THIS individual server.
2. Generate servers root SSH key - `ssh-vpn-server-files/scripts/generate_server_root_keys.sh` - the public/private key pair which allows for a safe login to root account at server -
3. Create some users - `ssh-vpn-server-files/scripts/create_user.sh` - two users are already created
4. Run `docker-compose up`

### Files needed by client for connection

Client should have following files, to be able to connect to server
- VPN configuration - `ssh-vpn-server-files/users/<username>/config`
- SSH Private key - `ssh-vpn-server-files/users/<username>/key`
- SSH Servers host public key - `ssh-vpn-server-files/config/ssh/server-host-keys/ssh_host_ed25519_key.pub` - used to verify ssh server

### How to establish VPN connection with such server
In this example we use "example_user_1" profile
- `sudo ip tuntap add mode tun user $USER name tun101`
- `sudo ip addr add 10.33.0.2/30 dev tun101`
- `sudo ip link set tun101 up`
- `ssh -i <private_key_path> example_user_1@10.123.2.2 -w 101:101`

Now, since the connection was established, the ping with the 10.33.0.1 machine, should work.
