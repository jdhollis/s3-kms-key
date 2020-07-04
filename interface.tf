variable "additional_account_ids" {
  type    = list(string)
  default = []
}

variable "alias_name" {}

variable "principals" {
  type = list(string)
}

output "arn" {
  value = aws_kms_key.key.arn
}

output "id" {
  value = aws_kms_key.key.key_id
}
