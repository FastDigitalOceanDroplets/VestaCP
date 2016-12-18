# VestaCP
A little script for myself to have a web server in Digital Ocean with Vesta Control Panel in no time.

Minimal requirements

A 5 dollars a month Digital Ocean Ubuntu 16.04 64bit server, 512 mb ram / 1 CPU, 20 GB SSD Disk, 1000 GB Transfer.
Get it at https://goo.gl/WWmpYW. They will give you $10 credit in virtual machines just for signing in.

The bigger the droplet, the better it works. Some features like Spam-Assasin and ClamAV install by default in servers with more than 3 GB of ram.

After login to your droplet for the first time, copy the line bellow (withouth the first #) and execute it in the terminal

    curl -O https://raw.githubusercontent.com/FastDigitalOceanDroplets/VestaCP/master/vestacp.sh && bash vestacp.sh
