FROM ubuntu:16.04

RUN apt-get update				\
    && apt-get install -y bash curl vim		\
    && mv /etc/vim/vimrc /etc/vim/vimrc.bak 

COPY oc /usr/local/bin/oc
COPY uid_entrypoint.sh ocp4-workshop-labs/ /labs/
WORKDIR /labs

# setup entrypoint for default user
RUN chmod -R g=u /etc/passwd /labs/*
ENTRYPOINT [ "/labs/uid_entrypoint.sh" ]
USER 1001
