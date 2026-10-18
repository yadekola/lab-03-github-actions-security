
# Use a lightweight Java 21 runtime
FROM eclipse-temurin:21-jre

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven-built JAR file into the image
COPY target/devops-lab-app-1.0.0.jar app.jar

# Run the Java application when the container starts
ENTRYPOINT ["java", "-cp", "app.jar", "com.yadekola.devopslab.App"]

