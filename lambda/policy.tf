
data "aws_iam_policy" "lambda-execute" {
  arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

data "aws_iam_policy" "ssm-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

data "aws_iam_policy" "ec2-read-only" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}