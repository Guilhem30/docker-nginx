FROM		guilhem30/sudokeys
MAINTAINER	Guilhem Berna  <guilhem.berna@gmail.com>

RUN apt-get update && apt-get install -yq \
	nginx \
	python-flup 

ENV autostart true
ENV autoconf false
ENV SEAFILE_IP seafile-container
ENV SEAHUB_PORT 8000
ENV FILESERVER_PORT 8082

#Nginx configuration at startup
RUN mkdir -p /etc/my_init.d
COPY setup_nginx.sh /etc/my_init.d/setup_nginx.sh
COPY nginx.conf /root/seafile.conf
#Nginx daemon
RUN mkdir /etc/service/nginx 
COPY run_nginx.sh /etc/service/nginx/run

VOLUME ["/etc/nginx/", "/var/log/nginx"]

EXPOSE 80 443

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]

# Clean up for smaller image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
