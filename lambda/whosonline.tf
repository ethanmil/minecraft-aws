resource "aws_iam_role" "lambda-whosonline" {
  name = "lambda-whosonline"
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

resource "aws_lambda_function" "whosonline" {
  filename         = "whosonline.zip"
  function_name    = "whosonline"
  role             = "${aws_iam_role.lambda-whosonline.arn}"
  handler          = "whosonline.lambda_handler"
  source_code_hash = "${base64sha256(file("whosonline.zip"))}"
  runtime          = "python3.6"
  timeout          = "5"
}

resource "aws_iam_role_policy_attachment" "lambda-whosonline-lambda-execute" {
  role = "${aws_iam_role.lambda-whosonline.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-whosonline-ssm-full-access" {
  role = "${aws_iam_role.lambda-whosonline.name}"
  policy_arn = "${data.aws_iam_policy.ssm-full-access.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-whosonline-ec2-read-only" {
  role = "${aws_iam_role.lambda-whosonline.name}"
  policy_arn = "${data.aws_iam_policy.ec2-read-only.arn}"
}
