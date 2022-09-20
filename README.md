# README


Container project "BASTION" with various automation tools and CLI of CLOUDs (AWS, Azure, GCP).

Usage Mode.

**1 - Use ready container**
```
podman run quay.io/fcalomen/bastion:latest -t bastion
```
````
podman exec -it bastion /bin/bash
````

**2 - Customize container**

The dockerfile file uses UBI(Universal Base Image) 8 as base image with python-3.9.

> registry.access.redhat.com/ubi8/python-39:latest

**Python Requirements**

requirements.txt
>awscli
>ansible
>ansible-core
>boto
>boto3
>botocore
>cffi
>cryptography
>ec2
>Jinja2
>jmespath
>MarkupSafe
>packaging
>pycparser
>pyparsing
>python-dateutil
>resolvelib
>s3transfer
>kubernetes
>jsonpatch

Cloud CLI's
-
- aws cli
- gcloud-cli
- azure-cli
- ibmcloud cli
- openshift
- openshift-install
- kubernetes
- rosa cli

Automation tools
- 
- ansible
- terraform
- skupper
