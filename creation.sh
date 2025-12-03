#!/bin/bash

cat <<'EOF' > main.tf 

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  count         = 2
  key_name       = "key"
  

  tags = {
    Name = "HelloWorld"
  }
}

EOF


cat <<'EOF' > inventory

[ansible]
IP GOES HERE
[ansible:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/eissa/Downloads/key.pem

EOF


cat <<'EOF' > ansible.cfg

[defaults]
inventory = inventory
ansible_private_key = /home/eissa/Downloads/key.pem

EOF

cat <<'EOF' > apache.yml

---
- hosts: all
  name: Bio-Website Installation with Apache2
  become: true

  tasks:

    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Apache2
      apt:
        name: apache2
        state: latest

    - name: Ensure Apache2 is running
      ansible.builtin.systemd:
        name: apache2
        state: started
        enabled: yes

    - name: Install Git
      apt:
        name: git
        state: latest

    - name: Remove old website folder
      file:
        path: /var/www/html/My-Bio-Website
        state: absent

    - name: Clone GitHub repo
      git:
        repo: "https://github.com/AbdullrahmanEissa/My-Bio-Website.git"
        dest: /var/www/html/My-Bio-Website
        version: main
        force: yes

    - name: Move index.html to Apache root
      command: mv /var/www/html/My-Bio-Website/index.html /var/www/html/index.html
      args:
        removes: /var/www/html/index.html  # Remove existing index if present

    - name: Restart Apache2
      ansible.builtin.systemd:
        name: apache2
        state: restarted

EOF
