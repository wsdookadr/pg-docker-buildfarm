Use-case: You want to run sql/plpgsql code on multiple versions of PostgreSQL to see
          how it performs on all of them.
          
          This software allows you to create a build farm using docker containers with
          multiple versions of PostgreSQL on each of them. The builds will be made using
          the PostgreSQL source from upstream.

This repository creates a testing environment to test PostgreSQL features over
a large number of major and minor PostgreSQL versions.

First, it creates docker containers for multiple different versions of Pg.
Then, inside each of them a Pg version is built.

At the end, you can run a number of different tests against different Pg versions
and get reports with the results of the tests on all the versions tested.

Usage

    docker build -f ./Dockerfile -t pg-test .
    docker create --name pg-9.6.2 pg-test
    docker start pg-9.6.2

To list all the tags do 
    git tag

then to check out a specific tag into a new branch do
    git checkout -b rel-9.6.2 REL9_6_2

To build Pg do
    autoreconf -i
    ./configure
    make
    make install

Then add the postgres user.

As root run this:
    mkdir /var/lib/postgresql /var/log/postgresql
    chown -R postgres:postgres /usr/local/pgsql/ /var/lib/postgresql/ /var/log/postgresql

As postgres run this:

    /usr/local/pgsql/bin/pg_ctl init -D /var/lib/postgresql/


