#!/bin/bash

# Update packages
sudo dnf update -y

# Install required packages
sudo dnf install -y wget unzip java-21-amazon-corretto

# Verify Java
java -version

# Create sonar user if not exists
id sonar >/dev/null 2>&1 || sudo useradd sonar

# Go to /opt
cd /opt

# Download SonarQube 10.x
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip

# Extract
sudo unzip sonarqube-10.6.0.92116.zip

# Rename directory
sudo mv sonarqube-10.6.0.92116 sonarqube

# Set ownership
sudo chown -R sonar:sonar /opt/sonarqube

# Set permissions
sudo chmod -R 755 /opt/sonarqube

# Linux kernel settings required by Elasticsearch
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p

# User limits
cat <<EOF | sudo tee -a /etc/security/limits.conf
sonar   -   nofile   131072
sonar   -   nproc    8192
EOF

# Create SonarQube systemd service
sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube Service
After=network.target

[Service]
Type=forking

User=sonar
Group=sonar

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=always
LimitNOFILE=131072
LimitNPROC=8192

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable SonarQube
sudo systemctl enable sonarqube

# Start SonarQube
sudo systemctl start sonarqube

# Check status
sudo systemctl status sonarqube --no-pager
