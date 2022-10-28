#!/bin/bash
if getent passwd ${USER_NAME}; then userdel -f ${USER_NAME}; fi && \
    if getent group ${USER_NAME} ; then groupdel ${USER_NAME}; fi && \
    groupadd -g ${GID} ${USER_NAME} &&  \
    useradd -l -u ${UID} -g ${GID} -m ${USER_NAME} && \
    usermod -aG www-data ${USER_NAME}

/usr/sbin/apache2ctl -D FOREGROUND;