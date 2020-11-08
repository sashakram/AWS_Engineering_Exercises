# AWS_Test_Exercise

## Goals
The goal of this exercise is to use Terraform to provision an AWS Autoscaling Group and Application Load Balancer in AWS us-east-1 region.

## How to use

### Pre task
Before applying the terraform configuretion make sure VPC default group excists in selected AWS region.
Also "webservers" key pairs should be in place.

### Apply
After appliing you get responce with SUCESS apling and  DNS name of your load balancer
```bash

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

ALB_DNS_Name = terraform-autosg-150166198.us-east-1.elb.amazonaws.com



## Authors

* [Kram Oleksandr](mailto:kram.oleksandr@gmail.com)
