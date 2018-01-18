FROM nicoinn/rpi-raspbian-qemu:alpine-debug1 as BUILDENV


FROM arm32v6/alpine

COPY --from=BUILDENV /qemu/arm-linux-user/qemu-arm /usr/bin/qemu-arm-static
COPY --from=BUILDENV /resin-xbuild/resin-xbuild /usr/bin/
COPY LICENSE /

ENV QEMU_EXECVE 1

COPY . /usr/bin

RUN qemu-arm-static /bin/sh -c "ln -s resin-xbuild /usr/bin/cross-build-start; ln -s resin-xbuild /usr/bin/cross-build-end; ln /bin/sh /bin/sh.real"

#RUN [ "qemu-arm-static", "/bin/sh", "-c", "ln -s resin-xbuild /usr/bin/cross-build-start; ln -s resin-xbuild /usr/bin/cross-build-end; ln /bin/sh /bin/sh.real" ]
