#!/bin/bash
#
# Create custom format dump of a Pg database
# 

rm /home/postgres/c1.dmp
/usr/local/pgsql/bin/dropdb c1
/usr/local/pgsql/bin/createdb c1

/usr/local/pgsql/bin/psql -d c1 -f /home/postgres/t/dump-compat.sql
/usr/local/pgsql/bin/pg_dump -Fc -d c1 -f /home/postgres/c1.dmp
