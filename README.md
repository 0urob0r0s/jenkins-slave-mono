# Jenkins Slave Builder for MONO
 
**Overview**

This Dockerfile builds a Swarm based Jenkins Build Slave for MONO.
Coupled with Rancher it will let you build a distributable, highly available Build Cluster.

**Features**

- Based on The latest Stable Mono release (at the time of writing) is: v5.20.1
- Integrates Jenkins Swarm Agent for Automatic provisioning to a Jenkins Master Node.
- Compatible with nuget package manager.
- Compatible with Auto-scaling services.
- Node already tagged as Mono for restricted builds.

**Pre-requisites**

- Jenkins v2.164 Master Node
- Swarm Plugin v3.15

**Usage - Deployment**

*Environment variables:*

- MASTER_URL = Jenkins Master URL (including port if different than default http/https ports)
  - Example: *http://jenkins-server.com:8182*
- MASTER_USER = a Jenkins Master available user
- MASTER_PASSVAR = a Jenkins Master user password
- SLAVE_EXES = Quantity of Executor tasks. (Recommendended <= number of cores)

Example Docker Compose - Node Deployment for already existing Jenkins Master
```
version: '2'
services:
  Jenkins-Slave-Mono:
    privileged: true
    image: 0urob0r0s/jenkins-slave-mono:latest
    environment:
      MASTER_URL: http://myjenkins-master.com:8080
      MASTER_USER: jenkins
      MASTER_PASSVAR: jenkins
      SLAVE_EXES: '4'
    stdin_open: true
    volumes:
    - /opt/volumes/jenkins-slave-mono:/workspace
    - /var/run/docker.sock:/var/run/docker.sock
    tty: true
```

Example Docker Compose - Full Stack Jenkins Master + Build Node
```
version: '2'
services:
  Jenkins-Slave-Mono:
    privileged: true
    image: 0urob0r0s/jenkins-slave-mono
    environment:
      MASTER_URL: http://jenkins-master:8080
      MASTER_USER: jenkins
      MASTER_PASSVAR: jenkins
      SLAVE_EXES: '4'
    stdin_open: true
    volumes:
    - /opt/volumes/jenkins-slave-mono:/workspace
    - /var/run/docker.sock:/var/run/docker.sock
    tty: true
    links:
    - Jenkins-Server:jenkins-master
  Jenkins-Server:
    privileged: true
    image: jenkins/jenkins:lts
    stdin_open: true
    volumes:
    - /opt/volumes/jenkins-master:/var/jenkins_home
    tty: true
```  
**Usage - Post-Deployment Steps**

The Swarm Plugin is required in order to allow the automatic provisioning of the Build nodes.

*Perform the following steps on the Jenkins Master:*

1 - Enable JNLP Agent:

	- Manage Jenkins > Configure Global Security >>
	- Enable security [+]
	- Agents > TCP Port JNLP Fixed (*) 50000
	- Enable Agent → Master Access Control [+]

2 - Create a jenkins-slave User:

	- Manage Jenkins > Manage Users >>
	- Create User
  
3 - Install Plugins:

	- Manage Jenkins > Manage Plugins >>
	- Available > Self-Organizing Swarm Plug-in Modules [+]
  - Available > MSBuild Plugin [+]
 
4 - Configure MSBuild:

	- Manage Jenkins > Global Tool Configuration >>
	- MSBuild > Add MsBuild
	- Name → Mono
	- Path to MSBuild → /usr/bin/msbuild
