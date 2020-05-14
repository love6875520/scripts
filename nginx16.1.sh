#!bin/bash
#V1.0
NGINX="nginx"
UL="/usr/local"
NGINXDIR="/usr/local/nginx"
echo "开始下载源码并解压"
sleep 1
rpm -qa | grep wget -w
if [ $? -ne 0 ]; then
    yum install wget -y
fi
wget https://nginx.org/download/nginx-1.16.1.tar.gz
tar -zxf nginx-1.16.1.tar.gz
if [ -e "./nginx-1.16.1" ]; then
    echo "文件下载并解压完成"
fi
sleep 1
mv nginx-1.16.1 $NGINX
mv $NGINX $UL
mkdir $NGINXDIR/logs
cd $NGINXDIR
echo "环境依赖配置与检测中"
sleep 1
rpm -qa | grep gcc-c++ -w
                
if [ $? -ne 0 ]; then
    yum install gcc-c++ -y
fi

rpm -qa | grep pcre -w
                
if [ $? -ne 0 ]; then
    yum install pcre pcre-devel -y
fi

rpm -qa | grep zlib -w
                
if [ $? -ne 0 ]; then
    yum install zlib zlib-devel -y
fi

rpm -qa | grep openssl  -w
                
if [ $? -ne 0 ]; then
    yum install openssl openssl-devel -y
fi

echo "配置与检测完成，开始编译安装"
sleep 1

./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-debug
make
make install