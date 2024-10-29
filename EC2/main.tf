
#Local variables are only used within the scope of the currentconfiguration file where they are defined.
#They are not passed between modules or configurations.

#- An EC2 in each subnet (EC2s in the public subnets are for the frontend, the EC2s in the private subnets are for the backend) Name the EC2's: "ecommerce_frontend_az1", "ecommerce_backend_az1", "ecommerce_frontend_az2", "ecommerce_backend_az2"


# Jenkins server is created in Jenkins_Terraform

# Create EC2 for public subnet 0
resource "aws_instance" "ecommerce_frontend_az1" {
  subnet_id  = var.public_subnet_id[0]

  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]       # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "KeZhou932_463key"                # The key pair name for SSH access to the instance.

  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_frontend_az1"         
  }
}

# Create EC2 for public_subnet_1
resource "aws_instance" "ecommerce_frontend_az2" {
  subnet_id  = var.public_subnet_id[1]

  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]       # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "KeZhou932_463key"                # The key pair name for SSH access to the instance.

  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_frontend_az2"         
  }
}

# Create EC2 for private_subnet_0
resource "aws_instance" "ecommerce_backend_az1" {
  subnet_id  = var.private_subnet_id[0]

  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.backend_sg.id]       # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "KeZhou932_463key"                # The key pair name for SSH access to the instance.

  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_backend_az1"         
  }
}

# Create EC2 for private_subnet_1
resource "aws_instance" "ecommerce_backend_az2" {
  subnet_id  = var.private_subnet_id[1]

  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
                                        # Replace this with a valid AMI ID
  instance_type     = var.instance_type               # Specify the desired EC2 instance size.
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.backend_sg.id]       # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "KeZhou932_463key"                # The key pair name for SSH access to the instance.

  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : "ecommerce_backend_az2"         
  }
}


# Create a security group named "frontend_sg" that allows SSH and React traffic.
# This security group will be associated with the frontend EC2 instance created above.
resource "aws_security_group" "frontend_sg" {
  vpc_id     = var.vpc_id
  name        = "frontend_sg"
  description = "open ssh traffic and port 3000"
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
  egress {
      from_port   = 0   #allow all outbound traffic
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  # Tags for the security group
  tags = {
    "Name"      : "tf_nade_frontend_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}


# Create a security group named "backend_sg" that allows SSH and Django traffic.
# This security group will be associated with the backend EC2 instance created above.
resource "aws_security_group" "backend_sg" {
  vpc_id     = var.vpc_id
  name        = "backend_sg"
  description = "open ssh traffic and 8000"
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
  egress {
      from_port   = 0   #allow all outbound traffic
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  # Tags for the security group
  tags = {
    "Name"      : "tf_made_backend_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}

output "instance_ips" {
  value = [aws_instance.ecommerce_frontend_az1.public_ip,
          aws_instance.ecommerce_frontend_az2.public_ip]
}