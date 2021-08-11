FROM moxm/java:1.8-full as builder
WORKDIR /build
ARG JAR_FILE=/target/tumo-cloud-visual-sentinel.jar
COPY ${JAR_FILE} app.jar
RUN java -Djarmode=layertools -jar app.jar extract && rm app.jar

FROM moxm/java:1.8-full
LABEL maintainer="tycoding@sina.com"
ENV TZ=Asia/Shanghai
ENV JAVA_OPTS="-Xms128m -Xmx256m -Djava.security.egd=file:/dev/./urandom"
WORKDIR /build

COPY --from=builder /build/dependencies/ ./
COPY --from=builder /build/snapshot-dependencies/ ./
COPY --from=builder /build/spring-boot-loader/ ./
COPY --from=builder /build/application/ ./

EXPOSE 5002

CMD sleep 60; java $JAVA_OPTS org.springframework.boot.loader.JarLauncher
