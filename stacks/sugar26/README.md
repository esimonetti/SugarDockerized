# Sugar Dockerized Sugar version 26
This repository will help you deploy a Docker based development full stack for Sugar version 26

## Stacks available
### Newly supported platforms
* php85-local-build.yml - Main reference stack - Single web server
    * PHP - 8.5
    * Apache - 2.4
    * MySQL - 8.4.3
    * Elasticsearch - 9.2.2 (docker.elastic.co)
    * Redis - latest
#### Usage
##### Pre-built images: `./utilities/stack.sh 26-latest <up/down>`
##### Build local images: `./utilities/stack.sh 26-latest-local <up/down>`

### Currently supported platforms
* `php84-local-build.yml` - Main reference stack - Single web server
    * PHP - 8.4.4
    * Apache - 2.4
    * MySQL - 8.4.3
    * Elasticsearch - 9.2.2 (docker.elastic.co)
    * Redis - latest

#### Usage
##### Pre-built images: `./utilities/stack.sh 26 <up/down>`
##### Build local images: `./utilities/stack.sh 26-local <up/down>`
