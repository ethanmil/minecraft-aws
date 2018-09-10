variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-2"
}
variable "AMIS" {
    type = "map"
    default {
        us-east-2 = "ami-0552e3455b9bc8d50"
    }
}
variable "PATH_TO_PRIVATE_KEY" {
}
variable "PATH_TO_PUBLIC_KEY" {
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
variable "DOMAIN" {
  default = "themightymillers.com"
}

 variable "S3_BUCKET_NAME" {
 }