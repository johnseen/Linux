#!/bin/bash
array=(deku smash ting)
select name in "${array[@]}"
do
    echo $name
done
