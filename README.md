# Sugar Dockerized
This repository will help you deploy a Docker based development full stack for Sugar, meeting all the platform requirements for a different set of platform combinations.

## Stacks available
There are few stacks available, with in itself multiple platform combinations. You can read more about the specific stacks on the links below:
* [Sugar 79](stacks/sugar79/README.md)
* [Sugar 79 upgraded to a future version](stacks/sugar79upgrade/README.md)
* [Sugar 710](stacks/sugar710/README.md) - For local development to apply to On-demand only

### Types of stacks
There are mainly two types of stack:
* Single Apache web server - Initial development
* An Apache load balancer with a cluster of two Apache web servers behind it - A more real-life environment to verify that everything works correctly

### All stack components
There are multiple stack components as docker containers, that perform different duties. Not all the stack components might be used on a specific stack setup.
* Apache load balancer - Load balance requests between the cluster round robin
* Apache PHP web server - Web server
* MySQL database - Database
* Elasticsearch - Sugar search engine
* Redis - Two purposes: Sugar object caching service and PHP Session storage/sharing service
* Cron - Sugar background scheduler processing. Note that this is enabled immediately and it will run `cron.php` as soon as the file is available, and it will attempt to do so every 60 seconds since its last run.
* Permission - Make sure the Sugar instance permissions are set correctly and will then shut down automatically
* LDAP - LDAP testing server if needed with authentication

## Get the system up and running
* The first step for everything to work smoothly, is to add on your host file the entry "docker.local" to point to your machine's ip (it might be 127.0.0.1 if running it locally or the ip of the VM running Docker)
* Clone the repository with `git clone https://github.com/esimonetti/SugarDockerized.git sugardocker` and enter sugardocker with `cd sugardocker`
* Choose the stack combination to run by choosing the correct yml file within the subfolders inside [stacks](stacks/)
* Run docker-compose -f <stack yml filename> up -d for the selected <stack yml filename>. As an example if we selected `stacks/sugar79/php71.yml`, you would run `docker-compose -f stacks/sugar79/php71.yml up -d`

## Current version support
The main stacks work with [Sugar version 7.9 and all its platform requirements](http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_7.9.x_Supported_Platforms/). Additional stacks are aligned with the pltform requirements of version 7.10.

## Starting and stopping the desired stack
* Run the stack with `docker-compose -f <stack yml filename> up -d`
* Stop the stack with `docker-compose -f <stack yml filename> down`

When starting/stopping and swapping between different stacks, add the option `--build` so that the stack is rebuilt with the correct software versions.

## System's details

### Stack components hostnames
* Apache load balancer: sugar-lb
* Apache PHP web server: On single stack: sugar-web1 On cluster stack: sugar-web1 and sugar-web2
* MySQL database: sugar-mysql
* Elasticsearch: sugar-elasticsearch (on stack with both elasticsearches sugar-elasticsearch for version 1.7.5 and sugar-elasticsearch54 for version 5.4)
* Redis - sugar-redis
* Cron - sugar-cron
* Permission - sugar-permissions
* LDAP - sugar-ldap

To verify all components hostnames just run `docker ps` when the stack is up and running.

Please note that on this setup, only the web server or the load balancer (if in single web server or cluster stack) and the database can be accessed externally. Everything else is only allowed within the stack components.

### Core stack components
* Linux
* Apache
* MySQL
* PHP
* Redis
* Elasticsearch

### Sugar Setup details
* Browser url: http://docker.local/sugar/ - Based on the host file entry defined above on the local machine
* MySQL hostname: sugar-mysql
    * MySQL user: root
    * MySQL password: root
* Elasticsearch hostname: sugar-elasticsearch
* Redis hostname: sugar-redis

### Apache additional information
Apache web servers have enabled:
* mod_headers
* mod_expires
* mod_deflate
* mod_rewrite

### PHP additional information
Apache web servers have PHP with enabled:
* Zend Opcache - Configured for Sugar with the assumption the files will be located within the correct path
* xdebug
* XHProf or Tideways profilers depending on the version

Session storage is completed leveraging the Redis container.

### Docker images
* `images/elasticsearch/175/` - Elasticsearch 1.7.5
* `images/elasticsearch/54/` - Elasticsearch 5.4
* `images/ldap/` - OpenLDAP
* `images/loadbalancer/` - Apache load balancer
* `images/mysql/57/` - MySQL 5.7
* `images/permissions/` - Permissions fixing container image
* `images/php/56/apache/` - Apache with PHP 5.6
* `images/php/56/cron/` - PHP 5.6 CLI for background jobs
* `images/php/71/apache/` - Apache with PHP 7.1
* `images/php/71/cron/` - PHP 7.1 CLI for background jobs

All images are currently leveraging Debian linux.

### Persistent storage locations
* The Sugar application files served from the web servers and leveraged by the cronjob server have to be located in `./data/app/sugar/`. Within the web servers and the cronjob server the location is `/var/www/html/sugar/`. Everything within `./data/app/` can be accessed through the browser, but the Sugar instance files have to be within `./data/app/sugar/`
* MySQL files are located in `./data/mysql/57/`
* Elasticsearch files are normally located in `./data/elasticsearch/175/`. For Elasticsearch 5.4 files are located in `./data/elasticsearch/54/`
* Redis files are located in `./data/redis/`
* LDAP files are located in `./data/ldap/`

Do not change the permissions of the various data subfolders, as it might cause the system to not work correctly.

## Tips
### Detect web server PHP error logs
To be able to achieve this consistently, it is recommended to leverage the single web server stack.
By running the command `docker logs -f sugar-web1` it is then possible to tail the output from the access and error log of Apache and/or PHP

### Fix Sugar permissions
You would just need to run again the permissions docker container with `docker start sugar-permissions`. The container will fix the permissions and ownership of files for you and then terminate its execution.

### Run the included command line Repair
The application contains few scripts built to facilitate the system's repair from command line. The scripts will wipe the various caches (including Opcache and Redis if used). It will also warm-up as much as possible the application, to improve the browser experience on first load. The cron container from which the repair runs, has also been optimised to speed up the repairing processing.
To run the repair from the docker host, assuming that the repository has been checked out on sugardocker execute:

```
cd sugardocker
./repair
```

### Simplify stack startup and shutdown
Once you choose the most commonly used stack for the job, you could simply create two bash scripts to start/stop your cluster. Examples of how those could look like are below:

Start (eg: ~/79up):
```
#!/bin/bash
cd ~/sugardocker
docker-compose -f stacks/sugar79/php71.yml up -d
```

Stop (eg: ~/79down):
```
#!/bin/bash
cd ~/sugardocker
docker-compose -f stacks/sugar79/php71.yml down
```

Making sure that the bash script is executable with `chmod +x <script>`.

### Setup Sugar instance to leverage Redis object caching
Add on `config_override.php` the following options:
```
$sugar_config['external_cache_disabled'] = false;
$sugar_config['external_cache_disabled_redis'] = false;
$sugar_config['external_cache']['redis']['host'] = 'sugar-redis';
```
Make sure there are no other caching mechanism enabled on your config/config_override.php combination, otherwise set them as disabled = true.

### Run command line command or script
To run a PHP script execute something like the following sample commands:
```
docker@docker:~/sugardocker$ docker exec -it sugar-cron bash -c "cd .. && php repair.php --instance sugar"
Debug: Entering folder sugar
Repairing...
Completed in 6
```

```
docker@docker:~/sugardocker$ docker exec sugar-cron bash -c "whoami"
sugar
```

```
docker@docker:~/sugardocker$ docker exec sugar-cron bash -c "pwd"
/var/www/html/sugar
```

If needed, sudo is available as well without the need of entering a password. Just make sure the permissions and ownership (user `sugar`) is respected.

### Disable and re-enable Zend Opcache
If you do need to disable/enable Zend Opcache to customise the system without opcache enabled, you can:
* Edit the two config files on `./images/php/<version>/(apache|cron)/config/php/mods-available/opcache.ini`
* Set `opcache.enable=0` and `opcache.enable_cli=0`
* `docker-compose -f <stack yml filename> down`
* `docker-compose -f <stack yml filename> up -d --build`

To re-enable, repeat by setting `opcache.enable=1` and `opcache.enable_cli=1`

### Typical Sugar config_override.php options for real-life development
```
$sugar_config['cache_expire_timeout'] = 600; // default: 5 minutes, increased to 10 minutes
$sugar_config['disable_vcr'] = true; // bwc module only
$sugar_config['disable_count_query'] = true; // bwc module only
$sugar_config['save_query'] = 'populate_only'; // bwc module only
$sugar_config['collapse_subpanels'] = true; // 7.6.0.0+
$sugar_config['hide_subpanel'] = true; // bwc module only
$sugar_config['hide_subpanel_on_login'] = true; // bwc module only
$sugar_config['logger']['level'] = 'fatal';
$sugar_config['logger']['file']['maxSize'] = '10MB';
$sugar_config['developerMode'] = false;
$sugar_config['dump_slow_queries'] = true;
$sugar_config['slow_query_time_msec'] = '1000';
$sugar_config['perfProfile']['TeamSecurity']['default']['teamset_prefetch'] = true;
$sugar_config['perfProfile']['TeamSecurity']['default']['teamset_prefetch_max'] = 500;
$sugar_config['perfProfile']['TeamSecurity']['default']['where_condition'] = true;
$sugar_config['import_max_records_total_limit'] = '2000';
$sugar_config['verify_client_ip'] = false;
$sugar_config['search_engine']['force_async_index'] = true;
```
Tweak the above settings based on your specific needs.

## Mac users notes
These stacks have been built on a Mac platform, that is known to not perform well with [Docker mounted volumes](https://github.com/docker/for-mac/issues/77).
Personally I currently run Docker on a Debian based minimal VirtualBox VM with fixed IP, running an NFS server. I either mount NFS on my Mac when needed or SSH directly into the VM.
