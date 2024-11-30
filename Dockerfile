FROM node:18-alpine

WORKDIR /apps/

COPY ./config/keys/id_ed25519 /root/.ssh/id_ed25519
COPY ./config/keys/id_ed25519.pub /root/.ssh/id_ed25519.pub
COPY ./config/zshrc /root/.zshrc

RUN apk update &&\
    apk -U upgrade &&\
    apk add curl fzf git openjdk21 openssh-client python3 shadow sudo zsh &&\
    apk cache clean &&\
    npm install -g npm@latest

RUN curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > /tmp/install.sh &&\
    chmod +x /tmp/install.sh &&\
    /tmp/install.sh --unattended --keep-zshrc &&\
    chsh -s $(which zsh)

RUN npm install -g firebase-tools &&\
    curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz &&\
    mkdir -p /usr/local/gcloud &&\
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
    /usr/local/gcloud/google-cloud-sdk/install.sh

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin