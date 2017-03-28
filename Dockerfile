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
WORKDIR /tmp
ENV PATH_NAME chisel_${VERSION}_linux_${ARCH}
RUN wget   -O chisel.tgz https://github.com/jpillora/chisel/releases/download/${VERSION}/${PATH_NAME}.tar.gz
RUN tar -xzvf chisel.tgz ${PATH_NAME}/chisel
RUN mv ${PATH_NAME}/chisel /usr/local/bin

# clean up
RUN rm -rf ${PATH_NAME} /var/lib/apt/lists/*

EXPOSE 8080
VOLUME ["/home/user/coolq"]