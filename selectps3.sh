#!/bin/bash
PS3="please select a num from menu:"
select name in deku smash lux
do
    echo -e "I guess you select the menu is:\n $REPLY) $name"
done
