resource "aws_codepipeline" "current" {
  depends_on = [aws_codebuild_project.static_web_build]

  name     = var.project_name
  role_arn = aws_iam_role.codepipeline.arn

  tags = {
    Environment = var.env
  }

  artifact_store {
    location = "codepipeline-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = var.codecommit_repository_name
        BranchName     = var.codecommit_repository_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "ProjectName" = var.project_name
        "EnvironmentVariables" = jsonencode(
          [
            {
              name  = "environment"
              type  = "PLAINTEXT"
              value = var.env
            },
          ]
        )
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name = "Build"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      run_order = 1
      version   = "1"
    }
  }

}
