Initial server setup
====================

Update & Upgrade
----------------
    $ sudo apt-get update && sudo apt-get upgrade --show-upgraded

Set Hostname
------------
    $ echo "foo" > /etc/hostname
    $ hostname -F /etc/hostname

Update /etc/hosts
-----------------
    $ sudo nano /etc/hosts

    127.0.0.1        localhost.localdomain    localhost
    12.34.56.78      plato.example.com        plato

Set Timezone
------------
    $ dpkg-reconfigure tzdata

Change SSH Port
---------------
    $ sudo nano /etc/ssh/sshd_config

  - edit Port entry, save
    $ sudo service ssh restart

  - don't forget to punch a hole in iptables i.e.

    $ sudo nano /etc/iptables.up.rules

  - and change `--dport ##` of a line like the following to add port 1024 `iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 1024 -j ACCEPT`

  - Now you need to connect like

    $ sftp -oPort=777 user@foo.bar

    $ ssh user@foo.bar -p 777


Apache modules
--------------
    $ sudo a2enmod rewrite
    $ sudo a2enmod headers
    $ sudo a2enmod expires
    $ sudo a2enmod deflate
    $ sudo a2enmod ssl

mod_security
------------
    $ sudo apt-get -y install libapache-mod-security
    $ sudo nano /etc/apache2/conf.d/modsecurity

    <ifmodule mod_security2.c>
    Include mod_security_rules/*.conf
    </ifmodule>

  - create directory for rules and basic set

    $ sudo mkdir /etc/apache2/mod_security_rules
    $ wget http://www.modsecurity.org/download/modsecurity-apache_2.5.13.tar.gz
    $ tar xf modsecurity-apache_2.5.13.tar.gz
    $ sudo mv modsecurity-apache_2.5.13/rules/base_rules/* /etc/apache2/mod_security_rules
    $ sudo chown -R root:root /etc/apache2/mod_security_rules
    $ rm -r modsecurity-apache_2.5.13.tar.gz modsecurity-apache_2.5.13/

  - get more rules at http://sourceforge.net/projects/mod-security/files/modsecurity-crs/0-CURRENT/

    $ sudo a2enmod mod-security
    $ sudo /etc/init.d/apache2 restart


Install MySQL
-------------
    $ sudo apt-get install mysql-server
    $ sudo mysql_secure_installation

  - Create MySQL databases

    > mysql -u root -p
    > create database DATABASENAME;
    > grant all on DATABASENAME.* to 'DBUSER' identified by 'DBPASSWORD';
    > flush privileges;
    > quit

Repetative Tasks
----------------
See /shell-scripts

