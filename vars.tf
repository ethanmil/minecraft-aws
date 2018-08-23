variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
    default = "us-east-2"
}
variable "AMIS" {
    type = "map"
    default {
        us-east-1 = "ami-a4dc46db"
        us-east-2 = "ami-6a003c0f"
        us-west-2 = "ami-db710fa3"
        eu-west-1 = "ami-58d7e821"
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