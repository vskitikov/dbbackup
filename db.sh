#!/bin/bash

source vars

#Docker start

echo "Docker start"
docker start mysql-test

i=0
while true
 do
   if [ $i == 1 ];then
   break
   fi
   i=$(mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} -e 'show tables'|grep -c Tables_in_wordpress;)
done

#Backup

filename=${database}`date +%Y%m%d_%H%M%S`.sql
mysqldump -h ${hostname} -P ${port} -u ${username} --databases ${database} --password=${password} > $filename;

echo 'Backup complete';

#Restore

mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} < $filename;

echo 'Restore complete';

#Test DB

echo "Comparison tables"

#Source
tables_source=$(mysql -h ${hostname} -P ${port} -u ${username} -p${password} --database=${database} -e 'show tables')
wp_tables_source=($tables_source)
#Backup
tables_backup=$(mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} -e 'show tables')
wp_tables_backup=($tables_backup)


index=0
for item in ${wp_tables_source[*]}
   do
   if [ ${wp_tables_backup[$index]} == ${wp_tables_source[$index]} ]; then 
      printf "   %s\n" $item "[OK!]"
      index=$(($index+1))
   else
      printf "ERROR"
      index=$(($index+1))
   fi 
done

#Test colums

echo "Comparison colums"

i="${#wp_tables_source[*]}"-1
index=1
for (( i; i>0; i-- ))
   do
    colums_source=$(echo "SELECT * FROM ${wp_tables_source[$index]}" | mysql -h ${hostname} -P ${port}  -u ${username} -p${password} --database=${database})
    colums_backup=$(echo "SELECT * FROM ${wp_tables_backup[$index]}" | mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database})
sleep 1
   if [ "${colums_source}" == "${colums_backup}" ]; then 
      printf "   %s\n" ${wp_tables_source[$index]} "[OK!]"
      index=$(($index+1))
   else
      printf "ERROR"
      index=$(($index+1))
   fi 
done





#     echo "Archiving"
#     tar -cvf backups/$filename.tar.gz $filename
#     rm $filename
#     echo "Complete"
#     echo "`date +%Y%m%d_%H%M%S` done $filename" >> log.txt 


#  rm $filename
#  echo "`date +%Y%m%d_%H%M%S` ZOPA" >> log.txt 


docker stop mysql-test
