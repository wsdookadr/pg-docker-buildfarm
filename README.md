Use-case
========

You want to run sql/plpgsql code on multiple versions of PostgreSQL to see
how it performs on all of them.
          
This software allows you to create a build farm using docker containers with
multiple versions of PostgreSQL on each of them. The builds will be made using
the PostgreSQL source from upstream.

This repository creates a testing environment to test PostgreSQL features over
a number of major and minor PostgreSQL versions.

First, it creates docker containers pre-provisioned with the PostgreSQL source code.
Then, inside each of them, the appropriate Pg version is built, and then a Pg server is
started inside each of them.

Then you can run a test suite over multiple Pg versions and then create reports based
on Pg logs to see how your test case on different versions.

Usage
=====
    
    ./op make_image # build common docker image used for all containers
    ./op make_containers # create all the containers from the image we just made
    ./op make_pg # builds PostgreSQL with different versions on all the containers
    ./op make_pg_cluster # basically runs initdb on each container to create a data
                         # directory, and also provisions them with a postgresql.conf
                         # config file
    ./op start_pg # starts the PostgreSQL server on all containers
    ./op run_tests # runs the tests we have lined up in the ./t/ directory on all
                   # the containers

    ./op report # get a report for each of the tests

Misc
====

    ./op shell_pg 9.6.8 # gives you a shell to the docker container that's running version 9.6.8
                        # under the postgres user
    ./op shell_root 9.6.8 # same as before but with the root user


Other
=====

On these containers */var/lib/postgresql/* is the datadir for Pg, and the logs are stored in
*/var/log/postgresql/logfile* .

