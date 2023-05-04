resource "aws_lb" "my-app-lb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.lb_sg_id, "sg-0f8115446572d8bb7"]
  subnets            = var.lb_subnets

  tags = {
    Name = var.lb_name
    created_by = "Terraform"
  }
}

resource "aws_lb_listener" "my-app-lb-listener" {
  load_balancer_arn = local.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = local.tg_arn
  }
}

locals{
    lb_arn = aws_lb.my-app-lb.arn
}


resource "aws_security_group" "lb-sg"{
    name = var.lb_sg_name
    description = "The sg for my load balancer"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.lb_web_cidr_blocks
    }

    tags = {
        Name = var.lb_sg_name
        created_by = "Terraform"
    }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = local.tg_arn
  target_id        = aws_instance.my-app.id
  port             = 80
}