
data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = var.bitbucket_creds_secret_name
}
resource "aws_amplify_app" "frontend" {
  name         = var.app_name
  repository   = var.repo
  access_token = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["access_token"]
  #Format of Access token value is username:personalaccesstoken
  iam_service_role_arn  = aws_iam_role.amplify_role.arn
  environment_variables = var.environment_variables
  platform              = "WEB_DYNAMIC"




  build_spec = <<-EOT
version: 1
frontend:
  phases:
    install:
      commands:
        - npm install -g yarn
    preBuild:
      commands:
        - yarn install --production=true
    build:
      commands:
        - yarn build
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  EOT
  lifecycle {
    ignore_changes = [
      custom_rule
    ]
  }
}



resource "aws_amplify_branch" "main_branch" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = var.branch # Name of your main branch

  # Set this to enable auto-building for the branch
  enable_auto_build = true
  framework         = "Next.js - SSR"
  # Add stage environment variables if any
  stage = "PRODUCTION" # or DEVELOPMENT, depending on your branch purpose

  # Other configurations like environment variables specific to the branch can be added here.
}

resource "aws_amplify_webhook" "master" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = var.branch
}
