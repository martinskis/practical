# Readme

## Notes

The app in production env does a redirect to https, so I added practical.martinski.com and got a certificate for it in AWS ACM to use with an ALB.

The cluster should be down at the moment. But it is easily reproducible, the steps are documented below.

![Screenshot](https://github.com/martinskis/practical/blob/master/Screenshot%202020-07-03%20at%2002.05.30.png)

## Docker image

pushed to dockerhub - martinskis/practical

### Test locally

```sh
docker network create app
docker run --network app --name mongo -d mongo
docker build -t practical .
docker run --network app -p 80:3000 -e NODE_ENV=development -e MONGODB_URL=mongodb://mongo:27017/database -d practical npm start
```

## Packer + Ansible to set up custom worker image

Forked https://github.com/martinskis/amazon-eks-custom-amis and made some updates

 - added practical_extras ansible role
 - ran into issues with the eksctl deployment with selinux for Docker, couldn't troubleshoot it quick enough so made it configurable with a variable and disabled the cis benchmark task in the ansible roles for packer
   - ideally would have liked to wrap the app with a semodule accompannying the helm chart

```sh
make AWS_REGION=us-east-1 AWS_VPC_ID=vpc-0d5782125c88ebcdf AWS_SUBNET_ID=subnet-0a457c45317ed2715 HARDENING=none cis_bencmark=false build-centos-7
```

## Set up an AWS EKS cluster with eksctl

```sh
eksctl create cluster -n practical -r us-east-1 --version 1.15 --nodegroup-name workers1 -m 1 -M 2 --node-ami ami-0df6f99a717252193 --asg-access --full-ecr-access --external-dns-access --alb-ingress-access --node-private-networking
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install aws-alb-ingress-controller --set clusterName=practical --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --namespace kube-system incubator/aws-alb-ingress-controller
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
```
 - cluster autoscaler - https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
#Edit the cluster-autoscaler container command to replace <YOUR CLUSTER NAME> with your cluster's name, and add the following options.
#
#--balance-similar-node-groups
#
#--skip-nodes-with-system-pods=false
```

## Deploying the application
### Deploy MongoDB via Helm package and deploy app with k8s manifests

```sh
helm install practical \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
  --version 7.8.10 \
    stable/mongodb
kubectl apply -f practical-deployment.yaml
```

### Deploy the app and MongoDB with a single Helm chart

I put in the production values in ./practical/values.yaml.

```sh
helm install practical -f ./practical/values.yaml ./practical-helm
```

## Add worker node group with Terraform

Added ./node-group.tf

Deployed an EKS cluster with `eksctl --without-nodegroup`, but ran into issues with the AWS CNI plugin and kubelet start. Checked out the eksctl approach to deploy a worker node group and  the userdata that works fine with eksctl is a long template and am out of time to include this in terraform now..

 - https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html - self managed nodes

```sh
eksctl create cluster -n practical -r us-east-1 --version 1.15 --without-nodegroup --asg-access  --alb-ingress-access
terraform apply --auto-approve
```
