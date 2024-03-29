/*=======
Common Variables 
=========*/
variable "environment" {
  
}
variable "app_name" {
  
}
variable "region" {
  
}
variable "tags" {
  
}

/*=======
VPC Variables 
=========*/
variable "public_subnets_cidr" {
  
}
variable "private_subnets_cidr" {
  
}

variable "vpc_cidr" {
  
}

/*=======
EKS Variables 
=========*/

variable "eks_node_iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type        = list(any)
}

variable "eks_version" {

}

variable "cni_version" {

}
variable "proxy_version" {

}
variable "coredns_version" {

}

variable "eks_instance_type" {

}
variable "eks_max_size" {

}
variable "eks_min_size" {

}
variable "eks_desired_size" {

}

variable "aws_alb_controller_helm_chart_version" {
  
}
variable "aws_alb_controller_settings" {
  
}