FROM openjdk:8-jre
MAINTAINER tycoding@sina.com

WORKDIR /build

ADD ./target/tumo-cloud-auth.jar ./app.jar

EXPOSE 3000

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
