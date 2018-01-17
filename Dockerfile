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


