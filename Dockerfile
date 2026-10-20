# Step 1: Build the application using Maven 3.9.6 and Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the project ZIP from the GitHub repository
COPY student-management.zip /tmp/student-management.zip

# Extract the project files
RUN apt-get update && apt-get install -y unzip && unzip -q /tmp/student-management.zip -d /app/source && rm -rf /var/lib/apt/lists/*

# Find pom.xml, build the project, and save the generated JAR
RUN POM="$(find /app/source -type f -name pom.xml -print -quit)" && test -n "$POM" && echo "Building project from $POM" && mvn -f "$POM" clean package -DskipTests && JAR="$(find "$(dirname "$POM")/target" -maxdepth 1 -type f -name '*.jar' ! -name '*.original' ! -name '*-sources.jar' ! -name '*-javadoc.jar' -print -quit)" && test -n "$JAR" && cp "$JAR" /app/app.jar

# Step 2: Run the application using Java 17
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the compiled JAR
COPY --from=build /app/app.jar app.jar

EXPOSE 8080

# Start the application on Render's assigned port
ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
