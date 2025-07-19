
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow OpenSSH

# sudo ufw allow 80
# sudo ufw allow 8080

sudo ufw enable

sudo ufw status
# sudo ufw show added