#!bin/bash
echo "��ѡ�񱾻���װ���ͣ���Ⱥģʽmaster����1����Ⱥģʽslave����2������ģʽ�ûس�"
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
        echo "�����������������"
        echo "��Ⱥģʽmaster����1����Ⱥģʽslave����2������ģʽ�ûس�"
        read mode
        esac
done