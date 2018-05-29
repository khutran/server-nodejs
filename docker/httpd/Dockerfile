FROM centos:latest
MAINTAINER https://github.com/CentOS/sig-cloud-instance-images

LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y install epel-release && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all && \ 
    yum -y install wget && \
    yum -y install yum-changelog && \
    yum changelog httpd && \
    cd /etc/yum.repos.d && \
    wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo && \
    yum -y install httpd && \
    mkdir /etc/httpd/conf.d/web && \
    sed -i s/80/6669/g /etc/httpd/conf/httpd.conf && \
    sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /etc/httpd/conf/httpd.conf && \
    echo "IncludeOptional conf.d/web/*.conf" >> /etc/httpd/conf/httpd.conf

RUN cd ~ && \
    curl 'https://setup.ius.io/' -o setup-ius.sh && \
	bash setup-ius.sh && \
    yum update -y && \
    yum install -y php71u-cli \
        php71u \
        php71u-fpm \
        php71u-mysqlnd \
        php71u-xml \
        php71u-gd \
        php71u-mcrypt \
	php71u-xmlrpc \
	php71u-json \
        php71u-mbstring \
        php71u-pdo \
	php71u-common \
	php71u-cli \
	php71u-devel

EXPOSE 6669

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
