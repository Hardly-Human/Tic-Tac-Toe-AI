# Create EC2 instance
resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_id

  depends_on             = [aws_security_group.instance_security_group]
  vpc_security_group_ids = [aws_security_group.instance_security_group.id]
  user_data              = file("${path.module}/installer.sh")

  tags = {
    Name = var.instance_name
  }
}

# Create a security group
resource "aws_security_group" "instance_security_group" {
  vpc_id = var.vpc_id

  # Example rule allowing inbound SSH traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example rule allowing inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application_server_security_group"
  }
}

# Wait for 2 minutes
resource "null_resource" "wait_2_minutes" {
  depends_on = [aws_instance.main]

  provisioner "local-exec" {
    command = "sleep 120"
  }
}

# Copy pod.yaml file to EC2 instance
resource "null_resource" "copy_pod_yaml" {
  depends_on = [null_resource.wait_2_minutes]

  provisioner "local-exec" {
    command = "scp -i ${path.module}/Project-Application-Server.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${path.module}/pod.yaml ubuntu@${aws_instance.main.public_ip}:/tmp/pod.yaml"
  }
}

# Run kubectl commands on EC2 instance
resource "null_resource" "run_kubectl" {
  depends_on = [null_resource.copy_pod_yaml]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/Project-Application-Server.pem")
    host        = aws_instance.main.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f /tmp/pod.yaml",
      "sleep 30",
      "kubectl logs -f tic-tac-toe-pod",
    ]
  }
}
