### System base:

google cloud centos7 minimum installation

copy public auth key to the virtual machine.

```bash
mv id_rsa_2048.pub /tmp/ && sudo -i

mkdir /root/.ssh/ && cat /tmp/id_rsa_2048.pub > /root/.ssh/authorized_keys && sed -i '1i\PermitRootLogin yes' /etc/ssh/sshd_config && service sshd restart
```



### 0.python

##### openssl

https://gist.github.com/Bill-tran/5e2ab062a9028bf693c934146249e68c

https://www.jianshu.com/p/8e476eef43f7

```bash
yum install -y make gcc perl-core pcre-devel wget zlib-devel
```

```shell
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
```

##### python

```bash
yum install -y bzip2-devel sqlite-devel readline-devel tk-devel libffi-devel xz-devel
```

```bash
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
tar vzxf Python-3.11.0.tgz
cd Python-3.11.0
./configure --with-openssl=/usr/local/openssl
make && make install

pip3 install openpyxl pymongo pyzipper bson
```

### 1.java

```bash
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
```

### 2.mongo

```bash
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
```



### 3.nginx

https://wintc.top/article/29

```bash
yum install epel-release

yum install nginx


service nginx start
sed -i 's/sendfile/client_max_body_size 100m;\n    client_body_buffer_size 2048k;\n    sendfile/' /etc/nginx/nginx.conf

sed -i 's/\/usr\/share\/nginx\/html;/\/usr\/share\/nginx\/pfas-web;/' /etc/nginx/nginx.conf

nginx -t
nginx -s reload
```



### 4.pfas-server

```bash
unzip pfas.zip
cd pfas
nohup java -jar pfas*.jar &>/dev/null &
```



### 5.pfas-web

```shell
unzip dist.zip
mv dist /usr/share/nginx/pfas-web
```

