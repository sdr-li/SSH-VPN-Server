#!/bin/sh

ssh-keygen -q -C "" -N "" -t ed25519 -f $PWD/../config/ssh/server-host-keys/ssh_host_ed25519_key
