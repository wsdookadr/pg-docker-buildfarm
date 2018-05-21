#!/bin/bash
cd /home/postgres/
/usr/local/pgsql/bin/createdb c2
REPORT=$HOME/restore-report.txt
: > $REPORT
for d in tmp_dmp/*; do
    /usr/local/pgsql/bin/psql -d c2 -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
    /usr/local/pgsql/bin/pg_restore -d c2 $d
    R=$?
    V=$(basename $d | sed -e 's/\.dmp//') 
    echo "$R,$V" >> $REPORT
done

