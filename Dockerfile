# Fase 1: Build (Compilação)
# Usa uma imagem do Maven com Java 17 para compilar o projeto
FROM maven:3.9.6-eclipse-temurin-17 AS build
# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o arquivo pom.xml e faz o download das dependências (para cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copia o código-fonte
COPY src /app/src

# Executa o comando de build (pulando testes)
RUN mvn clean install -DskipTests

# Fase 2: Produção (Runtime)
# Usa uma imagem JRE (Runtime Environment) leve para rodar o JAR
FROM eclipse-temurin:17-jre-alpine

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR compilado da fase de build
COPY --from=build /app/target/api-0.0.1-SNAPSHOT.jar /app/app.jar

# Expõe a porta que o Spring Boot usa
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
