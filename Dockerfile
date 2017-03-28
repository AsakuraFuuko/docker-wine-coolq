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
    apt-get install -y --install-recommends winehq-devel xvfb && \
    wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod 755 /usr/local/bin/winetricks && \
    apt-get clean

RUN env WINEPREFIX=~/.wine32 WINEARCH=win32 winecfg

RUN env WINEPREFIX=~/.wine32 sudo -Hu user /usr/local/bin/winetricks winhttp && \
    env WINEPREFIX=~/.wine32 sudo -Hu user /usr/local/bin/winetricks msscript && \
    env WINEPREFIX=~/.wine32 sudo -Hu user /usr/local/bin/winetricks cjkfonts && \
    mkdir /home/user/coolq

RUN env WINEPREFIX=~/.wine32 sudo -Hu user xvfb-run /usr/local/bin/winetricks -q vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    COOLQ_URL=http://dlsec.cqp.me/cqa-tuling

COPY vncmain.sh /app/vncmain.sh
COPY cq /usr/local/bin/cq
COPY cont-init.d /etc/cont-init.d/

ENV CHISEL_VERSION 1.1.3
ENV CHISEL_ARCH amd64

# install the chisel http tunnel
WORKDIR /tmp
ENV PATH_NAME chisel_${CHISEL_VERSION}_linux_${CHISEL_ARCH}
RUN wget   -O chisel.tgz https://github.com/jpillora/chisel/releases/download/${CHISEL_VERSION}/${PATH_NAME}.tar.gz
RUN tar -xzvf chisel.tgz ${PATH_NAME}/chisel
RUN mv ${PATH_NAME}/chisel /usr/local/bin

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# clean up
RUN rm -rf ${PATH_NAME} /var/lib/apt/lists/*

EXPOSE 8080
VOLUME ["/home/user/coolq"]
