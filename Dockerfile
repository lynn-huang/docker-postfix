From ubuntu:trusty
MAINTAINER Elliott Ye

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update

# Update OpenSSL
RUN apt-get -y remove openssl libssl-dev
RUN apt-get -y install gcc curl wget make
RUN mkdir -p /build/openssl
RUN curl -s https://www.openssl.org/source/openssl-1.1.1k.tar.gz -k | tar -C /build/openssl -xzf - && cd /build/openssl/openssl-1.1.1k && ./Configure shared linux-x86_64 && make && make install
RUN cp /build/openssl/openssl-1.1.1k/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/
RUN cp /build/openssl/openssl-1.1.1k/libssl.so.1.0.0 /lib/x86_64-linux-gnu/
RUN cp /build/openssl/openssl-1.1.1k/apps/openssl /usr/bin

# Start editing
# Install package here for cache
RUN apt-get -y install supervisor postfix sasl2-bin opendkim opendkim-tools

# Add files
ADD assets/install.sh /opt/install.sh

# Run
CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

