# Use Ubuntu 14.10 as base image
# FROM ubuntu:utopic
# Add Ubuntu mirrors
# RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt utopic main universe multiverse' > /etc/apt/sources.list

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

# Apache2
RUN apt-get install -y apache2

# PHP + Modules
RUN apt-get install -y php5 libapache2-mod-php5 php5-curl php5-mcrypt php5-gd php5-cli php5-sqlite php-apc php5-memcached memcached php5-mcrypt php5-svn php5-imagick php5-common php5-intl php5-pgsql php5-mysql

# Apache2 ModRewrite
RUN a2enmod rewrite &&\ 
    sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/var\/www\n<Directory\ "\/var\/www">\n\ AllowOverride\ All\n<\/Directory>\n/g' /etc/apache2/sites-available/000-default.conf &&\
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

# Pecl_HTML
RUN apt-get update
# RUN apt-get install -y pear
RUN apt-get install -y php-pear 
RUN apt-get install -y php-http
RUN apt-get install -y php5-dev
RUN apt-get install -y libcurl3
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN pear config-set php_ini /etc/php5/apache2/php.ini
RUN pecl config-set php_ini /etc/php5/apache2/php.ini
RUN pecl install raphf 
RUN pecl channel-update pecl.php.net
RUN pecl install pecl_http-1.7.6
RUN echo "extension = raphf.so"     >> /etc/php5/apache2/php.ini &&\
    echo "extension = propro.so"    >> /etc/php5/apache2/php.ini &&\
    echo "extension = hash.so"      >> /etc/php5/apache2/php.ini &&\
    echo "extension = iconv.so"     >> /etc/php5/apache2/php.ini &&\
    echo "extension = json.so"      >> /etc/php5/apache2/php.ini &&\
    echo "extension = http.so"      >> /etc/php5/apache2/php.ini
RUN service apache2 restart

# Vhosts - Hosts
ADD ./vhost_backend /etc/apache2/sites-available/myvhost_backend.conf
ADD ./vhost_static /etc/apache2/sites-available/myvhost_static.conf

# Hosts del Container
RUN echo "127.0.0.1 api.yeswead.local yeswead.local www.yeswead.local cdn.yeswead.local localhost" >> /etc/hosts &&\
    echo yeswead > /etc/hostname

# Upgrade
# RUN apt-get upgrade -y

RUN mkdir /var/www/backend

# Entrypoint
ADD ./startup.sh /root/run.sh
RUN chmod +x /root/run.sh
ENTRYPOINT ["/root/run.sh"]

# Ports SSL-Apache
EXPOSE 22 80 9000

