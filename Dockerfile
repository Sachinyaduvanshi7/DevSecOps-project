# ---------- BUILD STAGE ----------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Create non-root user (good security practice)
RUN addgroup -S javauser && adduser -S javauser -G javauser

COPY --from=build /app/target/*.jar app.jar

RUN chown -R javauser:javauser /app
USER javauser

ENTRYPOINT ["java","-jar","app.jar"]