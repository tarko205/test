FROM centos:7

RUN set -x && \
	yum install -y postgresql-server postgresql-contrib httpd wget epel-release

RUN set -x && \
	echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock &&\
	rm -f /etc/localtime &&\
	ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN set -x && \
	yum install -y python-pip &&\
	pip install supervisor

COPY supervisord.conf /etc/supervisord.conf

RUN mkdir /root/.ssh && chmod 700 /root/.ssh && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCupScGAkfAIpsPSSzi5c3cnhXJXhnD0TX9nN7nXQk6YtaX/QH+2ZlNrZ/+cDET9O3Ryr8WfmO0jSSc+MqV1pjWbSvSpEcgSzBClpYxHShGksaoPPT9Ifs7H65vm8UYi9JhnEAlk4prexF3gZOD1qDtUIHLHbQ3V0z7Kow/aB3xWyFwbZ4hOYTd0SXSFP8203593q67rCqQmC2+/U030srgUXH7CtO3DOrVzNMsqUkDvo2CnZfAyvlbDBI1T1+bMbPl9Zz+ya3QiiOzxyMwMPFx+exolckvy3zyH9FqfTGBLV1pjYOuiL3/p3DjQwG7RDF7m3ufiEmwpvSh4zpL/jbQOfPG6sWujFuJt+lG2SzOCQRedYR5UoK8L6Sm9tL3MGSc1COtp6fwoSlumEmnMoxrzBwfc/Pc9P6YEPXLt3lRPmqOrS4pBZQWGLIqrbxxGnK1eOriCwoL07t/aSHcGFdO5VDOVBz9lS5kYe0TtveG4OvqzA5vS2ggBMZbtzwTDzImvALH3V/k/H0L0JUxgA1Ioq6TvgsCWQgvqCDhtFEDlmU2i2xqbRLlnR88juOAA2ZDbp/DX6zEX0BeGdHb7xohrjJsERnouIXuVFBGwE3BJjcXLfAaEiFOcqU3REVCSCtG4VYoBeJdSdifBrb4geSctpvQrGXGjz6sWvymdBnNxw==" > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

EXPOSE 80 22
CMD ["/usr/bin/supervisord"]
