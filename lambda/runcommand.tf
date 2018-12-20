resource "aws_iam_role" "lambda-runcommand" {
  name = "lambda-runcommand"
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

resource "aws_lambda_function" "runcommand" {
  filename         = "runcommand.zip"
  function_name    = "runcommand"
  role             = "${aws_iam_role.lambda-runcommand.arn}"
  handler          = "runcommand.lambda_handler"
  source_code_hash = "${base64sha256(file("runcommand.zip"))}"
  runtime          = "python3.6"
  timeout          = "5"
}

resource "aws_iam_role_policy_attachment" "lambda-runcommand-lambda-execute" {
  role = "${aws_iam_role.lambda-runcommand.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-runcommand-ssm-full-access" {
  role = "${aws_iam_role.lambda-runcommand.name}"
  policy_arn = "${data.aws_iam_policy.ssm-full-access.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-runcommand-ec2-read-only" {
  role = "${aws_iam_role.lambda-runcommand.name}"
  policy_arn = "${data.aws_iam_policy.ec2-read-only.arn}"
}
