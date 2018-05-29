FROM centos:latest
LABEL maintainer="Vicente Zepeda <chente.z.m@gmail.com>"

ENV nginxversion="1.12.2-1" \
    os="centos" \
    osversion="7" \
    elversion="7_4"

RUN yum install -y wget openssl sed &&\
    yum -y autoremove &&\
    yum clean all &&\
    wget http://nginx.org/packages/$os/$osversion/x86_64/RPMS/nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    rpm -iv nginx-$nginxversion.el$elversion.ngx.x86_64.rpm &&\
    sed -i '1i\
    daemon off;\
    ' /etc/nginx/nginx.conf

# install supervisord
RUN yum -y install python-setuptools && \
	easy_install supervisor && \
	echo_supervisord_conf > /etc/supervisord.conf && \
	mkdir -p /var/log/supervisor && \
	mkdir -p /var/log/supervisor && \
	sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf && \
	mkdir /etc/supervisord.d && \
	echo [include] >> /eervisord.conf && \
	echo 'files = /etc/supervisord.d/*.ini' >> /etc/supervisord.conf

#install nodejs
RUN yum -y install git && \
    curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum -y install nodejs && \
    yum -y install yarn && \
    yum -y install gcc-c++ make && \
    yum -y install libgcrypt-devel && \
    ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4
    
CMD ["nginx"]
