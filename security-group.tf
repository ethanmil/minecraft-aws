resource "aws_security_group" "minecraft_server" {
    name = "vpc_server"
    description = "Allow incoming player connections."

    ingress {
        from_port = 25565
        to_port = 25565
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["12.179.102.162/32", "98.220.144.193/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.minecraft_server.id}"

    tags {
        Name = "Minecraft Security Group"
        Group = "Minecraft"
    }
}
