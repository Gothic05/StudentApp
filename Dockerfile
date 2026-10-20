# Step 1: Build the application using Maven 3.9.6 and Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the entire repository
COPY . .

# Find the Maven project, build it, and copy its JAR to a known location
RUN set -eu; 
    POM_FILE="$(find /app -type f -name pom.xml -not -path '*/target/*' -print -quit)"; 
    if [ -z "$POM_FILE" ]; then 
        echo "ERROR: No pom.xml found in the Docker build context"; 
        exit 1; 
    fi; 
    PROJECT_DIR="$(dirname "$POM_FILE")"; 
    echo "Found Maven project: $PROJECT_DIR"; 
    mvn -f "$POM_FILE" clean package -DskipTests; 
    JAR_FILE="$(find "$PROJECT_DIR/target" -maxdepth 1 -type f -name '*.jar' ! -name '*-sources.jar' ! -name '*-javadoc.jar' -print -quit)"; 
    if [ -z "$JAR_FILE" ]; then 
        echo "ERROR: No packaged JAR found"; 
        exit 1; 
    fi; 
    cp "$JAR_FILE" /app/app.jar

# Step 2: Run the application using Java 17
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
