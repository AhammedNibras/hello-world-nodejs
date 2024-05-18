provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "examples" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"

provisioner "remote-exec" {
    inline = [
              "echo 'Hello from the remote instance'",
              "sudo apt-get install -y nodejs",
              "sudo apt-get install -y git",
              "git clone https://github.com/AhammedNibras/hello-world-nodejs.git",
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
