# Mondrian OLAP Server - Docker Setup with GitHub Source

This repository contains Docker configuration to build and run Mondrian OLAP server directly from the GitHub source code, along with a MySQL database for data storage.

## Features

- Builds Mondrian directly from the Pentaho GitHub repository
- Multi-stage Docker build for smaller final image
- Includes MySQL with proper configuration
- Ready-to-use XMLA access

## Prerequisites

- Docker
- Docker Compose

## Directory Structure

Create the following directory structure:

```
mondrian-docker/
├── Dockerfile
├── docker-compose.yml
├── setup-mondrian.sh
├── README.md
├── mondrian-config/
│   ├── mondrian.properties
│   ├── datasources.xml
│   └── FoodMart.xml
├── data/
└── mysql-init/
    └── foodmart.sql (optional: database initialization script)
```

## Setup Instructions

1. **Create the project directories**

   ```bash
   mkdir -p mondrian-docker/mondrian-config mondrian-docker/data mondrian-docker/mysql-init
   cd mondrian-docker
   ```

2. **Save all the configuration files**

   Create all the files provided in this repository with the exact names shown in the directory structure.

3. **Make the setup script executable**

   ```bash
   chmod +x setup-mondrian.sh
   ```

4. **Build and start the containers**

   ```bash
   docker-compose up -d
   ```

   Note: The first build will take several minutes as it clones and compiles Mondrian from source.

5. **Initialize the FoodMart database (optional)**

   If you want to use the FoodMart example database:

   ```bash
   # Download the FoodMart MySQL script
   curl -o mysql-init/foodmart.sql https://raw.githubusercontent.com/pentaho/mondrian/master/demo/mysql/foodmart_mysql.sql
   
   # Restart containers to apply the script
   docker-compose down
   docker-compose up -d
   ```

## Accessing Mondrian

Once the containers are running:

- **Mondrian web interface**: http://localhost:8080/mondrian
- **XMLA endpoint**: http://localhost:8080/mondrian/xmla
- **MySQL database**: localhost:3306 (username: root, password: password)

## Using Mondrian

### Testing with MDX Queries

You can test Mondrian's XMLA endpoint using tools like:

- Saiku Analytics
- Pentaho BI Server
- Power BI
- Any MDX-compatible client

Example MDX query to test with:

```sql
SELECT
  {[Measures].[Unit Sales], [Measures].[Store Cost], [Measures].[Store Sales]} ON COLUMNS,
  {[Product].Children} ON ROWS
FROM [Sales]
WHERE ([Time].[1997])
```

### Custom Development

Since you're building from GitHub source, you can easily modify the Mondrian code:

1. Fork the Mondrian repository on GitHub
2. Update the Dockerfile to use your forked repository
3. Make your changes and commit them to your fork
4. Rebuild the Docker image

## Customizing Your Setup

### Using Your Own Schema

To use your own data warehouse schema:

1. Create your custom schema XML file and save it in `mondrian-config/`
2. Update `mondrian.properties` and `datasources.xml` to point to your schema file
3. Restart the containers

### Connecting to an Existing Database

To connect to an external database:

1. Update the JDBC connection string in `datasources.xml`
2. Modify your schema file to match the external database structure
3. If not using MySQL, add the appropriate JDBC driver to the Dockerfile

## Troubleshooting

- **Build fails**: Check your internet connection and GitHub access
- **Connection errors**: Verify database credentials in `datasources.xml`
- **Schema not loading**: Check paths in `mondrian.properties` and `datasources.xml`
- **Memory issues**: Increase Java heap size in `docker-compose.yml` (JAVA_OPTS)

## Logs and Debugging

View Mondrian logs:
```bash
docker-compose logs -f mondrian
```

For more verbose logging, edit `mondrian.properties` and set:
```
mondrian.trace.level=3
```

## Advanced Configuration

For advanced configuration options, refer to the [Mondrian documentation](https://mondrian.pentaho.com/documentation/).