Basic Setup
---------

WARNING: ATI/AMD proprietary FGLRX graphics drivers seem to prevent Java from working (may have other adverse affects)

1. Update

	`$ sudo apt-get update && sudo apt-get upgrade`

2. Set up dual monitors

	`$ sudo nano ~/.xprofile`

	add `xrandr --output VGA-0 --left-of DVI-0`

3. Move panels to primary 

	- Right-click > Panel > Panel Preferences > Output

4. Free ctrl+f5

	- Applications Menu > Settings > Settings Manager > Window Manager
	- check the Keyboard tab, and find the option which has Ctrl+F5 configured as short-cut key
	- clear that short-cut key
	- you should be able to use Ctrl+F5 key now

5. Set custom Datetime Date
	`%a, %d %b %Y %l:%M:%S %P`

6. Add some panel items
	- right-click top panel, click Places
	- right-click Places > move



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

	`User username`

	`Group username`

5. Set Userdir as default localhost - https://help.ubuntu.com/community/ApacheMySQLPHP#Virtual%20Hosts\

    `$ sudo cp /etc/apache2/sites-available/default /etc/apache2/sites-available/username`

    `$ sudo nano /etc/apache2/sites-available/username`

    - Change the `DocumentRoot` to point to the new location. For example, `/home/username/public_html/`

    - Change the `Directory` directive, replace `<Directory /var/www/>` with `<Directory /home/username/public_html/>`

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

    Do the same for the `<Directory /home/username/public_html/>` section.

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

3. Implement custom named ssh files
	`$ sudo nano /etc/ssh/ssh_config`

	add `IdentityFile ~/.ssh/customname`

4. Install Oracle (Sun) Java 1.6.0_32 - https://help.ubuntu.com/community/Java

	NOTE: ATI/AMD proprietary FGLRX graphics drivers seem to prevent Java from working.

	- download latest Oracle (Sun) JAVA 6 from http://www.oracle.com/technetwork/java/javase/downloads/jre-6u32-downloads-1594646.html
	`$ sudo chmod u+x jre-6u32-linux-x64.bin`

	`$ sudo ./jre-6u32-linux-x64.bin`

	`$ sudo mv jre1.6.0_32 /usr/lib/jvm/jre1.6.0_32`

	`$ sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.6.0_32/bin/java" 1`

	`$ sudo update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/lib/jvm/jre1.6.0_32/lib/amd64/libnpjp2.so" 1`

	- OPTIONAL: If more than one version of Java installed

	`$ sudo update-alternatives --config java`

	`$ sudo update-alternatives --config mozilla-javaplugin.so`

	- Check by running in terminal

	`$ java -version` should answer with 

	`java version "1.6.0_32"`<br>
	`Java(TM) SE Runtime Environment (build 1.6.0_32-b05)`<br>
	`Java HotSpot(TM) 64-Bit Server VM (build 20.7-b02, mixed mode)`


6. Install Gedit

	`sudo apt-get install gedit gedit-plugins gedit-developer-plugins`

- Eliminate annoying backup files

	- Edit > Preferences, select the Editor tab, uncheck “Create a backup copy of files before saving” option, click Close.

- Gedit plugin to format, minify, and validate javascript and CSS

    PREREQUISITES - NodeJS: http://nodejs.org/

    `$ sudo apt-get install nodejs`

    INSTALL

    `$ git clone https://github.com/trentrichardson/Gedit-Clientside-Plugin.git`

    - Copy the clientside directory and clientside.gedit-plugin file into your gedit plugins directory (/usr/lib/gedit/plugins/).
    - Start or restart gedit
    - Open the Preferences, and navigate to Plugins, check to enable Clientside plugin

- Gedit themes - https://github.com/mig/gedit-themes

    `$ git clone https://github.com/mig/gedit-themes.git ~/.gnome2/gedit/styles`<br>
    `$ cd ~/.gnome2/gedit/gedit/styles`<br>

7. Add Gimp "save for web" http://blog.sudobits.com/2010/09/06/gimp-save-for-web-plugin-image-optimization-on-ubuntu/

     Open Synaptic package manager and search for ‘gimp plugin registry’

8. Install VirutalBox - https://help.ubuntu.com/community/VirtualBox
    - Download  from http://www.virtualbox.org/wiki/Linux_Downloads for USB support
	- if VT-X issue
	`$ VBoxManage modifyvm virtualmachinename --hwvirtex off`
	- Install guest additions

	1. Launch VB
	2. Devices -> Install Guest Additions

    - Share host folder
    `VBoxManage sharedfolder add "XP" -name "share" -hostpath /home/your/shared/directory/VirtualBoxShare/`



Other Great Apps
--------------
- Meld Diff Viewer
- FileZilla
	- Edit > Settings > sftp to import your .ppk keyfile

- KeePassX
- Giggle Git repositoy viewer
- palimpsest "Disk Utility"
