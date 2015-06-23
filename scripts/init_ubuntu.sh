#!/bin/bash

# This script is used to update yum.repos.d, remove all remote
# repos, and replace with local repo

cat << EOF | tee /etc/apt/sources.list
deb http://200.21.0.30/ubuntu/ trusty main restricted universe multiverse
deb http://200.21.0.30/ubuntu/ trusty-security main restricted universe multiverse
deb http://200.21.0.30/ubuntu/ trusty-updates main restricted universe multiverse
deb http://200.21.0.30/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://200.21.0.30/ubuntu/ trusty-backports main restricted universe multiverse
EOF

cat << EOF | tee /etc/apt/apt.conf.d/90forceyes
APT::Get::Assume-Yes "true";
APT::Get::force-yes "true";
EOF

apt-get update

exit 0
