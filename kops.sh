#vim .bashrc
#export PATH=$PATH:/usr/local/bin/
#source .bashrc

#! /bin/bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

aws s3api create-bucket --bucket mustafa.project.flm.k8s.local --region us-east-1
aws s3api put-bucket-versioning --bucket mustafa.project.flm.k8s.local --region us-east-1 --versioning-configuration Status=Enabled
export KOPS_STATE_STORE=s3://mustafa.project.flm.k8s.local
kops create cluster --name mustafa.k8s.local --zones us-east-1a,us-east-1b --master-count=1 --master-size t2.large --master-volume-size=30 --node-count=3 --node-size t2.medium --node-volume-size=20
kops update cluster --name mustafa.k8s.local --yes --admin
