FROM qnib/ubuntu12_compute
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN echo "deb http://www.openfoam.org/download/ubuntu precise main" > /etc/apt/sources.list.d/openfoam.list
RUN echo "2014-10-02.1";apt-get update 
## cluser
RUN mkdir -p /chome
RUN getent passwd cluser && userdel -f cluser
RUN useradd -u 2000 -m -d /chome/cluser -s /bin/bash cluser
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
RUN apt-get install -y binutils cpp-4.4 g++-4.4 gcc-4.4 gcc-4.4-base libboost-date-time1.46-dev libboost-date-time1.46.1 libboost-dev libboost-program-options-dev libboost-program-options1.46-dev libboost-program-options1.46.1 libboost-serialization1.46-dev libboost-serialization1.46.1 libboost-thread-dev libboost-thread1.46-dev libboost1.46-dev libc-bin libc-dev-bin libc6 libc6-dev libdrm-dev libdrm-nouveau2 libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev libgmp-dev libgmpxx4ldbl libibverbs-dev libibverbs1 libmpfr-dev libmpfr4 libnuma1 libopenmpi-dev libopenmpi1.3 libpthread-stubs0 libpthread-stubs0-dev libqt4-designer libqt4-dev libqt4-help libqt4-opengl-dev libqt4-qt3support libqt4-scripttools libqt4-svg libqt4-test libqtwebkit-dev libqtwebkit4 libscotch-5.1 libscotch-dev libstdc++6-4.4-dev libtorque2 libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev libxext-dev linux-libc-dev manpages manpages-dev mesa-common-dev mpi-default-dev openmpi-common qt4-linguist-tools qt4-qmake x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev zlib1g-dev libicu48
RUN dpkg -i /dpkg/*
RUN apt-get install -y --force-yes openfoam230
RUN apt-get install -y --force-yes paraviewopenfoam410 
RUN echo "root:root" | chpasswd
USER root
ENV HOME /root
RUN echo "source /opt/openfoam230/etc/bashrc" >> /etc/bashrc
ADD ssh /tmp/ssh/
RUN if [ -f /tmp/ssh/*.pub ];then mkdir -p /root/.ssh; cat /tmp/ssh/*.pub >> /root/.ssh/authorized_keys;chmod 600 /root/.ssh/authorized_keys;chmod 700 /root/.ssh;fi

## create a compute node (slurm)
RUN apt-get install -y slurm-llnl

RUN apt-get install -y curl

ADD root/populate_hosts.sh /root/
ADD root/start_node.sh /root/start_node.sh
RUN echo "UseDNS no" >> /etc/ssh/sshd_config

CMD /root/start_node.sh

