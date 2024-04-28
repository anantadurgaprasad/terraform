variable "create_namespace" {
  default     = true
  description = "Boolean to indicate whether to create namespace or not"
  type        = bool
}
variable "namespace" {
  default     = "external-secrets"
  description = "Name Space on which the helm chart will be deployed"
  type        = string
}
variable "eso_settings" {
  default     = {}
  description = "Any Configuration Values to be passed to External Secret Operator Helm Chart"
  type        = map(any)
}
variable "oidc_issuer" {
  description = "The OIDC issuer of the kubernetes Cluster"
  type        = string

}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}
variable "external_secret_prereq" {
  type = object({
    external_secret_namespace            = optional(string, "default")
    external_secret_service_account_name = optional(string, "eso-sa")
    external_secret_irsa                 = optional(string, "ESO-Service-Role")

    enables_secretmanager = optional(bool, true)
    enables_ssm           = optional(bool, true)
  })
  default     = {}
  description = "Create IRSA in given namespace and sa for external secret use"
}

variable "create_external_secret_prereq" {
  default = false
}
