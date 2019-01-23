docker run -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=toor  -e MYSQL_DATABASE=wordpress -e MYSQL_USER=username -e MYSQL_PASSWORD=password --name mysql-test skepa23/mysql
