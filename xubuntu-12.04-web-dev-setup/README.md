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
	- right-click date > properties

	`%a, %d %b %Y %l:%M:%S %P`

6. Add some panel items
	- right-click top panel, click Places
	- right-click Places > move

7. Tweak terminal appearance

	- background: #2C001E @ 95% opacity
	- text-selection: #DD4814
	- text: #f3f3f3

8. Speed up Thunar initial launch - http://ubuntuforums.org/showpost.php?p=11109244&postcount=1
	- Open Thunar
	- File > Properties > Permissions
	- set your "group" to have read & write permissions



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

10. Install cURL

	`$ sudo apt-get install php5-curl`

 DNS
---------

1. Edit resolv.conf to set DNS to use Google nameservers - http://www.stgraber.org/2012/02/24/dns-in-ubuntu-12-04/

	`$ sudo nano /etc/resolvconf/resolv.conf.d/head`

	-add

	`nameserver 8.8.8.8`

	`nameserver 8.8.4.4`


Tools / Apps
-----

1. Install Git

	`sudo apt-get install git-core`

2. Implement custom named ssh files
	`$ sudo nano /etc/ssh/ssh_config`

	add `IdentityFile ~/.ssh/customname`

3. Install Oracle (Sun) Java 1.7.0_05 - http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html
	`sudo add-apt-repository ppa:webupd8team/java`
	`sudo apt-get update`
	`sudo apt-get install oracle-java7-installer`


4. Install Gedit

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

5. Add Gimp "save for web" http://blog.sudobits.com/2010/09/06/gimp-save-for-web-plugin-image-optimization-on-ubuntu/

     Open Synaptic package manager and search for ‘gimp plugin registry’

6. Install VirutalBox - https://help.ubuntu.com/community/VirtualBox
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
- Back in Time - http://backintime.le-web.org/
- Gimp
- Trimage image compressor
- K3B
- Arista Transcoder - video converter


Network File Sharing (NFS) - http://ubuntuforums.org/showthread.php?t=249889
-----

Server:

	`$ sudo apt-get install nfs-kernel-server rpcbind`

	`$ sudo nano /etc/exports`
		- example red/write share of users home directory to only local addresses `/home/user 192.168.0.0/24(rw,no_root_squash,no_subtree_check)

	`$ sudo /etc/init.d/nfs-kernel-server restart`

	`$ sudo exportfs -a`
		
Client:

	`$ sudo apt-get install nfs-common rpcbind`

	`$ sudo mkdir /mnt/localNameOfTheShare`

	- one time mount `sudo mount server.mydomain.com://home/user /mnt/localNameOfTheShare`

	- mount at boot	`$ sudo nano -w /etc/fstab` add `server.mydomain.com://home/user /mnt/localNameOfTheShare nfs rw,soft,intr 0 0`

	- `server.mydomain.com` can also be an IP address


Speed up folder view
-----
	- something to do with folder permissions / adding yourself

Tweak Grub
-----
	-`$ sudo nano /etc/default/grub`

	-`$ sudo update-grub`

Realtek Network Driver - http://ubuntuforums.org/showpost.php?p=11585129&postcount=4
-----
	- if `lspci -nn | grep 0200` gives us `[10ec:8169]`
	- `sudo modprobe r8169` to manually enable

	- `sudo su`
	- `echo r8169 >> /etc/modules`
	- `exit`



`couldn't connect to: /tmp/keyring...` issue - http://laslow.net/2012/05/06/gnome-keyring-issues-in-ubuntu-12-04/
-----
	- edit /etc/xdg/autostart/gnome-keyring-pkcs11.desktop
	- find `OnlyShowIn=GNOME;Unity` and add `;XFCE` to it (i.e. `OnlyShowIn=GNOME;Unity;XFCE`).




