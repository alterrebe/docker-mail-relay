FROM alpine:3.12
MAINTAINER Uri Savelchev <alterrebe@gmail.com>

# Packages: update
RUN apk -U add postfix ca-certificates libsasl cyrus-sasl-plain cyrus-sasl-login py-pip supervisor rsyslog
RUN pip install j2cli

# Add files
ADD conf /root/conf
RUN mkfifo /var/spool/postfix/public/pickup \
    && ln -s /etc/postfix/aliases /etc/aliases \
    && touch /etc/postfix/sender_canonical \
    && touch /etc/postfix/recipient_canonical
    && touch /etc/postfix/transport_maps

# Configure: supervisor
ADD bin/dfg.sh /usr/local/bin/
ADD conf/supervisor-all.ini /etc/supervisor.d/

# Runner
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

# Declare
EXPOSE 25

CMD ["/root/run.sh"]
