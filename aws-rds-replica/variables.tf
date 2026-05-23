variable "engine" {
  description = "RDS Engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "RDS Engine version"
  type        = string
  default     = "11.15"
}

variable "instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage allocated size"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Storage max size"
  type        = number
  default     = 100
}

variable "port" {
  description = "RDS instance port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "RDS DB name"
  type        = string
  default     = "postgresql_db"
}

variable "username" {
  description = "DB user"
  type        = string
  default     = "qse_svc_user"
}

variable "password" {
  description = "DB user pass. Lab/demo only; pass this from tfvars or Secrets Manager in real environments."
  type        = string
  sensitive   = true
  default     = null
}


variable "subnet_ids" {
  description = "RDS instance type"
  type        = list(string)
  default     = ["subnet-0000w0000", "subnet-04647958e522fa7a8", "subnet-04affbd43b99ee847"]
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0000w0000"
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "RDS name"
  type        = string
  default     = "postgres"
}

variable "subnet_id" {
  description = "AWS Subnet ID"
  type        = string
  default     = "subnet-0000w0000"
}

variable "cidr_blocks" {
  description = "network range"
  type        = string
  default     = "172.31.0.0/16"
}