FROM anishitani/docker-java

MAINTAINER André Nishitani <andre.nishitani@gmail.com>

ENV GEOSERVER_VERSION 2.7.2

ENV GEOSERVER_HOME /opt/geoserver
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir

RUN /scripts/init_squid_cache.sh

# Download and installs geoserver
RUN apt-get update -y && apt-get install -y unzip \
  && wget http://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-bin.zip \
  && unzip geoserver-$GEOSERVER_VERSION-bin.zip -d /opt \
  && mv /opt/geoserver-$GEOSERVER_VERSION /opt/geoserver \
  && apt-get purge -y unzip \
  && apt-get clean && apt-get autoclean && apt-get --purge -y autoremove \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* geoserver-$GEOSERVER_VERSION-bin.zip

# Creates geoserver user
RUN addgroup --system geoserver \
  && adduser --system --ingroup geoserver --no-create-home --disabled-password geoserver \
  && chown -R geoserver:geoserver /opt/geoserver

VOLUME /opt/geoserver/data_dir

RUN /scripts/stop_squid_cache.sh

CMD ["sh","/opt/geoserver/bin/startup.sh"]
