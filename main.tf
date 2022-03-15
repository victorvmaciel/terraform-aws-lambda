terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}

variable "aws_region" {
    
    type = string
    default = "us-east-1"
  
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

#Criar role para o lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "indexzip"{
    type = ziprovider
    source_file ="index.js"
    output_path ="index.zip"


}



# resource para função lambda
resource "aws_lambda_function" "ses_send_email_js" {
  filename      = "index.zip"
  function_name = "async function"
  role          = aws_iam_role.ses_email_iam_for_lambda.arn
  handler       = "index.js"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("index.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
