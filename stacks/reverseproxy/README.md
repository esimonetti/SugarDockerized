# Sugar Dockerized Reverse Proxy
If you are running the Linux VM within your OSX environment, you might want to expose your Sugar system to your whole network, while by default it is part of a NAT network, with ip address 10.10.10.10 and hostname docker.local.

This container will help you do just that, when deployed within your OSX environment. It is useful for devices within your network to be able to access your system. A practical example is the possibility of testing Sugar Mobile against your customisations.

## Instructions
* Clone the git repository into your OSX environment
* When leveraging this functionality, disable your OSX firewall by navigating to: System Preferences, Security & Privacy, Firewall, Turn Off Firewall
* Start the container with: `docker-compose -f stacks//docker-compose.yml up -d`
* Find out your local ip address by navigating to: System Preferences, Network and choosing the active network available in your specific scenario

It would then be possible for your local network to access your Sugar environment by navigating on the browser to the url: `http://<local ip address>/sugar/`

## Stacks available
* docker-compose.yml - Main reference stack - Single web server
    * Traefik 1.5.4