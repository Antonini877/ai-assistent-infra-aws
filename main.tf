provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for storing images
resource "aws_s3_bucket" "food_images" {
  bucket = "food-assistance-images"

  versioning {
    enabled = true
  }

  tags = {
    Name = "food-assistance-images"
  }
}

# Rekognition IAM Role
resource "aws_iam_role" "rekognition_role" {
  name = "rekognition_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rekognition.amazonaws.com"
      }
    }]
  })
}

# Rekognition Policy Attachment to the Role
resource "aws_iam_policy_attachment" "rekognition_policy" {
  name       = "rekognition_policy"
  roles      = [aws_iam_role.rekognition_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

# DynamoDB Table for storing ingredients and recipes
resource "aws_dynamodb_table" "recipes_table" {
  name           = "RecipesTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ingredient_id"

  attribute {
    name = "ingredient_id"
    type = "S"
  }

  attribute {
    name = "recipe"
    type = "S"
  }

  tags = {
    Name = "food-assistance-recipes"
  }
}

# Lambda Function to process images
resource "aws_lambda_function" "image_processor" {
  filename      = "lambda.zip"
  function_name = "image_processor"
  role          = aws_iam_role.rekognition_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.food_images.bucket
      TABLE_NAME = aws_dynamodb_table.recipes_table.name
    }
  }

  tags = {
    Name = "food-assistance-lambda"
  }
}

# API Gateway for voice interaction and image upload
resource "aws_api_gateway_rest_api" "food_assistance_api" {
  name = "FoodAssistanceAPI"
}

resource "aws_api_gateway_resource" "images_resource" {
  rest_api_id = aws_api_gateway_rest_api.food_assistance_api.id
  parent_id   = aws_api_gateway_rest_api.food_assistance_api.root_resource_id
  path_part   = "images"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.food_assistance_api.id
  resource_id   = aws_api_gateway_resource.images_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.food_assistance_api.id
  resource_id = aws_api_gateway_resource.images_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.image_processor.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.food_assistance_api.id
  stage_name  = "prod"
}

# S3 Bucket Policy to allow Lambda access
resource "aws_s3_bucket_policy" "food_images_policy" {
  bucket = aws_s3_bucket.food_images.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "s3:*"
      Effect = "Allow"
      Resource = "${aws_s3_bucket.food_images.arn}/*"
      Principal = "*"
    }]
  })
}
