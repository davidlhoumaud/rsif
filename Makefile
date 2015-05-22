all : install
install :
	sudo cp rsif.sh /usr/bin/rsif
	sudo chmod 755 /usr/bin/rsif
uninstall :
	sudo rm -f /usr/bin/rsif
