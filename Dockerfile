FROM ubuntu:22.04

COPY ./docker/apt-key.gpg /gcloud-akey.gpg

RUN apt update && apt-get install -y gnupg curl wget apt-transport-https && \
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] http://mirrors.tuna.tsinghua.edu.cn/Adoptium/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    apt update && apt install -y ant temurin-8-jdk git && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    cat /gcloud-akey.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && apt-get install google-cloud-cli google-cloud-cli-app-engine-java -y && \
    mkdir /app

COPY . /app

WORKDIR /app

RUN cd appinventor && ant MakeAuthKey && ant

EXPOSE 8888

ENTRYPOINT [ "/bin/bash", "./docker-entrypoint.sh" ]
