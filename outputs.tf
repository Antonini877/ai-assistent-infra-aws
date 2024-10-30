output "s3_bucket_url" {
  value = aws_s3_bucket.food_images.bucket_regional_domain_name
  description = "URL of the S3 bucket for uploading images."
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
  description = "URL of the API Gateway for sending image processing requests."
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.recipes_table.name
  description = "Name of the DynamoDB table storing recipes."
}
