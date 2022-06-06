# Sugar Dockerized [![Build Status](https://github.com/esimonetti/SugarDockerized/actions/workflows/sugar12.yml/badge.svg)](https://github.com/esimonetti/SugarDockerized/actions/workflows/sugar12.yml) ![Docker Pulls](https://img.shields.io/docker/pulls/esimonetti/sugardockerized.svg)

This repository will help you deploy a Docker based **development only** full stack for Sugar, meeting all the platform requirements for a different set of platform combinations.

## Requirements
* linux platform - it can be a virtual machine
* docker
* docker-compose
* curl
* rsync
* zip
* tar
* git
* Sugar zip installer

## Stacks available
There are few stacks available, with in itself multiple platform combinations. You can read more about the specific stacks on the links below:
* [Sugar 12](stacks/sugar12/README.md) - This stack is valid from version 12 for local developement also of Sugar Cloud only versions
* [Sugar 11](stacks/sugar11/README.md) - This stack is valid from version 11 for local developement also of Sugar Cloud only versions

You will find additional stacks within the [stack directory of the project](stacks).
For most stacks, there are both the pre-built version (eg on Sugar 9: `./stacks/sugar9/php73.yml`) and a locally built version (eg on Sugar 9: `./stacks/sugar9/php73-local-build.yml`). The locally built version will be built run-time, and therefore those stacks will let you specify additional changes you might require to the docker images provided. Local builds will take much longer to deploy than pre-built ones.

### Types of stacks
There are mainly three types of stack:
* Single Apache web server - Initial development
* Single Apache web server with local run-time build - Initial development when you need to modify the stack to better suit specific needs
* An Apache load balancer with a cluster of two Apache web servers behind it - A more real-life environment to verify that everything works correctly

### Stack components
There are multiple stack components as docker containers, that perform different duties. Not all the stack components might be used on a specific stack setup. Some of the stack components are listed below:
* Apache load balancer - Load balances requests between the cluster of Apache PHP web servers, round robin
* Apache PHP web server - Web server(s)
* MySQL database - Database
* Elasticsearch - Sugar search engine
* Redis - Two purposes: Sugar object caching service and PHP Session storage/sharing service
* Cron - Sugar background scheduler processing. Note that this is enabled immediately and it will run `cron.php` as soon as the file is available, and it will attempt to do so every 60 seconds since its last run. This container is used for any other CLI execution required during development
* Permission - Sets Sugar instance permissions correctly and then terminates

## SugarDockerized installation
* The first step for everything to work smoothly, is to add on your computer's host file `/etc/hosts` the entry `docker.local` to point to your machine's ip (it might be `127.0.0.1` if running the stack locally, or the LAN static ip address of the VM running Docker. If using the Debian VirtualBox image provided at the bottom of this README, the ip address is `10.10.10.10`)
* Clone the repository with `git clone https://github.com/esimonetti/SugarDockerized.git sugardocker` and enter sugardocker with `cd sugardocker`
* Choose the yml stack to run, within [stacks](stacks/)

## Starting and stopping the desired stack
Please leverage the utility script [stack.sh](https://github.com/esimonetti/SugarDockerized#stacksh) that will help with automation of the most common stacks. The utility will also notify you if a new version of SugarDockerized is available.

## Installation - How to get Sugar installed
For details about the hostnames and credentials of each of the infrastructure components, refer to [Sugar Setup details](https://github.com/esimonetti/SugarDockerized#sugar-setup-details).

### Sugar installation via installable zip file
* The first step is to copy (cp/scp/rsync/filezilla etc) the compressed installable zip file into a known path within the Linux host running SugarDockerized
* Run the utility `installfromzip.sh`. Read more about [installfromzip.sh](https://github.com/esimonetti/SugarDockerized#installfromzipsh)

### Sugar installation building from git source
* To be able to proceed further, you would need read permission access to Sugar's official git source control repository
* Clone the full git repository within your `./data/app/` directory so that the repository is located in `./data/app/Mango/`
* Switch to the correct branch
* Run the utility `build/build.sh`. Read more about [build/build.sh](https://github.com/esimonetti/SugarDockerized#buildbuildsh)

## Current version support
The main stacks work with [Sugar version 9.0 and all its platform requirements](http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_9.0.x_Supported_Platforms/). Additional stacks are aligned with the platform requirements of version [8.0](http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_8.0.x_Supported_Platforms/), [7.9](http://support.sugarcrm.com/Resources/Supported_Platforms/Sugar_7.9.x_Supported_Platforms/) and stacks for Sugar Cloud only versions for local development only.

## System's details

### Stack components hostnames and names
* Apache load balancer: sugar-lb
* Apache PHP web server; On single stack: sugar-web1 On cluster stack: sugar-web1 and sugar-web2
* MySQL database: sugar-mysql
* Elasticsearch: sugar-elasticsearch
* Redis: sugar-redis
* Cron: sugar-cron
* Permission: sugar-permissions

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
    * MySQL db name: sugar
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
* Zend OPcache - Configured for Sugar with the assumption the files will be located within the correct path
* XHProf and Tideways profilers
* Xdebug is installed but it is not enabled by default (due to its performance impact). For PHP 5.6 images and all cron images if there is the need to enable it, you would have to uncomment the configuration option on the PHP Dockerfile of choice, and leverage the stack configuration with local build. For other case see [`xdebug.sh`](#xdebugsh).
    * If you use an IDE such as PHPStorm, you can setup DBGp Proxy under the menus Preference -> Language & Framework -> PHP -> Debug -> DBGp Proxy. Example settings are available in the screenshot below:

      <img width="1026" alt="PHPStorm xdebug settings" src="https://user-images.githubusercontent.com/361254/38972661-d48661f6-4356-11e8-9245-ad598239fe94.png">

        * Debug with Xdebug Helper

          If you use Chrome as a browser, you can install the extension [Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc). When ready to debug, click the debug button on the Xdebug helper, and click on "Start listening for PHP Debug Connections" within PHPStorm

          <img width="146" alt="xdebughelper" src="https://user-images.githubusercontent.com/361254/43093912-5a7a3bf2-8e66-11e8-9c11-811316d8f2ee.png">
          <img  width="50" alt="Start listening for PHP Debug Connections" src="https://user-images.githubusercontent.com/361254/43093985-8d4aa724-8e66-11e8-946c-5ccc83b62560.png">

        * Debug with Postman

          It is possible to debug a specific API endpoint through Postman leveraging a similar approach.
          In this example, we are going to debug the login authentication api endpoint rest/v11_1/oauth2/token. The first step is to add the cookie "XDEBUG_SESSION" in Postman. The same cookie is set through the Xdebug helper, and the keyword is referenced on the PHPstorm settings and on Xdebug PHP server side settings as well.
          See screenshots below:

          <img width="948" alt="Debug with Postman" src="https://user-images.githubusercontent.com/361254/43094521-0cf97058-8e68-11e8-8fc3-303c513dc1e9.png">
          <img width="679" alt="Postman cookie setting for remote debug" src="https://user-images.githubusercontent.com/361254/43094713-9190640c-8e68-11e8-95e0-11b866e452d4.png">


Session storage is completed leveraging the Redis container.

## Elasticsearch additional information
If you notice that your Elasticsearch container is not running (check with `docker ps`), it might be required to tweak your Linux host settings.
To be able to run Elasticsearch version 5 and above, it is needed an [increase of the maximum mapped memory a process can have](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/vm-max-map-count.html). To complete this change permanently run:

`echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf`

Alternatively the limit can be increased runtime with:

`sudo sysctl -w vm.max_map_count=262144`

### Docker images
* `images/php/XY/apache/` - Image for Apache with PHP version X.X
* `images/php/XY/cron/` - Image for PHP version X.Y, for background jobs and any CLI need
* `images/mysql/XY/` - Image for MySQL version X.Y
* `images/elasticsearch/XY/` - Image for Elasticsearch X.Y
* `images/permissions/` - Image for permissions fixing container
* `images/loadbalancer/` - Image for Apache load balancer
* `images/jmeter/` - Image for Jmeter
* `images/sidecar-build/` - Image for building Sidecar's javascript
* `images/traefik/` - Traefik image to expose Sugar within the local network when using a VM
* `images/ldap/` - OpenLDAP image

Most images are currently leveraging Debian linux.

### Persistent storage locations
All persistent storage is located within the `./data` directory tree within your local checkout of this git repository.
* The Sugar application files served from the web servers and leveraged by the cronjob server have to be located in `./data/app/sugar/`. Within the web servers and the cronjob server the location is `/var/www/html/sugar/`. Everything within `./data/app/` can be accessed through the browser, but the Sugar instance files have to be within `./data/app/sugar/`
* MySQL files are located in `./data/mysql/XY/`
* Elasticsearch files are located in `./data/elasticsearch/XY/`
* Redis files are located in `./data/redis/`
* LDAP files are located in `./data/ldap/`

Do not change the permissions of the various data subdirectories, as it might cause the system to not work correctly.

#### Sugar single instance application files - important notes
This setup is designed to run only a single Sugar instance. It also requires the application files to be exactly on the right place for the following three reasons:
1. File system permissions settings
2. PHP OPcache settings (eg: blacklisting of files that should not be cached)
3. Cronjob background process running

For the above reasons the single instance Sugar's files have to be located inside `./data/app/sugar/` (without subdirectories), for the stack setup to be working as expected.
If you do need multiple instances, as long as they are not running at the same time, you can leverage the provided tools to replicate and swap the data directories.

## Tips

### Utilities
To help with development, there are a set of tools provided within the `utilities` [directory of this repository](utilities). Some of the scripts are mentioned below.

#### xdebug.sh
```./utilities/xdebug.sh [status | start | stop]```
```
./utilities/xdebug.sh status
xDebug status
PHP 7.1.33 (cli) (built: Nov 22 2019 18:28:25) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.1.33, Copyright (c)1999-2018, by Zend Technologies
```
```
./utilities/xdebug.sh start
Start xDebug
6c9a9862b60c
PHP 7.1.33 (cli) (built: Nov 22 2019 18:28:25) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.1.33, Copyright (c) 1999-2018, by Zend Technologies
    with Xdebug v2.9.2, Copyright (c) 2002-2020, by Derick Rethans
```
```
./utilities/xdebug.sh stop
Stop xDebug
6c9a9862b60c
PHP 7.1.33 (cli) (built: Nov 22 2019 18:28:25) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.1.33, Copyright (c) 1999-2018, by Zend Technologies
```
Due to performance impact, Xdebug is disabled by default. This script prompts you to activate Xdebug, check if Xdebug is activated, or disable it.
If you do not want to configure DBGp Proxy when running the script, you can specify the second argument `change-ip`. In this case, the script will change the `xdebug.remote_host` option to your local IP address.
```
./utilities/xdebug.sh start change-ip
Start xDebug
New IP of remote_host: 192.168.0.105
6c9a9862b60c
PHP 7.1.33 (cli) (built: Nov 22 2019 18:28:25) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.1.33, Copyright (c) 1999-2018, by Zend Technologies
    with Xdebug v2.9.2, Copyright (c) 2002-2020, by Derick Rethans
```

#### setownership.sh
```./utilities/setownership.sh```
```
All directories and files within "data" are now owned by uid:gid 1000:1000
```
It sets the correct ownership of the data directories

#### stack.sh
```./utilities/stack.sh 80 down```
```
./utilities/stack.sh 80 down
stacks/sugar8/php71.yml down
Stopping sugar-cron          ... done
Stopping sugar-web1          ... done
Stopping sugar-redis         ... done
Stopping sugar-mysql         ... done
Stopping sugar-elasticsearch ... done
Removing sugar-cron          ... done
Removing sugar-web1          ... done
Removing sugar-redis         ... done
Removing sugar-mysql         ... done
Removing sugar-permissions   ... done
Removing sugar-elasticsearch ... done
Removing network sugar8_default
No stopped containers
```
It helps to take the default stack for the sugar version passed as a parameter, up or down. It expects two parameters: version number (eg: 80, 90 etc) and up/down.
Have a look at the configuration file `./utilities/stacks.conf`, to know all the available stack combinations for the script. For some of the main stacks is available the "local" version of the stack, that allows local modification of settings and local docker image building.

#### runcli.sh
```./utilities/runcli.sh "php ./bin/sugarcrm password:weak"```
It helps to execute a command within the CLI container. It requires the stack to be on

#### toothpaste.sh
This script is a wrapper for the external Sugar CLI tool called [Toothpaste](https://packagist.org/packages/esimonetti/toothpaste). The tool is downloaded automatically during its first use from packagist through composer. To update it periodically, run `./utilities/toothpaste/install.sh`. To understand more about the featureset, either read more on the repository, or just run `./utilities/toothpaste.sh list` to list all the commands currently available.
This tool is also used to run a system repair throughout the system scripts.

#### backup.sh
```./utilities/backup.sh 802_2018_11_21```
```
Backing up sugar to "backups/backup_802_2018_11_21"
[sudo] password for docker: 
Application files backed up on backups/backup_802_2018_11_21/sugar
Database backed up on backups/backup_802_2018_11_21/sugar.sql
```
It takes a snapshot of sugar files on `backups/backup_802_2018_11_21/sugar` and a MySQL database dump on `backups/backup_802_2018_11_21/sugar.sql`.
The script assumes that the database name is sugar and the web directory is sugar as well. The script does not take backups of Elasticsearch and/or Redis.

#### restore.sh
```./utilities/restore.sh 802_2018_11_21```
```
Restoring sugar from "backups/backup_802_2018_11_21"
sugar-permissions
Application files restored
Database "sugar" dropped
Database restored
Debug: Entering directory .
Repairing...
Repair completed in 9 seconds.
System repaired
```
It restores a previous snapshot of sugar files from `backups/backup_802_2018_11_21/sugar` and of MySQL from `backups/backup_802_2018_11_21/sugar.sql`
The script assumes that the database name is sugar and the web directory is sugar as well. The script does not restore Elasticsearch and/or Redis.

#### jmeter/build.sh
This script installs the jmeter components present on the [performance repository](https://github.com/sugarcrm/performance).
Access to the repository is needed, if you are a Sugar Partner or Customer you can request access by mailing: developers@sugarcrm.com

#### jmeter/run.sh
This script runs the jmeter test scenario.
To allow authentication, users with the format user:user1 pass:user1 should be created in advance.
```sh
$./utilities/jmeter/run.sh "ant customerTarget -file build.xml -DHOST_HEADER=10.10.10.10 -DSERVER=10.10.10.10 -DTIMER_DELAY=5000 -DTHREADS=5 -DITERATION_NUM=8 -DREST_ENDPOINT=/sugar/rest/v11_1 -DTHREAD_RAMP_UP=120"
```
The following arguments should be adapted to target server:

* **HOST_HEADER** - Used to pass HOST header on load balancer.
* **SERVER** - SugarCRM server

#### installfromzip.sh
This script requires a Sugar zip package, and the zip package needs to be on the host running SugarDockerized.
If the installable zip package is located within the local directory `~/installable/SugarEnt-9.0.2.zip` the install command would be:
```./utilities/installfromzip.sh ~/installable/SugarEnt-9.0.2.zip```

The script will perform all the steps required to silently install the software within the SugarDockerized stack currently running.
To know more about additional custom configuration parameters and actions that can be used/performed during the silent installation refer to [script build/silentinstall.sh](https://github.com/esimonetti/SugarDockerized#buildsilentinstallsh).

#### build/build.sh
This script is most likely for Sugar Employees only.
The script requires a clone of Sugar's git repository within `./data/app/Mango` with the `index.php` located within `./data/app/Mango/sugarcrm/index.php`.
If we want to build the application version 10.0.0 Enterprise, the build command would be:
```./utilities/build/build.sh ent 10.0.0```

The script will perform all the steps necessary to build the current branch of the software and also perform its silent installation.
To know more about additional custom configuration parameters and actions that can be used/performed during the silent installation refer to [script build/silentinstall.sh](https://github.com/esimonetti/SugarDockerized#buildsilentinstallsh).

#### build/silentinstall.sh
The script is leveraged by both `installfromzip.sh` and `build/build.sh` to install silently Sugar on the current stack.
This script allows a certain degree of flexibility by allowing the following customisations:
* Custom installation configuration - to provide infrastructure details, urls, license key etc.
* Custom `config_override.php` - to provide additional settings that might be needed for your Sugar installation
* Custom initialisation PHP script - allows to perform actions to the system after installation, leveraging Sugar Beans and any system logic (eg: load few test users, configure mail settings etc)

##### Custom installation configuration
The custom installation configuration has to be located in `./data/app/configs/install_config_custom.php`. This script is optional. An empty and initialised version of this file will be generated if it does not exist.
An example of what an installation configuration looks like, is below:

```
<?php
$config_override = [
    'setup_license_key' => '123123123123123123123123123123123123123',
    'demoData' => 'yes',
];
```

As an example, if SugarDockerized is used only for the web server parts, and for the storages (database, search, cache) you decide to use native AWS components, you could easily override the installation settings required to do so. The full list of available setup options can be found on SugarDockerized `./utilities/configs/install_config.php`.

##### Custom `config_override.php`
The custom `config_override.php` has to be located in `./data/app/configs/config_override_custom.php`. This script is optional. An empty and initialised version of this file will be generated if it does not exist.
An example of what a custom `config_override.php` looks like, is below:

```
<?php
$config_override = [];
$config_override['passwordsetting']['minpwdlength'] = 1;
$config_override['passwordsetting']['oneupper'] = 0;
$config_override['passwordsetting']['onelower'] = 0;
$config_override['passwordsetting']['onenumber'] = 0;
$config_override['passwordsetting']['onespecial'] = 0;
$config_override['passwordsetting']['SystemGeneratedPasswordON'] = 0;
$config_override['passwordsetting']['forgotpasswordON'] = 0;
$config_override['moduleInstaller']['packageScan'] = true;
```

The above example disables automated password generation, forgot password functionality and reduces the complexity of enforced password policy to just 1 character for testing purposes. It also enables package scanner on the instance, to make sure all packages installed on the application through its api/UI can also be installed on SugarCloud.

##### Custom initialisation PHP script
The custom initialisation PHP script that is executed after the silent installation has to be located in `./data/app/custominitsystem.php`. This script is optional.
An example of a useful initilisation script is below:

```
<?php
// settings
$set = [
    'email-admin' => 'my@email.com',
    'email-user' => 'my-second@email.com',
    'tzone' => 'Australia/Sydney',
    'date' => 'd/m/Y',
    'time' => 'H:i',
    'name-format' => 's f l',
];

echo 'Updating admin user' . PHP_EOL;
$admin = \BeanFactory::newBean('Users');
$admin->getSystemUser();
$admin->first_name = 'admin';
$admin->last_name = 'admin';
$admin->email1 = $set['email-admin'];
$admin->cookie_consent = 1;
$admin->save();

$admin = \BeanFactory::getBean('Users', $admin->id);
$admin->setPreference('viewed_tour', 1);
$admin->setPreference('timezone', $set['tzone']);
$admin->setPreference('datef', $set['date']);
$admin->setPreference('time', $set['time']);
$admin->setPreference('ut', 1);
$admin->setPreference('default_locale_name_format', $set['name-format']);
$admin->savePreferencesToDB();

echo 'Creating test user' . PHP_EOL;
$u = \BeanFactory::newBean('Users');
$u->user_name = 'test';
$u->first_name = 'test';
$u->last_name = 'test';
$u->user_hash = \User::getPasswordHash('test');
$u->status = 'Active';
$u->email1 = $set['email-user'];
$u->cookie_consent = 1;
$u->save();

$u = \BeanFactory::getBean('Users', $u->id);
$u->setPreference('viewed_tour', 1);
$u->setPreference('timezone', $set['tzone']);
$u->setPreference('datef', $set['date']);
$u->setPreference('time', $set['time']);
$u->setPreference('ut', 1);
$u->setPreference('default_locale_name_format', $set['name-format']);
$u->savePreferencesToDB();

echo 'Setting default mail server to sugar-smtp' . PHP_EOL;
$oe = \BeanFactory::newBean('OutboundEmail');
$oe->mail_smtpserver = 'sugar-smtp';
$oe->mail_smtpport = 25;
$oe->mail_smtpssl = 0;
$oe->saveSystem();
```

The above script configures specific settings of the Sugar System user and also creates a new test user. The script can be extended and improved to suit the specific needs.

### Detect web server PHP error logs
To be able to achieve this consistently, it is recommended to leverage the single web server stack.
By running the command `docker logs -f sugar-web1` it is then possible to tail the output from the access and error log of Apache and/or PHP. To view just the errors of Apache and/or PHP it is possible to run the command `docker logs -f sugar-web1 1>/dev/null`. The same approach applies to the `sugar-cron` container for cron and cli debugging. It applyes to any Docker container in general.

### Fix Sugar permissions
You would just need to run again the permissions docker container with `docker start sugar-permissions`. The container will fix the permissions and ownership of files for you and then terminate its execution.
Apache and Cron run as the `sugar` user. Se the following options on `config_override.php`

```
$sugar_config['default_permissions']['user'] = 'sugar';
$sugar_config['default_permissions']['group'] = 'sugar';
```

### Run command line Repair
The application installs few scripts built to facilitate the system's repair from command line. The scripts will wipe the various caches (including OPcache and Redis if used). The cron container from which the repair runs, has also been optimised to speed up the repairing processing.
To run the repair from the docker host, assuming that the repository has been checked out on sugardocker execute:

```
cd sugardocker
./utilities/repair.sh
```
The actual code for `repair.sh` leverages the [`toothpaste.sh`](#toothpastesh) script mentioned above.

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
docker@docker:~/sugardocker$ ./utilities/runcli.sh "php ../myAppTestCliScript.php"
```

```
docker@docker:~/sugardocker$ ./utilities/runcli.sh "cd ../toothpaste && ./vendor/bin/toothpaste local:system:repair --instance ../sugar"
```

```
docker@docker:~/sugardocker$ ./utilities/runcli.sh "whoami"
sugar
```

```
docker@docker:~/sugardocker$ ./utilities/runcli.sh "pwd"
/var/www/html/sugar
```

If needed, sudo is available as well without the need of entering a password. Just make sure the permissions and ownership (user `sugar`) is respected.

### XHProf / Tideways profiling data collection

Both XHProf extension and Tideways extensions are configured in most stacks.

To enable profiling:
* If you choose to use Tideways, add [this custom code](https://github.com/esimonetti/SugarTidewaysProfiling) to your Sugar installation and repair the system.
* Configure `config_override.php` specific settings (see below based on the stack extension)

XHProf Sugar `config_override.php` configuration:
```
$sugar_config['xhprof_config']['enable'] = true;
$sugar_config['xhprof_config']['log_to'] = '../profiling';
$sugar_config['xhprof_config']['sample_rate'] = 1;
$sugar_config['xhprof_config']['flags'] = 0;
```

Tideways Sugar `config_override.php` configuration:
```
$sugar_config['xhprof_config']['enable'] = true;
$sugar_config['xhprof_config']['manager'] = 'SugarTidewaysProf';
$sugar_config['xhprof_config']['log_to'] = '../profiling';
$sugar_config['xhprof_config']['sample_rate'] = 1;
$sugar_config['xhprof_config']['flags'] = 0;
```

Make sure new files are created on `./data/app/profiling/` when navigating Sugar. If not, ensure that the directory permissions are set correctly so that the `sugar` user can write on the directory.

Please note that profiling degrades user performance, as the system is constantly writing to disk profiling information and tracking application stats. Use profiling only on replica of the production environment.

### XHProf / Tideways profiling data analysis

* Download [XHProf viewer](https://github.com/sugarcrm/xhprof-viewer/releases/latest) zip file
* Unzip its files content within `./data/app/performance/`
* Make sure the `config_override.php` settings available on `./data/app/performance/` are kept as is (`<?php
$config['profile_files_dir'] = '../profiling';`)
* Access the viewer on http://docker.local/performance/ and verify that the collected data is viewable

### Typical Sugar config_override.php options for real-life development
```
$sugar_config['external_cache_disabled'] = false;
$sugar_config['external_cache_disabled_redis'] = false;
$sugar_config['external_cache_force_backend'] = 'redis';
$sugar_config['external_cache']['redis']['host'] = 'sugar-redis';
$sugar_config['external_cache_disabled_wincache'] = true;
$sugar_config['external_cache_disabled_db'] = true;
$sugar_config['external_cache_disabled_smash'] = true;
$sugar_config['external_cache_disabled_apc'] = true;
$sugar_config['external_cache_disabled_zend'] = true;
$sugar_config['external_cache_disabled_memcache'] = true;
$sugar_config['external_cache_disabled_memcached'] = true;
$sugar_config['cache_expire_timeout'] = 600; // default: 5 minutes, increased to 10 minutes
$sugar_config['disable_vcr'] = true; // bwc module only
$sugar_config['disable_count_query'] = true; // bwc module only
$sugar_config['save_query'] = 'populate_only'; // bwc module only
$sugar_config['collapse_subpanels'] = true; // 7.6.0.0+
$sugar_config['hide_subpanels'] = true; // bwc module only
$sugar_config['hide_subpanels_on_login'] = true; // bwc module only
$sugar_config['logger']['level'] = 'fatal';
$sugar_config['logger']['file']['maxSize'] = '10MB';
$sugar_config['developerMode'] = false;
$sugar_config['dump_slow_queries'] = false;
$sugar_config['import_max_records_total_limit'] = '2000';
$sugar_config['verify_client_ip'] = false;
```
Tweak the above settings based on your specific needs.

### PHPMyAdmin
You can run PHPMyAdmin in a container to get access to the database tables.

Pull the image

```
docker pull phpmyadmin/phpmyadmin
```
Find the network name

```
docker inspect sugar-mysql -f "{{json .NetworkSettings.Networks }}"
```

Note the network name from the result

```
{"sugar9_default":{"IPAMConfig":null,"Links":null,"Aliases":["25cea53d92b9","mysql"],"NetworkID":"a5a4d323a0a423ad81512c189f73a5b44195a72708e0d48819cb1bd3c89ff5ba","EndpointID":"ea35c217dc0a8b23c09dbb1a46ca29de710dde7fe954413e92967bfc50808d43","Gateway":"172.20.0.1","IPAddress":"172.20.0.4","IPPrefixLen":16,"IPv6Gateway":"","GlobalIPv6Address":"","GlobalIPv6PrefixLen":0,"MacAddress":"02:42:ac:14:00:04","DriverOpts":null}}
```

Run phpmyadmin and forward port 80 to 8080 on localhost.  Substitute your network name.

```
docker run --network sugar9_default --name myadmin -d -e PMA_HOST=sugar-mysql -p 8080:80 phpmyadmin/phpmyadmin 
```

Go to PhpMyAdmin

http://localhost:8080

## Mac users notes
These stacks have been built on a Mac platform, that is known to not perform well with [Docker mounted volumes](https://github.com/docker/for-mac/issues/77).
Personally I run Docker on a Debian based minimal VirtualBox VM with fixed IP, running a NFS server. I either mount NFS on my Mac when needed or SSH directly into the VM. [The Debian Docker VirtualBox VM for Mac is available here](https://github.com/esimonetti/DebianDockerMac) with its [latest downloadable version here](https://github.com/esimonetti/DebianDockerMac/releases/latest).<br/>
Alternatively, (...if you are brave enough to run Docker locally on a Mac) you can attempt to use mounted volumes for the data storage (Redis, MySQL and Elasticsearch) and the delegated option. An example of this setup working, can be found [here `stacks/sugar9/php73-mac.yml`](stacks/sugar9/php73-mac.yml) and it can be initiated with `./utilities/stack.sh 90-mac up`.

### Disk performance stats
To compare performance between Mac and Linux VM on Mac we can use the Toothpaste utility as follows: `./utilities/toothpaste.sh "local:analysis:fsbenchmark --instance ../sugar"`.

Mac with `90` stack:
```
Read speed: 640.50 KB/s
Write speed: 1,407.49 KB/s
Execution completed in 840.26 seconds.
```

Mac with optimised `90-mac` stack:
```
Read speed: 2,455.70 KB/s
Write speed: 1,735.60 KB/s
Execution completed in 333.20 seconds.
```

Linux VirtualBox VM on Mac with `90` stack:
```
Read speed: 114,875.19 KB/s
Write speed: 56,997.04 KB/s
Execution completed in 8.26 seconds.
```

The performance difference with the same exact test cannot be ignored, hence the recommendation to use a Linux VirtualBox VM. The above mentioned disk speeds make the Mac setup unusable.
