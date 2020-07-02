# Readme

## Docker image

### Test locally

```sh
docker network create app
docker run --network app --name mongo -d mongo
docker build -t practical .
docker run --network app -p 80:3000 -e NODE_ENV=development -e MONGODB_URL=mongodb://mongo:27017/database -d practical npm start
```

## Packer + Ansible to set up custom worker image

Forked https://github.com/martinskis/amazon-eks-custom-amis and add role for extras like making sure NTP is there

## Set up an AWS EKS cluster with eksctl

```sh
eksctl create cluster -n practical -r us-east-1 --version 1.15 --nodegroup-name workers1 -m 1 -M 2 --node-ami ami-063fbf2822d21b085 --asg-access --full-ecr-access --external-dns-access --alb-ingress-access
```
TODO:

 - horizontal pod autoscaler - https://docs.aws.amazon.com/eks/latest/userguide/horizontal-pod-autoscaler.html
 - cluster autoscaler - https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html

## Deploy MongoDB via Helm package and deploy app

```sh
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install incubator/aws-alb-ingress-controller --set clusterName=practical --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --name aws-alb-ingress-controller --namespace kube-system
helm install practical \
  --set mongodbRootPassword=secretpassword,mongodbUsername=my-user,mongodbPassword=my-password,mongodbDatabase=my-database \
  --version 7.8.10 \
    stable/mongodb
kubectl apply -f practical-deployment.yaml
```

TODO:
 - add hpa config
 - add healthcheck, liveness/readiness probes
 - package app into helm

## Add worker node group with Terraform

- deploy cluster with `eksctl --without-nodegroup`

## Notes

The app in production env does a redirect to https, so I added practical.martinski.com and got a certificate for it in AWS ACM to use with an ALB. 
