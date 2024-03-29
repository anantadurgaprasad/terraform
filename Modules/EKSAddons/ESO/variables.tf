variable "create_namespace" {
  default = true
}
variable "namespace" {
  default = "external-secrets"
}
variable "eso_settings" {
  default = {}
}
variable "service_account_name" {
  default = "eso-sa"
}
variable "cluster_name" {
  
}
variable "operator_iam_role_name" {
  default = "ESO-Service-Role"
}