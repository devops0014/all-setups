sudo yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.5.2-1.x86_64.rpm
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server
