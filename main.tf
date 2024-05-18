provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-demo"  
  public_key = file("~/.ssh/id_rsa.pub")  
}

resource "aws_instance" "examples" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name

connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

provisioner "file" {
    source      = "index.js"  # Replace with the path to your local file
    destination = "/home/ubuntu/index.js"

provisioner "remote-exec" {
    inline = [
              "echo 'Hello from the remote instance'",
              "sudo apt-get install -y nodejs",
              "sudo apt-get install -y git",
              #git clone https://github.com/AhammedNibras/hello-world-nodejs.git
              "cd hello-world-nodejs",
              "npm install",
              "npm start"
 ]
}


  tags = {
    Name = "HelloWorldAppInstance"
  }
}

output "instance_public_ip" {
  value = aws_instance.examples.public_ip
}
