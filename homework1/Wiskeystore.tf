##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "us-east-1"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

##################################################################################
# DATA
##################################################################################

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


##################################################################################
# RESOURCES
##################################################################################

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "nginx_demo"
  description = "Allow ports for nginx demo"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Whiskey" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t3.micro"

  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data     = <<EOT
#cloud-config
# update apt on boot
package_update: true
# install nginx
packages:
- nginx
write_files:
- content: |
    <!DOCTYPE html>
    <html>
    <head>
      <title>StackPath - Welcom to whiskey world</title>
      <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
      <style>
        html, body {
          background: #000;
          height: 100%;
          width: 100%;
          padding: 0;
          margin: 0;
          display: flex;
          justify-content: center;
          align-items: center;
          flex-flow: column;
        }
        img { width: 500px; }
        svg { padding: 0 150px; }
        p {
          color: #fff;
          font-family: 'Courier New', Courier, monospace;
          text-align: center;
          padding: 10px 30px;
        }
      </style>
    </head>
    <body>
      <img src="https://filmandfurniture.com/wp-content/uploads/2020/04/tony-stark-the-avengers-whiskey-glass.jpg">
    #https://i.pinimg.com/564x/bf/32/4c/bf324cf216aa0b6f3db40863770c4d0d.jpg
      <p>  <strong> Welcom to Whiskey store </strong></p>
    </body>
    </html>
  path: /usr/share/app/index.html
  permissions: '0644'
runcmd:
- cp /usr/share/app/index.html /usr/share/nginx/html/index.html
EOT
  ebs_block_device {
          device_name           =  "/dev/sda1"
          encrypted             = true
          volume_size           = 10
          volume_type           = "gp2" 
  }
  root_block_device {
          volume_size           = 8
          volume_type           = "gp2"
  }
   tags = {
    Name = "Whiskey"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"

    ]
  }
}

resource "aws_instance" "whiskeypapi" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data     = <<EOT
  #cloud-config
  # update apt on boot
  package_update: true
  # install nginx
  packages:
  - nginx
  write_files:
  - content: |
      <!DOCTYPE html>
      <html>
      <head>
        <title>StackPath - Welcom to whiskey world</title>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <style>
          html, body {
            background: #000;
            height: 100%;
            width: 100%;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-flow: column;
          }
          img { width: 500px; }
          svg { padding: 0 150px; }
          p {
            color: #fff;
            font-family: 'Courier New', Courier, monospace;
            text-align: center;
            padding: 10px 30px;
          }
        </style>
      </head>
      <body>
        <p>  <strong> This is papi </strong></p>
        <img src="https://i.pinimg.com/564x/bf/32/4c/bf324cf216aa0b6f3db40863770c4d0d.jpg">
        <p>  <strong> Welcom to papi Whiskey store </strong></p>
      </body>
      </html>
    path: /usr/share/app/index.html
    permissions: '0644'
  runcmd:
  - cp /usr/share/app/index.html /usr/share/nginx/html/index.html
  EOT
  ebs_block_device {
          device_name           =  "/dev/sda1"
          encrypted             = true
          volume_size           = 10
          volume_type           = "gp2" 
  }
  root_block_device {
          volume_size           = 8
          volume_type           = "gp2"
  }
   tags = {
    Name = "Whiskeypapi"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)

  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }



}

##################################################################################
# OUTPUT
##################################################################################



  
