# Step 1: Build the application using Maven 3.9.6 and Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build
# Set the project root
WORKDIR /app
# Copy the project files from GitHub
COPY . .
# Build directly from the directory containing pom.xml
RUN mvn clean package -DskipTests
# Step 2: Run the built JAR using Java 17
FROM eclipse-temurin:17-jre-alpine
# Set the application directory
WORKDIR /app
# Copy the compiled JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
# Application port
EXPOSE 8080
# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
