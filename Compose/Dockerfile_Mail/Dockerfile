
# Use Ubuntu 14.04 as base image
FROM ubuntu:trusty
# Add Ubuntu mirrors
# RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main universe multiverse' > /etc/apt/sources.list

# Update package lists
RUN apt-get update --fix-missing

# Root Password
RUN echo testpass > /root/pw.txt &&\
    echo "root:$(cat /root/pw.txt)" | chpasswd

# Timezone
RUN echo America/Argentina/Buenos_Aires > /etc/timezone &&\
    dpkg-reconfigure -f noninteractive tzdata &&\
    locale-gen en_US en_US.UTF-8 &&\
    dpkg-reconfigure locales

# Dependencies
RUN apt-get update
RUN apt-get install -y build-essential software-properties-common
RUN apt-get install -y libsqlite3-dev ruby1.9.1-dev

# Install Mailcatcher
RUN sudo gem install mailcatcher

# SSH
RUN apt-get install -y openssh-server 
RUN mkdir /var/run/sshd &&\
    chmod 755 /var/run/sshd &&\
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&\
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config &&\
    start ssh

# Nano
RUN apt-get install -y nano

# Open Ports
EXPOSE 1080
EXPOSE 25
EXPOSE 22

# Entrypoint
ADD ./startup.sh /root/run.sh
RUN chmod +x /root/run.sh
ENTRYPOINT ["/root/run.sh"]
