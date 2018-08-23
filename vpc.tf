# Internet VPC
resource "aws_vpc" "minecraft_server" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "Minecraft Server VPC"
        Group = "Minecraft"
    }
}

# Subnets
resource "aws_subnet" "minecraft_server" {
    vpc_id = "${aws_vpc.minecraft_server.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    tags {
        Name = "Minecraft Server Subnet"
        Group = "Minecraft"
    }
}

# Internet GW
resource "aws_internet_gateway" "minecraft_server" {
    vpc_id = "${aws_vpc.minecraft_server.id}"
    tags {
        Name = "Minecraft Server IG"
        Group = "Minecraft"
    }
}

# route tables
resource "aws_route_table" "minecraft_server" {
    vpc_id = "${aws_vpc.minecraft_server.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.minecraft_server.id}"
    }
    tags {
        Name = "Minecraft Server Route Table"
        Group = "Minecraft"
    }
}

# route associations public
resource "aws_route_table_association" "minecraft_server" {
    subnet_id = "${aws_subnet.minecraft_server.id}"
    route_table_id = "${aws_route_table.minecraft_server.id}"
}
