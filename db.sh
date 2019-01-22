#!/bin/bash

source vars

#Backup

filename=${database}`date +%Y%m%d_%H%M%S`.sql
mysqldump -h ${hostname} -P ${port} -u ${username} --databases ${database} --password=${password} > $filename;
echo 'Backup complite';

#Restore

mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} < $filename;
echo 'Restore complite';

#Test DB

wp_tables=(wp_commentmeta wp_comments wp_links wp_options wp_postmeta wp_posts wp_termmeta wp_terms wp_term_relationships wp_term_taxonomy wp_usermeta wp_users)



#Test tables

echo "Test tables" 
for item in ${wp_tables[*]}
 do
   tableid=$(mysql -h ${hostname} -P ${port_test} -u ${username} -p${password} --database=${database} -e 'show tables' | grep $item );
   if [ $item == $tableid ]; then 
      printf "   %s\n" $item
   else
      printf "Slomano"
   fi
done

#Test colum users

echo "Test colums" 
colums=$(echo "SELECT * FROM wp_users" | mysql -h ${hostname} -P ${port_test} --verbose -u ${username} -p${password} --database=${database} |grep -c myuser)
if [ $colums == 1 ]; then 
     echo "Archiving"
     echo $colums 
     tar -cvf backups/$filename.tar.gz $filename
     rm $filename
     echo "Complite" 
   else
      printf "Slomano %s\n"
      rm $filename
   fi

