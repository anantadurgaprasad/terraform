variable "source_file_path" {
  description = "Source Code file path"
  type        = string
}
variable "lambda_runtime" {
  description = "Run time of lambda"
  type        = string
}
variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}
variable "environment_variables" {
  description = "Environment Variables to be made available to Lambda"
  type        = map(string)
  default     = {}
}
variable "schedule_expression" {
  description = "Cron Job Expression to schedule Lambda Trigger"
  default     = string
}
variable "cloudwatch_event_rule_name" {
  description = "CloudWatch Event Rule Name"
  type        = string
}
variable "lambda_role_arn" {
  description = "Role to be associated with Lambda"
  type        = string
}
