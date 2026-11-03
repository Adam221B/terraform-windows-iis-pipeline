provider "aws" {
  region = "eu-north-1" 
}

resource "aws_security_group" "windows_sg" {
  name_prefix = "windows-web-sg-"
  description = "Allow RDP and HTTP"

  ingress {
    from_port   = 3389
    to_port     = 3389
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-055eb33c79b889b43" # Windows Server 2025 AMI
  instance_type = "t3.micro"
  key_name      = "windows-key"
  security_groups = [aws_security_group.windows_sg.name]

  user_data = <<-EOF
              <powershell>
              dism /online /enable-feature /featurename:IIS-WebServerRole /all
              Set-Content -Path "C:\inetpub\wwwroot\index.html" -Value "<h1>Automated IIS via Terraform</h1>"
              </powershell>
              EOF

  tags = {
    Name = "Terraform-Windows-IIS"
  }
}