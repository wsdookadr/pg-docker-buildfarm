FROM debian:9.4

MAINTAINER Me "me@me.com"

# Add amd64 architecture, update package list & install needed packages
RUN dpkg --add-architecture amd64 \
    && apt-get update \
    && apt-get -y install \
    openssh-server \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    git-core \
    libreadline-dev \
    bison \
    flex \
    zlib1g-dev \
    libxml2-dev \
    libxml2-utils \
    docbook \
    file

# Set locale (fix locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :
RUN echo "America/Los_Angeles" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

# Add the new user called postgres
RUN useradd -ms /bin/bash postgres

RUN mkdir /var/log/postgresql \
    /var/lib/postgresql \
    /usr/local/pgsql \
    && chown -R postgres:postgres /var/log/postgresql \
    /var/lib/postgresql \
    /usr/local/pgsql

# Clone the PostgreSQL upstream Git repository
RUN cd /root ; git clone https://github.com/postgres/postgres

# Enable X11Forwarding
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
RUN mkdir -p /var/run/sshd

# expose ssh port
EXPOSE 22

# Start ssh services.
CMD ["/usr/sbin/sshd", "-D"]
