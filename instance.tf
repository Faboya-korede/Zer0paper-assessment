#resource "aws_key_pair" "mykeypair"{
#  key_name   = "Zer0-papaer"
 # public_key = file("/home/ubuntu/.ssh/id_rsa.pub")

#}


resource "aws_instance" "node"{
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.small"
  key_name       = "interview"
  subnet_id      = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
tags = {
    Name = "Zer0-papaer"
  }
}


resource "aws_instance" "bastion-host"{
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name       = "interview"
  associate_public_ip_address = true 
  subnet_id      = aws_subnet.public-1-subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
tags = {
    Name = "bastion host"
  }
}


resource "null_resource" "save_ip" {
  provisioner "local-exec" {
    command = "echo '[server]' >> /home/ubuntu/interview/host-inventory && echo '${aws_instance.node.public_ip}' ansible_user=ubuntu >> /home/ubuntu/interview/host-inventory"
  }
}


#resource "null_resource" "ansible" {
#provisioner "local-exec" {
 # command = "ANSIBLE_HOST_KEY_CHECKING=False  ansible-playbook -i /home/ubuntu/interview/host-inventory  /home/ubuntu/interview/ansible.yaml"
 #}
#depends_on = [aws_instance.node]
#, aws_alb_listener.alb_listener
#}