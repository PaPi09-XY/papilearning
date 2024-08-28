provider "aws" {
  region = "us-east-1"
  profile = "kay"
}


# create vpc

resource "aws_vpc" "kayvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "kayvpc"
  }
}
# create subnet

resource "aws_subnet" "kaysub" {
  vpc_id     = aws_vpc.kayvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  

  tags = {
    Name = "learningsub"
  }
}
# create internet gateway

resource "aws_internet_gateway" "kayigw" {
  vpc_id = aws_vpc.kayvpc.id

  tags = {
    Name = "KIGW"
  }
}
# create route table

resource "aws_route_table" "kayrt" {
  vpc_id = aws_vpc.kayvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kayigw.id
  }


  tags = {
    Name = "rt"
  }
}
# associate subnet to route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.kaysub.id
  route_table_id = aws_route_table.kayrt.id
}

# create SG

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.kayvpc.id

  ingress {
    description = "HTTPS web traffice from vpc"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  ingress {
    description = "HTTP inbound rule"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  ingress {
    description = "HTTP inbound rule"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

ingress {
    description = "SSH inbound rule"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls_SG"
  }

}

# use data source to get a registered ubuntu ami
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# create Ec2

resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.kaysub.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  availability_zone = "us-east-1b"
  key_name = "kay2"
  user_data = "${file("install_jenkins.sh")}"

  tags = {
    Name = "jenkins_server"
  }

}

resource "aws_instance" "server2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.kaysub.id
  vpc_security_group_ids = [aws_security_group.allow_web.id]
  availability_zone = "us-east-1b"
  key_name = "kay2"
  user_data = "${file("install_tomcat.sh")}"

  tags = {
    Name = "tomcat_server"
  }

}

# print the url of the jenkins server
output "Jenkins_website_url" {
  value     = join ("", ["http://", aws_instance.server1.public_ip, ":", "8080"])
  description = "Jenkins Server is server1"
}

# print the url of the tomcat server
output "Tomcat_website_url1" {
  value     = join ("", ["http://", aws_instance.server2.public_ip, ":", "8080"])
  description = "Tomcat Server is server2"
}

#output "website-url" {
 # value       = "${aws_instance.server1.*.public_ip}"
  #description = "PublicIP address details"
#}
# aws_instance.ec2_instance_instance.public_dns




