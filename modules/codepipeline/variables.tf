variable "project_name" {
  description = "Project's name"
}

variable "env" {
  description = "Deployment environment"
}

variable "codecommit_repository_name" {
  description = "CodeCommit repository name"
}

variable "codecommit_repository_branch" {
  description = "Repository branch to connect to"
  default     = "master"
}
