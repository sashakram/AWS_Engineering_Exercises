terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "flavor" {
  type = string
  default = "t2.micro"
}

variable "ec2_instance_port" {
  type = number
  default = 80
}

variable "region" {
    default = "us-east-1"
}

variable "ami" {
    default = {
        us-east-1 = "ami-0947d2ba12ee1ff75"  # US East (N. Virginia)
        us-west-1 = "ami-0e4035ae3f70c400f"  # US West (N. California)
//        us-west-2 = "ami-431a4273"  # US West (Oregon)
    }
}
