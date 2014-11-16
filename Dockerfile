FROM phusion/baseimage:latest

MAINTAINER Etienne Guilluy "etienne.guilluy@gmail.com"

ENV HOME /root
ENV LANG en_US.UTF-8
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]
EXPOSE 80

#RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install python-software-properties
RUN add-apt-repository -y ppa:nginx/stable
RUN add-apt-repository -y ppa:ondrej/php5
RUN apt-get update

RUN apt-get -y install nginx php5-fpm php-apc php5-imagick php5-mcrypt

ADD ./default /etc/nginx/sites-available/default
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN sed -i 's/\;daemonize = yes/daemonize = no/g' /etc/php5/fpm/php-fpm.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir -p /var/www
ADD ./dokuwiki /var/www
RUN chown -R www-data:www-data /var/www

RUN mkdir /etc/service/nginx
ADD run_scripts/nginx.sh /etc/service/nginx/run

RUN mkdir /etc/service/php5
ADD run_scripts/php5-fpm.sh /etc/service/php5/run

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
