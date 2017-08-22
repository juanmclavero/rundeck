FROM    alpine

ENV     RUNDECK_VERSION=2.9.2
ENV     RDECK_BASE=/etc/rundeck
ENV     RDECK_JAR=$RDECK_BASE/app.jar
ENV     PATH=$PATH:$RDECK_BASE/tools/bin
ENV     SSH_PATH=/var/lib/rundeck/.ssh
ENV     PROJECTS=$RDECK_BASE/projects/

ADD     http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-${RUNDECK_VERSION}.jar $RDECK_JAR
RUN     apk add --update openjdk8-jre bash curl ca-certificates openssh-client && \
        mkdir -p $RDECK_BASE && \
        rm -Rf /var/cache/apk/*

COPY    run.sh /bin/rundeck

# Keystore
RUN     mkdir -p ${SSH_PATH}
RUN     mkdir -p $RDECK_BASE/ssl 

# Active Directory integration
COPY    jaas-activedirectory.conf $RDECK_BASE/server/config/jaas-activedirectory.conf

# ssh-keys
# logs
# projects dir
VOLUME  [ "${SSH_PATH}", "$RDECK_BASE/server/logs", "$PROJECTS" ]

CMD     rundeck
