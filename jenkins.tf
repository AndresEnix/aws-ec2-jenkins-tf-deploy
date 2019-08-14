provider "aws" {
  profile    = "andres_root"
  region     = var.region
}

resource "aws_instance" "jenkins" {
  ami           = var.amis[var.region]
  instance_type = var.ami_types[var.amis[var.region]]
  user_data = "${data.template_file.jenkins_user_data.rendered}"
  key_name = "andres_default"
  #vpc_security_group_ids = [aws_security_group.jenkins_console_sg.id]
  tags = {
    Name = "jenkins"
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.jenkins.id
  provisioner "local-exec" {
    command = "echo 'Jenkins URI: ${aws_eip.ip.public_dns}:8080'"
  }
}

resource "aws_security_group" "jenkins_console_sg" {
  name        = "jenkins-console"
  description = "Allow Jenkins access (port 8080)"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_console_sg"
  }
}

output "jenkins_eip" {
  value = aws_eip.ip.public_ip
}

data "template_file" "jenkins_user_data" {
  template = "${file("templates/user_data/jenkins.tpl")}"
  vars = {
    message = "Jenkins Instal by Andres Perez using Terraform"
  }
}