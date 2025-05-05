FROM maven:3.8-openjdk-11 AS builder

# Install git
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# Clone Mondrian repository
WORKDIR /usr/src
RUN git clone https://github.com/pentaho/mondrian.git
WORKDIR /usr/src/mondrian

# Build Mondrian (skipping tests to save time)
RUN mvn clean package -DskipTests

# Second stage - Tomcat server
FROM tomcat:9-jdk11

# Copy the built WAR file from the builder stage
COPY --from=builder /usr/src/mondrian/mondrian/target/mondrian*.war ${CATALINA_HOME}/webapps/mondrian.war

# Install MySQL JDBC driver
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar -O ${CATALINA_HOME}/lib/mysql-connector-java.jar && \
    rm -rf /var/lib/apt/lists/*

# Create directories for configuration
RUN mkdir -p ${CATALINA_HOME}/webapps/mondrian/WEB-INF/classes
RUN mkdir -p /opt/mondrian/data

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]