resource "aws_iam_role" "amplify_role" {
  name = "${var.app_name}-${var.environment}-amplify-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "amplify.amazonaws.com"
        }
      },
    ]
  })
  inline_policy {
    name   = "amplify-policy"
    policy = data.aws_iam_policy_document.inline_policy.json
  }

}
data "aws_iam_policy_document" "inline_policy" {
  statement {
    actions = [
      "amplify:CreateApp",
      "amplify:CreateBackendEnvironment",
      "amplify:CreateBranch",
      "amplify:DeleteApp",
      "amplify:DeleteBackendEnvironment",
      "amplify:DeleteBranch",
      "amplify:GetApp",
      "amplify:GetBackendEnvironment",
      "amplify:GetBranch",
      "amplify:ListApps",
      "amplify:ListBackendEnvironments",
      "amplify:ListBranches",
      "amplify:ListDomainAssociations",
      "amplify:UpdateApp",
      "cloudformation:CreateChangeSet",
      "cloudformation:CreateStack",
      "cloudformation:CreateStackSet",
      "cloudformation:DeleteStack",
      "cloudformation:DeleteStackSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:DescribeStackEvents",
      "cloudformation:DescribeStackResource",
      "cloudformation:DescribeStackResources",
      "cloudformation:DescribeStacks",
      "cloudformation:DescribeStackSet",
      "cloudformation:DescribeStackSetOperation",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:GetTemplate",
      "cloudformation:ListStackResources",
      "cloudformation:UpdateStack",
      "cloudformation:UpdateStackSet",
      "cloudfront:CreateCloudFrontOriginAccessIdentity",
      "cloudfront:CreateDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:DeleteCloudFrontOriginAccessIdentity",
      "cloudfront:DeleteDistribution",
      "cloudfront:GetCloudFrontOriginAccessIdentity",
      "cloudfront:GetCloudFrontOriginAccessIdentityConfig",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:UpdateCloudFrontOriginAccessIdentity",
      "cloudfront:UpdateDistribution",
      "events:DeleteRule",
      "events:DescribeRule",
      "events:ListRuleNamesByTarget",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "iam:AttachRolePolicy",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetPolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetUser",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicyVersions",
      "iam:PassRole",
      "iam:PutRolePermissionsBoundary",
      "iam:PutRolePolicy",
      "iam:UpdateRole",
      "lambda:AddLayerVersionPermission",
      "lambda:AddPermission",
      "lambda:CreateEventSourceMapping",
      "lambda:CreateFunction",
      "lambda:DeleteEventSourceMapping",
      "lambda:DeleteFunction",
      "lambda:DeleteLayerVersion",
      "lambda:GetEventSourceMapping",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:GetLayerVersion",
      "lambda:InvokeAsync",
      "lambda:InvokeFunction",
      "lambda:ListEventSourceMappings",
      "lambda:ListLayerVersions",
      "lambda:PublishVersion",
      "lambda:PublishLayerVersion",
      "lambda:RemoveLayerVersionPermission",
      "lambda:RemovePermission",
      "lambda:EnableReplication*",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "s3:*"
    ]
    resources = ["*"]
  }

}