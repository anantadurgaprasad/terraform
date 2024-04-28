resource "aws_transfer_server" "example" {

  domain                 = "S3"
  identity_provider_type = "AWS_LAMBDA"
  protocols              = ["SFTP"]
  function               = var.lambda_arn
  endpoint_type          = "VPC"
  endpoint_details {
    address_allocation_ids = var.elastic_ips
    security_group_ids     = var.security_group_ids
    subnet_ids             = var.subnet_id
    vpc_id                 = var.vpc_id
  }
  logging_role = aws_iam_role.iam_for_transfer.arn
  structured_log_destinations = [
    "${aws_cloudwatch_log_group.aws-sftp-log-group.arn}:*"
  ]
  tags = {
    Name = "Renaissance-prod-AWS-Transfer-Family"
  }
}

data "aws_iam_policy_document" "transfer_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_transfer" {
  name_prefix         = "iam_for_transfer_"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSTransferLoggingAccess"]
}


resource "aws_cloudwatch_log_group" "aws-sftp-log-group" {
  name = "aws-transfer-family-log-group"
}
