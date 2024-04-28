variable "app_name" {
  description = "Name of the amplify application"
}
variable "repo" {
  description = "The repo to be built and deployed by amplify"
}
variable "branch" {
  description = "Repo branch used to build the application"
}
variable "environment_variables" {
  description = "Environment variables required for application to run"
}

variable "environment" {
  description = "The environment on which this amplify is deployed ( used only for naming)"
}
variable "bitbucket_creds_secret_name" {
  description = "Secret Manager Name which holds the bitbucket credentials"
}