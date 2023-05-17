# Define provider and region
provider "aws" {
  region = "us-east-1"
}

# Create VPC data source
data "aws_vpc" "existing_vpc" {
  id = "vpc-07a017c6a1f9e07bc"
}

# Create security group for EC2 instance
resource "aws_security_group" "my_security_group" {
  name        = "<your_name>-wordpress-sg"
  description = "Security group for WordPress EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "wordpress_instance" {
  ami           = "<your_ami_id>"
  instance_type = "t3.micro"
  key_name      = "<your_key_pair_name>"
  vpc_security_group_ids = [
    "sg-0f888901820107cd1",   # Default VPC Security Group
    aws_security_group.my_security_group.id,   # Your own security group
  ]
  subnet_id             = "subnet-0b569643926c3a3b6"  # Public subnet
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
  }

  # Install user data for EC2 instance
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install -y apache2
              apt install -y php php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}
              apt install -y wget unzip
              systemctl enable apache2
              
              # Download and install WordPress
              cd /var/www/html
              wget https://wordpress.org/latest.zip
              unzip latest.zip
              chown -R www-data:www-data /var/www/html/wordpress
              chmod -R 755 /var/www/html/wordpress

              # Configure Apache for WordPress
              cat << EOL > /etc/apache2/sites-available/wordpress.conf
              <VirtualHost *:80>
                ServerAdmin admin@example.com
                DocumentRoot /var/www/html/wordpress
                ServerName example.com
                ServerAlias www.example.com

                <Directory /var/www/html/wordpress/>
                  Options FollowSymLinks
                  AllowOverride All
                  Require all granted
                </Directory>

                ErrorLog \${APACHE_LOG_DIR}/error.log
                CustomLog \${APACHE_LOG_DIR}/access.log combined
              </VirtualHost>
              EOL

              a2ensite wordpress.conf
              a2enmod rewrite
              a2dissite 000-default.conf
              systemctl restart apache2
            EOF
}

# Create RDS instance
resource "aws_db_instance" "wordpress_rds" {
  identifier                = "<your_name>-wp"
  engine                    = "mysql"
  engine_version            = "8.0.21"
  instance_class            = "db.t2.micro"
  allocated_storage         = 20
  storage_type              = "gp3"
  storage_encrypted         = false
  backup_retention_period   = 7
  multi_az                  = false
  publicly_accessible       = true
  vpc_security_group_ids    = ["default"]
  db_subnet_group_name      = aws_db_subnet_group.default.name
  parameter_group_name      = "default.mysql8.0"
  skip_final_snapshot       = true
  apply_immediately         = true
}

# Create DB subnet group
resource "aws_db_subnet_group" "default" {
  name        = "default"
  description = "Default DB subnet group"
  subnet_ids  = ["subnet-0b569643926c3a3b6"]  # Public subnet
}

# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "<your_name>-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach S3 access policy to the IAM role
resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create S3 bucket for WordPress media
resource "aws_s3_bucket" "wordpress_bucket" {
  bucket = "<your_name>-wp-bucket"
  acl    = "public-read"
}
