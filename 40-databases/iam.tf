resource "aws_iam_role" "mysql" {
  name = local.mysql_iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-mysql"
  })
}

resource "aws_iam_policy" "mysql" {
  name        = local.mysql_iam_role_name
  description = "Allow mysql to read root password from SSM Parameter Store"
  policy      = templatefile("iam-policy.json", {
    environment = var.environment
  })

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-mysql"
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = aws_iam_policy.mysql.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
  role = aws_iam_role.mysql.name

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-mysql"
  })
}