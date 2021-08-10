# -----------------------------------------------------------------------------
#
# This file is the copyrighted property of Tableau Software and is protected
# by registered patents and other applicable U.S. and international laws and
# regulations.
#
# Unlicensed use of the contents of this file is prohibited. Please refer to
# the NOTICES.txt file for further details.
#
# -----------------------------------------------------------------------------
#ARG baseImageURL

#FROM rhel7/rhel
#FROM ${baseImageURL}
FROM registry.access.redhat.com/rhel7/rhel:7.9

COPY ./init /init
RUN ./init/setup_default_environment.bash

ARG eulaAccepted
ARG installerFile
ARG versionString
ARG serviceName
ARG unprivilegedUsername=tableau
ARG unprivilegedGroupName=tableau

LABEL tableau.service-name=${serviceName} \
    tableau.version=${versionString} \
    tableau.operating_system="rhel7/rhel"

COPY ./${installerFile} /${installerFile}
# Lots of code downstream from here is looking for this env var to be set to know we are running
# in a tableau server in a container
ENV SUPERVISOR_ENABLED=1 \
    TABLEAU_BYPASS_SYSTEM_REQ_CHECK=1
#RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
RUN yum install -y ${installerFile}

# This is one huge line so that it's only a single docker command and thus a single layer
ENV CONTAINER_ENABLED=1 \
    INSTALL_DIR=/opt/tableau/tableau_server \
    DATA_DIR=/var/opt/tableau/tableau_server \
    DOCKER_CONFIG=/docker \
    LANG=en_US.UTF-8 \
    SERVICE_NAME=${serviceName} \
    SERVICE_VERSION=${versionString} \
    INIT_CONTAINER=0 \
    BOOTSTRAP_INSTALL=0 \
    ALWAYS_WRITE_BOOTSTRAP_FILE=0 \
    WAIT_FOR_BOOTSTRAP_FILE=1 \
    IGNORE_TOPOLOGY_CONFIG=0 \
    CONFIG_NAME="tabsvc" \
    PRIVILEGED_TABLEAU_GID=997 \
    UNPRIVILEGED_TABLEAU_GID=998 \
    UNPRIVILEGED_TABLEAU_UID=999 \
    UNPRIVILEGED_USERNAME=${unprivilegedUsername} \
    UNPRIVILEGED_GROUP_NAME=${unprivilegedGroupName} \
    PRIVILEGED_GROUP_NAME=tsmadmin \
    PORT_RANGE_MIN=8800 \
    PORT_RANGE_MAX=9000 \
    ACCEPTEULA=${eulaAccepted} \
    TSM_ONLY=0 \
    TSM_REMOTE_UID="" \
    TSM_REMOTE_USERNAME="" \
    TABLEAU_USERNAME="" \
    TABLEAU_PASSWORD="" \
    HTTP_PROXY="" \
    HTTPS_PROXY="" \
    NO_PROXY="" \
    COORDINATION_SERVICE_CLIENT_PORT="" \
    COORDINATION_SERVICE_PEER_PORT="" \
    COORDINATION_SERVICE_LEADER_PORT="" \
    LICENSE_SERVICE_VENDOR_DAEMON_PORT="" \
    AGENT_FILE_TRANSFER_PORT="" \
    CONTROLLER_PORT="" \
    REQUESTED_LEASE_TIME=""

# This is not part of the previous ENV line because it needs to deref INSTALL_DIR which
# is defined there.
ENV PATH=${PATH}:${INSTALL_DIR}/packages/customer-bin.${SERVICE_VERSION} \
    ENV_FILE=${DOCKER_CONFIG}/customer-files/environment \
    DOCKER_TMP=${DOCKER_CONFIG}/tmp \
    REGISTRATION_FILE=${DOCKER_CONFIG}/customer-files/reg-info.json \
    REGISTRATION_DATA="" \
    LICENSE_KEY_FILE=${DOCKER_CONFIG}/config/license_file \
    LICENSE_KEY="" \
    BACKUP_FILE=${DOCKER_CONFIG}/config/backup/backup-file.tsbak \
    CONFIG_FILE=${DOCKER_CONFIG}/config/config.json \
    CONFIG_DATA="" \
    BOOTSTRAP_FILE=${DOCKER_CONFIG}/config/bootstrap/bootstrap.json \
    BOOTSTRAP_DATA="" \
    TSM_REMOTE_PASSWORD="" \
    TSM_REMOTE_PASSWORD_FILE="${DOCKER_CONFIG}/config/remote-user-secret" \
    PRE_INIT_COMMAND_SCRIPT=${DOCKER_CONFIG}/customer-files/pre_init_command \
    POST_INIT_COMMAND_SCRIPT=${DOCKER_CONFIG}/customer-files/post_init_command

COPY ./docker ${DOCKER_CONFIG}

COPY ./.metadata.conf ${DOCKER_CONFIG}/.metadata.conf

RUN ${DOCKER_CONFIG}/customer-files/setup-script

RUN ${DOCKER_CONFIG}/install-process-manager
USER ${UNPRIVILEGED_USERNAME}:${UNPRIVILEGED_GROUP_NAME}

CMD ${DOCKER_CONFIG}/start-process-manager
