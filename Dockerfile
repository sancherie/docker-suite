##################
# THE BASE IMAGE #
##################
FROM docker:18.09.7

# Install the dependencies
RUN apk update
RUN apk add curl py-pip python-dev libffi-dev openssl-dev gcc libc-dev make lzo-dev linux-pam-dev

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

# Enable BuildKit
ENV COMPOSE_DOCKER_CLI_BUILD=1
ENV DOCKER_BUILDKIT=1
