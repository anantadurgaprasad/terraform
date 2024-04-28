variable "lambda_arn" {
  description = "Arn of the lambda used for authentication"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ids on which AWS Transfer Family should be deployed"
  type        = list(string)
}
variable "vpc_id" {
  description = " VPC id on which AWS Transfer Family should be deployed"
  type        = string
}
variable "security_group_ids" {
  description = "Security Group ids to be attached to Transfer Family"
  type        = list(string)
}
variable "elastic_ips" {
  description = "Elastic Ip Associated to be associated to Transfer Family (required when SFTP is public)"
  type        = list(string)
}