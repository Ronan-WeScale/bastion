FROM debian:stable-slim

LABEL Author="Ronan Ducamp"

ENV TERM=xterm-256color

COPY /etc/apt/apt.conf.d/01proxy /etc/apt/apt.conf.d/01proxy
COPY ssh-user-auth.sh /usr/bin/ssh-user-auth.sh
COPY bastion-shell.sh /usr/bin/bastion-shell.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh

RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	   openssh-server net-tools telnet curl sudo \
	&& mkdir /var/run/sshd \
    && mkdir /var/log/bastion \
    && chmod 777 /var/log/bastion \
	&& echo "AuthorizedKeysCommand /usr/bin/ssh-user-auth.sh" >> /etc/ssh/sshd_config \
  	&& echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config \
    && echo "ForceCommand /usr/bin/bastion-shell.sh" >> /etc/ssh/sshd_config \
    && echo export PROMPT_COMMAND='echo "$(date "+%Y-%m-%d.%H:%M:%S") $(whoami) $(pwd) $(history 1)" >> /var/log/bastion/$(whoami)/`date "+%Y-%m-%d"`_`whoami`-history.log' >> /etc/environment \
	&& chmod 755 /usr/bin/ssh-user-auth.sh \
    && chmod 755 /usr/bin/bastion-shell.sh \
	&& chmod 755 /usr/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/usr/bin/entrypoint.sh"]