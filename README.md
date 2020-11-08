# AWS_Engineering_Exercises

## aws_autoscaling_group

### Goals
The goal of this exercise is to use Terraform to provision an AWS Autoscaling Group and Application Load Balancer in AWS us-east-1 region.

### How to use

#### Pre task
Before applying the terraform configuration make sure the VPC default group exists in the selected AWS region. Also "webservers" key pairs should be in place.

#### Applying 

After applying you get a SUCCESS response with the DNS name of your load balancer to connect to the application.
```bash

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

ALB_DNS_Name = terraform-autosg-150166198.us-east-1.elb.amazonaws.com
```
Application path is "index.html". 

#### Testing
```bash
$ curl -I http://terraform-autosg-150166198.us-east-1.elb.amazonaws.com/index.html
HTTP/1.1 200 OK
Date: Sun, 08 Nov 2020 19:56:43 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 144
Connection: keep-alive
Server: Apache/2.4.46 ()
Upgrade: h2,h2c
Last-Modified: Sun, 08 Nov 2020 19:38:46 GMT
ETag: "90-5b39d981b0aeb"
Accept-Ranges: bytes
```

## Authors

* [Kram Oleksandr](mailto:kram.oleksandr@gmail.com)

