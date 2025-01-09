# alarm.tf

resource "aws_cloudwatch_log_metric_filter" "lambda_error_filter" {
  name           = "info-count"
  log_group_name = aws_cloudwatch_log_group.http_api.name

  pattern = "INFO" 

  metric_transformation {
    name      = "info-count"
    namespace = "/moviedb-api/aasyrafb"
    value     = "1"
    unit = "None"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "asyraf-info-count-breach"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.lambda_error_filter.metric_transformation[0].name
  namespace           = "/moviedb-api/aasyrafb"
  period              = 60
  statistic           = "Sum"
  threshold           = 10

  alarm_description = "Triggered when errors occur in the Lambda function"
  actions_enabled   = true

  alarm_actions = [
    "arn:aws:sns:ap-southeast-1:123456789012:aasyrafb-alert-topic" 
  ]
}
