#!/bin/bash
echo
echo "System updates and basic setup"
echo "==============================================================="
echo
echo
echo "First things first, let's make sure we have the latest updates."
echo "---------------------------------------------------------------"
echo
#
aptitude update && aptitude -y safe-upgrade
#
echo
echo "Let's set the hostname."
# http://library.linode.com/getting-started
echo "---------------------------------------------------------------"
echo
read -p "Enter the hostname for this system: " HOSTNAME
echo
#
echo "$HOSTNAME" > /etc/hostname
hostname -F /etc/hostname
#
echo
echo "Now let's update /etc/hosts."
echo "---------------------------------------------------------------"
echo
read -p "Enter the I.P. address of this system: " SYSTEMIP
read -p "Enter the system FQDN domain.tld (i.e example.com): " DOMAIN
#
mv /etc/hosts /etc/hosts.bak
echo "
127.0.0.1       localhost
$SYSTEMIP       $HOSTNAME.$DOMAIN     $HOSTNAME
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
" >> /etc/hosts
#
echo "Now let's set the proper timezone."
echo "---------------------------------------------------------------"
#
dpkg-reconfigure tzdata
#
echo
echo "Synchronize the system clock with an NTP server"
echo "---------------------------------------------------------------"
#
aptitude install ntp ntpdate
#
echo "Setting the language and charset"
echo "---------------------------------------------------------------"
echo
read -p "Enter your language (i.e. en_GB): " LANGUAGE
read -p "Enter your charset (i.e. UTF-8): " CHARSET
#
locale-gen $LANGUAGE.$CHARSET
/usr/sbin/update-locale LANG=$LANGUAGE.$CHARSET
#
echo
echo
echo
echo
echo "SSH security"
# https://help.ubuntu.com/community/SSH/OpenSSH/Configuring
echo "==============================================================="
echo
echo "Change SSH port"
echo "---------------------------------------------------------------"
echo
read -p "Enter a new port for SSH connections: " SSHPORT
#
sed -i "s/Port 22/Port $SSHPORT/g" /etc/ssh/sshd_config
#
echo "Instruct SSH to listen on a specific IP"
echo "---------------------------------------------------------------"
echo
read -p "Enter the IP address SSH be restricted to: " SSHIP
#
sed -i "s/#ListenAddress 0.0.0.0/ListenAddress $SSHIP/g" /etc/ssh/sshd_config
#
echo
echo "Disabling root ssh login"
echo "---------------------------------------------------------------"
#
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
#
echo
echo "Disabling password authentication"
echo "---------------------------------------------------------------"
#
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
#
echo
echo "Disabling X11 forwarding"
echo "---------------------------------------------------------------"
#
sed -i "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
#
echo
echo "Disabling use of DNS for ssh"
echo "---------------------------------------------------------------"
echo "UseDNS no" >> /etc/ssh/sshd_config
echo
echo
echo "Creating webmasters group to share with www-data"
echo
addgroup webmasters
usermod -G webmasters www-data
echo
# Script to add a user to Linux system
# -------------------------------------------------------------------------
# Copyright (c) 2007 nixCraft project <http://bash.cyberciti.biz/>
# This script is licensed under GNU GPL version 2.0 or above
# Comment/suggestion: <vivek at nixCraft DOT com>
# -------------------------------------------------------------------------
# See url for more info:
# http://www.cyberciti.biz/tips/howto-write-shell-script-to-add-user.html
# -------------------------------------------------------------------------
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username of who can connect via SSH: " USER
	read -s -p "Enter password of that user: " PASSWORD
	egrep "^$USER" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$USER exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $PASSWORD)
		useradd -s /bin/bash -m -d /home/$USER -U -p $pass $USER
		[ $? -eq 0 ] && echo "$USER has been added to system!" || echo "Failed to add a $USER!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
# End script to add a user to Linux system
# -------------------------------------------------------------------------
echo
echo
echo
echo "Adding to SSH AllowUsers"
echo "---------------------------------------------------------------"
#
echo "AllowUsers $USER" >> /etc/ssh/sshd_config
#
echo
echo
echo
echo "Adding to sudoers"
echo "---------------------------------------------------------------"
#
cp /etc/sudoers /etc/sudoers.tmp
chmod 0640 /etc/sudoers.tmp
echo "$USER    ALL=(ALL) ALL" >> /etc/sudoers.tmp
chmod 0440 /etc/sudoers.tmp
mv /etc/sudoers.tmp /etc/sudoers
#
echo
echo
echo
read -p "Enter public authentication key for that user: " PUBLICKEY
#
mkdir /home/$USER/.ssh
touch /home/$USER/.ssh/authorized_keys
echo $PUBLICKEY >> /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
chmod 600 /home/$USER/.ssh/authorized_keys
service ssh reload
#
echo
echo
echo
echo "Installing iptables firewall"
echo "---------------------------------------------------------------"
#
aptitude install -y iptables
#
echo
echo
echo
echo "Setting up basic(!) rules for iptables. Uncomment / modify as needed, with care :)"
# http://www.thegeekstuff.com/scripts/iptables-rules
# http://wiki.centos.org/HowTos/Network/IPTables
# https://help.ubuntu.com/community/IptablesHowTo
echo "---------------------------------------------------------------"

#
# Flush old rules
iptables -F

# Allow SSH connections on tcp port $SSHPORT
# This is essential when working on remote servers via SSH to prevent locking yourself out of the system
#
iptables -A INPUT -p tcp --dport $SSHPORT -j ACCEPT

# Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback access
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Block a specific ip-address
#iptables -A INPUT -s 192.168.666.666 -j DROP

# Allow incoming HTTP
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# Allow outgoing HTTPS
iptables -A OUTPUT -o eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming HTTPS
iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# Allow outgoing HTTPS
iptables -A OUTPUT -o eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# Ping from inside to outside
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Ping from outside to inside
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

# Allow packets from internal network to reach external network.
# if eth1 is external, eth0 is internal
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

# Allow MySQL connection only from a specific network
#iptables -A INPUT -i eth0 -p tcp -s 192.168.200.0/24 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT

# Allow Sendmail or Postfix
iptables -A INPUT -i eth0 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT

# Prevent DoS attack
iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

# Log dropped packets
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -I INPUT 5 -m limit --limit 5/min -j LOG --log-prefix "Iptables denied: " --log-level 7
iptables -A LOGGING -j DROP

# Create the script to load the rules
echo '#!/bin/sh
iptables-restore < /etc/iptables.rules
' > /etc/network/if-pre-up.d/iptablesload

# Create the script to save currently used rules
echo '#!/bin/sh
iptables-save > /etc/iptables.rules
if [ -f /etc/iptables.downrules ]; then
   iptables-restore < /etc/iptables.downrules
fi
' > /etc/network/if-post-down.d/iptablessave

# Ensure they are executible
chmod +x /etc/network/if-post-down.d/iptablessave
chmod +x /etc/network/if-pre-up.d/iptablesload

#
/etc/init.d./networking restart

echo
echo
echo
echo "Misc Customization"
echo "==============================================================="
echo
echo "Adding a bit of color and formatting to the command promt"
echo "From - http://ubuntuforums.org/showthread.php?t=810590"
echo "---------------------------------------------------------------"
#
echo '
export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
' >> /home/$USER/.bashrc
source /home/$USER/.bashrc
#
echo
echo
echo
echo "Installing debconf utilities"
echo "---------------------------------------------------------------"
#
aptitude install -y debconf-utils
#
echo
echo
echo
echo "Install and configure postfix as email gateway for sending only"
# http://library.linode.com/email/postfix/gateway-ubuntu-10.04-lucid
echo "---------------------------------------------------------------"
#
echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
echo "postfix postfix/mailname string $DOMAIN" | debconf-set-selections
echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections
aptitude -y install postfix
rm /etc/aliases
echo "root: $USER" >> /etc/aliases
newaliases
sed -i "s/myhostname =/#myhostname =/g" /etc/postfix/main.cf
echo "myhostname = $DOMAIN" >> /etc/postfix/main.cf
sed -i "s/myorigin/#myorigin/g" /etc/postfix/main.cf
echo 'myorigin = $mydomain' >> /etc/postfix/main.cf
sed -i "s/mynetworks/#mynetworks/g" /etc/postfix/main.cf
echo "mynetworks = 127.0.0.0/8" >> /etc/postfix/main.cf
/etc/init.d/postfix restart
#
echo
echo
echo
echo "Install MySQL server"
echo "From - http://library.linode.com/email/postfix/gateway-ubuntu-10.04-lucid"
echo "---------------------------------------------------------------"
echo
read -p "Please enter the MySQL user password: " MYSQLPASSWD
#
echo mysql-server mysql-server/root_password password $MYSQLPASSWD | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $MYSQPASSWD | debconf-set-selections
aptitude -y install mysql-server && mysql_secure_installation
#
echo
echo
echo
echo "Installing Apache"
echo "---------------------------------------------------------------"
echo
# Install Apache
aptitude -y install apache2
echo "ServerName $HOSTNAME" > /etc/apache2/conf.d/servername.conf
sed -i "s/Timeout 300/Timeout 30/g" /etc/apache2/apache2.conf
apache2ctl graceful
apache2ctl start
#
echo
echo
echo
echo "Enable Apache modules"
echo "---------------------------------------------------------------"
echo
#
a2enmod rewrite
a2enmod headers
a2enmod expires
a2enmod deflate
a2enmod ssl
#
echo
echo
echo
echo "Basic Apache security"
echo "---------------------------------------------------------------"
echo
sed -i "s/ServerTokens OS/ServerTokens Prod/g" /etc/apache2/conf.d/security
sed -i "s/ServerSignature On/ServerSignature off/g" /etc/apache2/conf.d/security
#
echo
echo
echo
echo "Installing mod_security with basic ruleset"
# http://library.linode.com/web-servers/apache/mod-security
echo "---------------------------------------------------------------"
echo
aptitude -y install libxml2 libxml2-dev libxml2-utils
aptitude -y install libaprutil1 libaprutil1-dev
aptitude -y install libapache-mod-security

# TODO: Still some directory issues
# may have broken Apache2 config

wget http://downloads.sourceforge.net/project/mod-security/modsecurity-crs/0-CURRENT/modsecurity-crs_2.2.3.tar.gz
tar xzf modsecurity-crs_2.2.3.tar.gz
mv modsecurity-crs_2.2.3 /etc/apache2/modsecurity-crs
echo
echo "Loading base config"
echo
mv /etc/apache2/modsecurity-crs/modsecurity_crs_10_config.conf.example /etc/apache2/modsecurity-crs/modsecurity_crs_10_config.conf
echo
echo "Activating select rulesets"
echo
for f in $(ls /etc/apache2/modsecurity-crs/optional_rules/ | grep comment_spam) ; do ln -s /etc/apache2/modsecurity-crs/optional_rules/$f /etc/apache2/modsecurity-crs/activated_rules/$f ; done
for f in $(ls /etc/apache2/modsecurity-crs/slr_rules/ | grep joomla) ; do ln -s /etc/apache2/modsecurity-crs/slr_rules/$f /etc/apache2/modsecurity-crs/activated_rules/$f ; done
for f in $(ls /etc/apache2/modsecurity-crs/slr_rules/ | grep rfi) ; do ln -s /etc/apache2/modsecurity-crs/slr_rules/$f /etc/apache2/modsecurity-crs/activated_rules/$f ; done
for f in $(ls /etc/apache2/modsecurity-crs/slr_rules/ | grep lfi) ; do ln -s /etc/apache2/modsecurity-crs/slr_rules/$f /etc/apache2/modsecurity-crs/activated_rules/$f ; done
for f in $(ls /etc/apache2/modsecurity-crs/slr_rules/ | grep xss) ; do ln -s /etc/apache2/modsecurity-crs/slr_rules/$f /etc/apache2/modsecurity-crs/activated_rules/$f ; done
chown -R root:root /etc/apache2/modsecurity-crs
rm -r modsecurity-crs_2.2.3.tar.gz modsecurity-crs_2.2.3/
echo "
<IfModule security2_module>
    Include modsecurity-crs/modsecurity_crs_10_config.conf
    Include modsecurity-crs/base_rules/*.conf
    Include modsecurity-crs/activated_rules/*.conf
</IfModule>
" >> /etc/apache2/conf.d/modsecurity

# TODO: failban - http://library.linode.com/security/fail2ban

# TODO: look at mod_evasive ? - http://www.zdziarski.com/blog/?page_id=442 - http://www.linuxlog.org/?p=135 , http://library.linode.com/web-servers/apache/mod-evasive,

echo
echo
echo
echo "Install MySQL and MySQL modules"
echo "--------------------------------------------------------------"
echo
#
aptitude -y install php5 libapache2-mod-php5
aptitude -y install php5-mysql php5-dev php5-curl php5-gd php5-imagick php5-mcrypt php5-memcache php5-mhash php5-pspell php5-snmp php5-suhosin php5-xmlrpc php5-xsl
echo '
extension_dir = "./usr/lib/php5/20090626+lfs/"
extension=curl.so
extension=gd.so
extension=imagick.so
extension=mcrypt.so
extension=memcache.so
extension=mysqli.so
extension=mysql.so
extension=pdo_mysql.so
extension=pdo.so
extension=pspell.so
extension=snmp.so
extension=suhosin.so
extension=xmlrpc.so
extension=xsl.so
' >> /etc/php5/apache2/php.ini
#
echo
echo
echo
echo "Set PHP memory limit to 48M"
echo "--------------------------------------------------------------"
echo
#
sed -i "s/memory_limit =/#memory_limit =/g" /etc/php5/apache2/php.ini
echo "memory_limit = 48M" >> /etc/php5/apache2/php.ini
apache2ctl graceful
#
echo
echo
echo
echo "Seting up default site for server"
echo "--------------------------------------------------------------"
#
echo "
<VirtualHost *:80>
  ServerName  $DOMAIN
  ServerAlias www.$DOMAIN
  ServerAdmin webmaster@$DOMAIN
  Options FollowSymLinks MultiViews
  DirectoryIndex index.php index.html
  DocumentRoot /home/$USER/www/$DOMAIN/public_html
  LogLevel warn
  ErrorLog  /home/$USER/www/$DOMAIN/log/error.log
  CustomLog /home/$USER/www/$DOMAIN/log/access.log combined
</VirtualHost>
" >> /etc/apache2/sites-available/$DOMAIN
#
echo
echo
echo
echo "Creating web directory structure"
echo "--------------------------------------------------------------"
echo
#
mkdir -p /home/$USER/www/$DOMAIN/{cgi-bin,log,private,public_html}
chown -R $USER:webmasters /home/$USER/www && chmod -R g+w /home/$USER/www
find /home/$USER/www -type d -exec chmod g+s {} \;
echo "<h1>$DOMAIN works!</h1>" >> /home/$USER/www/$DOMAIN/public_html/index.php
echo "Enabling site, reloading apache"
a2ensite $DOMAIN
apache2ctl graceful
apache2ctl start
#
echo
echo
echo
echo "One final hurrah"
echo "--------------------------------------------------------------"
echo
aptitude update && aptitude -y safe-upgrade
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo "==============================================================="
echo
echo "All done!"
echo
echo "If you are confident that all went well, reboot this puppy and play."
echo
echo "If not, now is your (last?) chance to fix things."
echo
echo "==============================================================="
echo

