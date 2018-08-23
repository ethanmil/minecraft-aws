resource "aws_instance" "minecraft_server" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.minecraft_server.id}"
  vpc_security_group_ids = ["${aws_security_group.minecraft_server.id}"]
  key_name = "${aws_key_pair.minecraft_server.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.s3.id}"
  tags {
    Name = "Minecraft Server"
    Group = "Minecraft"
  }
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "file" {
    source = "minecraft.yml"
    destination = " /tmp/minecraft.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    agent = "false"
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}

output "Minecraft_Server_IP" {
  value = "${aws_instance.minecraft_server.public_ip}"
}

resource "aws_key_pair" "minecraft_server" {
  key_name = "minecraft-key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}