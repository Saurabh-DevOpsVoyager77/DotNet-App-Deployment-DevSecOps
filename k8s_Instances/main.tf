resource "aws_security_group" "k8s-SG" {
  name        = "k8s-Security Group"
  description = "Open 22,443,80,5000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443,5000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-SG-1"
  }
}


resource "aws_instance" "Master" {
  ami                    = "ami-0595d6e81396a9efb"  #change your ami value according to your aws instance
  instance_type          = "t2.medium"
  key_name               = "saurabh-key-aws"
  vpc_security_group_ids = [aws_security_group.k8s-SG.id]
  user_data              = templatefile("./master_script.sh", {})

  tags = {
    Name = "Master-Node"
  }
  root_block_device {
    volume_size = 30
  }
}
resource "aws_instance" "Worker" {
  ami                    = "ami-0595d6e81396a9efb" #change your ami value according to your aws instance 
  instance_type          = "t2.medium"
  key_name               = "saurabh-key-aws"
  vpc_security_group_ids = [aws_security_group.k8s-SG.id]
  user_data              = templatefile("./worker_script.sh", {})
  tags = {
    Name = "Worker-Node"
  }
  root_block_device {
    volume_size = 30
  }
}