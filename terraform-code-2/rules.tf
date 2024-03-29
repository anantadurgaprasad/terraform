resource "aws_config_config_rule" "r" {
  name = "example"

  source {
    owner             = "AWS"
    source_identifier = "VPC_DEFAULT_SECURITY_GROUP_CLOSED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}