variable "ec2_ami"{
    type = string
    description = "The ami for the ec2 instance"
}

variable "aws_region"{
    type = string
    description = "The region for the aws provider"
}

variable "ec2_machine_type"{
    type = string
    description = "The machine type for the ec2 instance"
    default = "t2.micro"
}

variable "key_pair_name"{
    type = string
    description = "The key pair name for the ec2 instance"
    default = "itai-key-pair"
}

variable "volume_size"{
    type = number
    description = "The volume size for the ec2 instance"
    default = 10
}

variable "volume_type" {
    type = string
    description = "The volume type for the ec2 instance"
    default = "gp3"
}

variable "ec2_name"{
    type = string
    description = "The name for the ec2 instance"
    default = "Itai-TF-Instance"
}

variable "ec2_sg_name" {
    type = string
    description = "The name of the security group"
    default = "ec2-sg"
}

variable "ssh_cidr_blocks"{
    type = list(string)
    description = "The cidr blocks for the security group"
    default = []
}

variable "ec2_web_cidr_blocks"{
    type = list(string)
    description = "The cidr blocks for the security group"
    default = []
}

variable "lb_name"{
    type = string
    description = "The name for the load balancer"
    default = "Itai-TF-LB"
}

variable "lb_subnets"{
    type = list(string)
    description = "The subnets for the load balancer"
    default = []
}

variable "lb_sg_name"{
    type = string
    description = "The name for the load balancer security-group"
    default = "Itai-TF-LB-SG"
}

variable "lb_web_cidr_blocks"{
    type = list(string)
    description = "The cidr blocks for the load balancer security-group"
    default = []
}

variable "tg_name"{
    type = string
    description = "The name for the target group"
    default = "Itai-TF-TG"
}

variable "vpc_id"{
    type = string
    description = "The vpc id for the load balancer"
    default = ""
}