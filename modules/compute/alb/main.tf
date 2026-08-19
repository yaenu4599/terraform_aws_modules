resource "aws_lb" "main" {
  name               = "${var.environment}-main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_id
  subnets            = var.subnet_ids

  enable_deletion_protection = var.prevent_destroy
  
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  */

  tags = merge (var.common_tags, 
  {
    Name = "${var.environment}-main-alb"
  })
}

resource "aws_lb_listener" "main-http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = merge( var.common_tags, {
    Name = "${var.environment}-alb-listner"
  })
}

resource "aws_lb_target_group" "main" {
  name     = "${var.environment}-main-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
  }

  tags = merge( var.common_tags,
  {
    Name = "${var.environment}-main-tg"
  })
}


/*
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" 
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4" 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
*/