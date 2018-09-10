resource "aws_iam_role" "minecraft-server" {
    name = "minecraft-server"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "minecraft-server" {
    name = "minecraft-server"
    role = "${aws_iam_role.minecraft-server.name}"
}

resource "aws_iam_role_policy" "minecraft-backup-s3" {
  name = "minecraft-backup-s3"
  role = "${aws_iam_role.minecraft-server.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::ethan-miller-minecraft-backup"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:Get*",
        "s3:Delete*"

      ],
      "Resource": ["arn:aws:s3:::ethan-miller-minecraft-backup/*"]
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda-ssm" {
  name = "lambda-ssm"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "lambda-execute" {
  arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

data "aws_iam_policy" "ssm-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

data "aws_iam_policy" "ec2-ssm" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "lambda-ssm-lambda-execute" {
  role = "${aws_iam_role.minecraft-server.name}"
  policy_arn = "${data.aws_iam_policy.lambda-execute.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda-ssm-ssm-full-access" {
  role = "${aws_iam_role.minecraft-server.name}"
  policy_arn = "${data.aws_iam_policy.ssm-full-access.arn}"
}

resource "aws_iam_role_policy_attachment" "minecraft-server-ssm-agent" {
  role = "${aws_iam_role.minecraft-server.name}"
  policy_arn = "${data.aws_iam_policy.ec2-ssm.arn}"
}