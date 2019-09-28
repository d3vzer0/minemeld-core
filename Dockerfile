FROM ubuntu:18.04

# Install core dependencies
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y p7zip-full git g++ libleveldb-dev librrd-dev libxslt1-dev libc-ares-dev libsnappy-dev
RUN apt-get install -y python2.7 python-pip

# Create main directory structure
RUN mkdir -p /opt/minemeld/{prototypes, supervisor, engine/{core, current}}

# Create local directoryn structure
RUN mkdir -p /opt/minemeld/local/{prototypes, data, trace, library, certs{site}, config/{api, traced}}

# Create user
RUN useradd minemeld

# Copy core repo files
COPY . /opt/minemeld/core/
RUN pip install -r /opt/minemeld/core/requirements.txt
RUN pip install -r /opt/minemeld/core/requirements-web.txt
RUN pip install -r /opt/minemeld/core/requirements-dev.txt
RUN pip install -e /opt/minemeld/core
#RUN mm-extensions-freeze /opt/minemeld/local /opt/minemeld/local/freeze.txt
#RUN pip freeze |grep -v minemeld-core > /opt/minemeld/local/constraints.txt

# Copy default config
COPY ./conf/traced.yml /opt/minemeld/local/config/
COPY ./conf/wsgi.htpasswd /opt/minemeld/local/config/api/
COPY ./conf/api/* /opt/minemeld/local/config/api/
COPY ./conf/supervisord.conf /opt/minemeld/supervisor/
COPY ./conf/supervisord/* /opt/minemeld/supervisor/config/conf.d/
COPY ./conf/collectd/* /etc/collectd/
COPY ./conf/minemeld.service /lib/systemd/system/




