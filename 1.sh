GRUPA=$2
IP=$1
IP1=$((GRUPA*3+1))
IP2=$((GRUPA*3+2))
IP3=$((GRUPA*3+3))

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
