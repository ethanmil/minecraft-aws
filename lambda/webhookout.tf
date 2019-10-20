resource "aws_iam_role" "lambda-webhookout" {
  name = "lambda-webhookout"
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

resource "aws_lambda_function" "webhookout" {
  filename         = "webhookout.zip"
  function_name    = "webhookout"
  role             = "${aws_iam_role.lambda-webhookout.arn}"
  handler          = "webhookout.lambda_handler"
  source_code_hash = "${base64sha256(file("webhookout.zip"))}"
  runtime          = "python3.6"
  timeout          = "5"
}

resource "aws_iam_role_policy_attachment" "lambda-webhookout-lambda-execute" {
  role = "${aws_iam_role.lambda-webhookout.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}