provider "aws" {
  region = var.region
}

################################################################################
# Master DB
################################################################################

## db_subnet_group ##
module "subnet_group" {
  source     = "../modules/db_subnet_group"
  name       = "database_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

## sg_security_group ##
module "security_group" {
  source      = "../modules/sg_security_group"
  name        = var.name
  description = "Master PostgreSQL security group"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 4241
      to_port     = 4244
      protocol    = "tcp"
      description = "example app nodes communication"
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 4432
      to_port     = 4432
      protocol    = "tcp"
      description = "Default listening port for the example app Repository Database"
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 4444
      to_port     = 4444
      protocol    = "tcp"
      description = "Security distribution port, only used within multi-node sites by non-master"
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 4747
      to_port     = 4747
      protocol    = "tcp"
      description = "example app Engine Service (QES) for communication with the example app web clients."
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 5050
      to_port     = 5050
      protocol    = "tcp"
      description = "example app Scheduler Service (QSS) master REST engine"
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 5151
      to_port     = 5151
      protocol    = "tcp"
      description = "example app Scheduler Service (QSS) slave REST engine."
      cidr_blocks = var.cidr_blocks
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "vpc all traffic"
      cidr_blocks = var.cidr_blocks
    }
  ]

  # egress
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "All traffic out"
      # Lab/demo CIDR: restrict this to trusted networks before production use.
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

## RDS ##
module "master" {
  source = "../modules/db_instance"

  identifier = "${var.name}-master"

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  multi_az               = true
  db_subnet_group_name   = module.subnet_group.db_subnet_group_name
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Backups are required in order to create a replica
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = false
}

