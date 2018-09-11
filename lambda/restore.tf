resource "aws_iam_role" "lambda-restore" {
  name = "lambda-restore"
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

resource "aws_lambda_function" "restore" {
  filename         = "restore.zip"
  function_name    = "restore"
  role             = "${aws_iam_role.lambda-restore.arn}"
  handler          = "restore.lambda_handler"
  source_code_hash = "${base64sha256(file("restore.zip"))}"
  runtime          = "python3.6"
}

resource "aws_iam_role_policy_attachment" "lambda-restore-lambda-execute" {
  role = "${aws_iam_role.lambda-restore.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-restore-ssm-full-access" {
  role = "${aws_iam_role.lambda-restore.name}"
  policy_arn = "${data.aws_iam_policy.ssm-full-access.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-restore-ec2-read-only" {
  role = "${aws_iam_role.lambda-restore.name}"
  policy_arn = "${data.aws_iam_policy.ec2-read-only.arn}"
}