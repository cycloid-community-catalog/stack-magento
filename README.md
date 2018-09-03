# Stack-magento

Service catalog magento stack

This stack will deploy a Magento on X Amazon EC2 instances behind an ELB load balancer, using RDS database and ElasticCache. 

<img src="https://raw.githubusercontent.com/cycloid-community-catalog/stack-magento/master/diagram.jpeg" width="400">

> **Pipeline** The pipeline contains a manual approval between terraform plan and terraform apply.
> That means if you trigger a terraform plan, to apply it, you have to go on terraform apply job
> and click on the `+` button to trigger it.

# Requirements

In order to run this task, couple elements are required within the infrastructure:

* Having a VPC with private & public subnets containing a bastion server that can access instances by SSH
* Having an S3 bucket for terraform remote states
* Having an S3 bucket for magento code WITH versioning enable

# Job description

## Overview

**build:**
Runs the appropriate php/composer commands to build the magento code.

**unittest**
Dummy job meant to eventually be replaced by proper tests or removed.

**full-deploy-front:**
Ansible job that will fully install the EC2 instances, users, config, etc.

**app-deploy-front:**
Ansible job meant to only deploy the Magento code in case of deployment.

**functional-test:**
Same as unittest, that's a dummy job to eventually ensure everything is working as expected following the deployment.

**terraform-plan:**
Terraform job that will simply make a plan of the infrastructure's stack.

**terraform-apply:**
Terraform job similar to the plan one, but will actually create/update everything that needs to. Please see the plan diff for a better understanding.

## /!\ Destroy /!\
**terraform-destroy:**
Terraform job meant to destroy the whole stack - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed.
Use with caution.

# Troubleshooting

## Test ansible role with molecule

Requires a bucket which contains a build of magento sources and AWS accesskey

```
export AWS_SECRET_ACCESS_KEY=$(vault read -field=secret_key secret/$CUSTOMER/aws)
export AWS_ACCESS_KEY_ID=$(vault read -field=access_key secret/$CUSTOMER/aws)

export MAGENTO_DEPLOY_BUCKET_NAME=cycloid-deploy
export MAGENTO_DEPLOY_BUCKET_OBJECT_PATH=/catalog-magento/ci/magento.tar.gz
export MAGENTO_DEPLOY_BUCKET_REGION=eu-west-1

# Share if needed your ssh key to an ssh agent (used by molecule to clone dependencies)
eval $(ssh-agent )
ssh-add ~/.ssh/id_rsa

# Run molecule
molecule test
molecule verify
```

## Manual insert of concourse pipeline

```
fly --target cycloid-products login --concourse-url $(vault read -field url secret/cycloid/concourse) -u cycloid -p $(vault read -field password secret/cycloid/concourse) -n cycloid-products
fly -t cycloid-products set-pipeline -p stack-magento -c magento.yml --load-vars-from=variables.yml --non-interactive
```
