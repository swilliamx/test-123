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

ARG imageName
FROM ${imageName}

USER root
ARG installerFile
ARG upgradeVersionString
ARG serviceName

LABEL tableau.service-name=${serviceName} \
    tableau.upgrade-version=${upgradeVersionString}

COPY ./${installerFile} /${installerFile}
# Lots of code downstream from here is looking for this env var to be set to know we are running
# in a tableau server in a container
RUN yum install -y ${installerFile}

ENV UPGRADE_VERSION=${upgradeVersionString} \
    UPGRADE_ENV_FILE=${DOCKER_CONFIG}/upgrade/upgrade-environment

# Copy only upgrade-tableau-server script and environment override file.
COPY ./docker/upgrade ${DOCKER_CONFIG}/upgrade
COPY ./.metadata.conf ${DOCKER_CONFIG}/.upgrade_metadata.conf

RUN chrpath -r "${INSTALL_DIR}/packages/apache.${UPGRADE_VERSION}/lib" "${INSTALL_DIR}/packages/apache.${UPGRADE_VERSION}/bin/httpd" > /dev/null

# Writes override environment variables to .bashrc file user's home directory.
RUN if [ -f "${UPGRADE_ENV_FILE}" ] ; then echo "export \$(sed -e '/^#/d'" "${UPGRADE_ENV_FILE}" "| xargs) > /dev/null 2>&1" >> "/docker/user/.bashrc" ; fi

USER ${UNPRIVILEGED_USERNAME}:${UNPRIVILEGED_GROUP_NAME}

CMD ${DOCKER_CONFIG}/upgrade/upgrade-tableau-server
