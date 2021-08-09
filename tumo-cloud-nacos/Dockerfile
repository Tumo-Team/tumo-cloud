FROM openjdk:8-jre
MAINTAINER tycoding@sina.com

WORKDIR /build

ADD ./target/tumo-cloud-nacos.jar ./app.jar

EXPOSE 8848

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
