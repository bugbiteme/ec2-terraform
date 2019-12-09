provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_key_pair" "example" {
  key_name = "pi_key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "example" {
  ami             = "ami-0a85857bfc5345c38"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.example.key_name
  security_groups = [
      "launch-wizard-2",
      "flask"
      ]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_dns} > hostname.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.example.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install git python-pip python-wheel",
      "sudo pip install gunicorn Flask",
      "git clone https://github.com/bugbiteme/os-sample-python-flask.git",
      "sudo cp os-sample-python-flask/service/dummy.service /lib/systemd/system/dummy.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable dummy.service",
      "sudo systemctl start dummy.service",
      "sudo systemctl status dummy.service"
    ]
  }

}


resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example.id
}

resource "null_resource" "output_eip" {

  provisioner "local-exec" {
    command = "echo [web] > eip.txt"
  }

  provisioner "local-exec" {
    command = "echo ${aws_eip.ip.public_ip} >> eip.txt"
  }

  provisioner "local-exec" {
    command = "lynx ${aws_eip.ip.public_ip} -dump"
  }

}


output "ip" {
  value = aws_eip.ip.public_ip
}

