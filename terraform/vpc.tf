resource "aws_vpc" "fargate_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "fargate_subnet" {
  count = 2
  vpc_id = aws_vpc.fargate_vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = "eu-west-1a"  # Replace with your desired availability zone
}