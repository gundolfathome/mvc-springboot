FROM openjdk:17

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
COPY ./nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["java", "-jar", "/app.jar"]

EXPOSE 80
