# Step 1: Build the application using Maven 3.9.6 and Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the repository into the build container
COPY . .

# Build from the project root or the nested project directory
RUN if [ -f pom.xml ]; then 
        mvn clean package -DskipTests; 
    elif [ -f student-management/student-management/pom.xml ]; then 
        cd student-management/student-management && mvn clean package -DskipTests; 
    elif [ -f student-management/pom.xml ]; then 
        cd student-management && mvn clean package -DskipTests; 
    else 
        echo "ERROR: pom.xml not found in expected locations"; 
        find . -name pom.xml -print; 
        exit 1; 
    fi

# Step 2: Run the application using Java 17
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the generated JAR from the supported project locations
COPY --from=build /app/target/*.jar /tmp/root-app.jar
COPY --from=build /app/student-management/target/*.jar /tmp/nested-app.jar
COPY --from=build /app/student-management/student-management/target/*.jar /tmp/deep-nested-app.jar

RUN if [ -f /tmp/root-app.jar ]; then 
        cp /tmp/root-app.jar app.jar; 
    elif [ -f /tmp/nested-app.jar ]; then 
        cp /tmp/nested-app.jar app.jar; 
    elif [ -f /tmp/deep-nested-app.jar ]; then 
        cp /tmp/deep-nested-app.jar app.jar; 
    else 
        echo "ERROR: Built JAR not found"; 
        exit 1; 
    fi

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]
