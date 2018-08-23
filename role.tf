resource "aws_iam_role" "s3" {
    name = "s3"
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

resource "aws_iam_instance_profile" "s3" {
    name = "s3"
    role = "s3"
}

resource "aws_iam_role_policy" "s3" {
  name = "s3"
  role = "${aws_iam_role.s3.id}"
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