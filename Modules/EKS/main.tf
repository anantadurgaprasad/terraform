/*=====
IAM roles for cluster
======*/
data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks-cluster-iam-role" {
  name               = "${var.environment}-${var.app_name}-eks-cluster-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
  tags               = merge(var.tags, {})
  lifecycle {
    ignore_changes = [ assume_role_policy ]
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-iam-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-iam-role.name
}





/*=====
EKS cluster
======*/
resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.environment}-${var.app_name}-eks-cluster"
  version  = var.eks_version
  role_arn = aws_iam_role.eks-cluster-iam-role.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = var.eks_endpoint_public_access
    endpoint_private_access = var.eks_endpoint_private_access
  }
  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
  }
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks-cluster-kms-key.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-iam-policy-attachment
  ]
  tags = merge(var.tags, {
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  })
}



resource "aws_eks_addon" "ekscluster_cni" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [ aws_eks_cluster.eks-cluster]
}

resource "aws_eks_addon" "ekscluster_proxy" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [ aws_eks_cluster.eks-cluster]
}

resource "aws_eks_addon" "ekscluster_coredns" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on                  = [ aws_eks_cluster.eks-cluster]
}
