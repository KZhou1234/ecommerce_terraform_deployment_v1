#- 1x Custom VPC named "wl5vpc" in us-east-1
provider "aws" {
  access_key =  var.access_key         # Replace with your AWS access key ID (leave empty if using IAM roles or env vars)
  secret_key =  var.secret_key        # Replace with your AWS secret access key (leave empty if using IAM roles or env vars)
  region     =  var.region          # Specify the AWS region where resources will be created (e.g., us-east-1, us-west-2)
}

module "VPC" {
  source = "./VPC"

}

module "EC2" {
  source = "./EC2"
  #get output from VPC, use them in EC2
  vpc_id = module.VPC.vpc_id
  private_subnet_id = module.VPC.private_subnet_ids
  public_subnet_id = module.VPC.public_subnet_ids
}


resource "aws_db_instance" "postgres_db" {
  identifier           = "ecommerce-db"
  engine               = "postgres"
  engine_version       = "14.13"
  instance_class       = var.db_instance_class
  allocated_storage    = 20
  storage_type         = "standard"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  
  # the subnet group is created below and the subnet used is the private subnet
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  #the security group here also is using the created backend sg
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "Ecommerce Postgres DB"
  }
}
# in aws, there are two types of subnet, and security group, one for data resource and one for resource
# following are data, so we need to connect with the resource
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = module.VPC.private_subnet_ids

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS"
  vpc_id      = module.VPC.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.EC2.backend_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.postgres_db.endpoint
}




#- A load balancer that will direct the inbound traffic to either of the public subnets.
#- An RDS databse (See next step for more details)
