FROM ubuntu:16.04

# add user group, user and make user home dir
RUN groupadd --gid 1000 mock && \
    useradd --uid 1000 --gid mock --shell /bin/bash --create-home mock

# set pwd to yapi home dir
WORKDIR /home/mock

# install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    python \
    wget \
    git \
    apt-transport-https \
    ca-certificates

# install nodejs
RUN wget http://cdn.npm.taobao.org/dist/node/v8.9.0/node-v8.9.0-linux-x64.tar.gz && \
    tar -xzvf node-v8.9.0-linux-x64.tar.gz && \
    ln -s /home/yapi/node-v8.9.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /home/yapi/node-v8.9.0-linux-x64/bin/npm /usr/local/bin/npm

RUN mkdir -p /home/mock/log

RUN chown -R mock:mock /home/mock/log

VOLUME ["/home/mock/log"]

# download yapi source code
USER mock

RUN git clone https://github.com/PhoenSXar/mock.git --depth 1 vendors

# npm install dependencies and run build
WORKDIR /home/mock/vendors

RUN npm install --production --registry https://registry.npm.taobao.org
