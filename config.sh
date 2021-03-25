#! /bin/bash

sudo apt update -y && apt upgrade -y
sudo apt install nmap -y
sudo apt install net-tools -y
sudo apt install dnsutils -y
sudo apt install vim -y

## CONFIGURAÇÃO TIMEZONE E LOCALE
sudo rm -f /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
sudo sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen
sudo echo 'LANG="pt_BR.UTF-8"'> /etc/default/locale
sudo dpkg-reconfigure --frontend=noninteractive locales
sudo update-locale LANG=pt_BR.UTF-8

## INSTALANDO E CONFIGURANDO DHCP
sudo apt install isc-dhcp-server -y
sudo cp /tmp/ativafw.sh ~/ativafw.sh
sudo cp /tmp/dhcpd.conf /etc/dhcp/
sudo cp /tmp/isc-dhcp-server /etc/default/
sudo systemctl enable isc-dhcp-server
sudo systemctl restart isc-dhcp-server

## CONFIGURANDO FORWARD E ROTA DEFAULT
sudo sed -i -e 's/#net.ipv4.ip/net.ipv4.ip/g' /etc/sysctl.conf
sudo sysctl -p
sudo ip route del default
sudo ip route add default via 192.168.100.1 dev eth1

## INSTALANDO E CONFIGURANDO OPENVPN
sudo apt install openvpn -y
sudo cp /tmp/server.conf /etc/openvpn/
sudo cp /tmp/static.key /etc/openvpn/
sudo groupadd openvpn; useradd -g openvpn openvpn
systemctl enable openvpn
systemctl restart openvpn

## CONFIGURANDO DATA E HORA NO HISTORY
sudo echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> /root/.bashrc

## CONFIGURANDO O SSH
sudo sed 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' sshd_config
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' sshd_config
sudo echo "root:25030" | chpasswd
systemctl restart sshd.service

## CONFIGURANDO IPTABLES
sudo dpkg -i /tmp/firewall_1.0_amd64.deb
systemctl enable firewall.service
systemctl restart firewall.service