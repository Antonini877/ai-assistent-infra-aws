variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket for storing food images"
  default     = "food-assistance-images"
}

variable "lambda_function_name" {
  description = "Lambda function for processing images"
  default     = "image_processor"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table for storing ingredients and recipes"
  default     = "RecipesTable"
}
