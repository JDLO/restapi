# Paso 1: Usar una imagen base de Java (JRE)
FROM eclipse-temurin:17-jre-alpine

# Paso 2: Crear un directorio para la app
WORKDIR /app

# Paso 3: Copiar el .jar que generó Maven en la etapa anterior del pipeline
# El asterisco ayuda si el nombre tiene la versión (ej: api-0.0.1-SNAPSHOT.jar)
COPY target/*.jar app.jar

# Paso 4: Exponer el puerto que usa Spring Boot (normalmente 8080)
EXPOSE 8080

# Paso 5: Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]