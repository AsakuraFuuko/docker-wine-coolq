FROM coolq/wine-coolq

COPY nginx.conf /etc/nginx/nginx.conf
COPY vncmain.sh /app/vncmain.sh
COPY cq /usr/local/bin/cq
COPY cont-init.d /etc/cont-init.d/

ENV CHISEL_VERSION 1.2.2
ENV CHISEL_ARCH amd64

# install the chisel http tunnel
WORKDIR /tmp
ENV PATH_NAME chisel_linux_${CHISEL_ARCH}
RUN wget   -O chisel.gz https://github.com/jpillora/chisel/releases/download/${CHISEL_VERSION}/${PATH_NAME}.gz
RUN gzip -d chisel.gz
RUN ls -all
RUN mv chisel /usr/local/bin/chisel
RUN chmod +x /usr/local/bin/chisel

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# clean up
#RUN rm -rf ${PATH_NAME} /var/lib/apt/lists/*

RUN mkdir -p /usr/share/wine/gecko \
    && curl -SL http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi -o /usr/share/wine/gecko/wine_gecko-2.47-x86.msi \
    && curl -SL http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi -o /usr/share/wine/gecko/wine_gecko-2.47-x86_64.msi \
    && chmod +x /usr/share/wine/gecko/*.msi

EXPOSE 8080
VOLUME ["/home/user/coolq"]
