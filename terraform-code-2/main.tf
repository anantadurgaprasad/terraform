resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "renaissance-recorder"
  role_arn = aws_iam_role.aws_config_role.arn
  recording_group {
    all_supported = false
    include_global_resource_types = false
    resource_types                = ["AWS::EC2::Instance", "AWS::EC2::NetworkInterface" , "AWS::EC2::SecurityGroup"]

  }
   recording_mode {
    recording_frequency = "DAILY"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "aws_config_role" {
  name               = "aws-config-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "aws_config_role_attachment" {
  role = aws_iam_role.aws_config_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" #arn:aws:iam::aws:policy/service-role/AWS_ConfigRoles
}

resource "aws_config_delivery_channel" "foo" {
  name           = "${aws_config_configuration_recorder.config_recorder.name}-devlivery-channel"
  s3_bucket_name = aws_s3_bucket.b.bucket
  depends_on     = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_s3_bucket" "b" {
  bucket        = "renaissance-recorder-awsconfig-us-east-1"
  force_destroy = true
  
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.foo]
}