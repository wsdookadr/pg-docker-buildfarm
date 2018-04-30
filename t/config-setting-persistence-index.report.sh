#!/bin/bash
declare -a versions=("9.6.0" "9.6.1" "9.6.2" "9.6.3" "9.6.4" "9.6.5" "9.6.6" "9.6.7" "9.6.8")
for ver in "${versions[@]}"; do
    echo "Result for pg-$ver"
    docker exec -t -i pg-$ver cat /var/log/postgresql/logfile | perl -ne 'BEGIN{@a=(0);$i=-1;$s=0;};if(m{restore_start}){$i++; $a[$i].=$_; $s=1;}elsif(m{restore_end} && $s == 1){$a[$i].=$_; $s=0;} elsif($s){$a[$i].=$_;}; END {print $a[-1];}' | grep "prefix.persist was not set" | wc -l
done
