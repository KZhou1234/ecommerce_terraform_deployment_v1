variable "access_key"{
    type=string
    sensitive=true

}         # Replace with your AWS access key ID (leave empty if using IAM roles or env vars)
variable "secret_key"{
    sensitive = true
}         # Replace with your AWS secret access key (leave empty if using IAM roles or env vars)
variable "region"{}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = "ecommercedb"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "kurac5user"
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  default     = "kurac5password"
}