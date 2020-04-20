##################
# THE BASE IMAGE #
##################
FROM docker:19.03.8

# Install the dependencies
RUN apk update
RUN apk add curl py-pip python-dev libffi-dev openssl-dev gcc libc-dev make lzo-dev linux-pam-dev cmake automake

# Install docker-compose
RUN pip install docker-compose

# Install docker-machine
RUN base=https://github.com/docker/machine/releases/download/v0.16.0 \
    && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
    && mv /tmp/docker-machine /usr/local/bin/docker-machine \
    && chmod +x /usr/local/bin/docker-machine

# Install OpenVPN
RUN wget https://swupdate.openvpn.org/community/releases/openvpn-2.4.6.tar.gz
RUN tar -xf openvpn-2.4.6.tar.gz
RUN cd openvpn-2.4.6 && ./configure && make && make install

# Install secrethub
RUN curl -fsSL https://alpine.secrethub.io/pub -o /etc/apk/keys/secrethub.rsa.pub \
    && apk add --repository https://alpine.secrethub.io/alpine/edge/main secrethub-cli

# Install libyaml-cpp
RUN apk add git g++ \
    && git clone https://github.com/jbeder/yaml-cpp.git && mkdir -p yaml-cpp/build && cd yaml-cpp/build \
    && cmake .. && make && make install \
    && cd ../.. && rm -rf yaml-cpp

# Install docker-compose-multistage
RUN apk add automake libtool autoconf \
    && git clone https://github.com/sancherie/docker-compose-multistage.git \
    && cd docker-compose-multistage \
    && ./autogen.sh && ./configure && make && make install \
    && cd .. && rm -rf docker-compose-multistage

# Enable BuildKit
ENV COMPOSE_DOCKER_CLI_BUILD=1
ENV DOCKER_BUILDKIT=1
