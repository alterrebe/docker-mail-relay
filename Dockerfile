# Using LTS ubuntu
FROM ubuntu:trusty
MAINTAINER Uri Savelchev <alterrebe@gmail.com>

# Ignore APT warnings about not having a TTY
ENV DEBIAN_FRONTEND noninteractive

# Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

# Packages: update
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" > /etc/apt/sources.list.d/multiverse.list && \
    echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list.d/multiverse.list && \
    apt-get update -qq

RUN apt-get install -qq -y --no-install-recommends postfix ca-certificates libsasl2-modules python-pip supervisor
RUN pip install j2cli

# Add files
ADD conf /root/conf

# Configure: supervisor
ADD bin/dfg.sh /usr/local/bin/
ADD conf/supervisor-all.conf /etc/supervisor/conf.d/

# Runner
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

# Declare
EXPOSE 25

CMD ["/root/run.sh"]
