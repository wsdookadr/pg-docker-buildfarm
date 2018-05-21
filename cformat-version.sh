#!/bin/bash
#
# Note, in what follows we'll talk about two different versioning schemes:
# - the PostgreSQL release version
# - the custom format archive(aka dump) that is being produced by the pg_dump
#   command that comes with a PostgreSQL release
#
# This script does the following:
# 
# Goes through each release in the official PostgreSQL repository [1] and extract
# the custom format version for dumps that are generated in that version.
#
# Apparently if a dump that was generated with `pg_dump -Fc` has a custom format
# version than that which the target Pg server understands, the target Pg server
# will not be able to import it, and it will throw this type of error:
#
#     pg_restore: [archiver] unsupported version (1.13) in file header
#
# So, this is important because it means(according to that table) that I can't
# restore a dump that was made on Pg 9.6.8 on 9.6.7
#
# This script produces a table which can be reviewed in case you need to know
# what versions will be involved, and if restores will work.
#
# [1] https://github.com/postgres/postgres
# 
#

exec &> >(tee "custom-format-version.report.txt")

echo "Report on custom format version for each Pg release"
echo "==================================================="
echo ""

for tag in $(git tag | grep "REL8\|REL9\|REL_10" | grep -v "BETA\|RC\|ALPHA"); do
    branch=$(echo $tag | perl -pne 's{[^0-9_]}{}g ; s{_}{.}g; s{^\.}{};')
    git checkout -b $branch $tag >/dev/null 2>/dev/null
    git checkout $branch

    K_VERS_MAJOR=$(cat src/bin/pg_dump/pg_backup_archiver.h | grep "\#define K_VERS_MAJOR" | perl -pne 's{^.*\s(\d+)$}{$1};')
    K_VERS_MINOR=$(cat src/bin/pg_dump/pg_backup_archiver.h | grep "\#define K_VERS_MINOR" | perl -pne 's{^.*\s(\d+)$}{$1};')
    K_VERS_REV=$(  cat src/bin/pg_dump/pg_backup_archiver.h | grep "\#define K_VERS_REV"   | perl -pne 's{^.*\s(\d+)$}{$1};')

    echo "$branch,$K_VERS_MAJOR.$K_VERS_MINOR-$K_VERS_REV"
done


