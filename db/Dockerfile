
FROM mysql:5.7.34

ENV TZ=Asia/Shanghai

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./tumo_cloud.sql /docker-entrypoint-initdb.d
COPY ./tumo_cloud_nacos.sql /docker-entrypoint-initdb.d
