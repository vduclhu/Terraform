#
# Run lighttpd to serve apk packages
#
FROM    alpine:3.2
MAINTAINER  Daniel Nephin <dnephin@gmail.com>

RUN     apk update && apk add lighttpd
RUN     apk update && apk add rsync
ADD     lighttpd.conf /etc/lighttpd/lighttpd.conf
ADD     exclude.txt /etc/rsync/exclude.txt
ADD     rsync.sh /etc/periodic/hourly/package-rsync
CMD     ["crond", "-f", "-d", "6"]
CMD     ["lighttpd", "-f", "/etc/lighttpd/lighttpd.conf", "-D"]
EXPOSE  80



