#!bin/bash
echo "请选择本机安装类型：集群模式master输入1、集群模式slave输入2，单机模式敲回车"
read mode
until [ -z $mode ]
do
        case $mode in
        1)
        echo 1
        ;;
        2)
        echo 2
        ;;
        *)
        echo "输入错误，请重新输入"
        echo "集群模式master输入1、集群模式slave输入2，单机模式敲回车"
        read mode
        esac
done