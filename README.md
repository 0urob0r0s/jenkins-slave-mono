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

Please refer to Github repo USAGE.md for further instructions and examples.
