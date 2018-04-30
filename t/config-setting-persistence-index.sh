#!/bin/bash
#
# We create two databases, p1 and p2.
# We provision the first database p1 with the sql script config-setting-persistence-index.sql.
# In order to reproduce, we then dump db p1 into /home/postgres/p1.dmp
# We then restore p2 from p1.dmp
#
# The goal is to check the log messages inside /var/log/postgresql/logfile, specifically
# the ones produced by pg_restore when it reaches the CREATE INDEX statement
# that is contained inside p1.dmp
# We have some debug messages that are generated via RAISE LOG, and we want to count
# those in order to build a report that will tell us more about the behaviour of our test
# case over multiple Pg versions.
#
rm /home/postgres/p1.dmp

/usr/local/pgsql/bin/dropdb p1
/usr/local/pgsql/bin/dropdb p2

/usr/local/pgsql/bin/createdb p1
/usr/local/pgsql/bin/createdb p2

/usr/local/pgsql/bin/psql -d p1 -f /home/postgres/t/config-setting-persistence-index.sql
/usr/local/pgsql/bin/pg_dump -Fc -d p1 -f /home/postgres/p1.dmp

PGAPPNAME="restore_start" /usr/local/pgsql/bin/psql -d p2 -c 'SELECT 1;'
PGAPPNAME="restore_run" /usr/local/pgsql/bin/pg_restore -v --no-acl --no-owner -d p2 ~/p1.dmp
PGAPPNAME="restore_end" /usr/local/pgsql/bin/psql -d p2 -c 'SELECT 1;'

