#/bin/bash
#Nginx配置文件目录
NGINX_PATH="/usr/local/nginx/conf"
#Nginx软件包目录
NGINXDIR="/usr/local"
#Nginx依赖包目录
RPMPATH="/usr/local/nginxrpm"
#Nginx工作目录
NGINX_DIR="/usr/local/nginx"
#系统服务目录
SYSDIR="/usr/lib/systemd/system"

mkdir -p $RPMPATH
mv nginx.tar.gz $NGINXDIR
mv rpm4nginx.tar $NGINXDIR
cd $NGINXDIR
tar -xf $NGINXDIR/rpm4nginx.tar -C $NGINXDIR

echo "---------开始进行依赖配置与检测---------"
        rpm -qa | grep authconfig -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/authconfig-6.2.8-30.el7.x86_64.rpm
        fi
        
        rpm -qa | grep kernel-headers -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/kernel-headers-3.10.0-957.el7.x86_64.rpm
        fi

        rpm -qa | grep glibc-headers -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/glibc-headers-2.17-260.el7.x86_64.rpm
        fi

        rpm -qa | grep glibc-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/glibc-devel-2.17-260.el7.x86_64.rpm
        fi

        rpm -qa | grep keyutils-libs-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/keyutils-libs-devel-1.5.8-3.el7.x86_64.rpm
        fi

        rpm -qa | grep mpfr -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/mpfr-3.1.1-4.el7.x86_64.rpm
        fi

        rpm -qa | grep libmpc -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libmpc-1.0.1-3.el7.x86_64.rpm
        fi

        rpm -qa | grep libstdc++ -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libstdc++-devel-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep libcom_err-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libcom_err-devel-1.42.9-13.el7.x86_64.rpm
        fi

        rpm -qa | grep libkadm5 -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libkadm5-1.15.1-34.el7.x86_64.rpm
        fi

        rpm -qa | grep pcre-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/pcre-devel-8.32-17.el7.x86_64.rpm
        fi

        rpm -qa | grep libsepol-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libsepol-devel-2.5-10.el7.x86_64.rpm
        fi

        rpm -qa | grep libselinux-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/libselinux-devel-2.5-14.1.el7.x86_64.rpm
        fi

        rpm -qa | grep krb5-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/krb5-devel-1.15.1-34.el7.x86_64.rpm
        fi

        rpm -qa | grep openssl-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/openssl-devel-1.0.2k-16.el7.x86_64.rpm
        fi

        rpm -qa | grep openssl-1 -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/openssl-1.0.2k-16.el7.x86_64.rpm
        fi

        rpm -qa | grep zlib-devel -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/zlib-devel-1.2.7-18.el7.x86_64.rpm
        fi

        rpm -qa | grep cpp -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/cpp-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep gcc-4 -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/gcc-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep gcc-c++ -w
                
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force $RPMPATH/gcc-c++-4.8.5-36.el7.x86_64.rpm
        fi
echo "---------依赖配置与检测完成---------"
        
tar -xf $NGINXDIR/nginx.tar.gz -C $NGINXDIR
sleep 3

echo "---------配置并安装nginx---------"
cd $NGINX_DIR
./configure --prefix=/usr/local/nginx --with-http_ssl_module
sleep 5
make 
sleep 5
make install

cp $NGINX_PATH/nginx.conf $NGINX_PATH/nginx.conf.default
mkdir $NGINX_DIR/logs

echo "---------注册系统服务---------"

cp $NGINX_DIR/nginx.service $SYSDIR
chmod 754 /usr/lib/systemd/system/nginx.service
systemctl daemon-reload

echo "---------nginx安装配置完成，使用systemctl start nginx来启动---------"