/*=====
Common variables values
======*/
app_name    = "project1"
environment = "integration"
region      = "us-east-1"

tags = {
  environment       = "integration",
  region            = "us-east-1",
  deployment_method = "terraform",

}
/*=====
VPC variables values
======*/
vpc_cidr             = "10.0.160.0/21"
public_subnets_cidr  = ["10.0.160.0/23", "10.0.162.0/23"]
private_subnets_cidr = ["10.0.164.0/23", "10.0.166.0/23"]




/*=====
EKS  variables values
======*/
eks_node_iam_policy_arn = []
eks_instance_type = "t2.medium"
# EKS and addons versions
eks_version      = "1.25"
cni_version      = "v1.12.2-eksbuild.1"
proxy_version    = "v1.25.6-eksbuild.1"
coredns_version  = "v1.9.3-eksbuild.3"
eks_desired_size = 1
eks_max_size     = 5
eks_min_size     = 1
aws_alb_controller_settings= {}
aws_alb_controller_helm_chart_version = "1.7.1"