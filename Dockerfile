FROM library/debian:stable as BUILDENV

RUN apt-get update && apt-get install -y \
	git \ 
	python \
	build-essential \
	pkg-config \ 
	libghc-zlib-dev \
	libglib2.0-dev zlib1g-dev \ 
	libpixman-1-dev \
	golang \ 
	&& apt-get autoclean && apt-get autoremove

RUN git clone git://git.qemu.org/qemu.git  

RUN cd qemu && ./configure --target-list=arm-linux-user --static && make  

COPY resin-xbuild.go /resin-xbuild/

RUN cd /resin-xbuild/ && go build -ldflags "-w -s" resin-xbuild.go 



FROM resin/rpi-raspbian:latest

COPY --from=BUILDENV /qemu/arm-linux-user/qemu-arm /usr/bin/qemu-arm-static
COPY --from=BUILDENV /resin-xbuild/resin-xbuild /usr/bin/
COPY LICENSE /

ENV QEMU_EXECVE 1

COPY . /usr/bin

RUN [ "qemu-arm-static", "/bin/sh", "-c", "ln -s resin-xbuild /usr/bin/cross-build-start; ln -s resin-xbuild /usr/bin/cross-build-end; ln /bin/sh /bin/sh.real" ]
