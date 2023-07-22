#!/bin/bash

# Script automatically install LAMP stack
# L inux (shoul be allready installed. Debian and RedHat are supported)
# A pache html server
# M ySQL database server
# P hp scripting support

# detect OS installed
# returns $OS as name of installed OS and $PMng as a package manager
# or <none> in case of unsupported OS
detect_os() {
	if [ -f /etc/debian_version ];
	then
		OS="Debian"
		PMng="apt-get"
	elif [ -f /etc/redhat-release ];
       	then
		OS="Rhel"
		PMng="yum"
	else
		OS="<none>"
		PMng="<none>"
	fi
}

install_apache2_debian() {
	sudo $PMng install -y apache2
	sudo systemctl start apache2
	sudo systemctl status apache2
}

install_mysql_debian() {
	sudo $PMng install -y mysql-server
	sudo systemctl start mysql.service
	sudo systemctl status mysql.service	
}

install_php_debian() {
	sudo $PMng install -y php
	sudo $PMng install -y libapache2-mod-php
	sudo systemctl restart apache2
	sudo $PMng install -y php-mysql
}

install_apache2_rhel() {
	sudo $PMng install -y httpd
	sudo systemctl start httpd
	sudo systemctl status httpd
}

install_mysql_rhel() {
	sudo $PMng install -y mysql-server
	sudo systemctl start mysqld
	sudo systemctl status mysqld	
}

install_php_rhel() {
	sudo $PMng install -y php
	sudo $PMng install -y php-mysql
}

install_LAMP_debian() {
	sudo $PMng update
	install_apache2_debian
	install_mysql_debian
	install_php_debian
	sudo systemctl list-unit-files apache2.service mysql.service phpsessionclean.service
}

install_LAMP_rhel() {
	sudo $PMng update
	install_apache2_rhel
	install_mysql_rhel
	install_php_rhel
	sudo systemctl list-unit-files httpd.service mysqld.service phpsessionclean.service
}

# Script starts here

if [[ $(id -u) -ne 0 ]]; then
	echo "Use 'sudo' to run this script"
	exit 1
fi

echo "Installing LAMP stack..."

detect_os

echo "$OS OS detected"

case "$OS" in
	"Debian")
		install_LAMP_debian
	;;
	"Rhel")
		install_LAMP_rhel
	;;
	*)
		echo "Error: Unsupported OS detected. Exiting..."
		exit 1
	;;
esac

echo "Installation completed."
