#!bin/bash
#Ver1.1
#Date 2020/05/14
NGINX="nginx"
UL="/usr/local"
NGINXDIR="/usr/local/nginx"
NGINXCONF="/usr/local/nginx/conf"
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
sleep 1
echo "编译完成，开始注册系统服务"
touch /usr/lib/systemd/system/nginx.service
echo "[Unit]" >> /usr/lib/systemd/system/nginx.service
echo "Description=The NGINX HTTP and reverse proxy server" >> /usr/lib/systemd/system/nginx.service
echo "After=syslog.target network.target remote-fs.target nss-lookup.target" >> /usr/lib/systemd/system/nginx.service
echo "[Service]" >> /usr/lib/systemd/system/nginx.service
echo "Type=forking" >> /usr/lib/systemd/system/nginx.service
echo "PIDFile=/usr/local/nginx/logs/nginx.pid" >> /usr/lib/systemd/system/nginx.service
echo "ExecStartPre=/usr/local/nginx/sbin/nginx -t" >> /usr/lib/systemd/system/nginx.service
echo "ExecStart=/usr/local/nginx/sbin/nginx" >> /usr/lib/systemd/system/nginx.service
echo "ExecReload=/usr/local/nginx/sbin/nginx -s reload" >> /usr/lib/systemd/system/nginx.service
echo "ExecStop=/bin/kill -s QUIT $MAINPID" >> /usr/lib/systemd/system/nginx.service
echo "PrivateTmp=true" >> /usr/lib/systemd/system/nginx.service
echo "[Install]" >> /usr/lib/systemd/system/nginx.service
echo "WantedBy=multi-user.target" >> /usr/lib/systemd/system/nginx.service
cp $NGINXCONF/nginx.conf $NGINXCONF/nginx.conf.bak
sleep 1
chmod 754 /usr/lib/systemd/system/nginx.service
systemctl daemon-reload
systemctl enable nginx
echo "NGINX安装配置完成，使用systemctl start nginx来启动。
工作目录/usr/local/nginx
配置文件/usr/local/nginx/conf
日志文件/usr/local/nginx/logs"
