################################################################################
# VPC Link
################################################################################
resource "aws_apigatewayv2_vpc_link" "vpclink_apigw_to_alb" {
  name        = "vpclink_apigw_to_alb"
  security_group_ids = []
  subnet_ids = var.privates_subnets_id
}

resource "aws_apigatewayv2_api" "apigw_http_endpoint" {
  name          = "pvt-endpoint"
  protocol_type = "HTTP"
}

################################################################################
# Api Gateway
################################################################################

resource "aws_apigatewayv2_integration" "apigw_integration" {
  api_id           = aws_apigatewayv2_api.apigw_http_endpoint.id
  integration_type = "HTTP_PROXY"
  integration_uri = var.listener_arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb.id
  payload_format_version = "1.0"
  depends_on      = [aws_apigatewayv2_vpc_link.vpclink_apigw_to_alb, 
                    aws_apigatewayv2_api.apigw_http_endpoint]
}

# API GW route with ANY method
resource "aws_apigatewayv2_route" "apigw_route" {
  api_id    = aws_apigatewayv2_api.apigw_http_endpoint.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.apigw_integration.id}"
  depends_on  = [aws_apigatewayv2_integration.apigw_integration]
}

# Set a default stage
resource "aws_apigatewayv2_stage" "apigw_stage" {
  api_id = aws_apigatewayv2_api.apigw_http_endpoint.id
  name   = "$default"
  auto_deploy = true
  depends_on  = [aws_apigatewayv2_api.apigw_http_endpoint]
}
