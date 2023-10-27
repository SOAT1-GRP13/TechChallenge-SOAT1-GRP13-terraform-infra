variable "region" {
  description = "us-west-2"
}

variable "environment" {
  description = "The Deployment environment"
}

variable "access_key" {
  description = "AWS access key to create resources"
}

variable "secret_key" {
  description = "AWS secret key to create resources"
}

variable "profile" {
  description = "AWS profile to create resources used locally"
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  description = "The CIDR block for the private subnet"
}
variable "availability_zones" {
  description = "availability zone to the subnets"
}

variable "db_username" {
  description = "us-west-2"
}

variable "db_password" {
  description = "us-west-2"
}