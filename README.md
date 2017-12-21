
# This repo contains the source code to initialize a micro docker swarm cluster with 2 rpi3 and a x86_64 device with a Linux OS
### This Source code is part of Emergent Internet Services Lecture of Software Engineering MSc at University of Coimbra

The code present in this repo simulates a FOG environment, with local data producers inserting data into a centralized node
on the network that in this context is the manager running a 64 bit Linux OS.

This creates a elasticsearch database in the Manager, that is accessible via a kibana dashboard without any credentials

By navigating to each slave you are hitting the endpoint responsible for creating the data:

CPU usage in percentage
Memory Usage in percentage
RPI temperature

Feel free to change this code to whatever fits your needs at demo/app/app.py

To run this repo you need the following devices:
2x RPI3 with **HypriotOS** installed with default credentials
Requirements for Linux Manager Host:
    
    sshpass

    openssl

    docker v+ 1.13
    
    docker-composer v+ 1.13

    bash


### Launching the environment

Both RPI devices must use default configuration for HypriotOS

You should be able to set the Environment variables present a init-swarm.sh

All that is required is

    chmod+x init-swarm.sh && ./init-swarm.sh
    export manager=192.168.1.X && export slave1=192.168.1.X && export slave1=192.168.1.X bash init-swarm.sh



Available services

http://manager-ip-here:5601 - Kibana

http://slave1-ip-here - Slave1

http://slave2-ip-here - Slave2


### Removing the environment 


    chmod+x init-swarm.sh && ./cleanup.sh

