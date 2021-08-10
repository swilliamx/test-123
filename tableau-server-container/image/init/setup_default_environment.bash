#!/bin/bash
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
set -e

yum update -y
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#yum install -y epel-release
yum install -y https://downloads.tableau.com/esdalt/2021.2.0/tableau-tabcmd-2021-2-0.noarch.rpm
yum install -y https://downloads.tableau.com/drivers/linux/yum/tableau-driver/tableau-postgresql-odbc-9.5.3-1.x86_64.rpm
yum install -y jq python-pip

# Install supervisord using pip instead of saying "yum install -y supervisor". Yum installing it will get a very old
# version. We want the latest version of supervisord.

pip install supervisor

yum clean all -q
rm -rf /var/tmp/yum-*
rm -rf /var/cache/yum

# Make the system-auth session module optional in the su pam file
# This will prevent TSM su calls from failing due to resources being unavailable
sed -i 's/session\s*include\s*system-auth/session\t\toptional\tsystem-auth/' /etc/pam.d/su
