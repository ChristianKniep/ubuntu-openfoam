FROM ubuntu:12.04
MAINTAINER "Christian Kniep <christian@qnib.org>"

ENV http_proxy http://129.184.89.14:80


RUN echo "deb http://www.openfoam.org/download/ubuntu precise main" > /etc/apt/sources.list.d/openfoam.list
RUN apt-get update 
## cluser
RUN mkdir -p /chome
RUN useradd -u 2000 -M -d /chome/cluser cluser
RUN echo "cluser:cluser"|chpasswd
## basic install
RUN apt-get install -y vim gnuplot
## SSHD
RUN apt-get install -y openssh-server xauth
RUN sed -i -e 's/#X11UseLocalhost.*/X11UseLocalhost no/' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
### openfoam
RUN apt-get install -y libgl1-mesa-glx libgmp10 libqt4-opengl libqtcore4 libqtgui4 libboost-thread1.46.1
ADD ./dpkg /dpkg/
RUN apt-get install -y binutils cpp-4.4 g++-4.4 gcc-4.4 gcc-4.4-base libboost-date-time1.46-dev libboost-date-time1.46.1 libboost-dev libboost-program-options-dev libboost-program-options1.46-dev libboost-program-options1.46.1 libboost-serialization1.46-dev libboost-serialization1.46.1 libboost-thread-dev libboost-thread1.46-dev libboost1.46-dev libc-bin libc-dev-bin libc6 libc6-dev libdrm-dev libdrm-nouveau2 libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev libgmp-dev libgmpxx4ldbl libibverbs-dev libibverbs1 libmpfr-dev libmpfr4 libnuma1 libopenmpi-dev libopenmpi1.3 libpthread-stubs0 libpthread-stubs0-dev libqt4-designer libqt4-dev libqt4-help libqt4-opengl-dev libqt4-qt3support libqt4-scripttools libqt4-svg libqt4-test libqtwebkit-dev libqtwebkit4 libscotch-5.1 libscotch-dev libstdc++6-4.4-dev libtorque2 libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev libxext-dev linux-libc-dev manpages manpages-dev mesa-common-dev mpi-default-dev openmpi-common qt4-linguist-tools qt4-qmake x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev zlib1g-dev
RUN dpkg -i /dpkg/*
RUN apt-get install -y --force-yes openfoam230
RUN apt-get install -y --force-yes paraviewopenfoam410 
RUN echo "source /opt/openfoam230/etc/bashrc" >> /etc/bashrc


