FROM sdhibit/rpi-raspbian:latest
MAINTAINER Guto Andreollo <gutoandreollo@users.noreply.github.com>

# steps adapted from:
#  https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu

# add the unifi repository, add the private key and update it.
RUN echo 'deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti' | tee -a /etc/apt/sources.list.d/ubnt.list > /dev/null && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
    apt-get update && \
    echo 20161119.01

# install UniFi
RUN DEBIAN_FRONTEND=noninteractive apt-get install unifi -y -q

# we don't need to start mongodb, UniFi will do that for it's own instance
RUN echo 'ENABLE_MONGODB=no' | tee -a /etc/mongodb.conf > /dev/null

# clean up the image
RUN apt-get -q clean && rm -rf /var/lib/apt/lists/*

# five directories at all
VOLUME ["/var/lib/unifi", "/var/log/unifi", "/var/run/unifi", "/usr/lib/unifi/work", "/usr/lib/unifi/data"]

# all the different ports for different purposes...
EXPOSE 8080/tcp 8081/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

WORKDIR /var/lib/unifi

CMD ["/usr/bin/java", "-Xmx512M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]





