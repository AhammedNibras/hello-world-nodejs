provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_instance" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu AMI
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              #curl -sL https://deb.nodesource.com/setup_14.x | bash -
              sudo apt install -y nodejs
              sudo apt install -y git
              git clone https://github.com/<your-username>/hello-world-nodejs.git
              cd hello-world-nodejs
              npm install
              npm start &
              EOF

  tags = {
    Name = "HelloWorldAppInstance"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}

