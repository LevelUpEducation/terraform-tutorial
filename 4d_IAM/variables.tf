variable "path" {
  description = "Path in which to create the user."
  default     = "/"
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices."
  default     = false
}
