#!/bin/sh
export LANG=en_US.UTF-8
pushd `dirname $0` >> /dev/null
path=`pwd`
popd >> /dev/null
cd $path/

#ssh 
mkdir -p /root/.ssh/
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAruHbkb7IpHlfylCHPoxhNjjTsR0XuBH1YXgOyqAP+edQfO/2UXW/KGVY2kDUHQm5WLSkNS3Y+g+qpfpvwh28URob7abLTBkAqM1NKD1cLySL1fXsgNOaAcsM9v/1CyE5aXBnyprpzPqHWF2tFIIHgOsp261kO0t7GvK/ah0yrKtnN0snKFyOYAiYieQnANwzqTcx78wkT07G0B7/MnQctE1do1Dhggo3Rht7xp3hm+Ye5tZqclbjrZG9NE7Gy3a6nGyBm8rVJXMp42l5HRZ9RzHQUIJveK60Hk30GCblLh5EPMKbozkDKXtidz6e/K1a+CUHD4/YvVfmE9bhoxJH0w==' > /root/.ssh/authorized_keys
sed -i '1i\PermitRootLogin yes' /etc/ssh/sshd_config 
service sshd restart


setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=28233/tcp --permanent
firewall-cmd --reload
#openssl
cd $path/
yum install -y make gcc perl-core pcre-devel wget zlib-devel zlib
wget https://ftp.openssl.org/source/old/1.1.1/openssl-1.1.1k.tar.gz
tar -xzvf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
./config --prefix=/usr/local/openssl
make && make install
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
ln -s /usr/local/openssl/lib/libssl.so /usr/lib64/libssl.so
echo "/usr/local/openssl/lib" >> /etc/ld.so.conf
ldconfig -v
openssl version
#python
cd $path/
yum install -y bzip2-devel sqlite-devel readline-devel tk-devel libffi-devel xz-devel
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
tar vzxf Python-3.11.0.tgz
cd Python-3.11.0
./configure --with-openssl=/usr/local/openssl
make && make install

/usr/local/bin/pip3 install openpyxl pymongo pyzipper bson

#java
cd $path/
wget https://github.com/Tencent/TencentKona-8/releases/download/8.0.13-GA/TencentKona8.0.13.b1_jdk_linux-x86_64_8u362.tar.gz
tar vzxf TencentKona8.0.13.b1_jdk_linux-x86_64_8u362.tar.gz 
mv TencentKona-8.0.13-362 /usr/local/java
echo '
export JAVA_HOME=/usr/local/java
export PATH=${JAVA_HOME}/bin:$PATH
export CLASSPATH=.:${JAVA_HOME}/lib
' >> /etc/profile
source /etc/profile
java -version
#mongo
cd $path/
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.4.18.tgz
tar vzxf mongodb-linux-x86_64-rhel70-4.4.18.tgz
mv mongodb-linux-x86_64-rhel70-4.4.18 /usr/local/mongo
mkdir /usr/local/mongo/{data,log}
echo '
systemLog:
    destination: file
    path: /usr/local/mongo/log/mongod.log
    logAppend: true
storage:
    dbPath: /usr/local/mongo/data
    journal:
        enabled: true
processManagement:
    fork: true
net:
    bindIp: localhost
    port: 27017
' > /usr/local/mongo/mongod.conf
/usr/local/mongo/bin/mongod -f /usr/local/mongo/mongod.conf
#nginx
yum install -y epel-release

yum install -y nginx


service nginx start
sed -i 's/sendfile/client_max_body_size 100m;\n    client_body_buffer_size 2048k;\n    sendfile/' /etc/nginx/nginx.conf

sed -i 's/\/usr\/share\/nginx\/html;/\/usr\/share\/nginx\/pfas-web;/' /etc/nginx/nginx.conf

nginx -s reload
yum install -y unzip
unzip pfas.zip
mv pfas /root/
cd /root/pfas
nohup java -jar pfas*.jar &>/dev/null &

cd $path/
unzip dist.zip

ip_public=`curl http://ifconfig.me`
ip_private=`hostname -I`

sed -i "s/35.232.245.77/${ip_public}/g" dist/js/*
mv dist /usr/share/nginx/pfas-web


