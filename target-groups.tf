resource "aws_lb_target_group" "my-app-tg" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
        Name = var.tg_name
        created_by = "Terraform"
  }
}

locals{
    tg_arn = aws_lb_target_group.my-app-tg.arn
}