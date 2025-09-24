
terminal: docker run --name pg-instance -e POSTGRES_PASSWORD="test@123" -p 5173:5173 -d postgres

pgAdmin 4 setup:
terminal: docker pull dpage/pgadmin4:latest

terminal: docker run --name pg-admin-instance -p 5174:80 -e PGADMIN_DEFAULT_EMAIL=test@example.com -e PGADMIN_DEFAULT_PASSWORD="test@123" -d dpage/pgadmin4:latest

now run both containers pg-instance and the pg-admin-instance 

to find out the IP of the pg-instance: 
terminal: docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pg-instance

url syntax: postgresql://<username>:<password>@<host>:<port>/<database>