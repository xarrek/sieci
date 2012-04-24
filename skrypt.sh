#!/bin/bash
IP=$1
GRUPA=$2
IP1=$((GRUPA*3+1))
IP2=$((GRUPA*3+2))
IP3=$((GRUPA*3+3))
ZOLTY="\E[33;1m"
RESET="\033[0m"
ZIELONY="\E[32m"
CZERWONY="\E[31m"
echo -e $ZOLTY"Zaliczenia LAMP"$RESET
echo -e $CZERWONY"Skrypt instalacyjny"$RESET

if [ "$#" -eq 2 ]
then
	echo -e $ZIELONY"Ustawianie aliasów"$RESET
	echo 'alias l="ls --color"' >> /etc/profile
	echo 'alias ll="ls -l --color"' >> /etc/profile
	echo 'alias la="ls -al --color"' >> /etc/profile
	echo 'alias apg="apache2ctl graceful"' >> /etc/profile
	echo 'alias bsp="/etc/init.d/bind9 stop"' >> /etc/profile
	echo 'alias bst="/etc/init.d/bind9 start"' >> /etc/profile
	echo 'alias bre="/etc/init.d/bind9 restart"' >> /etc/profile
	echo -e $ZIELONY"Aktualizacja systemu"$RESET
	echo -e $ZIELONY"Wymagana ingerecja uzyszkodnika"$RESET
	apt-get -qq update
	apt-get -qq dist-upgrade
	echo -e $ZIELONY"Instalacja potrzebnego oprogramowania"$RESET
	apt-get -qqy install mc less bzip2 unzip zip nano
	echo -e $ZIELONY"Ustawianie adresów subinterjesów"$RESET
	ifconfig eth0:0 192.168.201.$IP1 netmask 255.255.255.0
	ifconfig eth0:1 192.168.201.$IP2 netmask 255.255.255.0
	ifconfig eth0:2 192.168.201.$IP3 netmask 255.255.255.0
	echo -e $ZIELONY"Ustawianie trasy routingu"$RESET
	route add -net 82.145.72.0 netmask 255.255.254.0 gw 192.168.201.2
	echo -e $ZIELONY"Instalacja Apache2"$RESET
	apt-get -qq install apache2
	echo -e $ZIELONY"Konfiguracja serwerów wirtualnych IPB"$RESET
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
	ln -sf /etc/apache2/sites-available/host2 /etc/apache2/sites-enabled/010-host3
	mkdir -p /var/www/host1
	mkdir -p /var/www/host2
	mkdir -p /var/www/host3
	echo  "serwer wirtualny host1 – adres 192.168.201.$IP1" > /var/www/host1/index.html
	echo  "serwer wirtualny host2 – adres 192.168.201.$IP2" > /var/www/host2/index.html
	echo  "serwer wirtualny host3 – adres 192.168.201.$IP3" > /var/www/host3/index.html
	apache2ctl graceful
	echo -e $ZIELONY"Instalacja Bind9"$RESET
	apt-get -qq install bind9
	echo -e $ZIELONY"Konfiguracja Bind9"$RESET
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
	echo -e "192.168.200.$IP\tIN\tPTR\thostn2." >> /etc/bind/200.168.192.in-addr.arpa
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
	echo -e $ZIELONY"Konfiguracja Apache2 NB"$RESET
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
	echo -e $ZIELONY"INSTALACJA MYSQL i PHP"$RESET
	apt-get -qq update
	echo -e $CZERWONY"WYMAGANA INGERECJA UZYSZKODNIKA"$RESET
	apt-get -qq install php5 mysql-server mysql-client php5-mysql
	mysqladmin -p create joomladb
	echo -e $ZIELONY"Instalacja Joomla"$RESET
	wget -q http://joomlacode.org/gf/download/frsrelease/16914/73508/Joomla_2.5.4-Stable-Full_Package.zip
	unzip -q Joomla_2.5.4-Stable-Full_Package.zip -d joomla
	cp -R joomla/* /var/www/hostn1/
	apache2ctl graceful
else
	echo "Zla skladnia! ./skrypt.sh IP GRUPA"
	echo "Przyklad: ./skrypt.sh 132 15"
fi
