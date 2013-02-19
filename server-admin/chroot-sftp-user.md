## Dependencies

* OpenSSH 4.9p1 or newer

Install OpenSSH:

    $ apt-get install openssh-server


## Configure OpenSSH

Edit sshd_config

    $ nano /etc/ssh/sshd_config

Comment existing Subsystem:

    # Subsystem sftp /usr/lib/openssh/sftp-server

Add below it new Subsystem:

    Subsystem sftp internal-sftp


Check that `PasswordAuthentication` is either set to yes or commented out (not no):

    # PasswordAuthentication Yes

Add user to AllowUsers:

    AllowUsers <user>

Add at end of sshd_config, add the following:

    # Chroot members of sftp to their home directory
    Match Group sftp
    ChrootDirectory %h
    ForceCommand internal-sftp
    AllowTcpForwarding no


## Setup chrooted usergroup

    $ sudo groupadd sftp


## Setup chrooted users:

Create user if they don't exist

    $ adduser <user>

Add user to chrooted group

    $ usermod -G sftp <user>

Deny user shell access

    $ usermod -s /bin/false <user>


## Directory permissions / ownership

Users are restricied to their home directory, but cannot create directories or files in it.
Root must own user home directory:

    $ chown root:root /home/<user>
    $ chmod 0755 /home/<user>

### Option 1: Establish one or more sub-directories (i.e. public_html) that user can create files and sub-directories in:

    $ mkdir /home/<user>/<sub-directory>
    $ chown <user>:<user> /home/<user>/<sub-directory>

### Option 2: Using Tuxlite (see http://tuxlite.com/installation/)

    $ cd TuxLite
    $ ./domain.sh add johndoe yourdomain.com