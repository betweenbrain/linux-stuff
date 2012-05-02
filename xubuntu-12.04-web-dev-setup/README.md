Basic Setup
---------

1. Update

	`$ sudo apt-get update && sudo apt-get upgrade`

2. Set up dual monitors

	`$ xrandr --output VGA-0 --left-of DVI-0`

3. Move panels to primary 

	- Right-click => Panel => Panel Preferences => Output

4. Clear ctrl+f5

	- Applications Menu > Settings > Settings Manager > Window Manager
	- check the Keyboard tab, and find the option which has Ctrl+F5 configured as short-cut key
	- clear that short-cut key
	- you should be able to use Ctrl+F5 key now

Web Server
----------

1. Install LAMP

	`$ sudo apt-get install lamp-server^`

2. Enable usermod to use user's home diretory in Apache

	`$ sudo a2enmod userdir`

	`$ sudo service apache2 restart`

3. Edit /etc/apache2/mods-enabled/php5.conf and comment `php_admin_value engine Off` of the line in the following code - http://forums.digitalpoint.com/showthread.php?t=1736370#post13839938

    `<IfModule mod_userdir.c>`<br>
    `   <Directory /home/*/public_html>`<br>
    `#      php_admin_value engine Off`<br>
    `    </Directory>`<br>
    `</IfModule>`

4. Run Apache as yourself, add the following to end of /etc/apache2/httpd.conf - http://ubuntuforums.org/showthread.php?t=809934

	`ServerName localhost`
	`User username`<br>
	`Group username`

5. Set Userdir as default localhost - https://help.ubuntu.com/community/ApacheMySQLPHP#Virtual%20Hosts\

    `$ sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/username`<br>
    `$ sudo nano /etc/apache2/sites-available/username`<br>
    - Change the `DocumentRoot` to point to the new location. For example, `/home/username/public_html/`<br>
    - Change the `Directory` directive, replace `<Directory /var/www/>` with `<Directory /home/username/public_html/>`<br>

    - Disable default site and enable yours
    `$ sudo a2dissite default && sudo a2ensite username`

6. Specificy DirectoryIndex of files - https://help.ubuntu.com/10.04/serverguide/C/httpd.html

    `$ sudo nano /etc/apache2/sites-available/username`

    - add the following to below allow from all to define execution order of files

    `DirectoryIndex index.html index.htm default.htm index.php default.php kickstart.php`


7. Enable mod_rewrite http://www.ghacks.net/2009/12/05/enable-mod_rewrite-in-a-ubuntu-server/

    `$ sudo a2enmod rewrite`

    - edit /etc/apache2/sites-enabled/username

    First look in the `<Directory />` section and change the line:

    `AllowOverride None`
    to
    `AllowOverride All`

    Do the same for the `<Directory /var/www/>` section.

    Once you have the file edited, restart Apache with the command:

    `$ sudo service apache2 restart`

8. Send Email with SSMTP and Google Apps - http://www.bunkerhollow.com/blogs/matt/archive/2010/10/12/ubuntu-send-email-with-ssmtp-and-google-apps-gmail.aspx

	`sudo apt-get install ssmtp`

	`sudo cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.bak`

	`sudo nano /etc/ssmtp/ssmtp.conf`

	- mailhub=smtp.gmail.com:587
	- hostname=USER@MYDOMAIN.com
	- root=USER@MYDOMAIN.com
	- AuthUser=USER@MYDOMAIN.com
	- AuthPass=PASSWORD
	- UseSTARTTLS=yes
	- UseTLS=yes
	- FromLineOverride=yes

	`sudo nano /etc/ssmtp/revaliases`

	- root:USER@MYDOMAIN.com:smtp.gmail.com:587
	- user:USER@MYDOMAIN.com:smtp.gmail.com:587

9. Fetch latest Adminer

	`wget http://www.adminer.org/latest-mysql-en.php -O /home/username/public_html/adminer/index.php`

 DNS
---------

1. Edit resolv.conf to set DNS to use Google

	`$ sudo nano /etc/resolv.conf`

	`nameserver 8.8.8.8`

	`nameserver 8.8.4.4`

2. Prevent file from being overwritten

	`$ sudo chattr +i /etc/resolv.conf`


Tools / Apps
-----

1. Install Git

	`sudo apt-get install git-core`

2. Install s3cmd package

    Import S3tools signing key:
        `$ wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -`

    Add the repo to sources.list:
        `$ sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list`

    Refresh package cache and install the newest s3cmd:
        `$ sudo apt-get update && sudo apt-get install s3cmd`






