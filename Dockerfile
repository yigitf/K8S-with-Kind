# Build Stage
FROM maven:3.8.3-openjdk-11-slim AS build

WORKDIR /app

COPY app/pom.xml .

RUN mvn dependency:go-offline

COPY app/src ./src

RUN mvn package -DskipTests

# Second Stage
FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /app/target/app-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 9001

CMD ["java", "-jar", "app.jar"]