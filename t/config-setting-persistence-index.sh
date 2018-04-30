#!/bin/bash
rm ~/postgres.dmp
/usr/local/pgsql/bin/pg_ctl stop -D /var/lib/postgresql/
/usr/local/pgsql/bin/pg_ctl start -D /var/lib/postgresql/ -l /var/log/postgresql/logfile

/usr/local/pgsql/bin/pg_restore -v --no-acl --no-owner -d p1 ~/postgres.dmp
docker exec -u postgres -t -i pg-9.6.8 /usr/local/pgsql/bin/psql
