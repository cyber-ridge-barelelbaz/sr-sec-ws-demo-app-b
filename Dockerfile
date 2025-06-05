FROM gradle:7.3.1-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM openjdk:8u181-jdk-alpine
EXPOSE 8080
RUN mkdir /app

# Create a non-root user and group
RUN addgroup -S mygroup && adduser -S myuser -G mygroup

COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar

# Change ownership of the app directory and JAR file to the new user
RUN chown -R myuser:mygroup /app

# Switch to the non-root user
USER myuser

CMD ["java", "-jar", "/app/spring-boot-application.jar"]
