FROM coolq/wine-coolq

COPY nginx.conf /etc/nginx/nginx.conf
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
#RUN rm -rf ${PATH_NAME} /var/lib/apt/lists/*

EXPOSE 8080
VOLUME ["/home/user/coolq"]
