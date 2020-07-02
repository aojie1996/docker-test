#!/usr/bin/env bash

echo ">>>获取远程分支最新代码"
git pull origin master

# 刷新环境变量
echo ">>>环境配置刷新"
source /etc/profile

#操作/项目路径(Dockerfile存放的路径)
BASE_PATH=/data/javaResource/docker-test/src/main/docker
# 源jar路径  即jenkins构建后存放的路径（）
SOURCE_PATH=/data/javaResource/docker-test/target
#docker 镜像/容器名字或者jar名字 这里都命名为这个
SERVER_NAME=docker-test
#容器id
CID=$(docker ps | grep "$SERVER_NAME" | awk '{print $1}')
#镜像id
IID=$(docker images | grep "$SERVER_NAME" | awk '{print $3}')

echo ">>>maven 打包"
mvn clean package -U

echo ">>>删除老jar，复制新的jar"
rm $BASE_PATH/$SERVER_NAME.jar -f

echo "最新构建代码 $SOURCE_PATH/$SERVER_NAME.jar 迁移至 $BASE_PATH ...."
#把项目从jenkins构建后的目录移动到我们的项目目录下同时重命名下
 mv $SOURCE_PATH/docker-test-0.0.1-SNAPSHOT.jar $BASE_PATH/$SERVER_NAME.jar
#修改文件的权限
 chmod 777 $BASE_PATH/$SERVER_NAME.jar
 echo "迁移完成"


# 构建docker镜像
if [ -n "$IID" ]; then
        echo "存在$SERVER_NAME镜像，IID=$IID"
else
        echo "不存在$SERVER_NAME镜像，开始构建镜像"
                cd $BASE_PATH
        docker build -t $SERVER_NAME .
fi

# 停止和删除原来的容器
if [ -n "$CID" ]; then
		echo "存在$SERVER_NAME项目容器，CID=$CID,重启$SERVER_NAME容器 ..."
			sudo docker stop $CID
			sudo docker rm $CID
			# --name zjhy-mes                      容器的名字为zjhy-mes
      #   -d                                 容器后台运行
      #   -p 8080:8085                       是做端口映射，此时将服务器中的8080端口映射到容器中的8085(项目中端口配置的是8085)端口
      #   -v /usr/ms_backend/:/usr/ms_backend/   将主机的/data/javaResource/zjhy-mes/src/main/docker目录挂载到容器的/data/javaResource/zjhy-mes/src/main/docker 目录中（不可少每次本地更新jar包重启容器即可，不用重新构建镜像
			sudo docker run --name $SERVER_NAME -v $BASE_PATH:$BASE_PATH -d -p 8080:8085 $SERVER_NAME
		echo "$SERVER_NAME容器重启完成"
	else
		echo "不存在$SERVER_NAME容器，docker run创建容器..."
		  # --name zjhy-mes                      容器的名字为zjhy-mes
      #   -d                                 容器后台运行
      #   -p 8080:8085                       是做端口映射，此时将服务器中的8080端口映射到容器中的8085(项目中端口配置的是8085)端口
      #   -v /usr/ms_backend/:/usr/ms_backend/   将主机的/data/javaResource/zjhy-mes/src/main/docker目录挂载到容器的/data/javaResource/zjhy-mes/src/main/docker 目录中（不可少每次本地更新jar包重启容器即可，不用重新构建镜像
			sudo docker run --name $SERVER_NAME -v $BASE_PATH:$BASE_PATH -d -p 8080:8085 $SERVER_NAME
		echo "$SERVER_NAME容器创建完成"
	fi