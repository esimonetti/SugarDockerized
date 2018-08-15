#!/bin/bash
tmpkey=`cat ~/.ssh/id_rsa.pub`
docker exec -i --user sugar sugar-ssh bash -c "mkdir /home/sugar/.ssh"
docker exec -i --user sugar sugar-ssh bash -c "echo \"$tmpkey\" > /home/sugar/.ssh/authorized_keys"
tmpkey=''