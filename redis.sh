#!/bin/bash
#Redis配置文件目录
REDIS_PATH="/usr/local/redis/etc"
#Redis软件包目录
REDIS="/usr/local"
#Redis依赖包目录
RPMPATH="/usr/local/redisrpm"
#Redis工作目录
REDIS_DIR="/usr/local/redis"

useradd -r redis
mkdir -p $RPMPATH
mv redis.tar.gz $REDIS
mv rpm4redis.tar $REDIS
tar -xf $REDIS/rpm4redis.tar -C $REDIS
sleep 1

echo "---------开始进行依赖配置与检测---------"
        rpm -qa | grep kernel-headers -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/kernel-headers-3.10.0-957.el7.x86_64.rpm
        fi

        rpm -qa | grep glibc-headers -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/glibc-headers-2.17-260.el7.x86_64.rpm
        fi

        rpm -qa | grep glibc-devel -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/glibc-devel-2.17-260.el7.x86_64.rpm
        fi

        rpm -qa | grep mpfr -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/mpfr-3.1.1-4.el7.x86_64.rpm
        fi

        rpm -qa | grep libmpc -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/libmpc-1.0.1-3.el7.x86_64.rpm
        fi

        rpm -qa | grep libstdc++ -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/libstdc++-devel-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep cpp -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/cpp-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep gcc-4 -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/gcc-4.8.5-36.el7.x86_64.rpm
        fi

        rpm -qa | grep gcc-c++ -w
        if [ $? -ne 0 ]; then
                rpm -ivh --nodeps --force  $RPMPATH/gcc-c++-4.8.5-36.el7.x86_64.rpm
        fi
sleep 3
echo "---------依赖配置与检测完成---------"
sleep 1
echo "---------开始安装Redis---------"
tar -xf $REDIS/redis.tar.gz -C $REDIS
cd $REDIS_DIR
make install PREFIX=$REDIS_DIR
sleep 3
mkdir -p $REDIS_PATH/etc
mkdir $REDIS_DIR/log

echo "请选择本机安装类型：集群模式master输入1、集群模式slave输入2，单机模式请输入3"
read mode

until [ $mode = 0 ]
do
    echo "输入错误，请重新输入"
    read mode
done

until [ $mode -lt 4 ]
do
  if [ $mode -gt 3 ];then
    echo "输入错误，请重新输入"
    read mode
  fi
done

if [ $mode -eq 1 ];then
    cp redis-master.conf $REDIS_PATH/redis.conf
    cp sentinel.conf $REDIS_PATH
elif [ $mode -eq 2 ];then
    cp redis-slave.conf $REDIS_PATH/redis.conf
    cp sentinel.conf $REDIS_PATH
elif [ $mode -eq 3 ];then
    cp redis-single.conf $REDIS_PATH/redis.conf
fi


if [ -e "$REDIS_PATH/redis.conf" ]; then
        echo "---------Redis安装完毕---------"
fi