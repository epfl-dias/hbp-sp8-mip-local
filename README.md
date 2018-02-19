# MIP Local alternative deployment scripts

**Disclaimer:** The authors of this document are not in charge of the MIP development and its deployment scripts. They have limited knowledge of most of the elements that are deployed. No guaranties are offered as to the correctness of this document.

## Introduction

This repository contains alternative deployment scripts written in order to demonstrate the feasibility of a simpler deployment procedure.

By using more comprehensively the docker technology, it allows for:

 1. a simpler installation and deployment process, 
 2. lower software requirements on the host server,
 3. less infrastructure services as part of the platform, and finally,
 4. improved security as all the services are isolated from the physical network, unless explicitly published.

If anything, the current scripts contains still too many tunable options, which should be simplified.

At this time, and due to the lack of documentation, the following scripts deploy the MIP-local platform without the Data Factory, as it can be done based on version 2.5.3, from Dec 14 2017.

See also the official documentation of the deployment scripts project on Github:

 * [README](https://github.com/HBPMedical/mip-microservices-infrastructure/blob/master/README.md) file,
 * [Installation](https://github.com/HBPMedical/mip-microservices-infrastructure/blob/master/docs/installation/mip-local.md) instructions, and some
 * [More documentation](https://github.com/HBPMedical/mip-microservices-infrastructure/blob/master/docs).

## Software deployed

These scripts deploy the following software:

 1. On the host machine to support the platform:
    * [Docker Community Edition](https://www.docker.com/community-edition)
    * [docker-compose](https://docs.docker.com/compose/)

 2. As docker images as services:
    * [portainer](https://hub.docker.com/r/portainer/portainer/)
    * [zookeeper](https://hub.docker.com/_/zookeeper/)
    * [mesos-master](https://hub.docker.com/r/mesosphere/mesos-master/)
    * [mesos-slave](https://hub.docker.com/r/mesosphere/mesos-slave/)
    * [chronos](https://hub.docker.com/r/mesosphere/chronos/)
    * [postgresraw](https://hub.docker.com/r/hbpmip/postgresraw/)
    * [postgresraw-ui](https://hub.docker.com/r/hbpmip/postgresraw-ui/)
    * [woken](https://hub.docker.com/r/hbpmip/woken/)
    * [woken-validation](https://hub.docker.com/r/hbpmip/woken-validation/)
    * [portal-backend](https://hub.docker.com/r/hbpmip/portal-backend/)
    * [portal-frontend](https://hub.docker.com/r/hbpmip/portal-frontend/)

 3. As docker images, to setup the various databases required:
    * [create-databases](https://hub.docker.com/r/hbpmip/create-databases/)
    * [woken-db-setup](https://hub.docker.com/r/hbpmip/woken-db-setup/)
    * Metadata, one of: 
      + [mip-cde-meta-db-setup](https://hub.docker.com/r/hbpmip/mip-cde-meta-db-setup/)
      + [sample-meta-db-setup](https://hub.docker.com/r/hbpmip/sample-meta-db-setup/)
    * Packaged Data sets: **Public, requires sample-meta-db-setup**
      + [sample-data-db-setup](https://hub.docker.com/r/hbpmip/sample-data-db-setup/)
    * Packaged Data sets: **Private, requires mip-cde-meta-db-setup**
      + [adni-merge-db-setup](https://gitlab.com/hbpmip_private/adni-merge-db-setup)
      + [edsd-data-db-setup](https://gitlab.com/hbpmip_private/edsd-data-db-setup)
      + [ppmi-data-db-setup](https://gitlab.com/hbpmip_private/ppmi-data-db-setup)

## Requirements

- Ubuntu 16.04 system or RHEL 7.3+.

## Deployement

1. Install the software required

   ```sh
   $ sudo install-$OS.sh # OS=ubuntu or OS=redhat, depending on your system
   ```

2. Configure the platform for anything you wish or need to modify by adding your settings in settings.local.sh

   For reference, you can see all the parameters which can be tuned in `settings.default.sh`.

3. *Optional,* you can start a web interface to control the docker engine:

   ```sh
   $ ./portainer.sh 
   ```

4. Load the research data into the `LDSM`

   ```sh
   $ ./load_data.sh
   ```

   * If necessary, adapt the Database configuration options in `settings.local.sh`.
   * Check `settings.default.sh` to see the databases which are currently used by default. You can adapt the list `DB_SETUP_LIST` to this effect.

5. Start the platform with

   ```sh
   $ ./run.sh up -d
   ```

6. Add in the folder pointed by `${DB_DATASETS}` your CSV files, PostgresRAW will pick the up and create tables you can query right away automatically.

   If your clinical data contains variables used as part of the MIP CDEs, these will be taken into account automatically as long as you name your file `harmonized_clinical_data`.


**NOTES:** if you set `SHOW_SETTINGS=true` a printout of all the settings which will be used will be printed before doing anything.


## Settings

All the settings have default values, but you can change them by either exporting in your shell the setting with its value, or creating `settings.local.sh` in the same folder as `settings.sh`:

```sh
: ${VARIABLE:="Your value"}
```

**Note**: To find the exhaustive list of parameters available please take a look at `settings.default.sh`.

Settings are taken in the following order of precedence:

  1. Shell Environment, or on the command line
  2. Federation-specific `settings.local.sh`
  3. Default settings `settings.default.sh`
