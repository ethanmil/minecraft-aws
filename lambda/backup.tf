resource "aws_iam_role" "lambda-backup" {
  name = "lambda-backup"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "backup" {
  filename         = "backup.zip"
  function_name    = "backup"
  role             = "${aws_iam_role.lambda-backup.arn}"
  handler          = "backup.lambda_handler"
  source_code_hash = "${base64sha256(file("backup.zip"))}"
  runtime          = "python3.6"
}

resource "aws_iam_role_policy_attachment" "lambda-backup-lambda-execute" {
  role = "${aws_iam_role.lambda-backup.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-backup-ssm-full-access" {
  role = "${aws_iam_role.lambda-backup.name}"
  policy_arn = "${data.aws_iam_policy.ssm-full-access.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-backup-ec2-read-only" {
  role = "${aws_iam_role.lambda-backup.name}"
  policy_arn = "${data.aws_iam_policy.ec2-read-only.arn}"
}
