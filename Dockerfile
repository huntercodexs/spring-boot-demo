# Use a base image with Java and a minimal Linux distribution
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and source code into the container
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Copy the application source code into the container
COPY src/ src/

# Build the application
RUN ./mvnw clean package -DskipTests

# Copy the JAR file into the container
COPY ./target/spring-boot-demo-0.0.1-SNAPSHOT.jar app.jar

# Define the command to run your Spring Boot application
CMD ["java", "-jar", "app.jar", "--spring.config.location=/app/src/main/resources/application.properties"]

# Expose the port your Spring Boot app is running on
EXPOSE 38087
