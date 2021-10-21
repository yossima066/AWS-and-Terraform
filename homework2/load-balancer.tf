# Create a new load balancer
# LOAD BALANCER #
resource "aws_elb" "web" {
  name = "nginx-elb"

  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups = [aws_security_group.elb-sg.id]
  instances       = [aws_instance.web1.id, aws_instance.web2.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}
