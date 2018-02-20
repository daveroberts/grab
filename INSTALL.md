Linode
Ubuntu 17.10
ssh root@172.104.12.110

apt update
apt-get install -y apache2
apt-get install -y mysql-server libmysqlclient-dev

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y google-chrome-stable

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash 
apt-get install -y nodejs

# Self signed cert for now
https://www.digitalocean.com/community/tutorials/how-to-create-a-ssl-certificate-on-apache-for-ubuntu-14-04

ufw allow 443/tcp

a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

Add to /etc/apache2/sites-enabled/default-ssl.conf
<Location />
      ProxyPass  http://localhost:8090/
      ProxyPassReverse http://localhost:8090/
</Location>

systemctl restart apache2

useradd -m grab
passwd grab
usermod -aG sudo grab
mkdir /apps
chown grab /apps

su - grab
mkdir ~/.ssh
# copy local ~/.ssh/id_rsa.pub to /home/grab/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# logout, log back in
# ssh grab@ip
# sudo su -
# edit /etc/ssh/sshd_config, PasswordAuth to no; Root to no
# systemctl restart sshd

cd /apps
git clone https://github.com/daveroberts/grab.git

# install rvm
rvm install ruby-2.4.1
gem install bundler

cd /apps/grab/backend
bundle

mysql -u root -p
CREATE DATABASE grab;
CREATE USER grab;
GRANT ALL PRIVILEGES ON grab.* to 'grab'@'localhost' IDENTIFIED BY 'grab';

cd /apps/grab/frontend
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
yarn
/apps/grab/frontend/prod_build

get chromedriver, put into /usr/local/bin

sudo apt install -y imagemagick











































