FROM centos:7

RUN set -x && \
	yum install -y postgresql-server postgresql-contrib httpd wget epel-release &&\
	echo "SetEnv LD_LIBRARY_PATH /var/www/cgi-bin/dneo/lib" >> /etc/httpd/conf/httpd.conf

ADD dneoV35R13pg93lRE6.tar.gz /var/www/cgi-bin/

RUN set -x && \
	mv /var/www/cgi-bin/dneo/dneores /var/www/html/. &&\
	mv /var/www/cgi-bin/dneo/dneowmlroot /var/www/html/. &&\
	mv /var/www/cgi-bin/dneosp/dneospres /var/www/html/.

RUN set -x && \
	su postgres -c "initdb --encoding=utf8 --locale=C -D /var/lib/pgsql/data" &&\
	su postgres -c "/usr/bin/pg_ctl start -D /var/lib/pgsql/data -s -o \"-p 5432\" -w -t 300" &&\
	su postgres -c "psql -d template1 -c \"CREATE USER dneo WITH PASSWORD 'desknetsNeo_PgSql92us.v1' CREATEUSER\"" &&\
	su postgres -c "pg_restore -C -Fc -d template1 /var/www/cgi-bin/dneo/dump/dneodb.pgdmp" &&\
	su postgres -c "psql -d template1 -c \"CREATE USER dneofts WITH PASSWORD 'dneofts' CREATEUSER\"" &&\
	su postgres -c "pg_restore -C -Fc -d template1 /var/www/cgi-bin/dneo/dump/dneoftsdb.pgdmp"

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
