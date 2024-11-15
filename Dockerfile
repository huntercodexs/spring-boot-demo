# Use a base image with Java and a minimal Linux distribution
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY ./.mvn/ .mvn
COPY ./mvnw .
COPY ./pom.xml .

COPY ./src/ src/

RUN ./mvnw clean package -DskipTests

CMD ["java", "-jar", "target/spring-boot-demo-0.0.1-SNAPSHOT.jar", "--spring.config.location=/app/src/main/resources/application.properties"]

EXPOSE 38087
