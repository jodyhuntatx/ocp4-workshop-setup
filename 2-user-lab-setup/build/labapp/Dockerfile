FROM alpine:3.12.1

RUN apk update											\
    && apk add 											\
	bash curl vim										\
	mysql-client										\
    && curl -LO https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64		\
    && chmod a+x jq-linux64 									\
    && mv jq-linux64 /usr/local/bin/jq								\
    && mv /etc/vim/vimrc /etc/vim/vimrc.bak 							\
    && mkdir /labs										\
    && curl -sSL https://raw.githubusercontent.com/cyberark/summon/master/install.sh 		\
      | env TMPDIR=$(mktemp -d) bash 								\
    && curl -sSL https://raw.githubusercontent.com/cyberark/summon-conjur/master/install.sh	\
      | env TMPDIR=$(mktemp -d) bash

COPY secrets.yml mysql_REST.sh mysql_provider.sh mysql_secretless.sh mysql_summon.sh uid_entrypoint.sh /labs/

WORKDIR /labs

# setup entrypoint for default user
RUN chmod g=u /etc/passwd /labs/*.sh
ENTRYPOINT [ "/labs/uid_entrypoint.sh" ]
USER 1001
