FROM centos:latest
MAINTAINER https://github.com/CentOS/sig-cloud-instance-images

LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40

ARG NAME_REMOTE_SERVER

ENV nginxversion="1.12.2-1" \
    os="centos" \
    osversion="7" \
    elversion="7_4" \
    port_apache=6669 

RUN yum install -y wget openssl sed &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    sed -i '1i\
    daemon off;\
    ' /etc/nginx/nginx.conf && \
    rm -rf nginx*

    #sed -i s/80/${port_apache}/g /etc/httpd/conf/httpd.conf && \
    #sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /etc/httpd/conf/httpd.conf && \
    #echo "IncludeOptional conf.d/web/*.conf" >> /etc/httpd/conf/httpd.conf


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

#install composer 
ADD composer.phar /usr/sbin/composer

#config forever 
RUN mkdir -p /var/www/web/ecosystem
ADD remote_forever.json /var/www/web/ecosystem/remote_forever.json

# config nginx
RUN rm -rf /etc/nginx/nginx.conf

ADD remote_nginx.conf /etc/nginx/conf.d/${NAME_REMOTE_SERVER}.conf
ADD nginx.conf /etc/nginx/


# # add code remote
RUN mkdir -p /var/www/web/${NAME_REMOTE_SERVER}/workspace
COPY source_code* /var/www/web/${NAME_REMOTE_SERVER}/workspace

RUN sed -i s/remote.vicoders.com/${NAME_REMOTE_SERVER}/g /etc/nginx/conf.d/${NAME_REMOTE_SERVER}.conf && \
    sed -i s/remote.vicoders.com/${NAME_REMOTE_SERVER}/g /var/www/web/ecosystem/remote_forever.json

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run/mysql /usr/sbin/
ADD run/mysqldump /usr/sbin/

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
ENTRYPOINT ["forever", "start", "/var/www/web/ecosystem/remote_forever.json"]