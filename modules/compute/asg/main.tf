resource "aws_autoscaling_group" "main" {
  name                      = "${var.environment}-terraform-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]

  tag {
    key                 = "ManagedBy"
    value               = "terraform"
    propagate_at_launch = false
  }

  
  launch_template {
    id = aws_launch_template.main.id
    version = "$Latest"
  }


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.environment}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  policy_type = "StepScaling"

  step_adjustment {
    scaling_adjustment = 1
    metric_interval_upper_bound = 0
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.environment}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  policy_type = "StepScaling"

  step_adjustment {
    scaling_adjustment = -1
    metric_interval_lower_bound = 0
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name = "${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 80
  
  alarm_description = "monitor for ec2 high cpu utilization"
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name = "${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 10
  
  alarm_description = "monitor for ec2 low cpu utilization"
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}

resource "aws_launch_template" "main" {
  name          = "${var.environment}-instance"
  image_id      = var.ami_asg_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_group_id
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  yum install -y httpd
  echo "<h1>Instance IP: $(hostname -I)</h1>" > /var/www/html/index.html
  systemctl start httpd
  systemctl enable httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags,
      {
        Name = "${var.environment}-instance"
    })
  }
}