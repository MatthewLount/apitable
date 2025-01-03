# Base image with Amazon Corretto JDK
FROM amazoncorretto:17

# Set environment variables
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto

# Set the working directory
WORKDIR /app

# Copy the newly built JAR file
COPY application/build/libs/*.jar /app/app.jar

# Expose the application's port
EXPOSE 8081

# Command to run the application
CMD ["java", "-Djava.security.egd=file:/dev/./urandom", "--add-opens=java.base/java.lang=ALL-UNNAMED", "-jar", "/app/app.jar"]
