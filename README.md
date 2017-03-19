# Goal

Run an application like Jira Client inside a docker container on mac/osx

# Steps

1. Go ahead and clone this project.
2. You can build the image locally after cloning this project: `docker build -t jiraclient .`
3. Before you can run the image, you need to install xQuartz on mac/osx platforms
    1. This additional command was supposed to help but when I tried it ... it didn't accomplish its end goal (don't run it!):

    ```
    $ xhost +
    access control disabled, clients can connect from any host
    ```
4. So you will need to setup `socat` as an alternative
    1. You can use brew to install it: `sudo brew install socat`
    2. or, yo ucan use macports tp install it: `sudo port install socat`
5. This really extensive [thread](https://github.com/docker/docker/issues/8710) gives us an easy command for using `socat` to expose local `xQuartz` socket on a TCP port, let's run it in terminal: `socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`
6. In another terminal, you can now start jiraclient: `docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$(ipconfig getifaddr en0):0 jiraclient`

# Trial & Error

1. Before deciding to build an image from scratch for JavaFX, I tried many standard java container images:

    ```
    # attach to and use an image for experimentation
    docker run --rm -it java:8 /bin/bash
    docker run --rm -it java:7 /bin/bash
    docker run --rm -it openjdk:8 /bin/bash
    ```
2. And on each one I ran the following simple commands to install jiraclient but in the end everything failed because javafx was missing:

   ```
   # try to run jiraclient on the java image
   cd /opt && \
   wget -O jiraclient-3_8_1_without_jre.tar.gz http://d1.almworks.com/.files/jiraclient-3_8_1_without_jre.tar.gz && \
   tar -xzf jiraclient-3_8_1_without_jre.tar.gz && \
   cd jiraclient-3_8_1 && \
   bin/jiraclient.sh
   ```
3. Since Jira Client requires javafx ... finally the `Dockerfile` in this project was built based on the following tutorial: https://dexvis.wordpress.com/2016/04/04/running-javafx-in-a-docker-container/


# Useful Commands - Quick Reference

1. Show all containers: `docker ps -a`
2. Delete all stopped containers: `docker rm $(docker ps -a -q)`
3. Remove all untagged images: `docker rmi $(docker images -f "dangling=true" -q)`
