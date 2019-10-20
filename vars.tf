variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-1"
}
variable "AMIS" {
    type = "map"
    default {
        us-east-1 = "ami-04169656fea786776"
    }
}
variable "PATH_TO_PRIVATE_KEY" {
}
variable "PATH_TO_PUBLIC_KEY" {
}
variable "INSTANCE_USERNAME" {
  default = "minecraft"
}
variable "DOMAIN" {
  default = "themightymillers.com"
}

 variable "S3_BUCKET_NAME" {
 }