
#!/bin/bash

# STEP-1: UPDATE SYSTEM
yum update -y

# STEP-2: INSTALL GIT
yum install -y git

# STEP-3: ADD JENKINS REPOSITORY
wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# STEP-4: INSTALL JAVA 21
yum install -y java-21-amazon-corretto

# STEP-5: INSTALL JENKINS
yum install -y jenkins

# STEP-6: CREATE SWAP (2GB)
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# STEP-7: CREATE DEDICATED JENKINS TEMP DIRECTORY
mkdir -p /var/tmp/jenkins
chown jenkins:jenkins /var/tmp/jenkins

# STEP-8: SET JAVA MEMORY + TEMP DIRECTORY
sed -i '/Environment="JAVA_OPTS=/d' \
/usr/lib/systemd/system/jenkins.service

sed -i '/^\[Service\]/a Environment="JAVA_OPTS=-Djava.io.tmpdir=/var/tmp/jenkins -Xms256m -Xmx512m"' \
/usr/lib/systemd/system/jenkins.service

# STEP-9: RELOAD SYSTEMD
systemctl daemon-reload

# STEP-10: START JENKINS
systemctl start jenkins
systemctl enable jenkins

# STEP-11: CHECK STATUS
systemctl status jenkins --no-pager

echo ""
echo "Initial Jenkins Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
=======
yum install java-21-amazon-corretto -y
sudo wget -O /etc/yum.repos.d/jenkins.repo     https://pkg.jenkins.io/rpm-stable/jenkins.repo
yum install jenkins -y
systemctl start jenkins
systemctl status jenkins

