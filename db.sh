#!/bin/bash

source vars

if [ $(docker ps -a | grep -c mysql-test) != 1 ]; then
echo "Docker setup"
docker run -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=toor  -e MYSQL_DATABASE=${database} -e MYSQL_USER=${username} -e MYSQL_PASSWORD=${password} --name mysql-test skepa23/mysql
else
echo "Docker already setup"
fi

#Docker start
echo "Docker start"
docker start mysql-test

i=0
while true
 do
   if [ $i == 1 ];then
   break
   fi
   i=$(mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} -e 'show databases'|grep -c ${database};)
done
echo "  " >> log.txt
echo "`date +%Y%m%d_%H%M%S` $filename" >> log.txt
#Backup

filename=${database}`date +%Y%m%d_%H%M%S`.sql
mysqldump -h ${hostname} -P ${port} -u ${username} --databases ${database} --password=${password} > $filename;

echo 'Backup complete';

#Restore

mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} < $filename;

echo 'Restore complete';

#Test DB

echo "Comparison tables"
echo "  " >> log.txt
echo "Comparison tables" >> log.txt
echo "====================================" >> log.txt
#Source
tables_source=$(mysql -h ${hostname} -P ${port} -u ${username} -p${password} --database=${database} -e 'show tables')
wp_tables_source=($tables_source)

#Backup
tables_backup=$(mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} -e 'show tables')
wp_tables_backup=($tables_backup)

i="${#wp_tables_source[*]}"-1
index=1
for (( i; i>0; i-- ))
   do
   if [ ${wp_tables_backup[$index]} == ${wp_tables_source[$index]} ]; then
      printf "   %s\n" ${wp_tables_source[$index]} "[OK!]"
      echo ${wp_tables_source[$index]} "[OK!]" >> log.txt
      index=$(($index+1))
   else
      printf "   %s\n" "ERROR"
      echo "ERROR" >> log.txt
      index=$(($index+1))
      rm $filename
      exit 1
   fi
done

#Test colums

echo "Comparison colums"
echo "  " >> log.txt
echo "Comparison colums" >> log.txt
echo "====================================" >> log.txt

i="${#wp_tables_source[*]}"-1
index=1
for (( i; i>0; i-- ))
   do
    colums_source=$(echo "SELECT * FROM ${wp_tables_source[$index]}" | mysql -h ${hostname} -P ${port}  -u ${username} -p${password} --database=${database})
    colums_backup=$(echo "SELECT * FROM ${wp_tables_backup[$index]}" | mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database})
sleep 1
   if [ "${colums_source}" == "${colums_backup}" ]; then
      printf "   %s\n"  ${wp_tables_source[$index]} "[OK!]"
      echo ${wp_tables_source[$index]} "[OK!]" >> log.txt
      index=$(($index+1))
   else
      printf "   %s\n"  "ERROR"
      echo  "ERROR" >> log.txt
      index=$(($index+1))
      rm $filename
      exit 1
   fi
done

echo "Archiving"
tar -cvf backups/$filename.tar.gz $filename
rm $filename
echo "====================================" >> log.txt
echo $filename.tar.gz >> log.txt
echo "====================================" >> log.txt
echo "Stop Docker"
docker stop mysql-test
docker rm mysql-test
exit 0
