#!/bin/bash
set -x

/root/populate_hosts.sh

sleep 5

/usr/sbin/sshd -D
