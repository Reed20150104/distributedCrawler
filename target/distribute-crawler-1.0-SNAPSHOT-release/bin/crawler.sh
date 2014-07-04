#!/bin/bash

# CRAWLER_HOME=
# CLASS_PATH=
# JVM_ARG=
LAUNCHER_CLASS=guang.crawler.launcher.CrawlerLauncherMain

# caculate CRAWLER_HOME directory
enterCrawlerHome(){
	if [ "x$CRAWLER_HOME" = "x" ];then
		CRAWLER_HOME=$(which $0)
		match=$(echo $CRAWLER_HOME|grep "^/.*")
		if [ "x$match" = "x" ];then
			CRAWLER_HOME=$PWD/$CRAWLER_HOME
		fi
		unset match
		CRAWLER_HOME=$(dirname $CRAWLER_HOME)
		cd $CRAWLER_HOME
		cd ..
		CRAWLER_HOME=$PWD
	else
		cd $CRAWLER_HOME
	fi
}
# caculate class path
getClassPath(){
	for jar in $(ls lib/*.jar);do
		if [ "x$CLASS_PATH" = "x" ];then
			CLASS_PATH=$jar
		else
			CLASS_PATH=$CLASS_PATH:$jar
		fi
	done
}
if [ "x$LAUNCHER_CLASS" = "x" ];then
	echo "Main class of launcher should be set!"
	echo "exit ..."
	exit 1;
fi

if [ "x$CRAWLER_HOME" = "x" ];then
	enterCrawlerHome
fi
getClassPath
export CRAWLER_HOME
java ${CLASS_PATH:+-cp $CLASS_PATH} ${JVM_ARG} ${LAUNCHER_CLASS} 1>$CRAWLER_HOME/log/log.txt 2>&1 &
