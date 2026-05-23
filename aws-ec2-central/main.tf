provider "aws" {
  region = var.region
}

################################################################################
# Supporting Resources
################################################################################

## example AMI ##
data "aws_ami" "example_app_enterprise" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "image-id"
    values = [var.image_id]
  }
}

################################################################################
# EC2 Module
################################################################################


module "ec2" {
  source = "../modules/ec2_instance"

  name                        = var.name
  ami                         = data.aws_ami.example_app_enterprise.id
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.ec2_security_group_id
  associate_public_ip_address = true
  hibernation                 = true
  key_name                    = var.key_name
  user_data                   = file("user_data.tpl")
  iam_instance_profile        = var.ec2_role
  enable_volume_tags          = true
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 100
    },
  ]
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = module.ec2.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = 50
}

## Network Interface ##

resource "aws_network_interface" "this" {
  subnet_id = var.subnet_id
}

module "ec2_network_interface" {
  source        = "../modules/ec2_instance"
  name          = "${var.name}-network-interface"
  ami           = data.aws_ami.example_app_enterprise.id
  instance_type = var.instance_type

  network_interface = [
    {
      device_index          = 0
      network_interface_id  = aws_network_interface.this.id
      delete_on_termination = false
    }
  ]
}
