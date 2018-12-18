# https://hub.docker.com/u/cmptech/nodejs_sharessl_ubuntu:18.04

FROM ubuntu:18.04

Maintainer Wanjo Chan ( http://github.com/wanjochan/ )

RUN apt update && apt install -y wget libssl-dev

#http://npm.taobao.org/mirrors/node/latest
RUN echo export NODE_VERSION=node-`wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p'` > /node_env.sh

# build nodejs and then clean up
RUN . /node_env.sh \
&& apt install -y python-pip \
&& cd /root/ \
&& wget https://nodejs.org/dist/latest/$NODE_VERSION.tar.gz \
&& tar xzvf $NODE_VERSION.tar.gz \
&& cd $NODE_VERSION \
&& ./configure --prefix=/$NODE_VERSION --shared-openssl \
&& make -j8 \
&& make install \
&& cd /root/ \
&& rm -Rf ${NODE_VERSION}* \
&& apt remove -y python-pip \
&& apt autoremove -y \
&& rm -rf /var/lib/apt/lists/ \
&& /$NODE_VERSION/bin/node -v
