FROM openjdk:11.0.2-jre-slim

# AppD
RUN apt-get update
RUN apt-get install -y curl jq unzip
COPY downloadAgent.sh .
COPY custom-interceptors.xml .
RUN ./downloadAgent.sh

COPY target/microservice-kafka-shipping-0.0.1-SNAPSHOT.jar .
CMD /usr/bin/java -Xmx400m -Xms400m  -XX:TieredStopAtLevel=1 -noverify -javaagent:/opt/appdynamics/java/javaagent.jar -jar microservice-kafka-shipping-0.0.1-SNAPSHOT.jar
EXPOSE 8080
