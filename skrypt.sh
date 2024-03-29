#!/bin/bash
IP=$1
GRUPA=$2
IP1=$((GRUPA*3+1))
IP2=$((GRUPA*3+2))
IP3=$((GRUPA*3+3))


if [ "$#" -eq 2 ]
then
	if [ ! -e lock_profile ]
	then
		echo 'alias l="ls --color"' >> /etc/profile
		echo 'alias ll="ls -l --color"' >> /etc/profile
		echo 'alias la="ls -al --color"' >> /etc/profile
		echo 'alias apg="apache2ctl graceful"' >> /etc/profile
		echo 'alias bsp="/etc/init.d/bind9 stop"' >> /etc/profile
		echo 'alias bst="/etc/init.d/bind9 start"' >> /etc/profile
		echo 'alias bre="/etc/init.d/bind9 restart"' >> /etc/profile
		> lock_profile
	fi
	apt-get -y update --force-yes
	apt-get -y dist-upgrade --force-yes
	apt-get -y install mc less bzip2 unzip zip nano --force-yes
	ifconfig
	ifconfig eth0:0 192.168.201.$IP1 netmask 255.255.255.0
	ifconfig eth0:1 192.168.201.$IP2 netmask 255.255.255.0
	ifconfig eth0:2 192.168.201.$IP3 netmask 255.255.255.0
	if [ ! -e lock_interfaces ]
	then
		echo -e >> /etc/network/interfaces
		echo -e "auto eth0:0" >> /etc/network/interfaces
		echo -e "iface eth0:0 inet static" >> /etc/network/interfaces
		echo -e "\taddress 192.168.201.$IP1" >> /etc/network/interfaces
		echo -e "\tnetmask 255.255.255.0" >> /etc/network/interfaces
		echo -e "\tup route add -net 82.145.72.0 netmask 255.255.254.0 gw 192.168.201.2" >> /etc/network/interfaces
		echo -e >> /etc/network/interfaces
		echo -e "auto eth0:1" >> /etc/network/interfaces
		echo -e "iface eth0:1 inet static" >> /etc/network/interfaces
		echo -e "\taddress 192.168.201.$IP2" >> /etc/network/interfaces
		echo -e "\tnetmask 255.255.255.0" >> /etc/network/interfaces
		echo -e >> /etc/network/interfaces
		echo -e "auto eth0:2" >> /etc/network/interfaces
		echo -e "iface eth0:2 inet static" >> /etc/network/interfaces
		echo -e "\taddress 192.168.201.$IP3" >> /etc/network/interfaces
		echo -e "\tnetmask 255.255.255.0" >> /etc/network/interfaces
		> lock_interfaces
	fi
	route
	route add -net 82.145.72.0 netmask 255.255.254.0 gw 192.168.201.2
	route
	apt-get -y install apache2 --force-yes
	> /etc/apache2/sites-available/host1
	> /etc/apache2/sites-available/host2
	> /etc/apache2/sites-available/host3
	echo 'NameVirtualHost *' >> /etc/apache2/sites-available/host1
	echo 'NameVirtualHost *' >> /etc/apache2/sites-available/host2
	echo 'NameVirtualHost *' >> /etc/apache2/sites-available/host3
	echo "<VirtualHost 192.168.201.$IP1>" >> /etc/apache2/sites-available/host1
	echo "<VirtualHost 192.168.201.$IP2>" >> /etc/apache2/sites-available/host2
	echo "<VirtualHost 192.168.201.$IP3>" >> /etc/apache2/sites-available/host3
	echo -e "\tServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/host1
	echo -e "\tServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/host2
	echo -e "\tServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/host3
	echo -e "\tDocumentRoot /var/www/host1" >> /etc/apache2/sites-available/host1
	echo -e "\tDocumentRoot /var/www/host2" >> /etc/apache2/sites-available/host2
	echo -e "\tDocumentRoot /var/www/host3" >> /etc/apache2/sites-available/host3
	echo "</VirtualHost>" >> /etc/apache2/sites-available/host1
	echo "</VirtualHost>" >> /etc/apache2/sites-available/host2
	echo "</VirtualHost>" >> /etc/apache2/sites-available/host3
	ln -sf /etc/apache2/sites-available/host1 /etc/apache2/sites-enabled/010-host1
	ln -sf /etc/apache2/sites-available/host2 /etc/apache2/sites-enabled/010-host2
	ln -sf /etc/apache2/sites-available/host3 /etc/apache2/sites-enabled/010-host3
	mkdir -p /var/www/host1
	mkdir -p /var/www/host2
	mkdir -p /var/www/host3
	echo  "serwer wirtualny host1 – adres 192.168.201.$IP1" > /var/www/host1/index.html
	echo  "serwer wirtualny host2 – adres 192.168.201.$IP2" > /var/www/host2/index.html
	echo  "serwer wirtualny host3 – adres 192.168.201.$IP3" > /var/www/host3/index.html
	apache2ctl graceful
	apt-get -y install bind9 --force-yes
	> /etc/bind/named.conf
	echo 'include "/etc/bind/named.conf.options";' >> /etc/bind/named.conf
	echo 'zone "200.168.192.in-addr.arpa"{' >> /etc/bind/named.conf
	echo -e "\ttype master;" >> /etc/bind/named.conf
	echo -e '\tfile "/etc/bind/200.168.192.in-addr.arpa";' >> /etc/bind/named.conf
	echo "};" >> /etc/bind/named.conf
	echo 'zone "201.168.192.in-addr.arpa"{' >> /etc/bind/named.conf
	echo -e "\ttype master;" >> /etc/bind/named.conf
	echo -e '\tfile "/etc/bind/201.168.192.in-addr.arpa";' >> /etc/bind/named.conf
	echo "};" >> /etc/bind/named.conf
	echo "zone "z$GRUPA.lab.vs"{" >> /etc/bind/named.conf
	echo -e "\ttype master;" >> /etc/bind/named.conf
	echo -e "\tfile "\"/etc/bind/z$GRUPA.lab.vs"\";" >> /etc/bind/named.conf
	echo "};" >> /etc/bind/named.conf
	echo 'include "/etc/bind/named.conf.local";' >> /etc/bind/named.conf
	echo 'include "/etc/bind/named.conf.default-zones";' >> /etc/bind/named.conf
	echo -e '$TTL\t1s' > /etc/bind/200.168.192.in-addr.arpa
	echo -e '@\tIN\tSOA\tlocalhost. root.localhost. (' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '\t\t1\t;  Serial' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '\t\t604800\t;  Refresh' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '\t\t86400\t;  Retry' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '\t\t2419200\t;  Expire' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '\t\t604800 ) ; Negative Cache TTL' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e ";" >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '@\tIN\tNS\tlocalhost.' >> /etc/bind/200.168.192.in-addr.arpa
	echo -e "192.168.200.$IP\tIN\tPTR\tlocalhost." >> /etc/bind/200.168.192.in-addr.arpa
	echo -e "192.168.200.$IP\tIN\tPTR\thostn1" >> /etc/bind/200.168.192.in-addr.arpa
	echo -e "192.168.200.$IP\tIN\tPTR\thostn2" >> /etc/bind/200.168.192.in-addr.arpa
	echo -e '$TTL\t1s' > /etc/bind/201.168.192.in-addr.arpa
	echo -e '@\tIN\tSOA\tlocalhost. root.localhost. (' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '\t\t1\t;  Serial' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '\t\t604800\t;  Refresh' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '\t\t86400\t;  Retry' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '\t\t2419200\t;  Expire' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '\t\t604800 ) ; Negative Cache TTL' >> /etc/bind/201.168.192.in-addr.arpa
	echo -e ";" >> /etc/bind/201.168.192.in-addr.arpa
	echo -e "@\tIN\tNS\tlocalhost." >> /etc/bind/201.168.192.in-addr.arpa
	echo -e "1\tIN\tPTR\tlocalhost." >> /etc/bind/201.168.192.in-addr.arpa
	echo -e "1\tIN\tPTR\thost1" >> /etc/bind/201.168.192.in-addr.arpa
	echo -e "2\tIN\tPTR\thost2" >> /etc/bind/201.168.192.in-addr.arpa
	echo -e "3\tIN\tPTR\thost3" >> /etc/bind/201.168.192.in-addr.arpa
	echo -e '$TTL\t1s' > /etc/bind/z$GRUPA.lab.vs
	echo -e "@\tIN\tSOA\tns.z$GRUPA.lab.vs. root.ns.z$GRUPA.lab.vs. (" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\t1\t;  Serial" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\t604800\t;  Refresh" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\t86400\t;  Retry" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\t2419200\t;  Expire" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\t604800 ) ; Negative Cache TTL" >> /etc/bind/z$GRUPA.lab.vs
	echo -e ";" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "\t\tIN\tNS\tns" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "localhost\tIN\tA\t127.0.0.1" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "ns\t\tIN\tA\t192.168.200.$IP" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "host1\t\tIN\tA\t192.168.201.$IP1" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "host2\t\tIN\tA\t192.168.201.$IP2" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "host3\t\tIN\tA\t192.168.201.$IP3" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "hostn1\t\tIN\tA\t192.168.200.$IP" >> /etc/bind/z$GRUPA.lab.vs
	echo -e "hostn2\t\tIN\tA\t192.168.200.$IP" >> /etc/bind/z$GRUPA.lab.vs
	/etc/init.d/bind9 restart
	echo -e "<VirtualHost *>" > /etc/apache2/sites-available/hostn1
	echo -e "\tServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/hostn1
	echo -e "\tDocumentRoot /var/www/hostn1/" >> /etc/apache2/sites-available/hostn1
	echo -e "\tServerName hostn1.z$GRUPA.lab.vs" >> /etc/apache2/sites-available/hostn1
	echo -e "</VirtualHost>" >> /etc/apache2/sites-available/hostn1
	mkdir -p /var/www/hostn1
	ln -sf /etc/apache2/sites-available/hostn1 /etc/apache2/sites-enabled/040-hostn1
	echo -e "<VirtualHost *>" > /etc/apache2/sites-available/hostn2
	echo -e "\tServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/hostn2
	echo -e "\tDocumentRoot /var/www/hostn2/" >> /etc/apache2/sites-available/hostn2
	echo -e "\tServerName hostn2.z$GRUPA.lab.vs" >> /etc/apache2/sites-available/hostn2
	echo -e "</VirtualHost>" >> /etc/apache2/sites-available/hostn2
	mkdir -p /var/www/hostn2
	echo -e "serwer wirtualny hostn2 – adres 192.168.200.$IP" > /var/www/hostn2/index.html
	ln -sf /etc/apache2/sites-available/hostn2 /etc/apache2/sites-enabled/040-hostn2
	apache2ctl graceful
	apt-get -y update --force-yes
	apt-get -y install php5 mysql-server mysql-client php5-mysql --force-yes
	mysqladmin -p create joomladb
	wget http://joomlacode.org/gf/download/frsrelease/16914/73508/Joomla_2.5.4-Stable-Full_Package.zip
	unzip Joomla_2.5.4-Stable-Full_Package.zip -d joomla
	cp -R joomla/* /var/www/hostn1/
	rm Joomla_2.5.4-Stable-Full_Package.zip
	apache2ctl graceful
	echo nano /etc/profile > /root/.bash_history
	echo alias >> /root/.bash_history
	echo apt-get update >> /root/.bash_history
	echo apt-get dist-update >> /root/.bash_history
	echo apt-get install mc less bzip2 unzip zip nano >> /root/.bash_history
	echo ifconfig >> /root/.bash_history
	echo ifconfig eth0:0 192.168.201.$IP1 >> /root/.bash_history
	echo ifconfig eth0:1 192.168.201.$IP2 >> /root/.bash_history
	echo ifconfig eth0:2 192.168.201.$IP3 >> /root/.bash_history
	echo ifconfig >> /root/.bash_history
	echo route >> /root/.bash_history
	echo route add -net 82.145.72.0 netmask 255.255.254.0 gw 192.168.201.2 >> /root/.bash_history
	echo route >> /root/.bash_history
	echo nano /etc/network/interfaces >> /root/.bash_history
	echo /etc/init.d/networking restart >> /root/.bash_history
	echo ifconfig >> /root/.bash_history
	echo apt-get intall apache2 >> /root/.bash_history
	echo nano /etc/apache2/sites-available/host1 >> /root/.bash_history
	echo nano /etc/apache2/sites-available/host2 >> /root/.bash_history
	echo nano /etc/apache2/sites-available/host3 >> /root/.bash_history
	echo ln -s /etc/apache2/sites-available/host1 /etc/apache2/sites-enabled/010-host1 >> /root/.bash_history
	echo ln -s /etc/apache2/sites-available/host2 /etc/apache2/sites-enabled/010-host2 >> /root/.bash_history
	echo ln -s /etc/apache2/sites-available/host3 /etc/apache2/sites-enabled/010-host3 >> /root/.bash_history
	echo mkdir /var/www/host1 >> /root/.bash_history
	echo mkdir /var/www/host2 >> /root/.bash_history
	echo mkdir /var/www/host3 >> /root/.bash_history
	echo nano /var/www/host1/index.html >> /root/.bash_history
	echo nano /var/www/host2/index.html >> /root/.bash_history
	echo nano /var/www/host3/index.html >> /root/.bash_history
	echo apg >> /root/.bash_history
	echo apt-get install bind9 >> /root/.bash_history
	echo nano /etc/bind/named.conf >> /root/.bash_history
	echo nano /etc/bind/200.168.192.in-addr.arpa >> /root/.bash_history
	echo nano /etc/bind/201.168.192.in-addr.arpa >> /root/.bash_history
	echo nano /etc/bind/z$GRUPA.lab.vs >> /root/.bash_history
	echo bre >> /root/.bash_history
	echo ping host1.z$GRUPA.lab.vs >> /root/.bash_history
	echo ping host2.z$GRUPA.lab.vs >> /root/.bash_history
	echo ping host3.z$GRUPA.lab.vs >> /root/.bash_history
	echo nano /etc/apache2/sites-available/hostn1 >> /root/.bash_history
	echo nano /etc/apache2/sites-available/hostn2 >> /root/.bash_history
	echo ln -s /etc/apache2/sites-available/hostn1 /etc/apache2/sites-enabled/040-hostn1 >> /root/.bash_history
	echo ln -s /etc/apache2/sites-available/hostn2 /etc/apache2/sites-enabled/040-hostn2 >> /root/.bash_history
	echo mkdir /var/www/hostn1 >> /root/.bash_history
	echo mkdir /var/www/hostn2 >> /root/.bash_history
	echo apg >> /root/.bash_history
	echo apt-get update >> /root/.bash_history
	echo apt-get install php5 mysql-server mysql-client php5-mysql >> /root/.bash_history
	echo mysql -p >> /root/.bash_history
	echo wget http://joomlacode.org/gf/download/frsrelease/16914/73508/Joomla_2.5.4-Stable-Full_Package.zip >> /root/.bash_history
	echo unzip Joomla_2.5.4-Stable-Full_Package.zip -d joomla >> /root/.bash_history
	echo cp -R joomla/* /var/www/hostn1/ >> /root/.bash_history
	echo apg >> /root/.bash_history
	echo nano /var/www/hostn1/configuration.php >> /root/.bash_history
	echo rm -r /var/www/hostn1/installation/ >> /root/.bash_history
	sudo -i
else
		echo "Zla skladnia! ./skrypt.sh IP GRUPA"
		echo "Przyklad: ./skrypt.sh 132 15"
fi
