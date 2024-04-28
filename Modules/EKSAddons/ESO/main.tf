data "aws_caller_identity" "current" {}
data "aws_region" "current" {}




# Add the External Secrets Helm chart
resource "helm_release" "external_secrets" {
  name             = "external-secrets-release"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = var.create_namespace
  namespace        = var.namespace
  version          = "0.9.11"
  cleanup_on_fail  = true

  #If you need to customize the chart values, you can do so using set, set_string, or values
  #   set {
  #     name  = "key"
  #     value = "value"
  #   }

  dynamic "set" {
    for_each = var.eso_settings
    iterator = setting
    content {

      name  = setting.value["name"]
      value = setting.value["value"]
    }
  }
}

