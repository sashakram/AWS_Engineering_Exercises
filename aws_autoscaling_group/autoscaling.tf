//Create aws_autoscaling_group
resource "aws_autoscaling_group" "PlayQ-2019" {
  max_size = 6
  min_size = 2
  launch_configuration = aws_launch_configuration.ec2_template.name
  health_check_grace_period = 300

  health_check_type = "ELB"

  vpc_zone_identifier = data.aws_subnet_ids.default.ids 
  
// specified all the subnets in default vpc
  target_group_arns = [aws_lb_target_group.autosg.arn]
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "PlayQ-2019"
  }
  tag {
    key = "Type"
    propagate_at_launch = true
    value = "webserver"
  }
  lifecycle {
  create_before_destroy = true
  }
}
// Create EC2 Launch configuration
resource "aws_launch_configuration" "ec2_template" {
  image_id  = lookup(var.ami, var.region)
  instance_type = var.flavor
  user_data = file("userdata.sh")
  security_groups = [aws_security_group.autosg_sec_group.id, aws_security_group.access_to_instances.id]
  key_name = "webservers"
  lifecycle {
    create_before_destroy = true
  }
}


