resource "aws_s3_bucket" "main" {
    bucket = "${var.bucket_name}" 
}

resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.main.id
    acl = "private"
}

resource "aws_s3_bucket_object" "Images" {
    bucket = aws_s3_bucket.main.id
    key = "Images/"
    content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "Logs" {
    bucket = aws_s3_bucket.main.id
    key = "Logs/"
    content_type = "application/x-directory"
}

resource "aws_s3_bucket_lifecycle_configuration" "config" {
    bucket = aws_s3_bucket.main.id
    rule {
        id = "images"
        filter {
            prefix = "Images/"
        }
        status = "Enabled"
        transition {
            days = 90
            storage_class = "GLACIER"
        }
    }
    rule {
        id = "logs"
        filter {
            prefix = "Logs/"
        }
        status = "Enabled"
        expiration {
            days = 90
        }
    }
}
