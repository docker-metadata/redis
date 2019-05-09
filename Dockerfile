FROM deepin:minibase

RUN groupadd -r redis && useradd -r -g redis redis
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends sudo; \
	sudo -u nobody true; 

ENV REDIS_VERSION 5.0.2
COPY deepin-sw.list /etc/apt/sources.list.d/

RUN set -ex; \
	apt-get update; \
	apt-get install -y redis-server=5:$REDIS_VERSION* \
	redis-tools=5:$REDIS_VERSION* \
	redis-sentinel=5:$REDIS_VERSION* \
	--no-install-recommends; \
	apt-get clean ; 

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
