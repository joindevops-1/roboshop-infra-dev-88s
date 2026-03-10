resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  count = length(var.sg_names)
  name  = "/${var.project}/${var.environment}/backend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
}