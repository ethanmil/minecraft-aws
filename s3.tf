resource "aws_s3_bucket" "minecraft-backup" {
  bucket = "${var.S3_BUCKET_NAME}"
  acl = "private"
  # Testing purposes -- Allows you to tear the S3 bucket down
  force_destroy = true
  tags {
    Name = "Minecraft Backups"
    Group = "Minecraft"
  }

  lifecycle_rule {
    id = "world"
    enabled = true
    prefix  = "world/"
    tags {
      "rule" = "world"
    }
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 120
    }
  }

  lifecycle_rule {
    id = "log"
    enabled = true
    prefix  = "log/"
    tags {
      "rule" = "logs"
    }
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 120
    }
  }
}