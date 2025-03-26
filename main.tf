# Create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access settings
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set bucket ACL to public-read
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Upload error.html
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.mybucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

# Upload all files in the css folder
locals {
  css_files    = fileset("css/", "**/*.css")    
  js_files     = fileset("js/", "**/*.js")     
  image_files  = fileset("images/", "**/*.*")  
  font_files   = fileset("fonts/", "**/*.*")   
}

# Upload CSS files
resource "aws_s3_object" "css_files" {
  for_each = local.css_files

  bucket       = aws_s3_bucket.mybucket.id
  key          = "css/${each.value}" 
  source       = "css/${each.value}"
  acl          = "public-read"
  content_type = "text/css"
}

# Upload JS files
resource "aws_s3_object" "js_files" {
  for_each = local.js_files

  bucket       = aws_s3_bucket.mybucket.id
  key          = "js/${each.value}" 
  source       = "js/${each.value}"
  acl          = "public-read"
  content_type = "application/javascript"
}

# Upload image files
resource "aws_s3_object" "image_files" {
  for_each = local.image_files

  bucket       = aws_s3_bucket.mybucket.id
  key          = "images/${each.value}" 
  source       = "images/${each.value}"
  acl          = "public-read"
  content_type = "image/${split(".", each.value)[1]}" 
}

# Upload font files
resource "aws_s3_object" "font_files" {
  for_each = local.font_files

  bucket       = aws_s3_bucket.mybucket.id
  key          = "fonts/${each.value}" 
  source       = "fonts/${each.value}"
  acl          = "public-read"
  content_type = "font/${split(".", each.value)[1]}" 
}

# Configure S3 bucket as a static website
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]
}

# Add a bucket policy to allow public read access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.example]
}