provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_key_pair" "mysshkeypair" {
  key_name   = "my_ed25519_keypair"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJ5A7S9JFVJhnm+NWJeDwAAOlw/vOa0buocCnTQmCEA abdullah@abdullah.solutions"
}

resource "aws_security_group" "sg-k8s" {
  name        = "k8s-sg"
  description = "security group for k8s cluster"
  # vpc_id = "your vpc id"
  # if you don't have a default vpc in this region, create one by using aws ec2 
  # create-default-vpc --region your_region. then you can use its id here or go 
  # without it (if you have one default vpc in this region, no need to specify 
  # id)

  ingress {
    from_port   = 22 # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "node1" {
  ami           = "ami-02e1797d503e673f4"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.mysshkeypair.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  security_groups = [aws_security_group.sg-k8s.name]

  user_data = <<-EOF
#!/bin/bash
# Add Docker's official GPG key:
apt update
apt install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker.service
systemctl enable containerd.service
groupadd docker
usermod -aG docker admin
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install kubectl /usr/local/bin/kubectl
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod u+x get_helm.sh
./get_helm.sh
su - admin -c minikube start
EOF

}

output "pub_ip" {
  value = aws_instance.node1.public_ip
}
