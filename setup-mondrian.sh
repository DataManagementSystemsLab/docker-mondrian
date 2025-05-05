#!/bin/bash

# Wait for Tomcat to deploy the Mondrian WAR file
echo "Waiting for Mondrian deployment..."
while [ ! -d ${CATALINA_HOME}/webapps/mondrian ]; do
  sleep 5
  echo "Still waiting for Mondrian to deploy..."
done
echo "Mondrian deployed!"

# Copy configuration files from mounted volume to the deployed webapp
echo "Copying configuration files..."
cp -v /usr/local/tomcat/webapps/mondrian/WEB-INF/classes/*.xml ${CATALINA_HOME}/webapps/mondrian/WEB-INF/classes/
cp -v /usr/local/tomcat/webapps/mondrian/WEB-INF/classes/*.properties ${CATALINA_HOME}/webapps/mondrian/WEB-INF/classes/

echo "Mondrian setup complete!"