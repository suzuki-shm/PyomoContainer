From ubuntu:18.04

MAINTAINER Shinya Suzuki <sshinya@bio.titech.ac.jp>
LABEL DESCRIPTION "Container for optimization with Pyomo and some of solvers"

ENV TOOL_DIR /opt
ENV BONMIN_VERSION 1.8.7
ENV COUENNE_VERSION 0.5.7
ENV IPOPT_VERSION 3.12.12
ENV SCIP_VERSION 6.0.1
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/lib:/usr/lib:/usr/local/lib

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential \
                                              gfortran \
                                              file \
                                              wget \
                                              unzip \
                                              zlib1g-dev \
                                              bison \
                                              flex \
                                              libgmp-dev \
                                              libreadline-dev \
                                              libncurses5-dev \
                                              glpk-utils \
                                              libblas-dev \
                                              liblapack-dev \
                                              python3-dev \
                                              python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install python packages
RUN pip3 install wheel setuptools && \
    pip3 install jupyterlab pyomo

# Install Bonmin
WORKDIR ${TOOL_DIR}
RUN wget https://www.coin-or.org/download/source/Bonmin/Bonmin-${BONMIN_VERSION}.zip && \
    unzip Bonmin-${BONMIN_VERSION}.zip && \
    rm Bonmin-${BONMIN_VERSION}.zip && \
    cd ${TOOL_DIR}/Bonmin-${BONMIN_VERSION}/ThirdParty/ASL && \
    ./get.ASL && \
    cd ${TOOL_DIR}/Bonmin-${BONMIN_VERSION}/ThirdParty/Mumps && \
    ./get.Mumps && \
    cd ${TOOL_DIR}/Bonmin-${BONMIN_VERSION}/ThirdParty/Metis && \
    ./get.Metis && \
    cd ${TOOL_DIR}/Bonmin-${BONMIN_VERSION} && \
    mkdir build && \
    cd ${TOOL_DIR}/Bonmin-${BONMIN_VERSION}/build && \
    ../configure --prefix=/usr/local --enable-static CXX=g++ CC=gcc F77=gfortran && \
    make && \
    make test && \
    make install && \
    cd ${TOOL_DIR} && \
    rm -rf ${TOOL_DIR}/Bonmin-${BONMIN_VERSION}

# Install Couenne
WORKDIR ${TOOL_DIR}
RUN wget https://www.coin-or.org/download/source/Couenne/Couenne-${COUENNE_VERSION}.zip && \
    unzip Couenne-${COUENNE_VERSION}.zip && \
    rm Couenne-${COUENNE_VERSION}.zip && \
    cd ${TOOL_DIR}/Couenne-${COUENNE_VERSION}/ThirdParty/ASL && \
    ./get.ASL && \
    cd ${TOOL_DIR}/Couenne-${COUENNE_VERSION}/ThirdParty/Mumps && \
    ./get.Mumps && \
    cd ${TOOL_DIR}/Couenne-${COUENNE_VERSION}/ThirdParty/Metis && \
    ./get.Metis && \
    cd ${TOOL_DIR}/Couenne-${COUENNE_VERSION} && \
    mkdir build && \
    cd ${TOOL_DIR}/Couenne-${COUENNE_VERSION}/build && \
    ../configure --prefix=/usr/local --enable-static CXX=g++ CC=gcc F77=gfortran && \
    make && \
    make test && \
    make install && \
    cd ${TOOL_DIR} && \
    rm -rf ${TOOL_DIR}/Couenne-${COUENNE_VERSION}

# Install IpOPT
WORKDIR ${TOOL_DIR}
RUN wget https://www.coin-or.org/download/source/Ipopt/Ipopt-${IPOPT_VERSION}.tgz && \
    tar zxvf Ipopt-${IPOPT_VERSION}.tgz && \
    rm Ipopt-${IPOPT_VERSION}.tgz && \
    cd ${TOOL_DIR}/Ipopt-${IPOPT_VERSION}/ThirdParty/ASL && \
    ./get.ASL && \
    cd ${TOOL_DIR}/Ipopt-${IPOPT_VERSION}/ThirdParty/Mumps && \
    ./get.Mumps && \
    cd ${TOOL_DIR}/Ipopt-${IPOPT_VERSION}/ThirdParty/Metis && \
    ./get.Metis && \
    cd ${TOOL_DIR}/Ipopt-${IPOPT_VERSION} && \
    mkdir build && \
    cd ${TOOL_DIR}/Ipopt-${IPOPT_VERSION}/build && \
    ../configure --prefix=/usr/local --enable-static CXX=g++ CC=gcc F77=gfortran && \
    make && \
    make test && \
    make install && \
    cd ${TOOL_DIR} && \
    rm -rf ${TOOL_DIR}/Ipopt-${IPOPT_VERSION}

# Install SCIP (If you will not install it, please comment out this section)
COPY scipoptsuite-${SCIP_VERSION}.tgz ${TOOL_DIR}
WORKDIR ${TOOL_DIR}
RUN tar zxvf ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION}.tgz && \
    rm ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION}.tgz && \
    cd ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION} && \
    make ZIMPL=false && \
    cd ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION}/scip/interfaces/ampl && \
    ./get.ASL && \
    cd ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION}/scip/interfaces/ampl/solvers && \
    sh configurehere && \
    make && \
    cd ${TOOL_DIR}/scipoptsuite-${SCIP_VERSION}/scip/interfaces/ampl && \
    make && \
    cp bin/scipampl /usr/local/bin && \
    cd ${TOOL_DIR} && \
    rm -rf scipoptsuite-${SCIP_VERSION}

WORKDIR /root
EXPOSE 8888
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--LabApp.password_required=False", "--LabApp.token=''"]
