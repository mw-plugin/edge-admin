#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/opt/homebrew/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")

install_tmp=${rootPath}/tmp/mw_install.pl
VERSION=$2

Install_App()
{
	echo '正在安装脚本文件...' > $install_tmp
	mkdir -p $serverPath/source
	mkdir -p $serverPath/source/goedge

	FILE_TGZ=edge-admin-linux-amd64-plus-v${VERSION}.zip
	GOEDGE_DIR=$serverPath/source/goedge/

	if [ ! -f $GOEDGE_DIR/${FILE_TGZ} ];then
		wget -O $GOEDGE_DIR/${FILE_TGZ} https://dl.goedge.cloud/edge/v${VERSION}/${FILE_TGZ}
	fi
	
	cd $GOEDGE_DIR && unzip ${FILE_TGZ}

	if [ -d $GOEDGE_DIR/${FILE_TGZ} ];then
		rm -rf $GOEDGE_DIR/${FILE_TGZ}
	fi
}

Uninstall_App()
{
	if [ -f /usr/lib/systemd/system/redis.service ];then
		systemctl stop redis
		systemctl disable redis
		rm -rf /usr/lib/systemd/system/redis.service
		systemctl daemon-reload
	fi

	if [ -f /lib/systemd/system/redis.service ];then
		systemctl stop redis
		systemctl disable redis
		rm -rf /lib/systemd/system/redis.service
		systemctl daemon-reload
	fi

	if [ -f $serverPath/redis/initd/redis ];then
		$serverPath/redis/initd/redis stop
	fi

	if [ -d $serverPath/redis ];then
		rm -rf $serverPath/redis
	fi
	
	echo "卸载redis成功"
}

action=$1
if [ "${1}" == 'install' ];then
	Install_App
else
	Uninstall_App
fi
