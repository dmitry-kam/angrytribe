sudo useradd -m -s /bin/bash deploy
sudo usermod -aG docker deploy
sudo chown deploy:deploy -Rf /var/www/angrytribe

sudo -u deploy ssh-keygen -t ed25519 -f /home/deploy/.ssh/id_ed25519 -N ""
cat /home/deploy/.ssh/id_ed25519.pub >> /home/deploy/.ssh/authorized_keys
sudo -u deploy cat /home/deploy/.ssh/id_ed25519.pub
sudo -u deploy cat /home/deploy/.ssh/id_ed25519

git config --global --add safe.directory /var/www/angrytribe

sudo chown -R deploy:deploy /var/www/angrytribe