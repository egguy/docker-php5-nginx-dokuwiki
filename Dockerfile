FROM ubuntu:precise

MAINTAINER Etienne Guilluy "etienne.guilluy@gmail.com"

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install dialog net-tools lynx nano wget
RUN apt-get -y install python-software-properties
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:ondrej/php5
RUN apt-get update

RUN apt-get -y install nginx php5-fpm php-apc php5-imagick php5-mcrypt

ADD ./default /etc/nginx/sites-available/default
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir /var/www
ADD ./dokuwiki /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80

CMD /usr/sbin/php5-fpm && nginx
