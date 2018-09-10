resource "aws_instance" "minecraft-server" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.minecraft-server.id}"
  vpc_security_group_ids = ["${aws_security_group.minecraft-server.id}"]
  key_name = "${aws_key_pair.minecraft-server.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.minecraft-server.id}"
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
      "mkdir /home/ubuntu/scripts",
    ]
  }
  provisioner "file" {
    source      = "./scripts/backup_world.sh"
    destination = "/home/ubuntu/scripts/backup_world.sh"
  }

  provisioner "file" {
    source      = "./scripts/restore_world.sh"
    destination = "/home/ubuntu/scripts/restore_world.sh"
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

output "minecraft-server_IP" {
  value = "${aws_instance.minecraft-server.public_ip}"
}

resource "aws_key_pair" "minecraft-server" {
  key_name = "minecraft-key"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}