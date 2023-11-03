#!/bin/bash

for USRN in $USERS; do
  	echo "Creating user $USRN"
	useradd -m -s /bin/bash $USRN \
    && echo "$USRN ALL=(ALL) NOPASSWD: $SUDO_CMD" >> /etc/sudoers
done

exec /usr/sbin/sshd -D -e