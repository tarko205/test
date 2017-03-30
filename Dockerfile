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

EXPOSE 80
CMD ["/usr/bin/supervisord"]
