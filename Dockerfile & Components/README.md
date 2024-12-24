# Spring Boot Docker Application 🚀

## Overview 📝

This is Dockerfile for containerizing a Spring Boot application. The container runs on AdoptOpenJDK 11 with HotSpot JVM implementation.

## Prerequisites ✅

Before you begin, ensure you have the following installed:

- Docker 🐳
- Java 11 ☕
- Gradle/Maven (for building the application)

## Dockerfile Explanation 🔍

```dockerfile
# Base image with JRE 11
FROM adoptopenjdk:11-jre-hotspot

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose port 8081
EXPOSE 8081

# Command to run the application
CMD ["java", "-jar", "app.jar"]
```

## Build Instructions 🛠️

- 1.Build your Spring Boot application:

```bash
./gradlew build
```

- 2.Build the Docker image:

```bash
docker build -t springboot-app .
```

- 3.Run the container:

```bash
docker run -p 8081:8081 springboot-app
```

## Container Details 📦

- Base Image: adoptopenjdk:11-jre-hotspot

- Working Directory: /app

- Exposed Port: 8081

- Application JAR: app.jar

## Health Check 🏥

The application runs on port 8081. You can verify the application is running by accessing:

- http://localhost:8081 (when running locally)
