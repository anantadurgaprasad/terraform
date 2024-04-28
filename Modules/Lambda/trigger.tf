resource "aws_cloudwatch_event_rule" "example" {
  name                = var.cloudwatch_event_rule_name
  description         = "Trigger Lambda on a schedule"
  schedule_expression = var.schedule_expression #"rate(5 minutes)" # Replace with your cron schedule
}

resource "aws_cloudwatch_event_target" "example" {
  rule      = aws_cloudwatch_event_rule.example.name
  target_id = "TargetFunction"
  arn       = aws_lambda_function.test_lambda.arn
}