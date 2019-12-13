provider "aws" {
}

resource "random_id" "id" {
  byte_length = 8
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "/tmp/${random_id.id.hex}-lambda.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context) => {
	const param = event.param;
	console.log(`Function invoked with $${param}`);

	return {
		value: `Hello $${param}`,
	};
};
EOF
    filename = "backend.js"
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = "${random_id.id.hex}-function"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "backend.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "lambda_without_createloggroup" {
  function_name = "without-createloggroup-${random_id.id.hex}-function"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "backend.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.lambda_exec_without_createloggroup.arn
}

resource "aws_lambda_function" "lambda_without_createloggroup_with_resource" {
  function_name = "without-createloggroup-with-resource-${random_id.id.hex}-function"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "backend.handler"
  runtime = "nodejs12.x"
  role    = aws_iam_role.lambda_exec_without_createloggroup.arn
}

resource "aws_cloudwatch_log_group" "loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_without_createloggroup_with_resource.function_name}"
  retention_in_days = 14
}

# role
data "aws_iam_policy_document" "lambda_exec_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_exec_role" {
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_exec_role_policy.json
}

resource "aws_iam_role" "lambda_exec" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Action": "sts:AssumeRole",
	  "Principal": {
		"Service": "lambda.amazonaws.com"
	  },
	  "Effect": "Allow"
	}
  ]
}
EOF
}

# role without logs:CreateLogGroup permission
data "aws_iam_policy_document" "lambda_exec_role_policy_without_createloggroup" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_exec_role_without_createloggroup" {
  role   = aws_iam_role.lambda_exec_without_createloggroup.id
  policy = data.aws_iam_policy_document.lambda_exec_role_policy_without_createloggroup.json
}

resource "aws_iam_role" "lambda_exec_without_createloggroup" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
	{
	  "Action": "sts:AssumeRole",
	  "Principal": {
		"Service": "lambda.amazonaws.com"
	  },
	  "Effect": "Allow"
	}
  ]
}
EOF
}

output "function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "function_name_without_createloggroup" {
  value = aws_lambda_function.lambda_without_createloggroup.function_name
}

output "function_name_without_createloggroup_with_resource" {
  value = aws_lambda_function.lambda_without_createloggroup_with_resource.function_name
}
