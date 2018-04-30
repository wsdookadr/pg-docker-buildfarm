This repository creates a testing environment to test PostgreSQL features over
a large number of major and minor PostgreSQL versions.

First, it creates docker containers for multiple different versions of Pg.
Then, inside each of them a Pg version is built.

At the end, you can run a number of different tests against different Pg versions
and get reports with the results of the tests on all the versions tested.

Usage

    git clone https://github.com/postgres/postgres
    docker build -f ./Dockerfile -t pg-test .
    docker create --name pg-9.6.2 pg-test
    docker start pg-9.6.2


To list all the tags do 
    git tag

then to check out a specific tag into a new
branch do
    git checkout -b rel-9.6.2 REL9_6_2
