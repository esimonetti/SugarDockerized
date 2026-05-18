# Sugar Dockerized Sugar version 25
This repository will help you deploy a Docker based development full stack for Sugar version 25

## Stacks available
### Newly supported platforms
* php84-local-build.yml - Main reference stack - Single web server
    * PHP - 8.4.4
    * Apache - 2.4
    * MySQL - 8.4.3
    * Elasticsearch - 8.17.1
    * Redis - latest
#### Usage
##### Pre-built images: `./utilities/stack.sh 25-latest <up/down>`
##### Build local images: `./utilities/stack.sh 25-latest-local <up/down>`

### Currently supported platforms
* `php83-local-build.yml` - Main reference stack - Single web server
    * PHP - 8.3.14
    * Apache - 2.4
    * MySQL - 8.0.32
    * Elasticsearch - 8.4.3
    * Redis - latest

#### Usage
##### Pre-built images: `./utilities/stack.sh 25 <up/down>`
##### Build local images: `./utilities/stack.sh 25-local <up/down>`
