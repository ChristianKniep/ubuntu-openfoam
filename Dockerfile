FROM qnib/ubuntu_compute:12.04
MAINTAINER "Christian Kniep <christian@qnib.org>"

RUN echo "deb http://www.openfoam.org/download/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/openfoam.list
RUN echo "2014-10-02.1";apt-get update 
### openfoam
RUN apt-get install -y libgl1-mesa-glx libgmp10 libqt4-opengl libqtcore4 libqtgui4
RUN apt-get install -y binutils cpp-4.4 g++-4.4 gcc-4.4 gcc-4.4-base libstdc++6-4.4-dev
RUN apt-get install -y libibverbs-dev libopenmpi-dev openmpi-common  mpi-default-dev
RUN apt-get install -y libc-bin libc-dev-bin libc6 libc6-dev libdrm-dev libdrm-nouveau2 libgl1-mesa-dev libglu1-mesa libglu1-mesa-dev \
                       libgmp-dev libgmpxx4ldbl libicu48 libmpfr-dev libmpfr4 libnuma1 libpthread-stubs0 libpthread-stubs0-dev \
                       libqt4-designer libqt4-dev libqt4-help libqt4-opengl-dev libqt4-qt3support libqt4-scripttools libqt4-svg libqt4-test \
                       libqtwebkit-dev libqtwebkit4 libtorque2 \
                       libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev libxext-dev linux-libc-dev manpages manpages-dev \
                       mesa-common-dev qt4-linguist-tools qt4-qmake \
                       x11proto-core-dev x11proto-input-dev x11proto-kb-dev x11proto-xext-dev xorg-sgml-doctools xtrans-dev zlib1g-dev
RUN apt-get install -y libscotch-5.1 libscotch-dev 
RUN apt-get install -y binutils libboost-date-time1.46-dev libboost-date-time1.46.1 libboost-dev 
RUN apt-get install -y libboost-program-options-dev libboost-program-options1.46.1 libboost-serialization1.46-dev libboost-serialization1.46.1
RUN apt-get install -y libboost-thread-dev libboost-thread1.46-dev libboost1.46-dev

RUN apt-get install -y build-essential
RUN apt-get install -y libptscotch-dev

ADD dpkg /opt/dpkg/
RUN dpkg -i /opt/dpkg/*
RUN apt-get install -y --force-yes openfoam230

RUN sed -i -e 's/   allowSystemOperations.*/   allowSystemOperations   1;/' $(find /opt/openfoam*/etc -name controlDict|head -n1)
# ENV
RUN echo "source $(find /opt/openfoam*/etc -name bashrc|head -n1)" >> /root/.bashrc

CMD supervisord -c /etc/supervisord.conf

