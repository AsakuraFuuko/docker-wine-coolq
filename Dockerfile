FROM oott123/novnc:latest

RUN apt-get update && \
    apt-get install -y \
        software-properties-common \
        python-software-properties \
        python3-software-properties \
        cabextract unzip language-pack-zh-hans && \
    locale-gen zh_CN.UTF-8 && \
    add-apt-repository -y ppa:wine/wine-builds && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-devel && \
    wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod 755 /usr/local/bin/winetricks && \
    apt-get clean

RUN sudo -Hu user /usr/local/bin/winetricks winhttp && \
    sudo -Hu user /usr/local/bin/winetricks msscript && \
    sudo -Hu user /usr/local/bin/winetricks cjkfonts && \
    mkdir /home/user/coolq

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    COOLQ_URL=http://dlsec.cqp.me/cqa-tuling

COPY vncmain.sh /app/vncmain.sh
COPY cq /usr/local/bin/cq
COPY cont-init.d /etc/cont-init.d/

# install the chisel http tunnel
#WORKDIR /tmp
RUN apt-get install gzip
ENV PATH_NAME /tmp
RUN mkdir ${PATH_NAME}
RUN wget -O /tmp/chisel.gz https://github.com/jpillora/chisel/releases/download/1.1.4/chisel_linux_amd64.gz
RUN gzip -d /tmp/chisel.gz
RUN mv ${PATH_NAME}/chisel_linux_amd64 /usr/local/bin/chisel

# clean up
#RUN rm -rf ${PATH_NAME} /var/lib/apt/lists/*

EXPOSE 8080
VOLUME ["/home/user/coolq"]
