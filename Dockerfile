
# Use Ubuntu 14.04 as base image
FROM ubuntu:trusty

# Add Ubuntu mirrors
# RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main universe multiverse' > /etc/apt/sources.list

# Update package lists
RUN apt-get update --fix-missing

# Root Password
RUN echo testpass > /root/pw.txt &&\
    echo "root:$(cat /root/pw.txt)" | chpasswd

# Apache2
RUN apt-get install -y apache2

# PHP + Modules
RUN apt-get install -y php5 libapache2-mod-php5 php5-curl php5-mcrypt php5-gd php5-cli php5-sqlite php-apc php5-memcached memcached php5-mcrypt php5-svn php5-imagick php5-common php5-intl php5-pgsql php5-mysql

# Apache2 ModRewrite
RUN a2enmod rewrite &&\ 
    sed -i 's/DocumentRoot\ \/var\/www\/yii/DocumentRoot\ \/var\/www\/yii\n<Directory\ "\/var\/www\/yii">\n\ AllowOverride\ All\n<\/Directory>/g' /etc/apache2/sites-available/000-default.conf &&\ 
    service apache2 restart

# PHP php.ini Configuration
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php5/apache2/php.ini  &&\
	sed -i 's/expose_php = On/expose_php = Off/g' /etc/php5/apache2/php.ini &&\
	service apache2 restart

# Xdebug
RUN apt-get install -y php5-xdebug
RUN mkdir /var/log/xdebug &&\ 
    chown www-data:www-data /var/log/xdebug
RUN echo xdebug.remote_enable=1 > /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.remote_autostart=0 >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.remote_connect_back=0 >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.remote_port=9001 >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.remote_host=172.17.42.1 >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.remote_mode=req >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    echo xdebug.max_nesting_level = 10000 >> /etc/php5/apache2/conf.d/xdebug.ini &&\
    service apache2 restart

# SSH
RUN apt-get install -y openssh-server 
RUN mkdir /var/run/sshd &&\
    chmod 755 /var/run/sshd &&\
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&\
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config &&\
    start ssh

# Nano
RUN apt-get install -y nano

# Subversion
RUN apt-get install -y subversion

# Curl
RUN apt-get install -y curl

# Composer
RUN curl -s http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require "fxp/composer-asset-plugin:1.0.0"

# Vhosts - Hosts
ADD ./vhost /etc/apache2/sites-available/myvhost.conf
RUN mkdir /var/www/yii

# Upgrade
RUN apt-get upgrade -y

# Entrypoint
ADD ./startup.sh /root/run.sh
RUN chmod +x /root/run.sh
ENTRYPOINT ["/root/run.sh"]

# Ports SSL-Apache-XDEBUG
EXPOSE 22 80 9000

