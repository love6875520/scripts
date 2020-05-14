#!/bin/bash
#Ver2.0
#需要在定时器中新增定时任务，crontab -e编辑定时任务，新增：0 2 * * * /java/clearTmpFile.sh，需修改为清理脚本绝对路径，每天两点执行任务。

#清理多久以前的文件，单位是天，至少大于1，自行修改
day=7
#需要清理的文件目录，目录写绝对路径，执行脚本的用户要有读写权限，自行修改
FilePath=/data/uploadDirgroup2/M00
#清理脚本输出的日志文件保存的目录，执行脚本的用户要有读写权限，自行修改
clearLogPath=/home/ebs/clearuploadFile.log

#自定义输出
function mecho(){
	info=">>>>>"`date "+%Y-%m-%d %H:%M:%S"`" ${1}"
	echo -e "${info}" >> ${clearLogPath}
}

mecho "##############################start##############################"
#在指定目录下查找指定天数没有更新的文件
deleteFiles=`find ${FilePath}/ -mtime +${day} -type f`

#判断找到的文件是否为空
if [ -z "${deleteFiles}" ]; then
	mecho "没有需要清理的临时文件"
else	
	mecho "找到以下临时文件需要被清理:\n${deleteFiles}"
	#建议先将此行注释手动执行下脚本，看找到的文件是否正确
	find ${FilePath}/ -mtime +${day} -type f -exec rm -rf {} \;
	#判断命令是否执行成功
	if [ $? -eq 0 ]; then
		mecho "临时文件删除成功"
	else
		mecho "临时文件删除失败"
	fi
fi

mecho "############################## end ##############################"
