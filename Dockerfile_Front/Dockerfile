# Use Ubuntu 14.10 as base image
# FROM ubuntu:utopic
# Add Ubuntu mirrors
# RUN echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt utopic main universe multiverse' > /etc/apt/sources.list

# Use Ubuntu 14.04 as base image
FROM ubuntu:14.04
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
RUN apt-get install -y php5 libapache2-mod-php5 php5-curl php5-mcrypt php5-gd php5-cli php5-sqlite php-apc php5-memcached memcached php5-mcrypt php5-svn php5-imagick php5-common php5-intl php5-pgsql php5-mysql php-gettext

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

# Pecl_HTML
RUN apt-get update
RUN apt-get install -y php-http php-pear php-apc php5 php5-cli php5-common php5-curl php5-dev php5-gd php5-mcrypt libcurl4-openssl-dev &&\
    pecl channel-update pecl.php.net &&\
    pecl install pecl_http-1.7.6
RUN echo "extension = raphf.so"     >> /etc/php5/apache2/php.ini &&\
    echo "extension = propro.so"    >> /etc/php5/apache2/php.ini &&\
    echo "extension = hash.so"      >> /etc/php5/apache2/php.ini &&\
    echo "extension = iconv.so"     >> /etc/php5/apache2/php.ini &&\
    echo "extension = json.so"      >> /etc/php5/apache2/php.ini &&\
    echo "extension = http.so"      >> /etc/php5/apache2/php.ini

# Vhosts - Hosts
ADD ./vhost_frontend /etc/apache2/sites-available/myvhost_frontend.conf
ADD ./vhost_static /etc/apache2/sites-available/myvhost_static.conf

# Apache2 Mod Expires
RUN a2enmod expires
RUN service apache2 restart

# Hosts del Container
RUN echo "127.0.0.1 yeswead.local www.yeswead.local cdn.yeswead.local localhost" >> /etc/hosts &&\
	echo "172.17.42.1 api.yeswead.local" >> /etc/hosts &&\
    echo yeswead > /etc/hostname

# Upgrade
# RUN apt-get upgrade -y

# WebRoot
RUN mkdir /var/www/frontend

# Locales Faltantes
RUN locale-gen es_AR es_AR.UTF-8 &&\
    locale-gen pt_BR pt_BR.UTF-8 &&\
    dpkg-reconfigure locales

# Entrypoint
ADD ./onruncontainer.sh /root/run.sh
RUN chmod +x /root/run.sh
ENTRYPOINT ["/root/run.sh"]

# Ports SSL-Apache
EXPOSE 22 80 9000

