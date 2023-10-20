resource "aws_iam_role" "r2dso_lab_execution_role" {
  name               = "IMDSv1ExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "r2dso_lab_execution_policy" {
  name   = "IMDSv1ExecutionPolicy"
  role   = aws_iam_role.r2dso_lab_execution_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "r2dso_lab_execution_instance_profile" {
  name = "IMDSv1ExecutionInstanceProfile"
  role = aws_iam_role.r2dso_lab_execution_role.name
}

resource "aws_iam_role_policy_attachment" "r2dso_lab_execution_policy_attach" {
  role       = aws_iam_role.r2dso_lab_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}