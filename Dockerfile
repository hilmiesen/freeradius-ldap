# cd /data/freeradius
# docker build -t freeradius .
# docker run -d --restart=always -p 10.10.101.70:1812:1812 --name freeradius freeradius

FROM alpine:3.13.5
ENV PS1='\u@\h \w # '
RUN apk --update add --no-cache bash freeradius freeradius-ldap
RUN rm /etc/raddb/sites-enabled/*
COPY config/ldap /etc/raddb/mods-enabled/
COPY config/default /etc/raddb/sites-enabled/
COPY startup.sh /startup.sh	
RUN chmod u+x /startup.sh
ENTRYPOINT ["/startup.sh"]