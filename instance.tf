variable "ingress_rules" {
  type    = list(number)
  default = [22, 80]
}

variable "egress_rules" {
  type    = list(number)
  default = [80, 443]
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykey.key_name
  tags = {
    "Name" = "WebServer"
  }
  security_groups = [aws_security_group.webDMZ.name]

  provisioner "file" {
    source      = "metadata.sh"
    destination = "/tmp/metadata.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/metadata.sh",
      "sudo sed -i -e 's/\r$//' /tmp/metadata.sh",
      "sudo /tmp/metadata.sh",
    ]
  }
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

}

resource "aws_security_group" "webDMZ" {
  name = "My WebDMZ"
  dynamic ingress {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic egress {
    iterator = port
    for_each = var.egress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}

output "security_groups" {
  value = aws_instance.example.security_groups
}

output "all_attributes" {
  value = aws_instance.example.* [0]
}
