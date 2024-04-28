resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.example.arn
  qualifier     = aws_lambda_alias.latest_alias.name
}

resource "aws_lambda_alias" "latest_alias" {
  name = "latest-alias"

  function_name    = aws_lambda_function.test_lambda.function_name
  function_version = "$LATEST"
}