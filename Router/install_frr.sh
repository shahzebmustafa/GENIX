#!/bin/sh

# cd /local

test -f /usr/local/GENI-BGP/complete.txt &&
sudo systemctl start frr &&
exit 1

# test -f /local/GENI-BGP/complete.txt &&
# python local/GENI-BGP/server.py \& &&
# sudo systemctl start frr &&
# exit 1

# test -f /local/GENI-BGP/arp.txt &&
# exit 2

cd /usr/local

git clone https://github.com/shahzebmustafa/GENI-BGP.git

cd GENI-BGP

sudo apt update -y

sudo apt install -y python-pip

pip install netifaces

export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y \
  git autoconf automake libtool make libreadline-dev texinfo \
  pkg-config libpam0g-dev libjson-c-dev bison flex python3-pytest \
  libc-ares-dev python3-dev libsystemd-dev python-ipaddress python3-sphinx \
  install-info build-essential libsystemd-dev libsnmp-dev perl libcap-dev

sudo apt-get -y install cmake

wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.bz2

tar xvjf pcre-8.43.tar.bz2

sudo apt-get install -y libbz2-1.0 libbz2-dev libbz2-ocaml libbz2-ocaml-dev

cd pcre-8.43

./configure --prefix=/usr                     \
           --docdir=/usr/share/doc/pcre-8.43 \
           --enable-utf                      \
           --enable-unicode-properties       \
           --enable-pcre16                   \
           --enable-pcre32                   \
           --enable-pcregrep-libz            \
           --enable-pcregrep-libbz2          \
           --enable-pcretest-libreadline     \
           --disable-static                 &&
make

make check

make install                     &&
mv -v /usr/lib/libpcre.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so


cd ..

git clone https://github.com/CESNET/libyang.git

cd libyang

mkdir build; cd build

cmake -DENABLE_LYD_PRIV=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr \
     -D CMAKE_BUILD_TYPE:String="Release" ..
make
sudo make install

sudo apt-get install protobuf-c-compiler libprotobuf-c-dev -y

sudo apt-get install libzmq5 libzmq3-dev -y

sudo groupadd -r -g 92 frr
sudo groupadd -r -g 85 frrvty
sudo adduser --system --ingroup frr --home /var/run/frr/ \
  --gecos "FRR suite" --shell /sbin/nologin frr
sudo usermod -a -G frrvty frr

cd ..



git clone https://github.com/frrouting/frr.git frr

cd frr


./bootstrap.sh
./configure \
   --prefix=/usr \
   --includedir=\${prefix}/include \
   --enable-exampledir=\${prefix}/share/doc/frr/examples \
   --bindir=\${prefix}/bin \
   --sbindir=\${prefix}/lib/frr \
   --libdir=\${prefix}/lib/frr \
   --libexecdir=\${prefix}/lib/frr \
   --localstatedir=/var/run/frr \
   --sysconfdir=/etc/frr \
   --with-moduledir=\${prefix}/lib/frr/modules \
   --with-libyang-pluginsdir=\${prefix}/lib/frr/libyang_plugins \
   --enable-configfile-mask=0640 \
   --enable-logfile-mask=0640 \
   --enable-snmp=agentx \
   --enable-multipath=64 \
   --enable-user=frr \
   --enable-group=frr \
   --enable-vty-group=frrvty \
   --with-pkg-git-version \
   --with-pkg-extra-version=-MyOwnFRRVersion
make
sudo make install

sudo install -m 775 -o frr -g frr -d /var/log/frr
sudo install -m 775 -o frr -g frrvty -d /etc/frr
sudo install -m 640 -o frr -g frrvty tools/etc/frr/vtysh.conf /etc/frr/vtysh.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/frr.conf /etc/frr/frr.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/daemons.conf /etc/frr/daemons.conf
sudo install -m 640 -o frr -g frr tools/etc/frr/daemons /etc/frr/daemons

sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/g' /etc/sysctl.conf

sudo sysctl -p

sudo echo "# Load MPLS Kernel Modules" >> /etc/modules-load.d/modules.conf
sudo echo "mpls_router" >> /etc/modules-load.d/modules.conf
sudo echo "mpls_iptunnel" >> /etc/modules-load.d/modules.conf

apt-get install -y linux-modules-extra-`uname -r`
sudo modprobe mpls-router mpls-iptunnel

sudo echo "# Enable MPLS Label processing on all interfaces" >> /etc/sysctl.conf
for iface in $(ifconfig | cut -d ' ' -f1| tr ':' '\n' | awk NF)
do
  echo "net.mpls.conf."$iface".input=1" >> /etc/sysctl.conf
done

sudo echo "net.mpls.platform_labels=100000" >> /etc/sysctl.conf

sudo install -m 644 tools/frr.service /etc/systemd/system/frr.service
sudo systemctl enable frr

sudo sed -i 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons

sudo rm /etc/frr/frr.conf

sudo touch /etc/frr/zebra.conf

sudo touch /etc/frr/bgpd.conf

cd ..

sudo systemctl start frr

sudo touch /usr/local/GENI-BGP/complete.txt
# sudo touch bgpd.conf

# python /local/GENI-BGP/server.py &

# sudo cp /local/GENI-BGP/bgpd.conf /etc/frr



# date "+%H:%M:%S   %d/%m/%y\n" >> /local/GENI-BGP/task.txt
