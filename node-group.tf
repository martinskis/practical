provider "aws" {
  region  = "us-east-1"
}

variable "eks_cluster_name" {
  default = "practical3"
}

variable "keypair-name" {
  default = "smartinski-mac"
}

data "aws_vpc" "eks" {
  tags = {
    Name = "eksctl-practical3-cluster/VPC"
  }
}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["eks-centos7-none-1594051137"]
  }

  owners = ["120437109327"]
}

data "aws_eks_cluster" "practical" {
  name = var.eks_cluster_name
}

# Setup IAM role & instance profile for worker nodes

resource "aws_iam_role" "tf-eks-node" {
  name = "terraform-eks-tf-eks-node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tf-eks-node.name
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tf-eks-node.name
}

resource "aws_iam_role_policy_attachment" "tf-eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tf-eks-node.name
}

resource "aws_iam_policy" "alb_ingress_controller" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "acm:GetCertificate",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVpcs",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:RevokeSecurityGroupIngress",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetIpAddressType",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "elasticloadbalancing:SetWebACL",
                "iam:CreateServiceLinkedRole",
                "iam:GetServerCertificate",
                "iam:ListServerCertificates",
                "waf-regional:GetWebACLForResource",
                "waf-regional:GetWebACL",
                "waf-regional:AssociateWebACL",
                "waf-regional:DisassociateWebACL",
                "tag:GetResources",
                "tag:TagResources",
                "waf:GetWebACL",
                "wafv2:GetWebACL",
                "wafv2:GetWebACLForResource",
                "wafv2:AssociateWebACL",
                "wafv2:DisassociateWebACL",
                "shield:DescribeProtection",
                "shield:GetSubscriptionState",
                "shield:DeleteProtection",
                "shield:CreateProtection",
                "shield:DescribeSubscription",
                "shield:ListProtections"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "alb" {
  policy_arn = aws_iam_policy.alb_ingress_controller.arn
  role       = aws_iam_role.tf-eks-node.name
}

resource "aws_iam_policy" "autoscaling" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "autoscaling" {
  policy_arn = aws_iam_policy.autoscaling.arn
  role       = aws_iam_role.tf-eks-node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "terraform-eks-node"
  role = aws_iam_role.tf-eks-node.name
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.practical.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.practical.certificate_authority.0.data}' '${var.eks_cluster_name}'
USERDATA
}

# security groups get generated by eksctl
data "aws_security_group" "eksctl_node" {
  vpc_id = data.aws_vpc.eks.id
  tags = {
    Name = "*ClusterSharedNodeSecurityGroup*"
  }
}

data "aws_security_group" "eksctl_cluster" {
  vpc_id = data.aws_vpc.eks.id
  tags = {
    Name = "*eks-cluster-sg*"
  }
} 

resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "m5.large"
  name_prefix                 = "terraform-eks"
  security_groups             = [data.aws_security_group.eksctl_node.id,data.aws_security_group.eksctl_cluster.id]
  user_data_base64            = base64encode(local.tf-eks-node-userdata)
  key_name                    = var.keypair-name
 
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.eks.id

  tags = {
    Name = "*Public*"
  }
}

resource "aws_autoscaling_group" "tf_eks" {
  desired_capacity     = "1"
  launch_configuration = aws_launch_configuration.tf_eks.id
  max_size             = "3"
  min_size             = "1"
  name                 = "terraform-tf-eks"
  vpc_zone_identifier  = data.aws_subnet_ids.private.ids
 
  tag {
    key                 = "Name"
    value               = "terraform-tf-eks"
    propagate_at_launch = true
  }
 
  tag {
    key                 = "kubernetes.io/cluster/${var.eks_cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

data "external" "aws_iam_authenticator" {
  program = ["bash", "-c", "aws-iam-authenticator token -i ${var.eks_cluster_name} | jq -r -c .status"]
}

provider "kubernetes" {
  host                      = data.aws_eks_cluster.practical.endpoint
  cluster_ca_certificate    = base64decode(data.aws_eks_cluster.practical.certificate_authority.0.data)
  token                     = data.external.aws_iam_authenticator.result.token
  load_config_file          = false
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = <<EOF
- rolearn: ${aws_iam_role.tf-eks-node.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
EOF
  }
}

