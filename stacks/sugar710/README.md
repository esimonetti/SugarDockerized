# Sugar Dockerized Sugar version 7.10
This repository will help you deploy a Docker based development full stack for Sugar version 7.10

## Docker linux host changes
To be able to run Elasticsearch version 5 and above, it is needed an increase of the maximum mapped memory a process can have with. To complete it permanently run:

`echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf`

Alternatively the limit can be increased runtime with:

`sudo sysctl -w vm.max_map_count=262144`

## Stacks available
* php71.yml - Main reference stack - Single web server
    * PHP - 7.1
    * MySQL - 5.7
    * Elasticsearch - 5.4 (note that the hostname is sugar-elasticsearch now)
    * Redis - latest
