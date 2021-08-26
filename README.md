# Tableau Application

This is Tableau application which runs on port 8080.
## Features

- Infrastructure provision for ECS container using fargate with fault tolerant and HA.

## Tech

This project involves using open-source tools:

- [Terraform](https://www.terraform.io/) - Tools for infrastructure creation!

## Installation

Follow below links for tools installation
- [Jenkins](https://www.jenkins.io/doc/book/installing/)

## Pre-requisite
- Make sure you have permission to deploy the infrastructure on AWS platform.
- Make sure you update ECR repo name  which has image already build.

## Terraform Code Structure

```sh
   modules/
   autoscaling.tf       # autoscaling config
   load_balancer.tf     # loadbalancer and target group config
   main.tf              # VPC creation using module
   ecs.tf               # ecs cluster/service/task config
   variables.tf         # variables config.
   outputs.tf           # outputs config.
   provider.tf          # AWS provider config.
   environments/dev/dev.tfvars # variable values are defined here.
```

#### Terraform Usage
To deploy the infrastructure, use below command to do so.
```sh
$ terraform init
$ terraform plan  -var-file=environments/dev/dev.tfvars # Plan the changes
$ terraform apply -var-file=environments/dev/dev.tfvars -auto-aprove  # apply the changes
```
#### Pre-installed resources in APP and Jenkins server
- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)

#### How it works in terraform
We are using [user-data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to setup the pre-installed and initial deploy of code.