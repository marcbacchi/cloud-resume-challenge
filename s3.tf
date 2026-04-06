locals {
  cors_rule = {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    max_age_seconds = 10
  }
}

# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  tags = var.common_tags
}

resource "aws_s3_bucket_acl" "www_bucket_acl" {
  bucket = aws_s3_bucket.www_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "www_bucket_cors" {
  bucket = aws_s3_bucket.www_bucket.id
  cors_rule {
    allowed_headers = local.cors_rule.allowed_headers
    allowed_methods = local.cors_rule.allowed_methods
    allowed_origins = local.cors_rule.allowed_origins
    max_age_seconds = local.cors_rule.max_age_seconds
  }
}

resource "aws_s3_bucket_website_configuration" "www_bucket_website" {
  bucket = aws_s3_bucket.www_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_policy" "www_bucket_policy" {
  bucket = aws_s3_bucket.www_bucket.id
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  tags = var.common_tags
}

resource "aws_s3_bucket_acl" "root_bucket_acl" {
  bucket = aws_s3_bucket.root_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "root_bucket_cors" {
  bucket = aws_s3_bucket.root_bucket.id
  cors_rule {
    allowed_headers = local.cors_rule.allowed_headers
    allowed_methods = local.cors_rule.allowed_methods
    allowed_origins = local.cors_rule.allowed_origins
    max_age_seconds = local.cors_rule.max_age_seconds
  }
}

resource "aws_s3_bucket_website_configuration" "root_bucket_website" {
  bucket = aws_s3_bucket.root_bucket.id
  redirect_all_requests_to {
    host_name = "www.${var.domain_name}"
    protocol  = "https"
  }
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_bucket.id
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })
}
