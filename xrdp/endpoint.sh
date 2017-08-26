#!/bin/bash -e

USER_ID=$(id -u)
GROUP_ID=$(id -g)
PASSWD=${PASSWD:-${DEFAULT_PASSWD}}
USER=${USER:-${DEFAULT_USER}}

# Generate container group
echo "GROUP_ID: $GROUP_ID"
if [ x"$GROUP_ID" != x"0" ]; then
    groupadd -g $GROUP_ID $USER
fi

# Generate container user
echo "USER_ID: $USER_ID"
if [ x"$USER_ID" != x"0" ]; then
    useradd -d /home/$USER -m -s /bin/bash -u $USER_ID -g $GROUP_ID $USER
fi

# Revert permissions
sudo chmod u-s /usr/sbin/useradd
sudo chmod u-s /usr/sbin/groupadd

# Set login use rname
USER=$(whoami)
echo "USER: $USER"

# Set login password
echo "PASSWD: $PASSWD"
echo ${USER}:${PASSWD} | sudo chpasswd

echo "#############################"

# Run XRDP server with tail in the foreground
sudo bash -c "/etc/init.d/xrdp start && tail -F /var/log/xrdp-sesman.log"
