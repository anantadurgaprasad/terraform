locals {
  oidc_provider = replace(var.oidc_issuer, "https://", "")

}
resource "aws_iam_role" "this" {
  count              = var.create_external_secret_prereq ? 1 : 0
  name               = var.external_secret_prereq.external_secret_irsa
  description        = "IAM Role for ESO "
  assume_role_policy = templatefile("${path.module}/irsa-trust-policy.tftpl", { "account_id" = "${data.aws_caller_identity.current.account_id}", "oidc_provider" = "${local.oidc_provider}", "namespace" = "${var.external_secret_prereq.external_secret_namespace}", "service_account_name" = "${var.external_secret_prereq.external_secret_service_account_name}" })

}

resource "aws_iam_role_policy" "secretmanager" {
  count  = var.create_external_secret_prereq && var.external_secret_prereq.enables_secretmanager ? 1 : 0
  name   = "ESOSecretManagerAccessPolicy"
  role   = aws_iam_role.this[0].id
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

resource "aws_iam_role_policy" "ssm" {
  count  = var.create_external_secret_prereq && var.external_secret_prereq.enables_ssm ? 1 : 0
  name   = "ESOSSMAccessPolicy"
  role   = aws_iam_role.this[0].id
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
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        }
    ]
}
  EOF

}
