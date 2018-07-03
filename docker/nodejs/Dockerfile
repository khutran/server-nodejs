FROM centos:latest
MAINTAINER https://github.com/CentOS/sig-cloud-instance-images

LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40

ARG NAME_SERVER
ARG MYSQL_USER
ARG MYSQL_PASS
ARG MYSQL_HOST
ARG PORT

# VOLUME /var/www/web
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
RUN mkdir -p /var/www/web/ecosystem
ADD remote_forever.json /var/www/web/ecosystem/${NAME_SERVER}.json


# # add code remote
RUN mkdir -p /var/www/web/${NAME_SERVER}/workspace
COPY source_code* /var/www/web/${NAME_SERVER}/workspace

RUN sed -i s/remote.vicoders.com/${NAME_SERVER}/g /var/www/web/ecosystem/${NAME_SERVER}.json

# WORKDIR /var/www/web/${NAME_SERVER}/workspace
# RUN yarn install 
# RUN cp .env.example .env && \
#     sed -i s/user_mysql/${MYSQL_USER}/g .env && \
#     sed -i s/pass_mysql/${MYSQL_PASS}/g .env && \
#     sed -i s/host_mysql/${MYSQL_HOST}/g .env

EXPOSE ${PORT}

# WORKDIR /var/www/web/ecosystem
# ENTRYPOINT ["yarn", "devstart"]