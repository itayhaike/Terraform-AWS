resource "aws_instance" "my-app"{
    ami = var.ec2_ami
    instance_type = var.ec2_machine_type
    key_name = var.key_pair_name
    vpc_security_group_ids = [local.ec2_sg_id, "sg-0f8115446572d8bb7"]

    ebs_block_device {
          volume_size           = var.volume_size
          volume_type           = var.volume_type
          device_name           = "/dev/sda1"
        }

    tags = {
        Name = var.ec2_name
        created_by = "Terraform"
  }
}

resource "aws_security_group" "ec2-sg" {
    name = var.ec2_sg_name
    description = "The sg for my ec2 instance"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.ssh_cidr_blocks
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.ec2_web_cidr_blocks
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}