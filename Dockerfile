# pull base image
FROM debian:jessie
  
 RUN \
     echo "===> add webupd8 repository..."  && \
     echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
     echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
     echo "deb http://ftp.de.debian.org/debian jessie main" >> /etc/apt/sources.list && \
     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
     apt-get update && \
     apt-get install -y gtk2-engines libxtst6 libxxf86vm1 freeglut3 libxslt1.1 && \
     apt-get update  && \
     \
     echo "===> install Java"  && \
     echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
     echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
     DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default  && \
     \
     echo "===> clean up..."  && \
     rm -rf /var/cache/oracle-jdk8-installer && \
     apt-get clean  && \
     rm -rf /var/lib/apt/lists/*

RUN \
    cd /opt && \
    wget -O jiraclient-3_8_1_without_jre.tar.gz http://d1.almworks.com/.files/jiraclient-3_8_1_without_jre.tar.gz && \
    tar -xzf jiraclient-3_8_1_without_jre.tar.gz

# cd to the Dex directory and execute the jar.
#CMD cd ~/Dex && java -jar Dex.jar
CMD cd /opt/jiraclient-3_8_1 && bin/jiraclient.sh
