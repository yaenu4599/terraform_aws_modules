# =============================================================================
# sns
# =============================================================================

resource "aws_sns_topic" "alarm" {
  name = "${var.environment}-sns-alarm"
  tags = merge( var.common_tags, {
    Name = "${var.environment}-sns-alarm"
  })
}

resource "aws_sns_topic_subscription" "alarm" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol = "email"
  endpoint = var.email_for_sns
}

# =============================================================================
# cloudwatch
# =============================================================================

resource "aws_cloudwatch_log_group" "ec2" {
  name = "/aws/ec2/${var.environment}"
  retention_in_days = var.retention_in_days

  tags = merge( var.common_tags, {
    Name = "${var.environment}-ec2-log_group"
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name = "${var.environment}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = 2
  metric_name = "FreeStorageSpace"
  namespace = "AWS/RDS"
  period = 300
  statistic = "Average"
  threshold = var.rds_storage_low_threshold
  alarm_actions = [aws_sns_topic.alarm.arn]
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = merge( var.common_tags, {
    Name = "${var.environment}-rds-storage-low"
  })
}

resource "aws_cloudwatch_metric_alarm" "rds_high_connections_rate" {
  alarm_name = "${var.environment}-rds_high_connections_rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "DatabaseConnections"
  namespace = "AWS/RDS"
  period = 60
  threshold = var.rds_connections_threshold
  alarm_actions = [aws_sns_topic.alarm.arn]
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }
  
  tags = merge( var.common_tags, {
    Name = "${var.environment}-rds_high_connections_rate"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealty_instances" {
  alarm_name = "${var.environment}-alb-unhealty-instances"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "HealthyHostCount"
  namespace = "AWS/ApplicationELB"
  period = 60
  statistic = "Average"
  threshold = 0
  alarm_actions = [aws_sns_topic.alarm.arn]
  dimensions = {
    TargetGroup = var.target_group_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }

  tags = merge( var.common_tags, {
    Name = "${var.environment}-alb-unhealty-instances"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name = "${var.environment}-alb-5xx-erorrs"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "HTTPCode_Target_5xx_Count"
  namespace = "AWS/ApplicationELB"
  period = 300
  statistic = "Sum"
  threshold = var.alb_5xx_threshold
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = merge( var.common_tags, {
    Name = "${var.environment}-alb-5xx-erorrs"
  })
}
