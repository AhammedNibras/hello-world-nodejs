provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo"  
  public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_instance" "example" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name

 connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "index.js"  # Replace with the path to your local file
    destination = "/home/ubuntu/hello-world-nodejs/index.js"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
              "curl -sL https://deb.nodesource.com/setup_14.x | bash -",
              "sudo apt install nodejs -y",
              "sudo apt install git -y",
              #"git clone https://github.com/AhammedNibras/hello-world-nodejs.git",
              "cd /home/ubuntu/hello-world-nodejs",
              "npm install",
              "npm start",
]
}
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

