1. First download MongoDB Community Server and install it.
2. copy the path of the bin "C:/Program Files/MongoDB/Server/7.0/bin" and paste it in the path in the system variables
3. Download MongoDB Shell (as msi package) and install it.
4. Copy the installed location of the mongosh and paste it into the system variables path "C:\Users\moham\AppData\Local\Programs\mongosh"
5. Thats it now try on cmd "mongod --version"
6. And then type "mongosh" to intiate mongo db shell
7. type "show dbs" to view local database that are already available

# Create DB
1. type "use <"db-name">" to create a DB

# Create Collection
1. type "db.createCollection("collection-name")

# For More
refer "[Perform CRUD Operations - MongoDB Shell](https://www.mongodb.com/docs/mongodb-shell/crud/)"
