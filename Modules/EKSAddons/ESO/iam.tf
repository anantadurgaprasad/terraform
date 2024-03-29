locals {
  oidc_provider            = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
  
}
resource "aws_iam_role" "this" {
  name               = var.operator_iam_role_name
  description        = "IAM Role for ESO "
  assume_role_policy = templatefile("${path.module}/irsa-trust-policy.tftpl", { "account_id" = "${data.aws_caller_identity.current.account_id}", "oidc_provider" = "${local.oidc_provider}", "namespace" = "${var.namespace}", "service_account_name" = "${var.service_account_name}" })
  lifecycle {
    ignore_changes = [ assume_role_policy ]
  }
}

resource "aws_iam_role_policy" "secretmanager" {
  name   = "ESOSecretManagerAccessPolicy"
  role   = aws_iam_role.this.id
  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
            "Sid": "1",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:ListSecrets"
            ],
            "Effect": "Allow",
            "Resource": "*"
            }
        ]
}
  EOF
  lifecycle {
    ignore_changes = [policy]
  }
}
/*
resource "aws_iam_role_policy" "ssm" {
  name   = "ESOSSMAccessPolicy"
  role   = aws_iam_role.this.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DescribeParameters",
            ],
            "Resource": "*"
        }
    ]
}
  EOF
  lifecycle {
    ignore_changes = [policy]
  }
}
*/