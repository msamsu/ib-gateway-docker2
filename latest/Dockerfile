
#
# Setup Stage: install apps
#
# This is a dedicated stage so that donwload archives don't end up on 
# production image and consume unnecessary space.
#

FROM ubuntu:22.04 as setup

ARG IB_GATEWAY_VERSION=
ENV IB_GATEWAY_VERSION=${IB_GATEWAY_VERSION}

ARG IB_GATEWAY_RELEASE_CHANNEL=
ENV IB_GATEWAY_RELEASE_CHANNEL=${IB_GATEWAY_RELEASE_CHANNEL}

ARG IBC_VERSION=
ENV IBC_VERSION=${IBC_VERSION}

# Prepare system
RUN apt-get update -y
RUN apt-get install --no-install-recommends --yes \
  curl \
  ca-certificates \
  unzip

WORKDIR /tmp/setup

COPY /opt/ib-gateway-binaries/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh .
COPY /opt/ib-gateway-binaries/ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256 .
COPY /opt/ib-gateway-binaries/IBCLinux-${IBC_VERSION}.zip .

RUN sha256sum --check ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh.sha256
RUN chmod a+x ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh
RUN ./ibgateway-${IB_GATEWAY_VERSION}-standalone-linux-x64.sh -q -dir /root/Jts/ibgateway/${IB_GATEWAY_VERSION}
COPY ./config/ibgateway/jts.ini /root/Jts/jts.ini

# Install IBC
RUN curl -sSL https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip --output IBCLinux-${IBC_VERSION}.zip
RUN mkdir /root/ibc
RUN unzip ./IBCLinux-${IBC_VERSION}.zip -d /root/ibc
RUN chmod -R u+x /root/ibc/*.sh 
RUN chmod -R u+x /root/ibc/scripts/*.sh
COPY ./config/ibc/config.ini /root/ibc/config.ini

# Copy scripts
COPY ./scripts /root/scripts

#
# Build Stage: build production image
#

FROM ubuntu:22.04

ARG IB_GATEWAY_VERSION=
ENV IB_GATEWAY_VERSION=${IB_GATEWAY_VERSION}

WORKDIR /root

# Prepare system
RUN apt-get update -y
RUN apt-get install --no-install-recommends --yes \
  gettext \
  xvfb \
  libxslt-dev \
  libxrender1 \
  libxtst6 \
  libxi6 \
  libgtk2.0-bin \
  socat \
  x11vnc \
  && rm -rf /var/lib/apt/lists/*

# Copy files
COPY --from=setup /root/ .
RUN chmod a+x /root/scripts/*.sh
COPY --from=setup /usr/local/i4j_jres/ /usr/local/i4j_jres

# IBC env vars
ENV TWS_MAJOR_VRSN ${IB_GATEWAY_VERSION}
ENV TWS_PATH /root/Jts
ENV IBC_PATH /root/ibc
ENV IBC_INI /root/ibc/config.ini

# Start run script
CMD ["/root/scripts/run.sh"]
