FROM debian:stable

MAINTAINER Me "me@me.com"

# Update package list
RUN dpkg --add-architecture amd64
RUN apt-get update

# Set locale (fix locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :
RUN echo "America/Los_Angeles" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# We need ssh to access the instance, and wget to download skype
RUN apt-get install -y openssh-server wget
RUN apt-get install -y apt-utils

RUN apt-get install -y gcc g++
RUN apt-get install -y git-core

# Enable X11Forwarding
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
RUN mkdir -p /var/run/sshd

# expose ssh port
EXPOSE 22

# # Start ssh services.
CMD ["/usr/sbin/sshd", "-D"]
