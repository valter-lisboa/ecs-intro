variable "project_name" {
  description = "Project's name"
  default     = "exodus-hello"
}

variable "env" {
  description = "Depolyment environment"
  default     = "dev"
}

variable "codecommit_repository_name" {
  description = "CodeCommit repository name"
  default     = "docker-hello"
}

variable "codecommit_repository_branch" {
  description = "Repository branch to connect to"
  default     = "master"
}
