# VestaCP on Digital Ocean (Ubuntu 16.04 LTE)
A little script for myself to have a web server in Digital Ocean with Vesta Control Panel in no time.

Currently installing 
- VestaCP
- Nginx
- PHP 7
- MySQL
- Exim
- Dovecot
- vsftpd
- named
- iptables
- fail2ban

On servers over 3Gb of ram:
- spamassassin
- clamav

Minimal requirements

A 5 dollars a month Digital Ocean Ubuntu 16.04 64bit server, 512 mb ram / 1 CPU, 20 GB SSD Disk, 1000 GB Transfer.
Get it at https://goo.gl/WWmpYW . They will give you $10 credit in virtual machines just for signing in with that link.

The bigger the droplet, the better it works. Some features like Spam-Assasin and ClamAV install by default in servers with more than 3 GB of ram.

After login to your droplet for the first time, copy the line bellow and execute it in the terminal

    curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/vestacp.sh && bash vestacp.sh

Once installed, I have prepared some patches installation for your specific VestaCP version. Copy the line bellow and execute it in the terminal.

    bash vestacp_patch.sh
