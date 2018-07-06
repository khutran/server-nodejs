FROM centos:latest
MAINTAINER https://github.com/CentOS/sig-cloud-instance-images

LABEL Vendor="CentOS" \
  License=GPLv2 \
  Version=2.4.6-40

ENV nginxversion="1.12.2-1" \
  os="centos" \
  osversion="7" \
  elversion="7_4"

ARG NAME_SERVER='node.vicoders.com'
ARG HOST_NAME=127.0.0.1
ARG PORT=3000

# VOLUME /etc/nginx/conf.d

RUN yum install -y wget openssl sed &&\
  yum -y autoremove &&\
  yum clean all &&\
  wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
  rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
  sed -i '1i\
  daemon off;\
  ' /etc/nginx/nginx.conf && \
  rm -rf nginx* && \
  rm -rf /etc/nginx/conf.d/*

# install nodejs
RUN yum -y install git && \
  curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
  curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
  yum -y install nodejs && \
  yum -y install yarn && \
  yum -y install gcc-c++ make && \
  yum -y install libgcrypt-devel && \
  ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4 && \
  yum clean all

# install forever 
RUN npm install forever -g

#config forever 
RUN mkdir -p /var/www/config/ecosystem
ADD node_forever.json /var/www/config/ecosystem/${NAME_SERVER}.json

# config nginx
RUN rm -rf /etc/nginx/nginx.conf

ADD node_nginx.conf /etc/nginx/conf.d/${NAME_SERVER}.conf
ADD nginx.conf /etc/nginx/

RUN sed -i s/node.vicoders.com/${NAME_SERVER}/g /etc/nginx/conf.d/${NAME_SERVER}.conf && \
  sed -i s/127.0.0.1/${HOST_NAME}/g /etc/nginx/conf.d/${NAME_SERVER}.conf && \
  sed -i s/3000/${PORT}/g /etc/nginx/conf.d/${NAME_SERVER}.conf && \
  sed -i s/node.vicoders.com/${NAME_SERVER}/g /var/www/config/ecosystem/${NAME_SERVER}.json

WORKDIR /var/www/web/
VOLUME [ "/var/www/web" ]

RUN echo ${NAME_SERVER} > /home/name.txt

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run/mysql /usr/sbin/
ADD run/mysqldump /usr/sbin/

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

# WORKDIR /var/www/web/ecosystem

CMD ["/run-httpd.sh"]
