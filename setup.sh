#!/bin/sh
#                    Copyright (c) 2018-2018
#   Data Intensive Applications and Systems Labaratory (DIAS)
#            Ecole Polytechnique Federale de Lausanne
#
#                      All Rights Reserved.
#
# Permission to use, copy, modify and distribute this software and its
# documentation is hereby granted, provided that both the copyright notice
# and this permission notice appear in all copies of the software, derivative
# works or modified versions, and any portions thereof, and that both notices
# appear in supporting documentation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. THE AUTHORS AND ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE
# DISCLAIM ANY LIABILITY OF ANY KIND FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE
# USE OF THIS SOFTWARE.

# Import settings
. ./settings.sh

# Install docker, for ubuntu
sudo apt update
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update
sudo apt install docker-ce

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# If requested, setup portainer:
if ${PORTAINER_ENABLED}
then
	# Permanent storage for Portainer
	mkdir -p ${PORTAINER_DATA}

	sudo docker run -d -p ${PORTAINER_PORT}:9000 \
		--restart unless-stopped \
		-v /var/run/docker.sock:/var/run/docker.sock:rw \
		-v ${PORTAINER_DATA}:/data:rw \
		--name ${COMPOSE_PROJECT_NAME}_${PORTAINER_HOST} \
		${PORTAINER_IMAGE}${PORTAINER_VERSION}
fi

# Permanent storage for the Databases
mkdir -p ${DB_DATA}
mkdir -p ${DB_DATASETS}
sudo chown -R 999:999 ${DB_DATA} ${DB_DATASETS}

# Permanent storage for Mesos
mkdir -p ${MESOS_MASTER_LOGS}
mkdir -p ${MESOS_MASTER_TMP}
mkdir -p ${MESOS_SLAVE_LOGS}
mkdir -p ${MESOS_SLAVE_TMP}
