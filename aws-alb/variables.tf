variable "image_id" {
  description = "Image ID used on EC2"
  type        = string
  default     = "ami-0000w0000"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0000w0000"
}

variable "alb_vpc_id" {
  description = "ALB VPC ID"
  type        = list(string)
  default     = ["subnet-0000w0000", "subnet-04affbd43b99ee847"]
}

variable "az" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1"
}

variable "cidr_blocks" {
  description = "network range"
  type        = list(string)
  default     = ["172.31.0.0/16"]
}

variable "ec2_role" {
  description = "AWS Role"
  type        = string
  default     = "test-example-tf-role"
}

variable "name" {
  description = "Name"
  type        = string
  default     = "example-alb"
}