# Dynamic Data Source to fetch the LATEST official Ubuntu 22.04 LTS AMI in Sydney dynamically
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Official Ubuntu Owner ID)
}

# Security Group (Allow SSH & HTTP traffic)
resource "aws_security_group" "infra_sg" {
  name        = "allow_web_ssh"
  description = "Allow SSH and Web traffic"
  vpc_id      = aws_vpc.main_vpc.id

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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the name of our 5 servers 
variable "server_names" {
  type    = list(string)
  default = ["Ansible-Control-Node", "Web-Server-01", "Web-Server-02", "App-Server-01", "App-Server-02"]
}

# Loop and Provision for all EC2 instances
resource "aws_instance" "devops_servers" {
  count                  = length(var.server_names)
  ami                    = data.aws_ami.ubuntu.id # DYNAMIC: Fetching ID directly from the filter query data block above
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.infra_sg.id]

  tags = {
    Name = var.server_names[count.index]
    Role = "Devops-Infra_Lab"
  }
}
