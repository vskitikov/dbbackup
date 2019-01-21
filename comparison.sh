#!/bin/bash
source vars
f1=0
#backupdb
filename=backups/${database}`date +%Y%m%d_%H%M%S`.sql
mysqldump -h ${hostname} -P ${port} -u ${username} --databases ${database} --password=${password} > $filename

#test db
for var in "LOCK TABLES `wp_options` WRITE;" "INSERT INTO `wp_options` VALUES (1,'siteurl','http://192.168.1.5:8080','yes')" "CREATE TABLE `wp_users`" "`ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT," "LOCK TABLES `wp_users` WRITE;" "INSERT INTO `wp_users` VALUES (1,'test','$P$B74b4xo4ATCuXyi/bG99X6d.zqmkMG1','test','test@mail.test','','2019-01-21 14:09:53','',0,'test');"
do
$f1=grep -c $var $filename
echo $f1
done

