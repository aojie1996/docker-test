FROM registry.cn-hangzhou.aliyuncs.com/choerodon-tools/javabase:0.8.0
COPY docker-test-0.0.1-SNAPSHOT.jar /springBoot-docker.jar
ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8 -Duser.language=zh -Duser.region=zh_CN -Duser.country=zh_CN
ENTRYPOINT exec java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap $JAVA_OPTS $SKYWALKING_OPTS  -jar /springBoot-docker.jar