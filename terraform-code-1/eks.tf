module "eks" {
  source                                = "../Modules/EKS"
  environment                           = var.environment
  app_name                              = var.app_name
  eks_endpoint_private_access           = false
  eks_endpoint_public_access            = true
  eks_version                           = var.eks_version
  cni_version                           = var.cni_version
  proxy_version                         = var.proxy_version
  coredns_version                       = var.coredns_version
  private_subnet_ids                    = module.vpc.private_subnets_id
  eks_instance_type                     = var.eks_instance_type
  eks_desired_size                      = var.eks_desired_size
  eks_min_size                          = var.eks_min_size
  eks_max_size                          = var.eks_max_size
  tags = var.tags
}

/*===========
Installing AWS ALB Controller as Ingress Controller 
=============*/
module "AWSALBController" {
  source                   = "../Modules/EKSAddons/AWSALBController"
  controller_iam_role_name = "${var.environment}-${var.app_name}-AWSALBControllerRole"
  cluster_name             = module.eks.eks_cluster_name
  helm_chart_version       = var.aws_alb_controller_helm_chart_version
  settings                 =  (var.aws_alb_controller_settings != null) ? var.aws_alb_controller_settings : {}
}

/*===========
Installing External Secret Operator 
=============*/
module "ESO" {
  source                   = "../Modules/EKSAddons/ESO"
  cluster_name             = module.eks.eks_cluster_name
  }