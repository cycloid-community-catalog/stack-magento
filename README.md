# Stack-magento

Service catalog magento stack

This stack will deploy a Magento on X Amazon EC2 instances behind an ELB load balancer, using RDS database and ElasticCache. 

<img src="https://raw.githubusercontent.com/cycloid-community-catalog/stack-magento/master/diagram.jpeg" width="400">



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
